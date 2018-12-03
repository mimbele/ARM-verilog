module register(clk, new_pc, w, rst, old_pc);
	input clk;
	input [63:0]new_pc;
	input w;
	input rst;
	output reg [63:0]old_pc;
	
	always @(posedge clk)begin
		if(rst==1'b1)begin
			old_pc <= 64'b0;
		end else begin
			if(w==1'b1)begin
				old_pc <= new_pc;
			end
		end
	end
endmodule