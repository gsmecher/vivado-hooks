set projname arty
create_project -force $projname $projname -part xc7a35t-csg324-1
set_property target_language VHDL [current_project]

# Set project properties
set_property -dict [ list				\
	sim.ip.auto_export_scripts 1			\
	simulator_language Mixed			\
	target_language VHDL				\
	xpm_libraries "XPM_CDC XPM_MEMORY"		\
] -objects [current_project]

add_files -fileset sources_1 [list			\
	[file normalize "../rtl/arty.vhd"]		\
	[file normalize "../rtl/arty_tb.vhd"]		\
]

# Everything VHDL is VHDL-2008 by default
set_property file_type "VHDL 2008" -objects [get_files -of_objects [get_filesets sources_1] [list \
	"*.vhd"								\
]]

# Constraints
add_files -fileset constrs_1 [list			\
	[file normalize "../xdc/arty.xdc"]		\
]

set_property top arty [get_filesets sources_1]
set_property top arty_tb [get_filesets sim_1]
