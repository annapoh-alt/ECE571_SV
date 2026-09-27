// RISC-V RV32I single-cycle CPU (SystemVerilog)
// Supports a subset of RV32I: LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, ADDI, SLTI,
// ANDI, ORI, XORI, SLLI, SRLI, SRAI, ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND,
// LW, SW
// Instruction memory and data memory are simple arrays; use $readmemh to initialize.

`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Shrinidhi Nagarajan Sreedharamurthy
//PSU ID: 939025042
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------

import RISC_V_pkg :: *;

module riscv_single_cycle (
    input  logic clk,
    input  logic rst_n
	
 );

  // Program counter
  logic [DATA_WIDTH-1:0] pc;
  logic [DATA_WIDTH-1:0] pc_next;
  logic [DATA_WIDTH-1:0] pc_plus4;
  logic [DATA_WIDTH-1:0] branch_target;
  
  // Instruction fetched
  logic [DATA_WIDTH-1:0] instr;
  
  // Control signals
  logic        reg_write;
  logic [1:0]  alu_src_a_sel; // 0->rs1, 1->pc
  logic [1:0]  alu_src_b_sel; // 0->rs2, 1->imm
  logic [3:0]  alu_fn;
  logic [1:0]  imm_sel;
  logic        mem_read;
  logic        mem_write;
  logic        mem_to_reg;
  logic        branch;
  logic        jump;
  logic        jalr;
  
  // Register file
  logic [4:0]  rs1;
  logic [4:0]  rs2;
  logic [4:0]  rd ;
  
  logic [DATA_WIDTH-1:0] rs1_data;
  logic [DATA_WIDTH-1:0] rs2_data;
  logic [DATA_WIDTH-1:0] rd_data ;
  
  // Immediate
  logic [DATA_WIDTH-1:0] imm_i;
  logic [DATA_WIDTH-1:0] imm_s;
  logic [DATA_WIDTH-1:0] imm_b;
  logic [DATA_WIDTH-1:0] imm_u;
  logic [DATA_WIDTH-1:0] imm_j;
  logic [DATA_WIDTH-1:0] imm_out;
  
  // ALU
  logic [DATA_WIDTH-1:0] alu_in_a;
  logic [DATA_WIDTH-1:0] alu_in_b;
  logic [DATA_WIDTH-1:0] alu_out ;
  logic                  alu_zero;
  
  // Data memory
  logic [DATA_WIDTH-1:0] mem_rdata;
  logic [DATA_WIDTH-1:0] mem_wdata;
  logic [DATA_WIDTH-1:0] load_data;
  

  
  // -- Instruction memory (simple)
  instr_mem imem (
    .addr(pc[15:2]), 
    .instr(instr)
  ); // word addressed via bits [15:2]
  
  // -- Register file
  regfile regs (
    .clk(clk),
    .rst_n(rst_n),	
    .we(reg_write), 
    .rs1(rs1), 
    .rs2(rs2), 
    .rd(rd), 
    .wd(rd_data), 
    .rs1_data(rs1_data), 
    .rs2_data(rs2_data)
  );
  
  // -- ALU
  alu alu0 (
    .a(alu_in_a), 
    .b(alu_in_b), 
    .fn(alu_fn), 
    .y(alu_out), 
    .zero(alu_zero)
    
  );
  
  // -- Data memory
  data_mem dmem (
    .clk(clk), 
    .we(mem_write), 
    .re(mem_read), 
    .addr(alu_out[15:2]), 
    .wd(rs2_data), 
    .rd(mem_rdata)
    
  );
  
  // -- Control unit (simple decoder)
  control_unit ctrl (
    .opcode(instr[6:0]), 
    .funct3(instr[14:12]), 
    .funct7(instr[31:25]),
    .reg_write(reg_write), 
    .alu_src_a_sel(alu_src_a_sel), 
    .alu_src_b_sel(alu_src_b_sel),
    .alu_fn(alu_fn), 
    .imm_sel(imm_sel), 
    .mem_read(mem_read), 
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg), 
    .branch(branch), 
    .jump(jump), 
    .jalr(jalr)
    
  );
  
  // -- PC logic
  assign pc_plus4 = pc + 32'd4;
  
  // -- Decode fields
  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign rd  = instr[11:7];
  
  // -- Immediate generators
  assign imm_i = {instr[31:20]};
  assign imm_s = {instr[31:25], instr[11:7]};
  assign imm_b = {instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
  assign imm_u = {instr[31:12], 12'd0};
  assign imm_j = {instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
  
  // Select immediate per type
  always_comb 
  begin
    case (imm_sel)
      2'd0: imm_out = {{20{imm_i[11]}}, {imm_i[0+:11]}}; // I-type
      2'd1: imm_out = {{20{imm_s[11]}}, {imm_s[0+:11]}}; // S-type
      2'd2: imm_out = {{19{imm_b[12]}}, {imm_b[0+:12]}}; // B-type
      2'd3: imm_out = {{11{imm_j[20]}}, {imm_j[0+:20]}}; // J-type (use for JAL)
      default: imm_out = {{20{imm_i[11]}}, {imm_i[0+:11]}};
    endcase
    
  end
  
  // -- ALU input selection
  always_comb 
  begin
    case (alu_src_a_sel)
      2'd0: alu_in_a = rs1_data;
      2'd1: alu_in_a = pc;
      default: alu_in_a = rs1_data;
    endcase
    
    case (alu_src_b_sel)
      2'd0: alu_in_b = rs2_data;
      2'd1: alu_in_b = imm_out;
      default: alu_in_b = rs2_data;
    endcase
    
  end
  
  // -- Load data alignment 
  assign load_data = mem_rdata;
  
  // -- Writeback select
  always_comb 
  begin
    if (mem_to_reg)
        rd_data = load_data;
    else if (jump)
        rd_data = pc_plus4;
    else
        rd_data = alu_out;
  	  
  end
  
  // -- Branch target calculation
  assign branch_target = pc + imm_out;
  
  // -- PC next logic
  always_comb 
  begin
    if (jump) 
      if (jalr) 
        pc_next = {alu_out[31:1], 1'b0}; // JALR: target from ALU with low bit cleared
      else 
        pc_next = alu_out; // JAL with computed target in ALU
  
    else 
      if (branch && alu_zero) 
        pc_next = branch_target;
      else 
        pc_next = pc_plus4;
   	 
  end
  
  // -- PC register
  always_ff @(posedge clk or negedge rst_n) 
  begin
    if (!rst_n) 
      pc <= 32'h0000_0000;
    else 
      pc <= pc_next;
	  
  end

endmodule

// ----------------------- End of file -------------------------
