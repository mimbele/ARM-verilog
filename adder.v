module adder(A, B, Cin, S, Cout);
	parameter n=64;
	input [n-1:0] A;
	input [n-1:0] B;
	input Cin;
	output [n-1:0] S;
	output Cout;

	assign {Cout, S} = A + B + Cin;
endmodule