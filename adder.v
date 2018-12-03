`include "fa.v"
module adder(A, B, Cin, S, Cout);
	parameter n=64;
	input [n-1:0] A;
	input [n-1:0] B;
	input Cin;
	output [n-1:0] S;
	output Cout;

	wire carry[n:0];

	assign carry[0]=Cin;
	assign Cout = carry[64];
	genvar i;
	generate
		for(i=0;i<n;i=i+1) begin: label
			fa fulladder(A[i], B[i], carry[i], S[i], carry[i+1]);
		end
	endgenerate
endmodule