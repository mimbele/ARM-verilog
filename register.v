module register(clk, new_pc, w, rst, old_pc);
	parameter n=64;
	parameter delay = 50;
	
	input clk;
	input [n-1:0]new_pc;
	input w;
	input rst;
	output reg [n-1:0]old_pc;
	
	always @(posedge clk)begin
		if(rst==1'b1)begin
			#delay old_pc <= {(n-1){1'b0}};
		end else begin
			if(w==1'b1)begin
				#delay old_pc <= new_pc;
			end
		end
	end
endmodule