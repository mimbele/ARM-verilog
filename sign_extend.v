module sign_extend(Instruction, Out);
	input [31:0] Instruction;
	output [63:0] Out;

	wire Sign;
	assign Sign = Instruction[30] ? Instruction[20] : Instruction[23];
	assign Out = Instruction[30] ? ({{55{Sign}}, Instruction[20:12]}) : ({{45{Sign}}, Instruction[23:5]});	
endmodule