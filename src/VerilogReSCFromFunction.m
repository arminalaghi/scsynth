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
%% A. Alaghi and J. P. Hayes, "Exploiting correlation in stochastic circuit
%% design," 2013 IEEE 31st International Conference on Computer Design (ICCD),
%% Asheville, NC, 2013, pp. 39-46.
%% doi: 10.1109/ICCD.2013.6657023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function VerilogReSCFromFunction (func, degree, N, m_input, m_coeff, nameSuffix,
                                  singleWeightLFSR=true, domain = [0, 1],
                                  granularity=100)
  %Reconfigurable Architecture Based on Stochastic Logic, or ReSC, is a method
  %developed by Weikang Qian, Xin Li, Marc D. Riedel, Kia Bazargan, and David J.
  %Lilja for approximating the computation of any function with domain and range
  %in the unit interval as a stochastic circuit using a Bernstein polynomial
  %approximation of the function. This function, given a function handle, 
  %generates a complete ReSC module written in Verilog, containing the following
  %files:
  % ReSC_[nameSuffix].v - The core stochastic module
  % ReSC_wrapper_[nameSuffix].v - A wrapper for the module that converts inputs
  %                               inputs and outputs between binary and
  %                               stochastic representations.
  % ReSC_test_[nameSuffix].v - A testbench for the system.
  % LFSR_[log(N)]_bit_added_zero_[nameSuffix].v - The RNG for generating
  %                                               stochastic numbers.
  
  %Parameters:
  % func      : a function handle for the function being modeled
  % degree    : the desired degree of the Bernstein polynomial underlying the
  %             ReSC (higher means a larger circuit but less error)
  % N         : the length of the stochastic bitstreams, must be a power of 2
  % m_input   : the length in bits of the input, at most log2(N)
  % m_coeff   : the length in bits of the coefficients, at most log2(N)
  % nameSuffix: a distinguishing suffix to append to the name of each Verilog
  %             module
  
  %Optional Parameters:
  % singleWeightLFSR: Use the same LFSR for every constant. (Default true)
  % domain          : the domain over which to model  (Default [0, 1])
  % granularity     : the number of data points to sample in approximating the
  %                   the function
  addpath(genpath('.'));
  
  x = [domain(1):(domain(2) - domain(1))/granularity:domain(2)];
  y = arrayfun(func, x);
  
  VerilogReSCFromData([x' y'], degree, N, m_input, m_coeff, nameSuffix,...
                      singleWeightLFSR);
end

