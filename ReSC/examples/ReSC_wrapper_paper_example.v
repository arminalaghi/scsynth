module ReSC_wrapper_paper_example(
	input [9:0] x_bin,
	input start,
	output reg done,
	output reg [9:0] y_bin,

	input clk,
	input reset
);

	reg [9:0] c0_bin = 10'd256;
	reg [9:0] c1_bin = 10'd640;
	reg [9:0] c2_bin = 10'd384;
	reg [9:0] c3_bin = 10'd768;

	wire [2:0] x_stoch;
	wire [3:0] z_stoch;
	wire y_stoch;
	wire init;
	wire running;

	wire [9:0] randx0;
	LFSR_10_bit_added_zero_paper_example rand_gen_x_0 (
		.seed (10'd0),
		.data (randx0),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[0] = randx0 < x_bin;

	wire [9:0] randx1;
	LFSR_10_bit_added_zero_paper_example rand_gen_x_1 (
		.seed (10'd146),
		.data (randx1),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[1] = randx1 < x_bin;

	wire [9:0] randx2;
	LFSR_10_bit_added_zero_paper_example rand_gen_x_2 (
		.seed (10'd293),
		.data (randx2),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[2] = randx2 < x_bin;

	wire [9:0] randz0;
	LFSR_10_bit_added_zero_paper_example rand_gen_z_0 (
		.seed (10'd439),
		.data (randz0),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[0] = randz0 < c0_bin;

	wire [9:0] randz1;
	LFSR_10_bit_added_zero_paper_example rand_gen_z_1 (
		.seed (10'd585),
		.data (randz1),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[1] = randz1 < c1_bin;

	wire [9:0] randz2;
	LFSR_10_bit_added_zero_paper_example rand_gen_z_2 (
		.seed (10'd731),
		.data (randz2),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[2] = randz2 < c2_bin;

	wire [9:0] randz3;
	LFSR_10_bit_added_zero_paper_example rand_gen_z_3 (
		.seed (10'd878),
		.data (randz3),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign z_stoch[3] = randz3 < c3_bin;

	ReSC_paper_example ReSC (
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
