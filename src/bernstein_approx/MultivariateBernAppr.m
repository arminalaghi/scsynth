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
%%
%% Qian, W., & Riedel, M.D.. (2010). The Synthesis of Stochastic Logic to
%% Perform Multivariate Polynomial Arithmetic.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [coefs, obj, H, b, c] = MultivariateBernAppr(vals, degrees)
  %This function finds the closet bivariate Bernstein polynomial approximation 
  %to the given function funchandle f(x,y). The bivariate Bernstein polynomial 
  %has the x degree as n and y degree as m.
  % 
  %It optimizes the objective function obj = coefs'*H*coefs + 2*b'*obj + c where
  %coefs is a flattened vector representation of the coefficient matrix. For
  %example, in two dimensions, [b_{00}, b_{01},..., b_{0m}, b_{10},..., b_{nm}]
  %is the vector representation of the coefficient matrix
  %
  %     b_{00}, b_{01}, ..., b_{0m}
  %     b_{10}, b_{11}, ..., b_{1m}
  %                 ...
  %     b_{n0}, b_{n1}, ..., b_{nm}
  %
  %The constraint is
  %0 <= coefs <=1. Note b_{ij} (0 <= i <= n, 0 <= j <= m) is the coefficient of
  %the term B_{i,n}(x)*B_{j,m}(y) in the bivariate Bernsteain polynomial.
  
  %%Parameters:
  % vals  : n+1-column vector representing inputs and outputs of the function
  %         being approximated
  % degrees: the degrees of the Bernstein polynomial to generate
  pkg load optim;
  tol = 1.e-8;
  vals = sortrows(vals);

  % Obtain the H matrix.
  for row = 1:prod(degrees + 1)
    indices1 = [];
    reduced_row = row - 1;
    for i = 1:length(degrees)
      ind = floor(reduced_row/prod(degrees(i+1:length(degrees)) + 1));
      reduced_row -= ind * prod(degrees(i+1:length(degrees)) + 1);
      indices1 = [indices1, ind];
    end

	  for col = row:prod(degrees + 1) % H matrix is symmetric, so we only
		  % consider col from row to (n+1)(m+1)

		  indices2 = [];
      reduced_col = col - 1;
      for i = 1:length(degrees)
        ind = floor(reduced_col/prod(degrees(i+1:length(degrees)) + 1));
        reduced_col -= ind * prod(degrees(i+1:length(degrees)) + 1);
        indices2 = [indices2, ind];
      end

		  H(row,col) = 1;
      for i=1:length(degrees)
        fhandle = @(x)(BernBasis(x, indices1(i), degrees(i)) *
                       BernBasis(x, indices2(i), degrees(i)));
        H(row,col) *= quad(fhandle, 0, 1, tol);
      end
      
		  if col ~= row
			  H(col,row) = H(row,col);
	  	end
	  end
  end

  % Convert values to grid for numerical integration
  ranges = cell(length(degrees), 1);
  for i = 1:length(degrees)
    ranges{i} = unique(vals(:,i))';
  end
  
  [grids{1:length(degrees)}] = ndgrid(ranges{:});
  xi = [];
  for i = 1:length(degrees)
    xi = [xi grids{i}(:)];
  end
  data = griddatan(vals(:,1:length(degrees)), vals(:,length(degrees) + 1), xi);
  gridded_vals = reshape(data, size(grids{1}));
  
  % Obtain the b vector.
  for row = 1:prod(degrees + 1)
  	indices = [];
    reduced_row = row - 1;
    for i = 1:length(degrees)
      ind = floor(reduced_row/prod(degrees(i+1:length(degrees)) + 1));
      reduced_row -= ind * prod(degrees(i+1:length(degrees)) + 1);
      indices = [indices, ind];
    end
    
    b_data = gridded_vals;
    for i=1:length(degrees)
      b_data .*= arrayfun(@BernBasis, grids{i}, indices(i), degrees(i));
    end
    
    for i=1:length(degrees)
      b_data = trapz(ranges{i}, b_data, i);
    end
    
    b(row, 1) = -b_data;
  end
  
  % Obtain the constant c
  c = gridded_vals.^2;
  for i=1:length(degrees)
    c = trapz(ranges{i}, c, i);
  end

  options = optimset('LargeScale','off');

  lb = zeros(prod(degrees+1),1);
  ub = ones(prod(degrees+1),1);
  x0 = [];
  [coefs, val, exitflags] = quadprog(H,b,[],[],[],[],lb,ub,x0,options);
  obj = coefs' * H * coefs + 2 * b' * coefs + c;
end
