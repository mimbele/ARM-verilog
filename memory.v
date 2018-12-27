module memory(clk, address, data_in, read, write, data_out);
	parameter size  = 127;

	input clk;
	input [63:0] address;
	input [63:0] data_in;
	input read;
	input write;
	output [63:0] data_out;

	reg [7:0] memory [0:127];
	
	assign data_out = read ? {
		memory[address + 7],
		memory[address + 6],
		memory[address + 5],
		memory[address + 4],
		memory[address + 3],
		memory[address + 2],
		memory[address + 1],
		memory[address]
	} : 64'bz;
	
	integer i;
	initial begin
		for(i=0 ; i < 128 ; i = i + 1) memory[i] = i;
	end
	
	always @(posedge clk) begin
		if(write == 1'b1) begin
			memory[address + 7] <= data_in[63:56];
			memory[address + 6] <= data_in[55:48];
			memory[address + 5] <= data_in[47:40];
			memory[address + 4] <= data_in[39:32];
			memory[address + 3] <= data_in[31:24];
			memory[address + 2] <= data_in[23:16];
			memory[address + 1] <= data_in[15:8];
			memory[address]     <= data_in[7:0];
		end
	end 
endmodule