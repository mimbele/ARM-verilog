module instruction_memory(read_address, instruction);
	parameter delay = 50;
	
	input [63:0]read_address;
	output [31:0]instruction;
	reg [7:0]memory[0:127];
	assign #delay instruction = {
	   memory[read_address + 3],
	   memory[read_address + 2],
	   memory[read_address + 1],
	   memory[read_address]
	};
	initial begin
		memory[0] <= 8'hE5;
		memory[1] <= 8'h03;
		memory[2] <= 8'h1F;
		memory[3] <= 8'h8B;
		
		memory[4] <= 8'hA4;
		memory[5] <= 8'h00;
		memory[6] <= 8'h40;
		memory[7] <= 8'hF8;
		
		memory[8] <= 8'h86;
		memory[9] <= 8'h00;
		memory[10] <= 8'h04;
		memory[11] <= 8'h8B;
		
		memory[12] <= 8'hA6;
		memory[13] <= 8'h10;
		memory[14] <= 8'h00;
		memory[15] <= 8'hF8;
	end
endmodule
