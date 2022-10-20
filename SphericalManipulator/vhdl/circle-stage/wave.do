onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /circle_stage_tb/clk
add wave -noupdate /circle_stage_tb/rst_n
add wave -noupdate /circle_stage_tb/pwm
add wave -noupdate -divider DUT
add wave -noupdate -radix unsigned -childformat {{/circle_stage_tb/DUT/angle(0) -radix unsigned} {/circle_stage_tb/DUT/angle(1) -radix unsigned} {/circle_stage_tb/DUT/angle(2) -radix unsigned}} -expand -subitemconfig {/circle_stage_tb/DUT/angle(0) {-height 15 -radix unsigned} /circle_stage_tb/DUT/angle(1) {-height 15 -radix unsigned} /circle_stage_tb/DUT/angle(2) {-height 15 -radix unsigned}} /circle_stage_tb/DUT/angle
add wave -noupdate -radix decimal /circle_stage_tb/DUT/sin
add wave -noupdate -expand /circle_stage_tb/DUT/position
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
WaveRestoreZoom {0 ps} {103120262517 ps}
