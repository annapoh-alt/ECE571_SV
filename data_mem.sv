`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Shrinidhi Nagarajan Sreedharamurthy
//PSU ID: 939025042
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------
import RISC_V_pkg :: *;

// ----------------------- Data Memory -------------------------
module data_mem (
  input  logic clk,
  input  logic we, 
  input  logic re, 
  input  logic [ADDR_WIDTH-1:0] addr, 
  input  logic [DATA_WIDTH-1:0] wd, 
  output logic [DATA_WIDTH-1:0] rd
  
 );
  logic [DATA_WIDTH-1:0] mem [0:2**(ADDR_WIDTH)-1];
  
  //----
  always_ff @(posedge clk) 
  begin
    if (we) 
      mem[addr] <= wd;
  	
  end
  
  assign rd = (re) ? mem[addr] : 32'd0;
  
endmodule
