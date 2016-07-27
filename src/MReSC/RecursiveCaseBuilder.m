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

function RecursiveCaseBuilder (fp, degrees, bits, w, x, i, tabs)
  %Recursively builds the case statement for a multivariate lFSR's multiplexer
  
  %Parameters:
  % fp     : verilog file to write code to
  % degrees: the degrees of the Bernstein polynomials
  % bits: 
  % w      : index of the weight to use in the 1D weight vector
  % x      : index of the x input being considered at this depth
  % i      : index of the Bernstein polynomial at this particular depth
  % tabs   : string containing tabs to put at the beginning of lines to keep
  %          indentation clean
  
  if (x > length(degrees))
    fprintf(fp, "%s%d'd%d: z = w[%d];\n", tabs, bits(x - 1), i, w);
  else
    if (x == 1)
      fprintf(fp, '%scase(sum_%d)\n', tabs, x);
    else
      fprintf(fp, "%s%d'd%d: case(sum_%d)\n", tabs, bits(x - 1), i, x);
    end
    for j=0:degrees(x)
      newTabs = sprintf('%s\t', tabs);
      RecursiveCaseBuilder(fp, degrees, bits,
                           w + prod(degrees(x+1:length(degrees)) + 1) * j,
                           x + 1, j, newTabs);
    end
    fprintf(fp, '%sdefault: z = 0;\n', newTabs);
    fprintf(fp, '%sendcase\n', tabs);
  end
end
