onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rotate_stage_tb/DUT/clk
add wave -noupdate /rotate_stage_tb/DUT/rst_n
add wave -noupdate /rotate_stage_tb/DUT/pwm
add wave -noupdate -divider DUT
add wave -noupdate /rotate_stage_tb/DUT/pos_min
add wave -noupdate /rotate_stage_tb/DUT/pos_max
add wave -noupdate /rotate_stage_tb/DUT/position
add wave -noupdate /rotate_stage_tb/DUT/POSITIONER/direction
add wave -noupdate /rotate_stage_tb/DUT/POSITIONER/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3579815411231 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits us
update
WaveRestoreZoom {1405086224217 ps} {4341089205158 ps}
