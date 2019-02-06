# Galois Counter Mode AES Encryption in Verilog and Software Test Tool

## GCM-AES implementation in Verilog

This is a "partially pipelined" version of hardware implementaion in system-verilog. Here I pipeline the key expansion process into 4 steps to address the SLACK problem. This implements encryption in 110MHz. Throughput is 128bits * 250M = 32 Gbps. Worst SLACK is 0.04 ns.

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

3. **ATTENTION** It is a real-time running version of 128 bit encryption which only supports 128-bit input by now.

## Software validation is in the pyaes repository

## Usage

1. Run:

```bash
cd pyaes
ipython3 notebook
```

2. In your web browser, open the encrytion\_validation.ipynb to get the right encryption result for 128-bit input.

## TODO:
1. Further parallelize the data links.
2. Double the data rate by using data on falling and rising edge.
