module mux2(A, B, Select, Out);
	parameter n=64;
	input [n-1:0] A;
	input [n-1:0] B;
	input Select;
	output [n-1:0] Out;
	
	assign Out = Select ? B : A;
endmodule
