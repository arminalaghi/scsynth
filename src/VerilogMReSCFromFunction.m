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
%%
%% A. Alaghi and J. P. Hayes, "Exploiting correlation in stochastic circuit
%% design," 2013 IEEE 31st International Conference on Computer Design (ICCD),
%% Asheville, NC, 2013, pp. 39-46.
%% doi: 10.1109/ICCD.2013.6657023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function VerilogMReSCFromFunction (func, degrees, N, m_input, m_coeff,
                                   nameSuffix, singleWeightLFSR=true,
                                   domains=[0, 1], granularities=100)
  %Reconfigurable Architecture Based on Stochastic Logic, or ReSC, is a method
  %developed by Weikang Qian, Xin Li, Marc D. Riedel, Kia Bazargan, and David J.
  %Lilja for approximating the computation of any function with domain and range
  %in the unit interval as a stochastic circuit using a Bernstein polynomial
  %approximation of the function. The Multivariate form allows extension to
  %functions of several variables by using the product of the individual
  %polynomials on those variables. This function, given a function handle,
  %generates a complete multivariate ReSC module written in Verilog, containing
  %the following files:
  % ReSC_[nameSuffix].v - The core stochastic module
  % ReSC_wrapper_[nameSuffix].v - A wrapper for the module that converts inputs
  %                               inputs and outputs between binary and
  %                               stochastic representations.
  % ReSC_test_[nameSuffix].v - A testbench for the system.
  % LFSR_[log(N)]_bit_added_zero_[nameSuffix].v - The RNG for generating
  %                                               stochastic numbers.
  
  %Parameters:
  % func      : a function handle for the function being modeled
  % degrees   : the desired degrees of the Bernstein polynomials underlying the
  %             ReSC (one per input, higher means a larger circuit but less
  %             error)
  % N         : the length of the stochastic bitstreams, must be a power of 2
  % m_input   : the length in bits of the input, at most log2(N)
  % m_coeff   : the length in bits of the coefficients, at most log2(N)
  % nameSuffix: a distinguishing suffix to append to the name of each Verilog
  %             module
  
  %Optional Parameters:
  % singleWeightLFSR: Use the same LFSR for every constant. (Default true)
  % domains         : The domains of each input of the function being modeled
  %                   each row representing one variable. If there is only one
  %                   row, it will be used for every variable (Default [0, 1])
  % granularities   : The number of data points to sample on each axis in
  %                   approximating the function. If only one value is given, it
  %                   will be used for every axis. (Default 100)
  addpath(genpath('.'));
  
  if size(domains) == [1, 2]
    domain = domains;
    for i=2:length(degrees)
      domains = [domains; domain];
    end
  end
  
  if length(granularities) == 1
    granularity = granularities;
    for i=2:length(degrees)
      granularities = [granularities, granularity];
    end
  end
  
  points = cell(1, length(degrees));
  for i=1:length(degrees)
    points{i} = [domains(i, 1):(domains(i, 2) - domains(i, 1))/...
                 granularities(i):domains(i, 2)];
  end
  [grids{1:length(degrees)}] = ndgrid(points{:});
  
  data = [];
  for i=1:length(degrees)
    data = [data, grids{i}(:)];
  end
  
  y = [];
  for i=1:length(data)
    y = [y; func(num2cell(data(i,:)){:})];
  end
  data = [data, y];
  
  VerilogMReSCFromData(data, degrees, N, m_input, m_coeff, nameSuffix,...
                       singleWeightLFSR);
end