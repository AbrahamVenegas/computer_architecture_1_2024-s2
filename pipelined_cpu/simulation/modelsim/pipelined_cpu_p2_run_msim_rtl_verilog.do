transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/ram.v}
vlog -sv -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/mainModule.sv}
vlog -sv -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/VGA_Main_Module.sv}
vlog -sv -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/GraphicsController.sv}
vlog -sv -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/pll.sv}
vlog -sv -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/ImageDrawer.sv}

vlog -sv -work work +incdir+/home/abner/Desktop/Arqui\ 1/Proyecto\ Arqui\ 1/computer_architecture_1_2024-s2/pipelined_cpu {/home/abner/Desktop/Arqui 1/Proyecto Arqui 1/computer_architecture_1_2024-s2/pipelined_cpu/mainModule_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  mainModule_tb

add wave *
view structure
view signals
run -all
