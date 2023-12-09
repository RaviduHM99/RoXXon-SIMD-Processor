create_clock -period 8.000 -name CLK -waveform {0.000 4.000} [get_ports CLK]
set_input_jitter CLK 0.005
set_input_delay -clock [get_clocks CLK] -min -add_delay 2.000 [get_ports RSTN]
set_input_delay -clock [get_clocks CLK] -max -add_delay 3.000 [get_ports RSTN]
set_input_delay -clock [get_clocks CLK] -min -add_delay 2.000 [get_ports START_SIGNAL]
set_input_delay -clock [get_clocks CLK] -max -add_delay 3.000 [get_ports START_SIGNAL]
set_output_delay -clock [get_clocks CLK] -min -add_delay 0.000 [get_ports STOP_SIGNAL]
set_output_delay -clock [get_clocks CLK] -max -add_delay 1.000 [get_ports STOP_SIGNAL]
