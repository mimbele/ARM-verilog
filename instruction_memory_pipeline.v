module pipeline_instruction_memory(read_address, instruction);
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
	
    integer i;
	initial 
	begin
	  	for(i = 0;i < 128; i = i + 1)
			memory[i] <= 0;

		memory[0] <= 8'hE5;
		memory[1] <= 8'h03;
		memory[2] <= 8'h1F;
		memory[3] <= 8'h8B;
		

		memory[16] <= 8'hA4;
		memory[17] <= 8'h00;
		memory[18] <= 8'h40;
		memory[19] <= 8'hF8;
		

		memory[32] <= 8'h86;
		memory[33] <= 8'h00;
		memory[34] <= 8'h04;
		memory[35] <= 8'h8B;
	

		memory[48] <= 8'hA6;
		memory[49] <= 8'h10;
		memory[50] <= 8'h00;
		memory[51] <= 8'hF8;
	end
endmodule    
//checked
