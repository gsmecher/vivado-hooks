# Constraints for Digilent Arty A7

set_property -dict {					\
	CFGBVS VCCO					\
	CONFIG_VOLTAGE 3.3				\
	BITSTREAM.GENERAL.COMPRESS true			\
	BITSTREAM.CONFIG.SPI_BUSWIDTH 4			\
	BITSTREAM.CONFIG.CONFIGRATE 50			\
} [current_design]

# 100 MHz system clock
create_clock -period 10.000 -name clk_100mhz -waveform {0.000 5.000} [get_ports clk]

set_property -dict {LOC E3 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {LOC G6 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led]

