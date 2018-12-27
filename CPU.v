`default_nettype none

module CPU;
	wire clk;
	reg pc_reset, pc_write;
	wire [63:0] new_pc;
	wire [63:0] old_pc;
	wire [31:0] instruction;
	wire [63:0] PCPlus4;
	wire Reg2Loc, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch;
	wire [1:0] ALUOperation;
	wire [63:0] read_data_1;
	wire [63:0] read_data_2;
	wire [63:0] ExtendedData;
	wire [3:0] ALUFunc;
	wire [63:0] ALUResult;
	wire ALUZero;
	wire [63:0] ALUSrcMuxOutput;
	wire [63:0] ShiftedAddress;
	wire [63:0] JumpAddress;
	wire [63:0] MemDataOut;
	wire [63:0] MemtoRegMuxOutput;
	//wire [4:0] read_register_1;
	wire [4:0] read_register_2;
	
	initial begin
		pc_reset = 1;
		#210 pc_reset = 0;
		pc_write = 1;
	end
	
	//assign read_register_1 = instruction[9:5];

	//Clock
	clock OSC(clk);

	//PC
	register PC(clk, new_pc, pc_write, pc_reset, old_pc);

	//Instruction Memory
	instruction_memory inst_mem(old_pc, instruction);

	//PC + 4
	adder add4(.A(old_pc), .B(64'b100), .Cin(1'b0), .S(PCPlus4));
	
	//Control Unit
	control_unit CU(instruction[31:21], Reg2Loc, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOperation);

	//Reg2Loc Mux
	mux2 Reg2LocMux(instruction[20:16], instruction[4:0], Reg2Loc, read_register_2);
	
	//Register Bank
	register_bank bank(clk, instruction[9:5], read_register_2, instruction[4:0], MemtoRegMuxOutput, RegWrite, read_data_1, read_data_2);
	
	//Sign Extend
	sign_extend SE(instruction, ExtendedData);
	
	//ALU Control
	alu_control ALU_CU(instruction[31:21], ALUOperation, ALUFunc);
	
	//ALU
	ALU alu_instance(read_data_1, ALUSrcMuxOutput, ALUFunc, ALUResult, ALUZero);
	
	//ALU SRC Mux
	mux2 ALUSrcMux(read_data_2, ExtendedData, ALUSrc, ALUSrcMuxOutput);
	
	//ShiftLeft
	shift_left shift(ExtendedData, ShiftedAddress);
	
	//Address Adder
	adder address_adder(.A(old_pc), .B(ShiftedAddress), .Cin(1'b0), .S(JumpAddress));
	
	//JumpMux
	mux2 JumpMux(PCPlus4, JumpAddress, (Branch & ALUZero), new_pc);
	
	//Data Memory
	memory DataMemory(clk, ALUResult, read_data_2, MemRead, MemWrite, MemDataOut);
	
	//MemToReg Mux
	mux2 MemToRegMux(ALUResult, MemDataOut, MemToReg, MemtoRegMuxOutput);
endmodule