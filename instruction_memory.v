module instruction_memory(read_address, instruction);
	input [63:0]read_address;
	output [31:0]instruction;
	reg [7:0]memory[0:127];
	assign instruction = {
	   memory[read_address + 3],
	   memory[read_address + 2],
	   memory[read_address + 1],
	   memory[read_address]
	};
endmodule
