%% sampleScript.m
% This script produces three Stochastic Systems.
% It's a good starting point to check if everything has
% been setup correctly. If needed, turn 'useParallel' to 'false'
% To run, open an Octave session in this script's folder and do
% sampleScript <Enter>
% It should produce 12 files, 4 files for each case.

clear all
% Add src folder and all source code to environment
addpath(genpath('.'))
% Allow printing during executing
% this turns off "page mode"
more off;

%ReSC Example
func = @sin;
func = @(x) 0.25*x
degree = 1
det_bits = 16;
m_input =  det_bits
m_coeff =  det_bits
N =  2^det_bits
modSuffix = 'SinReSC'
ConstantRNG='SharedLFSR';
InputRNG='LFSR';
ConstantSNG='WBG';
InputSNG='Comparator';
SCModule='ReSC'; 
domain=[0,1];
granularity=100;
useParallel=true

VerilogSCFromFunction(func, degree, N, m_input, m_coeff, modSuffix, ...
   ConstantRNG, InputRNG, ConstantSNG, InputSNG, ...
   SCModule, domain, granularity,useParallel) 
% STRAUSS example

func = @sin;
func = @(x) 0.25*x
degree = 1
det_bits = 16;
m_input =  det_bits
m_coeff =  det_bits
N =  2^det_bits
modSuffix = 'SinSTRAUSS'
ConstantRNG='SharedLFSR';
InputRNG='LFSR';
ConstantSNG='WBG';
InputSNG='Comparator';
SCModule='STRAUSS'; 
domain=[0,1];
granularity=100;
useParallel=true

VerilogSCFromFunction(func, degree, N, m_input, m_coeff, modSuffix, ...
   ConstantRNG, InputRNG, ConstantSNG, InputSNG, ...
   SCModule, domain, granularity,useParallel)

%% MReSC example
degrees =  [1,1,1]
det_bits = 8;
m_input =  det_bits
m_coeff =  det_bits
N =  2^det_bits
domains = [0, 1]
granularities = [5,10,4]
namePrefix='SampleMReSC'
singleWeightLFSR=true
useParallel=true

%% MReSC from function
func = @(z1,z2,z3) (abs(z1+2*z2+z3)+abs((z3+2)-(z1)))/3.0;
VerilogMReSCFromFunction(func, degrees, N, m_input, m_coeff, namePrefix,...
                    singleWeightLFSR, domains, granularities,useParallel);

 
 
