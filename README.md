# scsynth
scsynth is a synthesis tool for stochastic computing circuits. Currently, it can create Verilog files describing reconfigurable architectures based on stochastic logic, or ReSCs (Qian et al., 2011), but its functionality is constantly expanding.

## Stochastic Computing
Stochastic computing is a computing technique involving representing numbers as single streams of bits in sequence rather than groups of bits probabilistically in parallel as is typically done in modern computing architectures. Stochastic circuits tend to run slower than their typical digital counterparts, but they also tend to be smaller (and thus lower-energy) and can be more error tolerant, giving them a number of potential applications, including neural networks and image processing.

More information can be found at https://en.wikipedia.org/wiki/Stochastic_computing.

## Usage
scsynth consists of functions that can be run in MATLAB or Octave to generate Verilog modules. Currently, the following user-facing functions exist:
* `VerilogLFSRGenerator(dataLen, taps, addZero, moduleName)` which generates a linear feedback shift register, a module for pseudorandom number generation
* `VerilogReSCGenerator(coeff, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true)` which generates a full ReSC unit, including conversion to and from binary equivalents (and pseudorandom number generators used therein) as well as a testbench for the module
* `VerilogMultivariateReSCGenerator(coeff, degrees, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true)` which functions much like the normal ReSC generator but allows for functions on multiple variables

More details on the usage of these functions can be found in the source code.

## References
* Qian, W., Li, X., Riedel, M. D., Bazargan, K., & Lilja, D. J. (2011). An Architecture for Fault-Tolerant Computation with Stochastic Logic. IEEE Transactions on Computers IEEE Trans. Comput., 60(1), 93-105. doi:10.1109/tc.2010.202
* Qian, W., & Riedel, M.D. (2010). The Synthesis of Stochastic Logic to Perform Multivariate Polynomial Arithmetic.
