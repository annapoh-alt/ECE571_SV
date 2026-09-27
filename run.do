#####################################################################
#Name  : Shrinidhi Nagarajan Sreedharamurthy
#PSU ID: 939025042
#Introduction to SystemVerilog
#RISC V 
#####################################################################

vlog RISC_V_pkg.sv alu.sv control_unit.sv data_mem.sv instr_mem.sv regfile.sv riscv_single_cycle.sv tb_riscv_single_cycle.sv 
vsim -voptargs=+acc work.tb_riscv_single_cycle 
do wave.do
run -all


