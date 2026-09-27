`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Devdutt Mallick
//PSU ID: 982590414
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------

import RISC_V_pkg :: *;

// ----------------------- Instruction Memory -------------------------
module instr_mem (
  input  logic [ADDR_WIDTH-1:0] addr , 
  output logic [DATA_WIDTH-1:0] instr
  
 );
    // 16k words -> 64KB
    logic [DATA_WIDTH-1:0] mem [0:2**(ADDR_WIDTH)-1];

    initial 
	begin
      integer i;
	  
      for(i=0;i<(2**(ADDR_WIDTH));i=i+1) 
	    mem[i] = 32'h0000_0013; // ADDI x0,x0,0 => NOP 
    end

    assign instr = mem[addr];
endmodule