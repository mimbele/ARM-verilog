module shift_left(Input, Output);
	parameter shift_amount = 2;
	input [63:0] Input;
	output [63:0] Output;
	
	assign Output = {Input[(63 - shift_amount):0], {shift_amount{1'b0}}};
endmodule