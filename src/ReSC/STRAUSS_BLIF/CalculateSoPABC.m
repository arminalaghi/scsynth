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
function z = CalculateSoPABC(filename)
	%Calculates the number of AND gates in a BLIF file

  %Parameters:
  % filename: name of the BLIF file
  
	%temporary files
	input_filename = sprintf('octave_input.txt');
	output_filename = sprintf('octave_output.txt');
	output_filename2 = sprintf('octave_output2.txt');
	
	
	%Generating a list of commands as the input to ABC
	fp = fopen(input_filename, 'w');
	
	%reads the BLIF file first
	fprintf(fp, 'read %s\n', filename);
	
  	%synthesis commands here
  	%Armin: I added strash renode strash, then I print the output stats
  	fprintf(fp, 'strash\nrenode\nstrash\nprint_stats\nquit\n');
  
	fflush(fp);
	fclose(fp);

	%run the commands in ABC and dumpt the output to a temporary file
	command = sprintf('abc10216.exe < %s > %s', input_filename, output_filename);
	system(command);

	%extract the line that has the word "and"		
	command = sprintf('cat %s | grep and> %s', output_filename, output_filename2);
	system(command);

	
	fp = fopen(output_filename2, 'r');
	data = textscan(fp, '%s');
	
	%searching for the word "and" in the line
	for i=1:length(data{1,1})
    		if(length(cell2mat(data{1,1}(i,1))) == 3)
      			if(cell2mat(data{1,1}(i,1)) == 'and')
      				%reading the value of and
        			result = cell2mat(data{1,1}(i+2,1));
      			end
    		end
  	end
  
	fclose(fp);
  
	%returning result
	z = str2num(result);

	%removing temporary files
	command = sprintf('rm %s', input_filename);
	system(command);
	command = sprintf('rm %s', output_filename);
	system(command);
	command = sprintf('rm %s', output_filename2);
	system(command);

end
