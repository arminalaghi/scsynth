module ReSC_test_varied_bin_lengths_test();
	reg [5:0] x_bin;
	reg start;
	wire done;
	wire [9:0] y_bin;
	reg [9:0] expected_y;

	reg clk;
	reg reset;

	ReSC_wrapper_varied_bin_lengths_test ReSC (
		.x_bin (x_bin),
		.start (start),
		.done (done),
		.y_bin (y_bin),
		.clk (clk),
		.reset (reset)
	);

	always begin
		#1 clk <= ~clk;
	end

	initial begin
		clk = 0;
		reset = 1;
		#1 reset = 0;
		start = 1;

		#2 x_bin = 6'd44;
		expected_y = 10'd558;
		start = 0;

		#2068 x_bin = 6'd35;
		expected_y = 10'd433;
		start = 0;

		#2068 x_bin = 6'd27;
		expected_y = 10'd338;
		start = 0;

		#2068 x_bin = 6'd62;
		expected_y = 10'd801;
		start = 0;

		#2068 x_bin = 6'd27;
		expected_y = 10'd338;
		start = 0;

		#2068 x_bin = 6'd47;
		expected_y = 10'd606;
		start = 0;

		#2068 x_bin = 6'd33;
		expected_y = 10'd404;
		start = 0;

		#2068 x_bin = 6'd57;
		expected_y = 10'd748;
		start = 0;

		#2068 x_bin = 6'd31;
		expected_y = 10'd380;
		start = 0;

		#2068 x_bin = 6'd4;
		expected_y = 10'd135;
		start = 0;

		#2068 x_bin = 6'd27;
		expected_y = 10'd345;
		start = 0;

		#2068 $stop;
	end

	always @(posedge done) begin
		$display("x: %b, y: %b, expected_y: %b",x_bin, y_bin, expected_y);
		start = 1;
	end
endmodule
