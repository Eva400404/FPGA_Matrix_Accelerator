# FPGA Systolic Matrix-Multiplication Accelerator

A parameterized matrix-multiplication accelerator implemented in **SystemVerilog** using a **systolic-array architecture** and targeting Xilinx FPGAs.

The project explores hardware acceleration of matrix multiplication through parallel multiply-accumulate (MAC) processing elements, FPGA DSP resources, banked BRAM storage, and FSM-based control.

The design is currently under active development. The RTL has been verified through simulation, synthesized and implemented in **Xilinx Vivado**, and successfully deployed to a **Digilent Basys 3 (Xilinx Artix-7) FPGA**. The current 4x4 accelerator has been validated on physical hardware at **100 MHz**.

---

## Project Overview

Matrix multiplication is a computationally intensive operation used in scientific computing, signal processing, and machine-learning workloads. This project implements matrix multiplication as a systolic array in order to exploit the parallelism available in FPGA hardware.

Instead of computing matrix elements sequentially, the accelerator contains an array of processing elements (PEs) that perform multiply-accumulate operations concurrently while matrix data propagates through the array.

The project has progressed incrementally from basic arithmetic modules to a parameterized systolic architecture with FPGA-specific memory and DSP optimizations.

### Current design flow

```text
Matrix A ──► Banked BRAM ──►┐
                            │
                            ▼
                     ┌───────────────┐
                     │ Systolic Array│
                     │               │
Matrix B ──► Banked BRAM ──►  PE Grid │
                     │               │
                     └───────┬───────┘
                             │
                             ▼
                         Matrix C

                 FSM Controller
             loading / prefetch / run
```

---

## Architecture

### Systolic Array

The accelerator uses an `N x N` systolic array of processing elements.

Each PE performs a multiply-accumulate operation while forwarding matrix operands to neighboring PEs. This allows multiple partial products to be evaluated concurrently rather than using a single arithmetic unit sequentially.

The design evolved from a fixed 2x2 implementation to a parameterized `N x N` architecture.

Key modules include:

- `systolic_pe.sv` — systolic processing element
- `systolic_array_2x2.sv` — initial 2x2 systolic-array implementation
- `systolic_array_NxN.sv` — parameterized systolic-array implementation
- `systolic_controller.sv` — accelerator control FSM
- `systolic_accelerator_top.sv` — systolic accelerator integration
- `systolic_accelerator_top_bram.sv` — accelerator with BRAM-based input storage

---

### Processing Elements and DSP Resources

Each processing element performs multiply-accumulate operations of the form

```text
accumulator = accumulator + A * B
```

The RTL is written so that multiplication can be inferred using FPGA **DSP48 resources** rather than implementing the arithmetic entirely with general-purpose LUT logic.

For the current 4x4 configuration, synthesis infers **16 DSP resources**, corresponding to the parallel multipliers in the processing-element array.

---

## BRAM-Based Input Storage

An earlier version of the accelerator exposed matrix inputs directly through top-level signals. The current design instead stores the input matrices in FPGA block RAM.

For an `N x N` matrix:

- Matrix **A** is stored using row-oriented BRAM banks.
- Matrix **B** is stored using column-oriented BRAM banks.

For the current `N = 4` implementation:

```text
Matrix A
Row 0 ──► BRAM A0
Row 1 ──► BRAM A1
Row 2 ──► BRAM A2
Row 3 ──► BRAM A3

Matrix B
Col 0 ──► BRAM B0
Col 1 ──► BRAM B1
Col 2 ──► BRAM B2
Col 3 ──► BRAM B3
```

This organization allows the systolic array to access multiple matrix elements in parallel while reducing the number of top-level FPGA I/O signals.

The BRAM interface supports loading matrix elements according to their row and column indices before computation begins.

---

## Controller

The accelerator uses an FSM-based controller to coordinate memory access and systolic-array execution.

The current controller follows the sequence

```text
IDLE
  │
  ▼
CLEAR
  │
  ▼
PREFETCH
  │
  ▼
RUN
  │
  ▼
STORE
  │
  ▼
DONE
```

The `PREFETCH` stage is used because FPGA block RAM uses synchronous reads. The controller accounts for this read latency before data is consumed by the systolic array. After computation, the `STORE` stage writes the completed output matrix C into result BRAM.

This required coordinating BRAM addresses, read counters, systolic-array timing, and the overall computation schedule.

---

## Verification

The RTL is verified using **self-checking SystemVerilog testbenches**.

The accelerator testbench:

1. Loads matrices into the accelerator.
2. Starts the computation.
3. Waits for the controller to assert completion.
4. Computes the expected matrix multiplication result in the testbench.
5. Automatically compares the hardware output against the expected result.

The expected result is calculated independently in the testbench using conventional matrix multiplication:

```systemverilog
expected_C[i][j] =
    expected_C[i][j] + A_mat[i][k] * B_mat[k][j];
```

Tests have been performed using nontrivial input matrices to verify data movement, accumulation, and controller behavior.

Individual modules also have dedicated testbenches, including the MAC, PE, systolic array, controller, and BRAM-integrated accelerator.

### Physical FPGA Verification

A synthesizable Basys 3 board wrapper, `basys3_accelerator_top.sv`, replaces the simulation testbench as the external controller. Its FSM loads fixed 4x4 matrices A and B, starts computation, waits for completion, reads matrix C from result BRAM, and checks all 16 values.

The hardware test uses:

```text
A = B = [ 1   2   3   4
          5   6   7   8
          9  10  11  12
         13  14  15  16 ]
```

with expected output:

```text
C = [  90  100  110  120
      202  228  254  280
      314  356  398  440
      426  484  542  600 ]
```

A pushbutton starts the hardware test, while LEDs indicate completion and pass/fail status. The physical FPGA test completed with both `led_done` and `led_pass` asserted, confirming correct end-to-end matrix multiplication on hardware.


---

## Synthesis

The design has been synthesized using **Xilinx Vivado**.

Current synthesis work has focused on:

- DSP48 multiplier inference
- BRAM-based input storage
- LUT and flip-flop utilization
- DSP utilization
- BRAM utilization
- top-level I/O reduction

Moving the input matrices from direct top-level signals into BRAM substantially reduces the required top-level I/O while preserving correct matrix-multiplication behavior.

### Basys 3 Implementation Results

The current 4x4 design was implemented on the Basys 3 Artix-7 FPGA with a **100 MHz (10 ns)** clock constraint.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs | 202 | 20,800 | 0.97% |
| Slice Registers | 42 | 41,600 | 0.10% |
| Slices | 65 | 8,150 | 0.80% |
| Block RAM Tiles | 4.5 | 50 | 9.0% |
| DSPs | 16 | 90 | 17.8% |
| Bonded I/O | 5 | 106 | 4.7% |
| BUFGCTRL | 1 | 32 | 3.1% |

The 16 inferred DSP resources correspond to the 16 processing elements in the 4x4 systolic array.

Post-implementation timing analysis reports:

- **Worst Negative Slack (WNS): +1.480 ns**
- **Total Negative Slack (TNS): 0.000 ns**
- **Worst Hold Slack (WHS): +0.129 ns**
- **Failing setup/hold endpoints: 0**

All user-specified timing constraints are met at 100 MHz.

---

## Project Structure

The project currently retains the standard Vivado project directory structure.

RTL source files are located in:

```text
counter_project.srcs/sources_1/new/
```

SystemVerilog testbenches are located in:

```text
counter_project.srcs/sim_1/new/
```

Important RTL modules include:

```text
bram_simple.sv
mac.sv
pe.sv
pe_array.sv
systolic_pe.sv
systolic_array_2x2.sv
systolic_array_NxN.sv
systolic_controller.sv
systolic_accelerator_top.sv
systolic_accelerator_top_bram.sv
basys3_accelerator_top.sv
```

The repository also contains earlier modules and intermediate implementations developed while building and validating the accelerator architecture.

Vivado-generated simulation, synthesis, implementation, cache, and temporary files are excluded from version control.

---

## Development Progress

### Completed

- [x] Basic arithmetic and MAC modules
- [x] Processing-element design
- [x] Multi-PE array
- [x] Matrix multiplication RTL
- [x] 2x2 systolic-array implementation
- [x] Parameterized `N x N` systolic array
- [x] FSM-based accelerator controller
- [x] Self-checking SystemVerilog testbenches
- [x] Vivado RTL simulation
- [x] Vivado synthesis
- [x] DSP48 multiplier inference
- [x] Banked BRAM storage for matrix A
- [x] Banked BRAM storage for matrix B
- [x] BRAM-aware prefetch/read scheduling
- [x] Verification with nontrivial input matrices
- [x] Store output matrix C in BRAM
- [x] Reduce top-level FPGA I/O with BRAM-backed storage
- [x] Basys 3 board-control wrapper
- [x] FPGA synthesis and implementation
- [x] Post-implementation timing analysis at 100 MHz
- [x] Deploy design to Digilent Basys 3 / Artix-7
- [x] Validate 4x4 matrix multiplication on physical hardware

### In Progress / Planned

- [ ] Characterize resource scaling for multiple array sizes (`N = 2, 4, 8`, where feasible)
- [ ] Measure maximum achievable clock frequency
- [ ] Measure accelerator latency and throughput
- [ ] Add UART host interface for loading arbitrary matrices and reading results
- [ ] Add fixed-point arithmetic support
- [ ] Compare FPGA performance against a software implementation

---

## Tools and Technologies

- **SystemVerilog**
- **Xilinx Vivado**
- RTL design
- FPGA synthesis
- Systolic arrays
- DSP48 resources
- Block RAM (BRAM)
- Finite-state machines
- Self-checking testbenches
- Git / GitHub

---

## Current Status

The project is **actively under development**.

The current 4x4 accelerator has been validated end-to-end on a **Digilent Basys 3 Artix-7 FPGA**. The implementation uses banked BRAM for matrix A and B storage, result BRAM for matrix C, an FSM-based controller, and 16 DSP-backed processing elements. It meets a **100 MHz** timing constraint with **+1.480 ns WNS** and produces the expected matrix result on physical hardware.

The next phase focuses on scaling and performance characterization, followed by a UART host interface so arbitrary matrices can be transferred between a computer and the FPGA.

---

## Author

**Heshu Yin**  
Electrical Engineering / Physics / Mathematics
