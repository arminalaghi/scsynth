%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (C) 2016 by N. Eamon Gaffney
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
function error = MultivariateBernError(vals, degrees, coeff,
                  errorMetric=@MeanSquareError)
  %Calculate the error of a multivariate Bernstein approximation on a set of
  %sample data
  
  %Parameters:
  % vals   : n+1-column vector representing inputs and outputs of the function
  %          being approximated
  % degrees: degrees of
  % coeff  : the coeffecients of the Bernstein polynomial
  
  %Optional Parameters:
  % errorMetric: metric by which to compare approximate and expected results,
  %              default MeanSquareError
  
  computed = [];
  for i=1:length(vals)
    computed = [computed; ComputeMultivariateBernstein(coeff, degrees, 1,
                            vals(i, 1:length(degrees)), 1)];
  end
  error = errorMetric(computed, vals(:,2));
end
