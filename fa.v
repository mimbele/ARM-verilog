module fa(A, B, Cin, S, Cout);
	input A;
	input B;
	input Cin;
	output S;
	output Cout;
	
	wire T0, T1, T2;

	xor(S, A, B, Cin);
	and(T0, A, B);
	and(T1, A, Cin);
	and(T2, B, Cin);
	or(Cout, T0, T1, T2);
endmodule