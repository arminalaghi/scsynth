module ReSC_test_paper_example();
	reg [9:0] x_bin;
	reg start;
	wire done;
	wire [9:0] y_bin;
	reg [9:0] expected_y;

	reg clk;
	reg reset;

	ReSC_wrapper_paper_example ReSC (
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

		#2 x_bin = 10'd679;
		expected_y = 10'd549;
		start = 0;

		#2068 x_bin = 10'd444;
		expected_y = 10'd499;
		start = 0;

		#2068 x_bin = 10'd51;
		expected_y = 10'd309;
		start = 0;

		#2068 x_bin = 10'd520;
		expected_y = 10'd514;
		start = 0;

		#2068 x_bin = 10'd119;
		expected_y = 10'd366;
		start = 0;

		#2068 x_bin = 10'd986;
		expected_y = 10'd727;
		start = 0;

		#2068 x_bin = 10'd319;
		expected_y = 10'd467;
		start = 0;

		#2068 x_bin = 10'd554;
		expected_y = 10'd520;
		start = 0;

		#2068 x_bin = 10'd1003;
		expected_y = 10'd746;
		start = 0;

		#2068 x_bin = 10'd241;
		expected_y = 10'd438;
		start = 0;

		#2068 x_bin = 10'd260;
		expected_y = 10'd446;
		start = 0;

		#2068 $stop;
	end

	always @(posedge done) begin
		$display("x: %b, y: %b, expected_y: %b",x_bin, y_bin, expected_y);
		start = 1;
	end
endmodule
