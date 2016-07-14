module ReSC_paper_example(
	input [2:0] x,
	input [3:0] z,
	output reg y
);

	wire [1:0] sum;
	assign sum = x[0] + x[1] + x[2];

	always @(*) begin
		case (sum)
			2'd0: y = z[0];
			2'd1: y = z[1];
			2'd2: y = z[2];
			2'd3: y = z[3];
			default: y = 0;
		endcase
	end
endmodule
