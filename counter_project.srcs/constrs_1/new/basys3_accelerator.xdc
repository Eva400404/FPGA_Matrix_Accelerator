## 100 MHz clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Center button: start
set_property PACKAGE_PIN U18 [get_ports btnC]
set_property IOSTANDARD LVCMOS33 [get_ports btnC]

## Up button: reset
set_property PACKAGE_PIN T18 [get_ports btnU]
set_property IOSTANDARD LVCMOS33 [get_ports btnU]

## LED0: done
set_property PACKAGE_PIN U16 [get_ports led_done]
set_property IOSTANDARD LVCMOS33 [get_ports led_done]

#LED1: pass
set_property PACKAGE_PIN E19 [get_ports led_pass]
set_property IOSTANDARD LVCMOS33 [get_ports led_pass]