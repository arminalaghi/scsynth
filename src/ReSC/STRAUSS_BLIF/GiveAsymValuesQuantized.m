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
function z = GiveAsymValuesQuantized(a, n, noOfR)
	%Generates an asymmetric set of STRAUSS coefficients for a single Bernstein
  %coefficient. Gives a series of ones and zeroes followed by (possibly) one,
  %other value, as opposed to the symmetric version, which simply copies the
  %coefficient the appropriate number of times.
  
  %Parameters:
  % a   : Bernstein coefficient
  % n   : Number of STRAUSS coefficients
  % nOfR: Precision of the coefficient in bits.

	if(a == 1)
		z = ones(1, n);
		return;
	end

	b = floor(a * n);
	zz = zeros(1, n-1);

	if(b > 0)
		zz(1:b) = ones(1, b);
	end

	c = n*a - sum(zz);
	q = noOfR - floor(log2(n));
	c = round(c * (2^q))/(2^q);
	z = [zz, c];

	%if(mean(z) != a)
	%	printf('error: %f != %f\n', mean(z), a);
	%end
	
