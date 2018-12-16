module sign_extend(Instruction, Out);
	input [31:0] Instruction;
	output [63:0] Out;

	wire [1:0]A;

	assign A = Instruction[31:30];

	wire Sign;
	assign Sign = A[1] ? (A[0] ? (Instruction[20]) : (Instruction[23])) : (A[0] ? 0 : (Instruction[25]));
	assign Out = A[1] ? (A[0] ? ({{55{Sign}}, Instruction[20:12]}) : ({{45{Sign}}, Instruction[23:5]})) : (A[0] ? (64'b0) : ({{38{Sign}}, Instruction[25:0]}));
endmodule