transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/adder.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/alu.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/cpu.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/condcheck.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/controller.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/datapath.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/decoder.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/extend.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/flopenr.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/flopfl.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/flopflenr.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/flopr.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/hazardunit.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/mux2.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/mux3.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/regfile.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/shift.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/top.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/dmem.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/imem.sv}
vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/tb_top.sv}

vlog -sv -work work +incdir+C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu {C:/Users/Jose/Desktop/Proyecto_Arqui1/computer_architecture_1_2024-s2/five_stage_pipelined_cpu/tb_top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all