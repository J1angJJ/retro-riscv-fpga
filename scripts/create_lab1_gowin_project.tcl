set script_dir [file dirname [file normalize [info script]]]
set repo_root [file dirname $script_dir]

set project_root [file normalize [file join $repo_root labs lab1_led_blink gowin]]
set verilog_file [file normalize [file join $repo_root labs lab1_led_blink src led_blink.v]]
set cst_file [file normalize [file join $repo_root labs lab1_led_blink constraints tang_nano_20k.cst]]

file mkdir $project_root

create_project -name lab1_led_blink -dir $project_root -pn GW2AR-LV18QN88C8/I7 -device_version C -force
add_file $verilog_file
add_file $cst_file
