`timescale 1ns/1ps
//-------------------------------------------------------------------
//Name  : Annapoorna Hamsagaru Manjunath
//PSU ID: 984436960
//Introduction to SystemVerilog
//RISC V
//-------------------------------------------------------------------
import RISC_V_pkg :: *;

module tb_riscv_single_cycle;
  
  bit clk;
  bit rst_n;
  
  // ============================
  // DUT INSTANCE
  // ============================
  riscv_single_cycle dut (
      .clk(clk),
      .rst_n(rst_n)
  );
  
  // ============================
  // CLOCK (10ns PERIOD)
  // ============================
  always #5 clk = ~clk;
  
  // ============================
  // SIM CONTROL
  // ============================
  initial 
  begin
    reset;
    load_mem;
    #500;
    $display(" SIMULATION FINISHED");
    $finish;
  end
  
  // =====================================================
  // RESET
  // =====================================================
  task reset;
    rst_n = 0;
    #20;
    rst_n = 1;
  endtask
  
  // =====================================================
  // RISC-V RV32I INSTRUCTION LOAD
  // =====================================================
  task load_mem;
    $readmemh("program.hex", dut.imem.mem);
  endtask
  
  // =====================================================
  // RISC-V RV32I INSTRUCTION DISASSEMBLER
  // =====================================================
  task automatic disasm(input logic [31:0] instr);
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic [4:0] rd, rs1, rs2;
    integer imm_i, imm_s, imm_b, imm_j;
    
    begin
      opcode = instr[6:0];
      rd     = instr[11:7];
      funct3 = instr[14:12];
      rs1    = instr[19:15];
      rs2    = instr[24:20];
      funct7 = instr[31:25];
    
      imm_i = {{20{instr[31]}}, instr[31:20]};
      imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      imm_b = {{19{instr[31]}}, instr[31], instr[7],
               instr[30:25], instr[11:8], 1'b0};
      imm_j = {{11{instr[31]}}, instr[31], instr[19:12],
               instr[20], instr[30:21], 1'b0};
    
      case (opcode)
    
        RType: begin
            case ({funct7, funct3})
              ADD: $display("INST = ADD  x%0d, x%0d, x%0d", rd, rs1, rs2);
              SUB: $display("INST = SUB  x%0d, x%0d, x%0d", rd, rs1, rs2);
              AND: $display("INST = AND  x%0d, x%0d, x%0d", rd, rs1, rs2);
              OR : $display("INST = OR   x%0d, x%0d, x%0d", rd, rs1, rs2);
              XOR: $display("INST = XOR  x%0d, x%0d, x%0d", rd, rs1, rs2);
              default:         $display("INST = UNKNOWN R-TYPE");
            endcase
        end
    
        IType: begin
            case (funct3)
              3'b000: $display("INST = ADDI x%0d, x%0d, %0d", rd, rs1, imm_i);
              3'b111: $display("INST = ANDI x%0d, x%0d, %0d", rd, rs1, imm_i);
              3'b110: $display("INST = ORI  x%0d, x%0d, %0d", rd, rs1, imm_i);
              default:$display("INST = UNKNOWN I-TYPE");
            endcase
        end
    
        LW   : begin
            if (funct3 == 3'b010)
              $display("INST = LW   x%0d, %0d(x%0d)", rd, imm_i, rs1);
            else
              $display("INST = UNKNOWN LOAD");
        end
    
        SW   : begin
            if (funct3 == 3'b010)
              $display("INST = SW   x%0d, %0d(x%0d)", rs2, imm_s, rs1);
            else
              $display("INST = UNKNOWN STORE");
        end
    
        BType: begin
            case (funct3)
              BEQ: $display("INST = BEQ  x%0d, x%0d, %0d", rs1, rs2, imm_b);
              BNE: $display("INST = BNE  x%0d, x%0d, %0d", rs1, rs2, imm_b);
              default:$display("INST = UNKNOWN BRANCH");
            endcase
        end
    
        JAL : $display("INST = JAL  x%0d, %0d", rd, imm_j);
    
        JALR: $display("INST = JALR x%0d, %0d(x%0d)", rd, imm_i, rs1);
    
        LUI : $display("INST = LUI  x%0d, 0x%08h", rd, instr[31:12] << 12);
    
        default:    $display("INST = UNKNOWN OPCODE: 0x%02h", opcode);
        
      endcase
    end
  endtask
  
  // =====================================================
  // MAIN MONITOR
  // =====================================================
  always @(posedge clk) 
  begin
    if (rst_n) 
    begin
      $display("--------------------------------------------------");
      $display("TIME = %0t", $time);
      $display("PC   = 0x%08h", dut.pc);
      $display("HEX  = 0x%08h", dut.instr);
    
      disasm(dut.instr);
    
      if (dut.reg_write) 
      begin
        $display("REG WRITE: x%0d = 0x%08h",
                 dut.rd,
                 dut.rd_data);
      end
    
      if (dut.mem_write) 
      begin
        $display("MEM WRITE: Addr = 0x%08h Data = 0x%08h",
                 dut.alu_out,
                 dut.rs2_data);
      end
    end
  end
  
endmodule
