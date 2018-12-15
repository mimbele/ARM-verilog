module sign_extend(A, Out);
	parameter n=32;
	parameter m=64;
	input [n-1:0] A;
	output [m-1:0] Out;
	
	assign Out = A[n-1] ? { {(m-n){1'b1}}, A} : { {(m-n){1'b0}}, A};
endmodule
