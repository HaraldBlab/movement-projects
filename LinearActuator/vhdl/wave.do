onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /linear_actuator_tb/clk
add wave -noupdate /linear_actuator_tb/rst
add wave -noupdate /linear_actuator_tb/btn_start
add wave -noupdate /linear_actuator_tb/limit_closed
add wave -noupdate /linear_actuator_tb/limit_open
add wave -noupdate /linear_actuator_tb/coils
add wave -noupdate -divider DUT
add wave -noupdate /linear_actuator_tb/DUT/stopped
add wave -noupdate /linear_actuator_tb/DUT/cw
add wave -noupdate /linear_actuator_tb/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {262500 ps}
