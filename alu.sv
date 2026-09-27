`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Annapoorna Hamsagaru Manjunath
//PSU ID: 984436960
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------

import RISC_V_pkg :: *;

// ----------------------- ALU -------------------------
module alu (
  input  logic [DATA_WIDTH-1:0] a, 
  input  logic [DATA_WIDTH-1:0] b, 
  input  logic            [3:0] fn, 
  output logic [DATA_WIDTH-1:0] y, 
  output logic zero
  
 );
 
  logic [DATA_WIDTH-1:0] b_shamt;
  //ENUM
  funct_t opr;
  
  //----
  assign b_shamt = b[4:0];
  assign opr = funct_t'(fn);

  //----
  always_comb
  begin
    unique case (opr)
      // arithmetic
      OPR_ADD  : y = a + b;                  // ADD / ADDI
      OPR_SUB  : y = a - b;                  // SUB
      OPR_AND  : y = a & b;                  // AND
      OPR_OR   : y = a | b;                  // OR
      OPR_XOR  : y = a ^ b;                  // XOR
      OPR_SLL  : y = (a << b_shamt);         // SLL
      OPR_SRL  : y = (a >> b_shamt);         // SRL logical
      OPR_SRA  : y = $signed(a) >>> b_shamt; // SRA arithmetic
      OPR_SLT  : y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT
      OPR_SLTU : y = (a < b) ? 32'd1 : 32'd0; // SLTU
      default: y = 32'd0;
    endcase
  end
  
  assign zero = (y == 32'd0);
  
endmodule
