module clock(clk);
	output reg clk;
	always begin
		clk = 1'b1;
		#800 clk = 1'b0;
		#800;
	end
endmodule
