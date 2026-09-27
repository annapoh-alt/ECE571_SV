//-------------------------------------------------------------------
//Name  : Annapoorna Hamsagaru Manjunath
//PSU ID: 984436960
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------

// ----------------------- RISC_V_pkg -------------------------
package RISC_V_pkg;
  
  //Parameters
  parameter  DATA_WIDTH  = 'd32;
  parameter  ADDR_WIDTH  = 'd14;
  
  //Instruction Type
  localparam RType = 7'b0110011;
  localparam IType = 7'b0010011;
  localparam LW    = 7'b0000011;
  localparam SW    = 7'b0100011;
  localparam BType = 7'b1100011;
  localparam JAL   = 7'b1101111;
  localparam JALR  = 7'b1100111;
  localparam LUI   = 7'b0110111;
  localparam AUIPC = 7'b0010111;
  
  //ALU Function(FUNCT 7, FUNCT 3)
  localparam ADD   = 10'b0000000_000;
  localparam SUB   = 10'b0100000_000;
  localparam SLL   = 10'b0000000_001;
  localparam SLT   = 10'b0000000_010;
  localparam SLTU  = 10'b0000000_011;
  localparam XOR   = 10'b0000000_100;
  localparam SRL   = 10'b0000000_101;
  localparam SRA   = 10'b0100000_101;
  localparam OR    = 10'b0000000_110;
  localparam AND   = 10'b0000000_111;
  
  //Branch Type
  localparam BEQ = 3'b000;
  localparam BNE = 3'b001;
  localparam BLT = 3'b100;
  localparam BGE = 3'b101;
  
  //ALU OperATION
  typedef enum logic [3:0] {
    OPR_ADD  ,
    OPR_SUB  ,
    OPR_AND  ,
    OPR_OR   ,
    OPR_XOR  ,
    OPR_SLL  ,
    OPR_SRL  ,
    OPR_SRA  ,
    OPR_SLT  ,
    OPR_SLTU
  } funct_t;
  
endpackage