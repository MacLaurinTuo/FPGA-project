transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/develop_tools/quartus13.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/develop_tools/quartus13.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/develop_tools/quartus13.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/develop_tools/quartus13.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/develop_tools/quartus13.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {d:/develop_tools/quartus13.1/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/rtl {E:/code/workspace_FPGA/vga_rom_pic/rtl/vga_rom_pic.v}
vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/rtl {E:/code/workspace_FPGA/vga_rom_pic/rtl/vga_pic.v}
vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/rtl {E:/code/workspace_FPGA/vga_rom_pic/rtl/vga_ctrl.v}
vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/prj/ip_core/rom_pic {E:/code/workspace_FPGA/vga_rom_pic/prj/ip_core/rom_pic/rom_pic.v}
vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/prj/ip_core/vga_clk {E:/code/workspace_FPGA/vga_rom_pic/prj/ip_core/vga_clk/vga_clk.v}
vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/prj/db {E:/code/workspace_FPGA/vga_rom_pic/prj/db/vga_clk_altpll.v}

vlog -vlog01compat -work work +incdir+E:/code/workspace_FPGA/vga_rom_pic/prj/../sim {E:/code/workspace_FPGA/vga_rom_pic/prj/../sim/tb_vga_rom_pic.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_vga_rom_pic

add wave *
view structure
view signals
run 1 us
