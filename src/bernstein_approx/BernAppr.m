%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (C) 2011 W. Qian
%% Edited 2016 by N. Eamon Gaffney
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [coefs, obj, H, b, c] = BernAppr(vals, degree)
  %This function finds the closet Bernstein polynomial approximation of degree n
  %to the given vectors representing a function.
  %
  %It optimizes the objective function obj = coefs'*H*coefs + 2*b'*coefs + c
  %subject to 0 <= coefs <=1, where coefs is the vector of Bernstein
  %coefficients to be solved.
  %Matrix H and vector b correspond to the matrix H and vector c defined in the
  %Section 2.2 of the paper "An Architecture for Fault-Tolerant Computation with
  %Stochastic Logic". Constant c is the integral of func_to_appr*func_to_appr
  %over the given range [int_l, int_u].
  
  %Parameters:
  % vals  : two-column vector representing inputs and outputs of the function
  %         being approximated
  % degree: the degree of the Bernstein polynomial to generate
  tol = 1.e-12;
  int_l = 0;
  int_u = 1;
  x = vals(:,1).'
  y = vals(:,2).'
  x = [0, x, 1]
  y = [y(1), y, y(length(y))]

  % set up the matrix H
  for i = 1:(degree+1)
  	for j = i:(degree+1)
  		fhandle = @(x)(BernBasis(x, i-1, degree).*BernBasis(x, j-1, degree));
  		H(i,j) = quad(fhandle, int_l, int_u, tol);
  		if i ~= j
	  		H(j,i) = H(i,j);
	  	end
	  end
  end

  % set up the vector b
  for i= 1:(degree+1)
    b(i,1) = -trapz(x, BernBasis(x, i-1, degree) .* y);
  end

  % set up the constant c
  c = trapz(x, y .* y);

  options = optimset('LargeScale','off');

  lb = zeros(degree+1,1);
  ub = ones(degree+1,1);
  x0 = [];
  [coefs, val, exitflags] = quadprog(H,b,[],[],[],[],lb,ub,x0,options);
  obj = coefs' * H * coefs + 2 * b' * coefs + c;
end
