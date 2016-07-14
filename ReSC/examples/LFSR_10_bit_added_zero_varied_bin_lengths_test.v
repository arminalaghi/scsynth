module LFSR_10_bit_added_zero_varied_bin_lengths_test(
	input [9:0] seed,
	output [9:0] data,
	input enable,
	input restart,

	input reset,
	input clk
);

	reg [9:0] shift_reg;
	wire shift_in;

	always @(posedge clk or posedge reset) begin
		if (reset) shift_reg <= seed;
		else if (restart) shift_reg <= seed;
		else if (enable) shift_reg <= {shift_reg[8:0], shift_in};
	end


	wire xor_out;
	assign xor_out = shift_reg[9] ^ shift_reg[6];

	wire zero_detector;
	assign zero_detector = ~(|(shift_reg[8:0]));
	assign shift_in = xor_out ^ zero_detector;


	assign data = shift_reg;
endmodule
