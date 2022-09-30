onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /servo_tb/clk
add wave -noupdate /servo_tb/rst
add wave -noupdate /servo_tb/position
add wave -noupdate /servo_tb/pwm
add wave -noupdate /servo_tb/min_pulse_us
add wave -noupdate /servo_tb/max_pulse_us
add wave -noupdate /servo_tb/step_count
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
WaveRestoreZoom {0 ps} {126010500 ns}
