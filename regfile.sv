`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Devdutt Mallick
//PSU ID: 982590414
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------

import RISC_V_pkg :: *;

// ----------------------- Register File -------------------------
module regfile (
  input  logic                  clk, 
  input  logic                  rst_n, 
  input  logic                  we,
  input  logic            [4:0] rs1, 
  input  logic            [4:0] rs2, 
  input  logic            [4:0] rd,
  input  logic [DATA_WIDTH-1:0] wd,
  output logic [DATA_WIDTH-1:0] rs1_data, 
  output logic [DATA_WIDTH-1:0] rs2_data
  
 );

    logic [DATA_WIDTH-1:0] regs [0:DATA_WIDTH-1];
    integer i;

    always_ff @(posedge clk, negedge rst_n) 
	begin
	  if(!rst_n)
        for(i=0;i<DATA_WIDTH;i=i+1) 
	      regs[i] = 32'd0;
		  
    end

    // read ports (combinational)
    assign rs1_data = (rs1 != 0) ? regs[rs1] : 32'd0;
    assign rs2_data = (rs2 != 0) ? regs[rs2] : 32'd0;

    // write port (synchronous)
    always_ff @(posedge clk, negedge rst_n) 
	begin
	  if(!rst_n)
	    regs[rd] <= 'd0;
      else 
	    if((we && rd) != 0)
          regs[rd] <= wd;
		  
    end
	
endmodule
