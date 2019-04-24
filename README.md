# Galois Counter Mode AES Encryption in Verilog and Software Test Tool

## GCM-AES implementation in Verilog

This is a "pipelined" version of hardware implementaion in system-verilog. Here I pipeline the key expansion process into 15 steps to address the SLACK problem. This implements encryption in 110MHz. Throughput is 2 * 128bits * 200M = 51.2 Gbps. Worst SLACK is 0.04 ns. [Reference](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf) [AES](https://nvlpubs.nist.gov/nistpubs/fips/nist.fips.197.pdf).

## Usage

### Requirement:

1. Vivado 16.4 or higher.

2. Implementaion is on a SUME FPGA board.

### Simulation:

1. Modify the simulation file test128.sv.

2. In the directory run:

```bash
bash shell/sim.bash
```

### Implementation

1. Run:

```bash
bash shell/make.bash
```

2. Download the bitstream file to hardware.

3. **ATTENTION** It is a real-time running version of 128 bit encryption which only supports 128-bit-multiple input by now.

## Software validation is in the pyaes repository

## Usage

1. Run:

```bash
cd pyaes
ipython3 notebook
```

2. Modify and run the pyaes\test.py to get the right encryption result for 128-bit-mulitple input. Or you can migrate to ipython notebook to debug it. And modify the input in test128.sv to check if the SW/HW results coincide.

## TODO:
1. (Now 15 clks) Further parallelize the data links.
2. (Done encryption part) Double the data rate by using data on falling and rising edge.
