module ReSC_varied_bin_lengths_test(
	input [4:0] x,
	input [5:0] z,
	output reg y
);

	wire [2:0] sum;
	assign sum = x[0] + x[1] + x[2] + x[3] + x[4];

	always @(*) begin
		case (sum)
			3'd0: y = z[0];
			3'd1: y = z[1];
			3'd2: y = z[2];
			3'd3: y = z[3];
			3'd4: y = z[4];
			3'd5: y = z[5];
			default: y = 0;
		endcase
	end
endmodule
