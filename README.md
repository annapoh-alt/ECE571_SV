This project uses SV methodology to verify the RISC-V 32 instruction format.
RTL is the migrated version of a legacy Verilog RV32I design to SystemVerilog with a single-cycle datapath.
TB verifies all supported arithmetic, logic, load/store, branch, and jump instructions in simulation.

What is RISC-V?
RISC-V, an open-source instruction set architecture, used to create custom processors for a wide range of applications, spanning from embedded systems to supercomputers.
Firstly, it was developed at the University of California, Berkeley, RISC-V represents the fifth generation of processors built on the concept of reduced instruction set computing (RISC).

Why RISC-V is chosen?
RISC-V is popular because it is a free, open-source instruction set architecture (ISA) that removes expensive licensing fees and corporate gatekeepers from processor design.

RISC-V supports 6 instruction formats. They are listed below-
1. R-type (Register-to-Register): Used for pure ALU operations like addition, subtraction, and bitwise logic between registers. Fields include funct7, rs2, rs1, funct3, rd, and opcode
2. I-type (Short Immediates and Loads): Used for arithmetic with constants and memory load operations. Replaces rs2 and funct7 with a 12-bit immediate value (imm[11:0])
3. S-type (Store Instructions): Used for storing register values into memory. Splits the 12-bit immediate across two fields (imm[11:5] and imm[4:0]) where rd usually sits
4. B-type (Branch Instructions): Used for conditional branching. A variation of the S-type format that reorganizes immediate bits to encode offset addresses for conditional jumps.
5. U-type (Long Immediates): Used for long upper immediates (such as lui, load upper immediate). Allocates a 20-bit immediate field alongside rd and opcode.
6. J-type (Unconditional Jumps): Used for unconditional jump instructions like jal. A variation of the U-type format structured to handle larger 20-bit jump offsets.

<img width="1544" height="545" alt="image" src="https://github.com/user-attachments/assets/5e09e380-5223-4ba0-a026-43e24cb563cd" />
