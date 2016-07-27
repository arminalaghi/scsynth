%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (C) 2016 N. Eamon Gaffney
%%
%% This program is free software; you can resdistribute and/or modify it under
%% the terms of the MIT license, a copy of which should have been included with
%% this program at https://github.com/arminalaghi/scsynth
%%
%% References:
%% Qian, W., Li, X., Riedel, M. D., Bazargan, K., & Lilja, D. J. (2011). An
%% Architecture for Fault-Tolerant Computation with Stochastic Logic. IEEE
%% Transactions on Computers IEEE Trans. Comput., 60(1), 93-105.
%% doi:10.1109/tc.2010.202
%%
%% Qian, W., & Riedel, M.D.. (2010). The Synthesis of Stochastic Logic to
%% Perform Multivariate Polynomial Arithmetic.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function VerilogMultivariateReSCTestGenerator (coeff, degrees, N, m_input,
                                               m_coeff, wrapModule, moduleName)

  %Generates a Verilog module that wraps an ReSC unit with conversions
  %from binary to stochastic on the inputs and from stochastic to binary
  %on the outputs.
  
  %Parameters:
  % coeff     : a list of coefficients of the Bernstein polynomial, ordered
  %             w_0_0..._0, w_0_0..._1, ..., w_0_0..._1_0, etc.; each
  %             coefficient should fall within the unit interval
  % degrees   : the degrees of the component Bernstein polynomials in order
  % N         : the length of the stochastic bitstreams, must be a power of 2
  % m_input   : the length in bits of the input, at most log2(N)
  % m_coeff   : the length in bits of the coefficients, at most log2(N)
  % wrapModule: name of the ReSC wrapper module to test
  % nameSuffix: a distinguishing suffix to be appended to the Verilog module's
  %             name
  
  m = log2(N);
  
  fileName = sprintf('%s.v', moduleName);
  header = "/*\n * This file was generated by the scsynth tool, and is availabl\
efor use under\n * the MIT license. More information can be found at\n * https:\
//github.com/arminalaghi/scsynth/\n */\n"
  
  fp = fopen(fileName, 'w');

  fprintf(fp, header);
	fprintf(fp, 'module %s(); //a testbench for an ReSC module\n', moduleName);
  for i=1:length(degrees)
	  fprintf(fp, '\treg [%d:0] x_%d_bin; //binary value of input %d\n',
            m_input - 1, i, i);
  end
  fprintf(fp, '\treg start;\n');
	fprintf(fp, '\twire done;\n');
	fprintf(fp, '\twire [%d:0] z_bin; //binary value of output\n', m - 1);
  fprintf(fp, '\treg [%d:0] expected_z; //expected output\n\n', m - 1);

	fprintf(fp, '\treg clk;\n');
	fprintf(fp, '\treg reset;\n\n');

	fprintf(fp, '\t%s ReSC (\n', wrapModule);
	for i=1:length(degrees)
    fprintf(fp, '\t\t.x_%d_bin (x_%d_bin),\n', i , i);
  end
	fprintf(fp, '\t\t.start (start),\n');
	fprintf(fp, '\t\t.done (done),\n');
	fprintf(fp, '\t\t.z_bin (z_bin),\n');
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
      fprintf(fp, '\t\t#2\n');
    else
      fprintf(fp, '\t\t#%d\n', N * 2 + 6);
    end
    x = rand(1, length(degrees));
    y = ComputeMultivariateBernstein(coeff, degrees, 1, x, 1);
    x_quantized = round(x * 2 ^ m_input);
    y_quantized = round(y * N);
    for j=1:length(degrees)
      fprintf(fp, "\t\tx_%d_bin = %d'd%d;\n", j, m_input, x_quantized(j));
    end
    fprintf(fp, "\t\texpected_z = %d'd%d;\n", m, y_quantized);
    fprintf(fp, '\t\tstart = 0;\n\n');
  end
  
	fprintf(fp, '\t\t#%d $stop;\n', 2 * N + 20);
	fprintf(fp, '\tend\n\n');

	fprintf(fp, '\talways @(posedge done) begin\n');
  fprintf(fp, '\t\t$display("x: ');
  for i=1:length(degrees)
    fprintf(fp, '%%b, ');
  end
  fprintf(fp, 'z: %%b, expected_z: %%b",');
  for i=1:length(degrees)
    fprintf(fp, 'x_%d_bin, ', i);
  end
  fprintf(fp, 'z_bin, expected_z);\n');
	fprintf(fp, '\t\tstart = 1;\n');
	fprintf(fp, '\tend\n');
  fprintf(fp, 'endmodule\n');
  
  fclose(fp);
end
