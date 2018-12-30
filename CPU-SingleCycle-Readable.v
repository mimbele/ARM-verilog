module CPU;
	//Clock
	wire clk;
	clock OSC(clk);

	//PC
	wire pc_reset, pc_write;
	wire [63:0] new_pc;
	wire [63:0] old_pc;
	register PC(clk, new_pc, pc_write, pc_reset, old_pc);

	//Instruction Memory
	wire [31:0] instruction;
	instruction_memory inst_mem(old_pc, instruction);

	//PC + 4
	wire [63:0] PCPlus4;
	adder add4(.A(old_pc), .B(64'b100), .Cin(1'b0), .S(PCPlus4));
	
	//Control Unit
	wire Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	wire [1:0] ALUOperation;
	control_unit CU(instruction[31:21], Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOperation);

	//Reg2Loc Mux
	mux2 #(5) Reg2LocMux(instruction[20:16], instruction[4:0], Reg2Loc, read_register_2);
	
	//Register Bank
	wire [63:0] read_data_1;
	wire [63:0] read_data_2;
	register_bank bank(clk, read_register_1, read_register_2, instruction[4:0], MemtoRegMuxOutput, RegWrite, read_data_1, read_data_2);
	
	//Sign Extend
	wire [63:0] ExtendedData;
	sign_extend SE(instruction, ExtendedData);
	
	//ALU Control
	wire [4:0] ALUFunc;
	alu_control ALU_CU(instruction[31:21], ALUOperation, ALUFunc);
	
	//ALU
	wire [63:0] ALUResult;
	wire ALUZero;
	ALU alu_instance(read_data_1, ALUSrcMuxOutput, ALUFunc, ALUResult, ALUZero);
	
	//ALU SRC Mux
	wire [63:0] ALUSrcMuxOutput;
	mux2 ALUSrcMux(read_data_2, ExtendedData, ALUSrc, ALUSrcMuxOutput);
	
	//ShiftLeft
	wire [63:0] ShiftedAddress;
	shift_left shift(ExtendedData, ShiftedAddress);
	
	//Address Adder
	wire [63:0] JumpAddress;
	adder address_adder(.A(old_pc), .B(ShiftedAddress), .Cin(1'b0), .S(JumpAddress));
	
	//JumpMux
	mux2 JumpMux(PCPlus4, JumpAddress, (Branch & ALUZero), new_pc);
	
	//Data Memory
	wire [63:0] MemDataOut;
	memory DataMemory(clk, ALUResult, read_data_2, MemRead, MemWrite, MemDataOut);
	
	//MemToReg Mux
	wire [63:0] MemtoRegMuxOutput;
	mux2 MemToRegMux(ALUResult, MemDataOut, MemToReg, MemtoRegMuxOutput);
endmodule