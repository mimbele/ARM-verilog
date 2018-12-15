module mux2(A, B, Sel, Out);
	parameter n=64;
	input [n-1:0] A;
	input [n-1:0] B;
	input Sel;
	output [n-1:0] Out;
	
	assign Out = Sel ? B : A;
endmodule
