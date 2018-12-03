module arm_tb;
	wire clk;
	wire [63:0] data_out;
	wire [63:0] new_pc;
	wire [63:0] old_pc;
	reg mem_read;
	reg mem_write;
	reg pc_write;
	reg pc_reset;
	wire [61:0]memory_data_in;

	assign memory_data_in = old_pc[63:2];
	register pc(clk, new_pc, pc_write, pc_reset, old_pc);
	clock clock0(clk);
	memory memory0(clk, old_pc, memory_data_in, mem_read, mem_write, data_out);
	adder add(.A(old_pc), .B(64'b100), .Cin(1'b0), .S(new_pc));

	initial begin
		mem_write = 1'b1;
		mem_read = 1'b0;
		pc_reset = 1'b1;
		/*
		 * Period of clock cycle: 200ns, and 10ns for safety.
		 */
		#210 pc_reset = 1'b0;

		pc_write = 1'b1;
		
	end 
	always @(posedge clk)begin
		/*
		 * begin reading phase when pc hits 16.
		 * output of the memory will be 64'hx for one clock cycle after hitting 16, because PC contains address of an unwritten memory cell.
		 * best Run Length for simulation: 3500ns
		 */
		if(old_pc == 64'b10000)begin
			mem_write = 1'b0;
			pc_reset = 1'b1;
			/*
			 * Period of clock cycle: 200ns, and 10ns for safety.
			 */
			#210 pc_reset = 1'b0;
			mem_read = 1'b1;
		end
	end
endmodule