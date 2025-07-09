#!/usr/bin/env bash

# This script is intended to be source'd, and sets environment variables
# suitable for building C code in this repository. For example, use
#
#    $ . setenv.sh

VIVADO_RELEASE=2023.2

if ! command -v locate &> /dev/null
then
	echo "Unable to find the 'locate' tool - please sudo apt-get install plocate or similar."
	return
fi

#
# Look for Vivado
#

if [ -n "$XILINX_VIVADO" ]
then
	echo "XILINX_VIVADO: Using existing $XILINX_VIVADO"
else
	MAYBE_VIVADOES=( $(locate -l1 Vivado/$VIVADO_RELEASE/settings64.sh) )
	if [ ${#MAYBE_VIVADOES[@]} -ne 1 ]
	then
		echo "XILINX_VIVADO: Unable to find a single Vivado $VIVADO_RELEASE candidate. Candidates:"
		for (( i=0; i<${#MAYBE_VIVADOES[@]}; i++ ))
		do
			echo "- ${MAYBE_VIVADOES[i]}"
		done
		return -1
	else
		source ${MAYBE_VIVADOES[0]}
		echo "XILINX_VIVADO: Found $XILINX_VIVADO"
	fi
fi

#
# Aliases
#

alias go_bitstream="git push -f straylight:crs-mkids-autobuild HEAD:bitstream"
alias go_cosim="git push -f straylight:crs-mkids-autobuild HEAD:cosim"
