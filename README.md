# scsynth
scsynth is a synthesis tool for stochastic computing circuits developed by N. Eamon Gaffney and Armin Alaghi at the Univeristy of Washington. Currently, it can create Verilog files describing reconfigurable architectures based on stochastic logic, or ReSCs (Qian et al., 2011), as well as similar STRAUSS architectures (Alaghi et al., 2015) but its functionality is constantly expanding.

## Stochastic Computing
Stochastic computing is a computing technique involving representing numbers as single streams of bits in sequence rather than groups of bits probabilistically in parallel as is typically done in modern computing architectures. Stochastic circuits tend to run slower than their typical digital counterparts, but they also tend to be smaller (and thus lower-energy) and can be more error tolerant, giving them a number of potential applications, including neural networks and image processing.

More information can be found at https://en.wikipedia.org/wiki/Stochastic_computing.

## Usage
scsynth consists of functions that can be run in MATLAB or Octave to generate Verilog modules. Currently, the following user-facing functions exist:
* `VerilogLFSRGenerator(dataLen, taps, addZero, moduleName)` which generates a linear feedback shift register, a module for pseudorandom number generation
* `VerilogSCFromData(data, degree, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true, ConstantRNG='SharedLFSR', InputRNG='LFSR', ConstantSNG='HardWire', InputSNG='Comparator', SCModule='ReSC')` which, given datapoints from a function and the desired degree of the polynomial used to model the function, generates a full ReSC or STRAUSS unit, including conversion to and from binary equivalents (and pseudorandom number generators used therein) as well as a testbench for the module
* `VerilogSCFromFunction(func, degree, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true, ConstantRNG='SharedLFSR', InputRNG='LFSR', ConstantSNG='HardWire', InputSNG='Comparator', SCModule='ReSC', domain=[0,1], granularity=100)` which works like VerilogSCFromData, but takes a function itself rather than data representing that function 
* `VerilogMReSCFromData(data, degrees, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true)` which functions much like the normal ReSC generator but allows for functions on multiple variables (note: computational complexity scales very quickly as you add variables)
* `VerilogMReSCFromData(func, degrees, N, m_input, m_coeff, nameSuffix, singleWeightLFSR=true, domains=[0,1], granularities=100)` which generates a multivariate ReSC from a function rather than data

More details on the usage of these functions can be found in the source code.

## References
* A. Alaghi and J. P. Hayes, "A spectral transform approach to stochastic circuits," 2012 IEEE 30th International Conference on Computer Design (ICCD), Montreal, QC, 2012, pp. 315-321. doi: 10.1109/ICCD.2012.6378658
* A. Alaghi and J. P. Hayes, "Exploiting correlation in stochastic circuit design," 2013 IEEE 31st International Conference on Computer Design (ICCD), Asheville, NC, 2013, pp. 39-46. doi: 10.1109/ICCD.2013.6657023
* A. Alaghi and J. P. Hayes, "STRAUSS: Spectral Transform Use in Stochastic Circuit Synthesis," in IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems, vol. 34, no. 11, pp. 1770-1783, Nov. 2015. doi: 10.1109/TCAD.2015.2432138
* B. D. Brown and H. C. Card, "Stochastic neural computation. I. Computational elements," IEEE Trans. Computers, 2001. doi: 10.1109/12.954505
* P. K. Gupta and R. Kumaresan, "Binary multiplication with PN sequences," IEEE Trans. Acoustics Speech Signal Process, 1988.
* W. Qian, X. Li, M. D. Riedel, K. Bazargan and D. J. Lilja, D. J. "An architecture for fault-tolerant computation with stochastic logic," IEEE Trans. on Computers, 2011. doi:10.1109/tc.2010.202
* W. Qian and M. D. Riedel, "The synthesis of stochastic logic to perform multivariate polynomial arithmetic," 2010.
* The Berkeley ABC library. https://people.eecs.berkeley.edu/~alanmi/abc/abc.htm
