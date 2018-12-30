module alu_control(Operation, ALUOperation, ALUFunc);
	parameter delay = 50;
	
	input [10:0] Operation;
	input [1:0] ALUOperation;
	output reg [3:0] ALUFunc;

	wire [4:0] important_bits;
	assign #delay important_bits = {ALUOperation[1], ALUOperation[0], Operation[9], Operation[8], Operation[3]};


	always @(important_bits)begin
		casex(important_bits)
			5'b00xxx: #delay ALUFunc <= 4'b0010;
			5'bx1xxx: #delay ALUFunc <= 4'b0111;
			5'b1x001: #delay ALUFunc <= 4'b0010;
			5'b1x101: #delay ALUFunc <= 4'b0110;
			5'b1x000: #delay ALUFunc <= 4'b0000;
			5'b1x010: #delay ALUFunc <= 4'b0001;
			default:  #delay ALUFunc <= 4'bz;
		endcase
	end
endmodule 