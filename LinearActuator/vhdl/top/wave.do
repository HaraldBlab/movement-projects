onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rst_n
add wave -noupdate /top_tb/btn_start
add wave -noupdate /top_tb/limit_closed
add wave -noupdate /top_tb/limit_open
add wave -noupdate /top_tb/coils
add wave -noupdate -divider DUT
add wave -noupdate /top_tb/DUT/LINEAR_ACTUATOR/stopped
add wave -noupdate /top_tb/DUT/LINEAR_ACTUATOR/cw
add wave -noupdate /top_tb/DUT/LINEAR_ACTUATOR/state
add wave -noupdate /top_tb/DUT/btn_start_debounced
add wave -noupdate /top_tb/DUT/limit_closed_debounced
add wave -noupdate /top_tb/DUT/limit_open_debounced
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20002129591 ps} 0}
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
WaveRestoreZoom {19998283964 ps} {20005975218 ps}
