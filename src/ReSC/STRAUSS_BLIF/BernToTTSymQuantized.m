%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (C) 2017 Armin Alaghi and N. Eamon Gaffney
%%
%% This program is free software; you can resdistribute and/or modify it under
%% the terms of the MIT license, a copy of which should have been included with
%% this program at https://github.com/arminalaghi/scsynth
%%
%% References:
%% A. Alaghi and J. P. Hayes, "A spectral transform approach to stochastic
%% circuits," 2012 IEEE 30th International Conference on Computer Design (ICCD),
%% Montreal, QC, 2012, pp. 315-321. doi: 10.1109/ICCD.2012.6378658
%%
%% A. Alaghi and J. P. Hayes, "STRAUSS: Spectral Transform Use in Stochastic
%% Circuit Synthesis," in IEEE Transactions on Computer-Aided Design of
%% Integrated Circuits and Systems, vol. 34, no. 11, pp. 1770-1783, Nov. 2015.
%% doi: 10.1109/TCAD.2015.2432138
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function z = BernToTTSymQuantized(a, noOfR)
  %Generates a series of symmetric STRAUSS constans given Bernstein constants.
  %Effectively just copies the constants repeatedly into the appropriate order

  %Parameters:
  % a    : Bernstein coefficients
  % nOfR : Precision of the coefficients (in bits)
	a = round(a * (2^noOfR))/(2^noOfR);

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);

	z = zeros(1, l_z);

	for i = 1: l_z
		j = sum(dec2bin(i-1)-48);
		z(i) = a(j+1);
	end
