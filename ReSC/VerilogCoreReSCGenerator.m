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

function VerilogCoreReSCGenerator (degree, moduleName)

  %Generates an ReSC module in verilog whose inputs and outputs
  %remain in stochastic format
  
  %Parameters:
  % degree    : the degree of the Bernstein polynomial
  % moduleName: the name of the verilog module
  
  fileName = sprintf('%s.v', moduleName);
  
  fp = fopen(fileName, 'w');
  
  fprintf(fp, 'module %s(\n', moduleName);
	fprintf(fp, '\tinput [%d:0] x,\n', degree - 1);
  fprintf(fp, '\tinput [%d:0] z,\n', degree);
  fprintf(fp, '\toutput reg y\n);\n\n');

  bits = ceil(log2(degree));
	fprintf(fp, '\twire [%d:0] sum;\n', bits - 1); 
	fprintf(fp, '\tassign sum = x[0]');
  for i=1:degree - 1
    fprintf(fp, ' + x[%d]', i);
  end
  fprintf(fp, ';\n\n');
  
	fprintf(fp, '\talways @(*) begin\n');
	fprintf(fp, '\t\tcase (sum)\n');
  for i=0:degree
    fprintf(fp, "\t\t\t%d'd%d: y = z[%d];\n", bits, i, i);
  end
  fprintf(fp, '\t\t\tdefault: y = 0;\n');
	fprintf(fp, '\t\tendcase\n');
	fprintf(fp, '\tend\n');
  fprintf(fp, 'endmodule\n');
  
  fclose(fp);
end
