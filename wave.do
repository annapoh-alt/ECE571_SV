onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider IMEM
add wave -noupdate -radix unsigned /tb_riscv_single_cycle/dut/imem/addr
add wave -noupdate /tb_riscv_single_cycle/dut/imem/instr
add wave -noupdate -divider DMEM
add wave -noupdate /tb_riscv_single_cycle/dut/dmem/clk
add wave -noupdate /tb_riscv_single_cycle/dut/dmem/we
add wave -noupdate /tb_riscv_single_cycle/dut/dmem/re
add wave -noupdate /tb_riscv_single_cycle/dut/dmem/addr
add wave -noupdate /tb_riscv_single_cycle/dut/dmem/wd
add wave -noupdate /tb_riscv_single_cycle/dut/dmem/rd
add wave -noupdate -divider CTRL
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/opcode
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/funct3
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/funct7
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/reg_write
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/alu_src_a_sel
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/alu_src_b_sel
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/alu_fn
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/imm_sel
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/mem_read
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/mem_write
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/mem_to_reg
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/branch
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/jump
add wave -noupdate /tb_riscv_single_cycle/dut/ctrl/jalr
add wave -noupdate -divider REG
add wave -noupdate /tb_riscv_single_cycle/dut/regs/clk
add wave -noupdate /tb_riscv_single_cycle/dut/regs/rst_n
add wave -noupdate /tb_riscv_single_cycle/dut/regs/we
add wave -noupdate /tb_riscv_single_cycle/dut/regs/rs1
add wave -noupdate /tb_riscv_single_cycle/dut/regs/rs2
add wave -noupdate /tb_riscv_single_cycle/dut/regs/rd
add wave -noupdate /tb_riscv_single_cycle/dut/regs/wd
add wave -noupdate /tb_riscv_single_cycle/dut/regs/rs1_data
add wave -noupdate /tb_riscv_single_cycle/dut/regs/rs2_data
add wave -noupdate /tb_riscv_single_cycle/dut/regs/i
add wave -noupdate -divider ALU
add wave -noupdate /tb_riscv_single_cycle/dut/alu0/a
add wave -noupdate /tb_riscv_single_cycle/dut/alu0/b
add wave -noupdate /tb_riscv_single_cycle/dut/alu0/fn
add wave -noupdate /tb_riscv_single_cycle/dut/alu0/y
add wave -noupdate /tb_riscv_single_cycle/dut/alu0/zero
add wave -noupdate /tb_riscv_single_cycle/dut/alu0/b_shamt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 422
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {16219 ps} {97470 ps}
