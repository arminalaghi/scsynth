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
function z = GreedySearchForAsymScalable(a, noOfR)
	%Gets a BernTT and finds the best sym/asym set of STRAUSS coefficients.
  %Fast greedy algorithm.
  
  %Parameters:
  % a   : Bernstein coefficients
  % nOfR: Precision of the coefficients (in bits)

	l_a = length(a);
	l_z = 2 ^ (l_a - 1);
	temp_filename = sprintf('octave_tempfile.blif');
	temp_modelname = sprintf('octave_tempfile');
	noOfX = length(a) - 1;

	z = zeros(1, l_z);
	z = BernToTTSymQuantized(a, noOfR);
	%z(2) = 5
	
	for count = 1: 2
		for i = 1: l_a
			temp = GiveAsymValuesQuantized(a(i), nchoosek(l_a-1, i-1), noOfR);
			temp2 =  unique(perms(temp), "rows");
			index = zeros(1, l_a - 1);
			if(i-1 > 0)
				index(1:i-1) = ones(1, i-1);
			end
			index = unique(perms(index), "rows");
			index = bin2dec(char(index + 48)) + 1;
			
			%z(index) = temp;
			
			if(size(temp2, 1) > 120)
				rand_index = randperm(size(temp2, 1));
				temp2 = temp2(rand_index(1:120), :);
			end


			z_temp = zeros(size(z,1)*size(temp2,1), l_z);

			for j=1:size(z,1)
				for k=1:size(temp2, 1)
					z_temp((j-1)*size(temp2,1)+k, :) = z(j, :);
					z_temp((j-1)*size(temp2,1)+k, index) = temp2(k, :);
				end
			end

			best_sop = 10^10;
			best_index = 0;
			for j=1:size(z_temp, 1)
				WriteBLIFWithSharing(z_temp(j, :), noOfX, noOfR, temp_filename, temp_modelname);
				temp_sop = CalculateSoPABC(temp_filename);
				if(temp_sop < best_sop)
					best_sop = temp_sop;
					best_index = j;
				end
			end
			best_sop;
			best_index;

			z = z_temp(best_index, :);
		end
	end

