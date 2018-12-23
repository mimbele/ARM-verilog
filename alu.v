module ALU(A, B, Ctrl, Out, Z);
	parameter n=64;
	input [n-1:0]A;
	input [n-1:0]B;
	input [3:0]Ctrl;
	output [n-1:0]Out;
	output Z;

	wire [n-1:0] adderB;
	wire cout;
	wire [n-1:0]adder_out;


	assign Z = ~ (| Out);

	assign adderB = Ctrl[2]? ~B : B;
	adder add_circuit(A, adderB, Ctrl[2], adder_out, cout);
	assign Out = Ctrl[3]?
		~(A | B) : 
		( Ctrl[2] ? (Ctrl[0] ? B : adder_out) :
			 Ctrl[1]? adder_out : 
				Ctrl[0]? A|B : A&B);
		
endmodule