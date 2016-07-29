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

function VerilogReSCGenerator(coeff, N, m_input, m_coeff, nameSuffix,
                              singleWeightLFSR=true)
  %Reconfigurable Architecture Based on Stochastic Logic, or ReSC, is a methods
  %developed by Weikang Qian, Xin Li, Marc D. Riedel, Kia Bazargan, and David J.
  %Lilja for approximating the computation of any function with domain and range
  %in the unit interval as a stochastic circuit using a Bernstein polynomial
  %approximation of the function. This function generates a complete ReSC module
  %written in Verilog, containing the following files:
  % ReSC_[nameSuffix].v - The core stochastic module
  % ReSC_wrapper_[nameSuffix].v - A wrapper for the module that converts inputs
  %                               inputs and outputs between binary and
  %                               stochastic representations.
  % ReSC_test_[nameSuffix].v - A testbench for the system.
  % LFSR_[log(N)]_bit_added_zero_[nameSuffix].v - The RNG for generating
  %                                               stochastic numbers.
  
  %Parameters:
  % coeff     : a list of coefficients of the Bernstein polynomial; each
  %             coefficient should fall within the unit interval
  % N         : the length of the stochastic bitstreams, must be a power of 2
  % m_input   : the length in bits of the input, at most log2(N)
  % m_coeff   : the length in bits of the coefficients, at most log2(N)
  % nameSuffix: a distinguishing suffix to append to the name of each Verilog
  %             module
  
  %Optional Parameters:
  % singleWeightLFSR: Use the same LFSR for every constant. (Default true)
  
  ReSCName = sprintf('ReSC_%s', nameSuffix);
  wrapperName = sprintf('ReSC_wrapper_%s', nameSuffix);
  testName = sprintf('ReSC_test_%s', nameSuffix);
  randName = sprintf('LFSR_%d_bit_added_zero_%s', log2(N), nameSuffix);
  
  VerilogCoreReSCGenerator(length(coeff) - 1, ReSCName);
  
  VerilogSCWrapperGenerator(coeff, N, m_input, m_coeff, randName, ReSCName,
                            wrapperName, singleWeightLFSR);
  
  VerilogReSCTestGenerator(coeff, N, m_input, m_coeff, wrapperName, testName);
 
  switch(log2(N))
		case 3
			taps = [3, 2];
		case 4
			taps = [4, 3];
		case 5
			taps = [5, 3];
		case 6
			taps = [6, 5];
		case 7
			taps = [7, 6];
		case 8
			taps = [8, 7, 6, 1];
		case 9
			taps = [9, 5];
		case 10
			taps = [10, 7];
		case 11
			taps = [11, 9];
		case 12
			taps = [12, 11, 10, 4];
		case 13
			taps = [13, 12, 11, 8];
		case 14
			taps = [14, 13, 12, 2];
		case 15
			taps = [15, 14];
		case 16
			taps = [16, 15, 13, 4];
		case 17
			taps = [17, 14];
		case 18
			taps = [18, 11];
		case 19
			taps = [19, 18, 17, 14];
		case 20
			taps = [20, 17];
		case 24
			taps = [24, 23, 22, 17];
		case 32
			taps = [32, 31, 30, 10];

		otherwise
			taps = [3, 2];
	end
  
  VerilogLFSRGenerator(log2(N), taps, true, randName);
end
