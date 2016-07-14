module ReSC_wrapper_varied_bin_lengths_test(
	input [5:0] x_bin,
	input start,
	output reg done,
	output reg [9:0] y_bin,

	input clk,
	input reset
);

	wire [9:0] x_bin_shifted;
	assign x_bin_shifted = x_bin << 4;

	reg [9:0] c0_bin = 10'd104;
	reg [9:0] c1_bin = 10'd204;
	reg [9:0] c2_bin = 10'd308;
	reg [9:0] c3_bin = 10'd408;
	reg [9:0] c4_bin = 10'd716;
	reg [9:0] c5_bin = 10'd820;

	wire [4:0] x_stoch;
	wire [5:0] z_stoch;
	wire y_stoch;
	wire init;
	wire running;

	wire [9:0] randx0;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_x_0 (
		.seed (10'd0),
		.data (randx0),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[0] = randx0 < x_bin_shifted;

	wire [9:0] randx1;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_x_1 (
		.seed (10'd93),
		.data (randx1),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[1] = randx1 < x_bin_shifted;

	wire [9:0] randx2;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_x_2 (
		.seed (10'd186),
		.data (randx2),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[2] = randx2 < x_bin_shifted;

	wire [9:0] randx3;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_x_3 (
		.seed (10'd279),
		.data (randx3),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[3] = randx3 < x_bin_shifted;

	wire [9:0] randx4;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_x_4 (
		.seed (10'd372),
		.data (randx4),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[4] = randx4 < x_bin_shifted;

	wire [9:0] randz0;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_z_0 (
		.seed (10'd465),
		.data (randz0),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[0] = randz0 < c0_bin;

	wire [9:0] randz1;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_z_1 (
		.seed (10'd559),
		.data (randz1),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[1] = randz1 < c1_bin;

	wire [9:0] randz2;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_z_2 (
		.seed (10'd652),
		.data (randz2),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[2] = randz2 < c2_bin;

	wire [9:0] randz3;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_z_3 (
		.seed (10'd745),
		.data (randz3),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[3] = randz3 < c3_bin;

	wire [9:0] randz4;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_z_4 (
		.seed (10'd838),
		.data (randz4),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[4] = randz4 < c4_bin;

	wire [9:0] randz5;
	LFSR_10_bit_added_zero_varied_bin_lengths_test rand_gen_z_5 (
		.seed (10'd931),
		.data (randz5),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[5] = randz5 < c5_bin;

	ReSC_varied_bin_lengths_test ReSC (
		.x (x_stoch),
		.z (z_stoch),
		.y (y_stoch)
	);

	reg [9:0] count;
	wire [9:0] neg_one;
	assign neg_one = -1;

	reg [1:0] cs;
	reg [1:0] ns;
	assign init = cs == 1;
	assign running = cs == 2;

	always @(posedge clk or posedge reset) begin
		if (reset) cs <= 0;
		else begin
			cs <= ns;
			if (running) begin
				if (count == neg_one) done <= 1;
				count <= count + 1;
				y_bin <= y_bin + y_stoch;
			end
		end
	end

	always @(*) begin
		case (cs)
			0: if (start) ns = 1; else ns = 0;
			1: if (start) ns = 1; else ns = 2;
			2: if (done) ns = 0; else ns = 2;
			default ns = 0;
		endcase
	end

	always @(posedge init) begin
		count <= 0;
		y_bin <= 0;
		done <= 0;
	end
endmodule
