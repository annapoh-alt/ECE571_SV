`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Shrinidhi Nagarajan Sreedharamurthy
//PSU ID: 939025042
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------

import RISC_V_pkg :: *;

// ----------------------- Control Unit -------------------------
module control_unit (
  input  logic [6:0] opcode, 
  input  logic [2:0] funct3, 
  input  logic [6:0] funct7,
  output logic       reg_write, 
  output logic [1:0] alu_src_a_sel, 
  output logic [1:0] alu_src_b_sel,
  output logic [3:0] alu_fn, 
  output logic [1:0] imm_sel,
  output logic       mem_read, 
  output logic       mem_write, 
  output logic       mem_to_reg,
  output logic       branch, 
  output logic       jump, 
  output logic       jalr
  
 );
  
  // Default values
  always_comb 
  begin
    reg_write = 1'b0;
    alu_src_a_sel = 2'd0;
    alu_src_b_sel = 2'd0;
    alu_fn = 4'h0;
    imm_sel = 2'b00;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_to_reg = 1'b0;
    branch = 1'b0;
    jump = 1'b0;
    jalr = 1'b0;
    
    unique case (opcode)
      RType : begin // R-type
                reg_write = 1;
                alu_src_b_sel = 2'd0; // rs2
                imm_sel = 2'b00;
                // funct3/funct7 define operation
                unique case ({funct7, funct3})
                  ADD : alu_fn = 4'h0; // ADD
                  SUB : alu_fn = 4'h1; // SUB
                  SLL : alu_fn = 4'h5; // SLL
                  SLT : alu_fn = 4'h8; // SLT
                  SLTU: alu_fn = 4'h9; // SLTU
                  XOR : alu_fn = 4'h4; // XOR
                  SRL : alu_fn = 4'h6; // SRL
                  SRA : alu_fn = 4'h7; // SRA
                  OR  : alu_fn = 4'h3; // OR
                  AND : alu_fn = 4'h2; // AND
                  default: alu_fn = 4'h0;
                endcase
              end
  		  
      IType : begin // I-type ALU immediate
                reg_write = 1;
                alu_src_b_sel = 2'd1; // imm
                imm_sel = 2'b00;
                unique case (funct3)
                    3'b000: alu_fn = 4'h0; // ADDI
                    3'b010: alu_fn = 4'h8; // SLTI
                    3'b011: alu_fn = 4'h9; // SLTIU
                    3'b100: alu_fn = 4'h4; // XORI
                    3'b110: alu_fn = 4'h3; // ORI
                    3'b111: alu_fn = 4'h2; // ANDI
                    3'b001: alu_fn = 4'h5; // SLLI (funct7 0000000)
                    3'b101: begin // SRLI or SRAI
                            if (funct7 == 7'b0000000) 
  		 				    alu_fn = 4'h6; // SRLI
                            else 
  		 				    alu_fn = 4'h7; // SRAI
                    end
                    default: alu_fn = 4'h0;
                endcase
              end
  		  
      LW    : begin // LW
                reg_write = 1;
                mem_read = 1;
                mem_to_reg = 1;
                alu_src_b_sel = 2'd1;
                imm_sel = 2'b00;
                alu_fn = 4'h0; // add
              end
  		  
      SW    : begin // SW
                mem_write = 1;
                alu_src_b_sel = 2'd1;
                imm_sel = 2'b01; // S-type
                alu_fn = 4'h0; // add
              end
  		  
      BType : begin // Branches
                branch = 1;
                alu_src_b_sel = 2'd0;
                imm_sel = 2'b10; // B-type
                case (funct3)
                  BEQ : alu_fn = 4'h1; // BEQ -> SUB then zero
                  BNE : alu_fn = 4'h1; // BNE -> SUB then zero 
                  BLT : alu_fn = 4'h1; // BLT -> SUB and check sign
                  BGE : alu_fn = 4'h1; // BGE
                  default: alu_fn = 4'h1;
                endcase
              end
  		  
      JAL   : begin // JAL
                reg_write = 1;
                jump = 1;
                imm_sel = 2'b11; // J-type
                alu_src_a_sel = 2'd1; // pc
                alu_src_b_sel = 2'd1; // imm
                alu_fn = 4'h0; // add
              end
  		  
      JALR  : begin // JALR
                reg_write = 1;
                jump = 1;
                jalr = 1;
                imm_sel = 2'b00; // I-type imm
                alu_src_a_sel = 2'd0; // rs1
                alu_src_b_sel = 2'd1; // imm
                alu_fn = 4'h0; // add -> target = rs1 + imm
              end
  		  
      LUI   : begin // LUI
                reg_write = 1;
                imm_sel = 2'b00; // handled in immediate generator differently
                alu_src_a_sel = 2'd0;
                alu_src_b_sel = 2'd1;
                // We'll use imm_u externally -- but set ALU to pass-through of imm: use add with a=0
                alu_fn = 4'h0;
              end
  		  
      AUIPC : begin // AUIPC
                reg_write = 1;
                alu_src_a_sel = 2'd1; // pc
                alu_src_b_sel = 2'd1; // imm_u
                imm_sel = 2'b00; 
                alu_fn = 4'h0; // add pc + imm
              end
  		  
      default: begin
                // default: NOP
                reg_write = 0;
                alu_fn = 4'h0;
              end
    endcase
    
  end
  
endmodule
