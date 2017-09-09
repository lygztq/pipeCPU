transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {pipeCPU_fast.vo}

vlog -vlog01compat -work work +incdir+D:/Quartus\ II/projects/pipeCPU/simulation/modelsim {D:/Quartus II/projects/pipeCPU/simulation/modelsim/pipeCPU.vt}

vsim -t 1ps +transport_int_delays +transport_path_delays -L cycloneii_ver -L gate_work -L work -voptargs="+acc"  pipeCPU_vlg_tst

add wave *
view structure
view signals
run -all
