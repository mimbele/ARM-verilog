`default_nettype none

module CPU_Pipeline;
	wire clk;
	reg register_reset, register_write;
	wire [63:0] new_PC;
	wire [63:0] PCPlus4;
	wire [3:0] ALUFunc;
	wire [63:0] ALUSrcMuxOutput;
	wire [63:0] ShiftedAddress;
	wire [63:0] MemtoRegMuxOutput;
	
	//IF Stage Wires
	wire [63:0] IF_PC;
	wire [31:0] IF_instruction;

	
	//ID Stage Wires
	wire ID_Reg2Loc, ID_ALUSrc, ID_MemToReg, ID_RegWrite, ID_MemRead, ID_MemWrite, ID_Branch;
	wire [1:0] ID_ALUOperation;
	wire [4:0] ID_read_register_2;
	wire [31:0] ID_instruction;
	wire [63:0] ID_PC, ID_ExtendedData, ID_read_data_1, ID_read_data_2;

	//EX Stage Wires
	wire [1:0] EX_ALUOperation;
	wire EX_Reg2Loc, EX_ALUSrc, EX_MemToReg, EX_RegWrite, EX_MemRead, EX_MemWrite, EX_Branch, EX_ALUZero;
	wire [4:0] EX_instruction_4_0, EX_read_register_2;
	wire [10:0] EX_instruction_31_21;
	wire [31:0] EX_instruction;
	wire [63:0] EX_PC, EX_ALUResult, EX_JumpAddress, EX_read_data_1, EX_read_data_2, EX_ExtendedData;
	
	
	//MEM Stage Wires
	wire MEM_Branch, MEM_ALUZero, MEM_MemToReg, MEM_RegWrite, MEM_MemRead, MEM_MemWrite;
	wire [4:0] MEM_instruction_4_0;
	wire [63:0] MEM_JumpAddress, MEM_ALUResult, MEM_read_data_2, MEM_MemDataOut;

	
	//WB Stage Wires
	wire WB_RegWrite, WB_MemToReg;
	wire [63:0] WB_MemDataOut, WB_ALUResult;
	wire [4:0] WB_instruction_4_0;



	
	initial begin
		register_reset = 1;
		#210 register_reset = 0;
		register_write = 1;
	end
	
	//assign read_register_1 = instruction[9:5];

	//Clock
	clock OSC(clk);

	
	
	
	/*
	 * IF Stage
	 */
	
	//JumpMux
	mux2 JumpMux(PCPlus4, MEM_JumpAddress, (MEM_Branch & MEM_ALUZero), new_PC);

	//PC
	register PC(clk, new_PC, register_write, register_reset, IF_PC);

	//Instruction Memory
	instruction_memory inst_mem(IF_PC, IF_instruction);

	//PC + 4
	adder add4(.A(IF_PC), .B(64'b100), .Cin(1'b0), .S(PCPlus4));
	
	
	
	register  #(96) IF_ID(clk, {IF_PC, IF_instruction}, register_write, register_reset, {ID_PC, ID_instruction});
	
	
	/*
	 * ID Stage
	 */
	
	//Control Unit
	control_unit CU(ID_instruction[31:21], ID_Reg2Loc, ID_ALUSrc, ID_MemToReg, ID_RegWrite, ID_MemRead, ID_MemWrite, ID_Branch, ID_ALUOperation);

	//Reg2Loc Mux
	mux2 Reg2LocMux(ID_instruction[20:16], ID_instruction[4:0], ID_Reg2Loc, ID_read_register_2);
	
	//Register Bank
	register_bank bank(clk, ID_instruction[9:5], ID_read_register_2, ID_instruction[4:0], MemtoRegMuxOutput, WB_RegWrite, ID_read_data_1, ID_read_data_2);
	
	//Sign Extend
	sign_extend SE(ID_instruction, ID_ExtendedData);
	
	
	
	register  #(96) ID_EX (clk, {ID_ALUSrc, ID_MemToReg, ID_RegWrite, ID_MemRead, ID_MemWrite, ID_Branch, ID_ALUOperation, ID_PC, ID_read_data_1, ID_read_data_2, ID_ExtendedData, ID_instruction[31:21], ID_instruction[4:0]}, register_write, register_reset,
							   {EX_ALUSrc, EX_MemToReg, EX_RegWrite, EX_MemRead, EX_MemWrite, EX_Branch, EX_ALUOperation, EX_PC, EX_read_data_1, EX_read_data_2, EX_ExtendedData, EX_instruction_31_21,  EX_instruction_4_0});

	
	
	/*
	 * EX Stage
	 */
	 
	//ALU Control
	alu_control ALU_CU(EX_instruction_31_21, EX_ALUOperation, ALUFunc);
	
	//ALU
	ALU alu_instance(EX_read_data_1, ALUSrcMuxOutput, ALUFunc, EX_ALUResult, EX_ALUZero);
	
	//ALU SRC Mux
	mux2 ALUSrcMux(EX_read_data_2, EX_ExtendedData, EX_ALUSrc, ALUSrcMuxOutput);
	
	//ShiftLeft
	shift_left shift(EX_ExtendedData, ShiftedAddress);
	
	//Address Adder
	adder address_adder(.A(EX_PC), .B(ShiftedAddress), .Cin(1'b0), .S(EX_JumpAddress));
		
		
		
	register  #(96) EX_MEM (clk, {EX_MemToReg,  EX_RegWrite,  EX_MemRead,  EX_MemWrite,  EX_Branch,  EX_JumpAddress,  EX_ALUZero,  EX_ALUResult,  EX_read_data_2,  EX_instruction_4_0}, register_write, register_reset,
								 {MEM_MemToReg, MEM_RegWrite, MEM_MemRead, MEM_MemWrite, MEM_Branch, MEM_JumpAddress, MEM_ALUZero, MEM_ALUResult, MEM_read_data_2, MEM_instruction_4_0});

							   
	/*
	 * MEM Stage
	 */
	 
	//Data Memory
	memory DataMemory(clk, MEM_ALUResult, MEM_read_data_2, MEM_MemRead, MEM_MemWrite, MEM_MemDataOut);
	
	
	register  #(96) MEM_WB (clk, {MEM_MemToReg, MEM_RegWrite, MEM_MemDataOut, MEM_ALUResult, MEM_instruction_4_0}, register_write, register_reset,
								 {WB_MemToReg,  WB_RegWrite,  WB_MemDataOut, WB_ALUResult,  WB_instruction_4_0});

	
	/*
	 * WB Stage
	 */
	 
	//MemToReg Mux
	mux2 MemToRegMux(WB_ALUResult, WB_MemDataOut, WB_MemToReg, MemtoRegMuxOutput);
endmodule