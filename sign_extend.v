module sign_extend(Instruction, Out);
	parameter delay = 50;
	
	input [31:0] Instruction;
	output [63:0] Out;

	wire Sign;
	assign #delay Sign = Instruction[30] ? Instruction[20] : Instruction[23];
	assign #delay Out = Instruction[30] ? ({{55{Sign}}, Instruction[20:12]}) : ({{45{Sign}}, Instruction[23:5]});	
endmodule