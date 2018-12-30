module control_unit(Operation, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOperation);
	parameter delay = 50;
	
	input [10 : 0] Operation;
	output Reg2Loc;
	output ALUSrc;
	output MemtoReg;
	output RegWrite;
	output MemRead;
	output MemWrite;
	output Branch;
	output [1 : 0] ALUOperation;
	
	reg [8:0] cu_output;
	
	assign  #delay {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOperation[1], ALUOperation[0]} = cu_output;

	always @(Operation)begin
		casex(Operation)
			11'b00000000000: #delay cu_output <= 9'b000000000;
		
			11'b1xx0101x000: #delay cu_output <= 9'b000100010;
			
			11'b11111000010: #delay cu_output <= 9'b011110000;
			
			11'b11111000000: #delay cu_output <= 9'b110001000;
			
			11'b10110100xxx: #delay cu_output <= 9'b100000101;
		endcase
	end


endmodule