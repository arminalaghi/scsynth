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
function Y = WriteBLIFWithSharing(TT, noOfX, noOfR, filename, modelname);
  %Writes BLIF with the STRASS algorithm, tries to share constant generation
	%TT is in sym/asym format
  
  %Parameters:
  % TT        : STRAUSS coefficients
  % noOfX     : Number of x values.
  % noOfR     : Precision of coefficiens in bits.
  % filename  : Name of BLIF file.
  % modulename: Name of BLIF module.

	%noOfR
	ll = length(TT);
	fp = fopen(filename, 'w');

	fprintf(fp, '.model %s\n\n', modelname);
	%fprintf(fp, '.search LFSR%d.blif\n\n', noOfR);
	fprintf(fp, '.inputs');
	for i=1:noOfX
		fprintf(fp, ' x%d', i);
	end
	for i=1:noOfR
		fprintf(fp, ' r%d', i);
	end

	%fprintf(fp, ' clk');
	fprintf(fp, '\n\n.outputs z\n\n');

	
	fprintf(fp, '\n\n.names x1 ONE\n0 1\n1 1\n\n.names ONE ZERO\n1 0\n\n');

	fprintf(fp, '.names');
	for i=1:noOfX
		fprintf(fp, ' x%d', i);
	end
	for i=1:(ll)
		fprintf(fp, ' wire%d_1', i);
	end
	fprintf(fp, ' z\n');
	for i=0:(ll-1)
		for j=noOfX-1:-1:0
			fprintf(fp, '%d', giveBit(i, j));
		end
		for j=0:(ll-1)
			if(i==j)
				fprintf(fp, '1');
			else
				fprintf(fp, '-');
			end
		end
		fprintf(fp, ' 1\n');
	end


	
	prob_table = zeros(1, 4);
	%prob, level, wire_number1, wire_number2


	for i=1:ll
		
		temp = round(TT(i)*(2^noOfR))/(2^noOfR); %round to closes representable number given noOfR
		fprintf(fp, '\n\n');

		for j=1:noOfR+1
			if(temp == 1)
				fprintf(fp, '\n.names ONE wire%d_%d\n1 1\n', i, j);
				break;
			elseif(temp == 0)
				fprintf(fp, '\n.names ZERO wire%d_%d\n1 1\n', i, j);
				break;
			else
				if(size(find(prob_table(:, 1) == temp), 1) ~= 0) %prob exists
					index = find(prob_table(:, 1) == temp);
					temp2 = prob_table(index, :);
					if(size(find(temp2(:, 2) == j), 1) ~= 0) %the same level
						index2 = find(temp2(:, 2) == j);
						temp2 = temp2(index2, :);
						fprintf(fp, '\n.names wire%d_%d wire%d_%d\n1 1\n', temp2(1, 3), temp2(1, 4), i, j);
						break;
					end
				end

				if(size(find(prob_table(:, 1) == 1 - temp), 1) ~= 0) %prob inverse exists
					index = find(prob_table(:, 1) == 1 - temp);
					temp2 = prob_table(index, :);
					if(size(find(temp2(:, 2) == j), 1) ~= 0) %the same level
						index2 = find(temp2(:, 2) == j);
						temp2 = temp2(index2, :);
						fprintf(fp, '\n.names wire%d_%d wire%d_%d\n0 1\n', temp2(1, 3), temp2(1, 4), i, j);
						%printf('\ncontinue seen %d %d\n', i, j)
						break;
					end
				end

				%printf('\ncontinue not applied %d %d\n', i, j)
				new_row = [temp, j, i, j];
				prob_table = [prob_table ; new_row];
				if(temp < 0.5)
					fprintf(fp, '\n.names r%d wire%d_%d wire%d_%d\n11 1\n', j, i, j+1, i, j);
					temp = 2*temp;
				else
					fprintf(fp, '\n.names r%d wire%d_%d wire%d_%d\n00 0\n', j, i, j+1, i, j);
					temp = 2*temp - 1;
				end
			end
		end


		%fprintf(fp, '\n.names');
		%for j=1:noOfR
		%	fprintf(fp, ' r%d', j);
		%end
		%fprintf(fp, ' wire%d\n', i);
		%temp = (1-TT(i+1))/2; % convert to unipolar
		%temp = round(temp*(2^noOfR)); %round to closes representable number given noOfR
		%%temp tells you how many 1s you need	
		%for j=0:temp-1
		%	for k=noOfR-1:-1:0
		%		fprintf(fp, '%d', giveBit(j, k));
		%	end
		%	fprintf(fp, ' 1\n');
		%end

	end

	%fprintf(fp, '\n.subckt LFSR%d clk=clk', noOfR);
	%for i=1:noOfR
	%	fprintf(fp, ' s%d=r%d', i, i);
	%end

	fprintf(fp, '\n\n.end\n');
	
	fflush(fp);
	fclose(fp);



	

