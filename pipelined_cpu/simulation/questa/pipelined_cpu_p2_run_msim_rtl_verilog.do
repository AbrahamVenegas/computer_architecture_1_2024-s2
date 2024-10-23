transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/22.1std/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/mux3.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/mux2.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/flipfloprc.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/flipflopr.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/flipflopenrc.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/flipflopenr.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/eqcmp.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/adder.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/alu.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/extend.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/regfile.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/hazard.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/datapath.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/conditional.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/controller.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/cpu.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/top.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/RAMMemory.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/pipeline_tb.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/imem.sv}

vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/pipelined_cpu/pipeline_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  pipeline_tb

add wave *
view structure
view signals
run -all