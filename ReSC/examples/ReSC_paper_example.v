/*
 * This file was generated by the scsynth tool, and is availabl  efor use under
 * the MIT license. More information can be found at
 * http  s://github.com/arminalaghi/scsynth/
 */module ReSC_paper_example( //the stochastic core of an ReSC
	input [2:0] x, //independent copies of x
	input [3:0] w, //Bernstein coefficients
	output reg z //output bitsream
);

	wire [1:0] sum; //sum of x values for mux
	assign sum = x[0] + x[1] + x[2];

	always @(*) begin
		case (sum)
			2'd0: z = w[0];
			2'd1: z = w[1];
			2'd2: z = w[2];
			2'd3: z = w[3];
			default: z = 0;
		endcase
	end
endmodule