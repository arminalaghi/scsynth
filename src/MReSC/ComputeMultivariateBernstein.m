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

function [retval] = ComputeMultivariateBernstein(coeff, degrees, w, x, i)
  %Recursively computes the value of a multivariate Bernstein polynomial for
  %a given set of x values
  
  %Parameters:
  % coeff     : a list of coefficients of the Bernstein polynomial, ordered
  %             w_0_0..._0, w_0_0..._1, ..., w_0_0..._1_0, etc.; each
  %             coefficient should fall within the unit interval
  % degrees   : the degrees of the component Bernstein polynomials in order
  % w         : index of the weight to use in the 1D weight vector
  % x         : the list of x values
  % i         : the current depth of the recursion
  
  if i > length(degrees)
    retval = coeff(w);
  else
    retval = 0;
    for j=0:degrees(i)
      retval += (nchoosek(degrees(i), j) * x(i) ^ j * (1 - x(i)) ^...
                (degrees(i) - j) *...
                ComputeMultivariateBernstein(coeff, degrees,...
                  w + prod(degrees(i+1:length(degrees))) * j, x, i + 1));
    end
  end                
end
