/*
 * This file was generated by the scsynth tool, and is availablefor use under
 * the MIT license. More information can be found at
 * https://github.com/arminalaghi/scsynth/
 */
module MReSC_test_example(); //a testbench for an ReSC module
	reg [11:0] x_1_bin; //binary value of input 1
	reg [11:0] x_2_bin; //binary value of input 2
	reg [11:0] x_3_bin; //binary value of input 3
	reg start;
	wire done;
	wire [11:0] z_bin; //binary value of output
	reg [11:0] expected_z; //expected output

	reg clk;
	reg reset;

	MReSC_wrapper_example ReSC (
		.x_1_bin (x_1_bin),
		.x_2_bin (x_2_bin),
		.x_3_bin (x_3_bin),
		.start (start),
		.done (done),
		.z_bin (z_bin),
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

		#2
		x_1_bin = 12'd987;
		x_2_bin = 12'd3856;
		x_3_bin = 12'd1661;
		expected_z = 12'd1785;
		start = 0;

		#8198
		x_1_bin = 12'd57;
		x_2_bin = 12'd1035;
		x_3_bin = 12'd717;
		expected_z = 12'd2854;
		start = 0;

		#8198
		x_1_bin = 12'd2434;
		x_2_bin = 12'd1055;
		x_3_bin = 12'd2222;
		expected_z = 12'd1984;
		start = 0;

		#8198
		x_1_bin = 12'd423;
		x_2_bin = 12'd734;
		x_3_bin = 12'd2476;
		expected_z = 12'd2616;
		start = 0;

		#8198
		x_1_bin = 12'd971;
		x_2_bin = 12'd1870;
		x_3_bin = 12'd3772;
		expected_z = 12'd2260;
		start = 0;

		#8198
		x_1_bin = 12'd1925;
		x_2_bin = 12'd748;
		x_3_bin = 12'd1295;
		expected_z = 12'd1949;
		start = 0;

		#8198
		x_1_bin = 12'd2571;
		x_2_bin = 12'd3069;
		x_3_bin = 12'd314;
		expected_z = 12'd2203;
		start = 0;

		#8198
		x_1_bin = 12'd1878;
		x_2_bin = 12'd121;
		x_3_bin = 12'd1553;
		expected_z = 12'd1893;
		start = 0;

		#8198
		x_1_bin = 12'd1392;
		x_2_bin = 12'd226;
		x_3_bin = 12'd3695;
		expected_z = 12'd1728;
		start = 0;

		#8198
		x_1_bin = 12'd1967;
		x_2_bin = 12'd2344;
		x_3_bin = 12'd2063;
		expected_z = 12'd2199;
		start = 0;

		#8198
		x_1_bin = 12'd2903;
		x_2_bin = 12'd1635;
		x_3_bin = 12'd1301;
		expected_z = 12'd1914;
		start = 0;

		#8212 $stop;
	end

	always @(posedge done) begin
		$display("x: %b, %b, %b, z: %b, expected_z: %b",x_1_bin, x_2_bin, x_3_bin, z_bin, expected_z);
		start = 1;
	end
endmodule
