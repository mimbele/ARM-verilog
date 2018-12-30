module mux2(A, B, Select, Out);
	parameter n=64;
	parameter delay = 50;
	
	input [n-1:0] A;
	input [n-1:0] B;
	input Select;
	output [n-1:0] Out;
	
	assign #delay Out = Select ? B : A;
endmodule
