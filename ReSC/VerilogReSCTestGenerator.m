%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (C) 2016 N. Eamon Gaffney
%%
%% This program is free software; you can resdistribute and/or modify it under
%% the terms of the MIT license, a copy of which should have been included with
%% this program at https://github.com/arminalaghi/scsynth
%%
%% References:
%% W. Qian, X. Li, M. D. Riedel, K. Bazargan and D. J. Lilja, "An Architecture
%% for Fault-Tolerant Computation with Stochastic Logic," in IEEE Transactions
%% on Computers, vol. 60, no. 1, pp. 93-105, Jan. 2011.
%% doi: 10.1109/TC.2010.202
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function VerilogReSCTestGenerator (coeff, N, m_input, m_coeff, wrapModule,
                                    moduleName)

  %Generates a Verilog module that wraps an ReSC unit with conversions
  %from binary to stochastic on the inputs and from stochastic to binary
  %on the outputs.
  
  %Parameters:
  % coeff     : a list of coefficients of the Bernstein polynomial; each
  %             coefficient should fall within the unit interval
  % N         : the length of the stochastic bitstreams, must be a power of 2
  % m_input   : the length in bits of the input, at most log2(N)
  % m_coeff   : the length in bits of the coefficients, at most log2(N)
  % wrapModule: name of the ReSC wrapper module to test
  % nameSuffix: a distinguishing suffix to be appended to the Verilog module's
  %             name
  
  m = log2(N);
  degree = length(coeff) - 1;
  
  fileName = sprintf('%s.v', moduleName);
  
  fp = fopen(fileName, 'w');

	fprintf(fp, 'module %s();\n', moduleName);
	fprintf(fp, '\treg [%d:0] x_bin;\n', m_input - 1);
  fprintf(fp, '\treg start;\n');
	fprintf(fp, '\twire done;\n');
	fprintf(fp, '\twire [%d:0] y_bin;\n', m - 1);
  fprintf(fp, '\treg [%d:0] expected_y;\n\n', m - 1);

	fprintf(fp, '\treg clk;\n');
	fprintf(fp, '\treg reset;\n\n');

	fprintf(fp, '\t%s ReSC (\n', wrapModule);
	fprintf(fp, '\t\t.x_bin (x_bin),\n');
	fprintf(fp, '\t\t.start (start),\n');
	fprintf(fp, '\t\t.done (done),\n');
	fprintf(fp, '\t\t.y_bin (y_bin),\n');
	fprintf(fp, '\t\t.clk (clk),\n');
	fprintf(fp, '\t\t.reset (reset)\n');
	fprintf(fp, '\t);\n\n');

	fprintf(fp, '\talways begin\n');
	fprintf(fp, '\t\t#1 clk <= ~clk;\n');
	fprintf(fp, '\tend\n\n');

	fprintf(fp, '\tinitial begin\n');
  fprintf(fp, '\t\tclk = 0;\n');
	fprintf(fp, '\t\treset = 1;\n');
	fprintf(fp, '\t\t#1 reset = 0;\n');
	fprintf(fp, '\t\tstart = 1;\n\n');
    
  for i=0:10
    if (i==0)
      fprintf(fp, '\t\t#2 ');
    else
      fprintf(fp, '\t\t#%d ', N * 2 + 20);
    end
    x = rand();
    y = sum(coeff .* arrayfun(@nchoosek, degree, 0:degree) .*
            x .^ (0:degree) .* (1 - x) .^ (degree - (0:degree)));
    x_quantized = round(x * 2 ^ m_input);
    y_quantized = round(y * N);
    fprintf(fp, "x_bin = %d'd%d;\n", m_input, x_quantized);
    fprintf(fp, "\t\texpected_y = %d'd%d;\n", m, y_quantized);
    fprintf(fp, '\t\tstart = 0;\n\n');
  end
  
	fprintf(fp, '\t\t#%d $stop;\n', 2 * N + 20);
	fprintf(fp, '\tend\n\n');

	fprintf(fp, '\talways @(posedge done) begin\n');
	fprintf(fp, '\t\t$display("x: %%b, y: %%b, expected_y: %%b",');
  fprintf(fp, 'x_bin, y_bin, expected_y);\n');
	fprintf(fp, '\t\tstart = 1;\n');
	fprintf(fp, '\tend\n');
  fprintf(fp, 'endmodule\n');
  
  fclose(fp);
end
