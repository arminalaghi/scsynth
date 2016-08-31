# scsynth
scsynth is a synthesis tool for stochastic computing circuits developed by N. Eamon Gaffney and Armin Alaghi at the Univeristy of Washington. Currently, it can create Verilog files describing reconfigurable architectures based on stochastic logic, or ReSCs (Qian et al., 2011), but its functionality is constantly expanding.

## Stochastic Computing
Stochastic computing is a computing technique involving representing numbers as single streams of bits in sequence rather than groups of bits probabilistically in parallel as is typically done in modern computing architectures. Stochastic circuits tend to run slower than their typical digital counterparts, but they also tend to be smaller (and thus lower-energy) and can be more error tolerant, giving them a number of potential applications, including neural networks and image processing.

More information can be found at https://en.wikipedia.org/wiki/Stochastic_computing.

## Usage
scsynth consists of functions that can be run in MATLAB or Octave to generate Verilog modules. Currently, the following user-facing functions exist:
* `VerilogLFSRGenerator(dataLen, taps, addZero, moduleName)` which generates a linear feedback shift register, a module for pseudorandom number generation
* `VerilogReSCFromData(data, degree, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true, ConstantRNG='SharedLFSR', InputRNG='LFSR', ConstantSNG='Comparator', InputSNG='Comparator')` which, given datapoints from a function and the desired degree of the polynomial used to model the function, generates a full ReSC unit, including conversion to and from binary equivalents (and pseudorandom number generators used therein) as well as a testbench for the module
* `VerilogReSCFromFunction(func, degree, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true, ConstantRNG='SharedLFSR', InputRNG='LFSR', ConstantSNG='Comparator', InputSNG='Comparator', domain=[0,1], granularity=100)` which works like VerilogReSCFromData, but takes a function itself rather than data representing that function 
* `VerilogMReSCFromData(data, degrees, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true)` which functions much like the normal ReSC generator but allows for functions on multiple variables (note: computational complexity scales very quickly as you add variables)
* `VerilogMReSCFromData(func, degrees, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true, domains=[0,1], granularities=100)` which generates a multivariate ReSC from a function rather than data

More details on the usage of these functions can be found in the source code.

## References
*A. Alaghi and J. P. Hayes, "Exploiting correlation in stochastic circuit design," 2013 IEEE 31st International Conference on Computer Design (ICCD), Asheville, NC, 2013, pp. 39-46. doi: 10.1109/ICCD.2013.6657023
*B. D. Brown and H. C. Card, "Stochastic neural computation. I. Computational elements," in IEEE Transactions on Computers, vol. 50, no. 9, pp. 891-905, Sep 2001. doi: 10.1109/12.954505
*Gupta, P. K. and Kumaresan, R. 1988. Binary multiplication with PN sequences. IEEE Trans. Acoustics Speech Signal Process. 36, 603–606.
* Qian, W., Li, X., Riedel, M. D., Bazargan, K., & Lilja, D. J. (2011). An Architecture for Fault-Tolerant Computation with Stochastic Logic. IEEE Transactions on Computers IEEE Trans. Comput., 60(1), 93-105. doi:10.1109/tc.2010.202
* Qian, W., & Riedel, M.D. (2010). The Synthesis of Stochastic Logic to Perform Multivariate Polynomial Arithmetic.