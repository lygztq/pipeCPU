transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/lpm_rom_irom.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/lpm_ram_dq_dram.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipeCPU.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/alu.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/regfile.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/mux4x32.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/mux2x32.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/mux2x5.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipepc.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipeif.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipeir.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipeid.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipe_cu.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipedereg.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipeexe.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipeemreg.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipemem.v}
vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU {D:/Quartus II/projects/pipeCPU/pipemwreg.v}

vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU/simulation/modelsim {D:/Quartus II/projects/pipeCPU/simulation/modelsim/pipeCPU.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  pipeCPU_vlg_tst

add wave *
view structure
view signals
run -all
