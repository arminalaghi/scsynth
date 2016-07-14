# scsynth
scsynth is a synthesis tool for stochastic computing circuits. Currently, it can create Verilog files describing reconfigurable architectures based on stochastic logic, or ReSCs (Qian et al., 2010), but its functionality is constantly expanding.

## Stochastic Computing
Stochastic computing is a computing technique involving representing numbers as single streams of bits in sequence rather than groups of bits probabilistically in parallel as is typically done in modern computing architectures. Stochastic circuits tend to run slower than their typical digital counterparts, but they also tend to be smaller (and thus lower-energy) and can be more error tolerant, giving them a number of potential applications, including neural networks and image processing.

More information can be found at https://en.wikipedia.org/wiki/Stochastic_computing.

## Usage
scsynth consists of functions that can be run in MATLAB or Octave to generate Verilog modules. Currently, the following functions exist:
* `VerilogLFSRGenerator(dataLen, taps, addZero, moduleName)` which generates a linear feedback shift register, a module for pseudorandom number generation
* `VerilogReSCGenerator(coeff, N, m_input, m_coeff, nameSuffix)` which generates a full ReSC unit, including conversion to and from binary equivalents (and pseudorandom number generators used therein) as well as a testbench for the module

More details on the usage of these functions can be found in the source code.

## References
* W. Qian, X. Li, M. D. Riedel, K. Bazargan and D. J. Lilja, "An Architecture for Fault-Tolerant Computation with Stochastic Logic," in IEEE Transactions on Computers, vol. 60, no. 1, pp. 93-105, Jan. 2011. doi: 10.1109/TC.2010.202
