# Boot Essential Generator #

This tcl script helps to generate essential applications for ZYNQ and ZYNQ UltraScale+ MPSoC so that it would be easy to test the processor and package boot.bin.

The applications for ZYNQ are:
- Hello World from OCM (to test UART)
- Hello World from DDR (assuming UART is good, simple test DDR)
- ZYNQ DRAM Test (DDR Complete Test application)
- ZYNQ FSBL with "FSBL_DEBUG_INFO" defined

The applications for ZYNQ MPSoC are:
- Hello World from OCM on A53 (to test UART)
- Hello World from DDR on A53 (assuming UART is good, simple test DDR)
- ZYNQ MP DRAM Test (DDR Complete Test application)
- ZYNQ MP FSBL with "FSBL_DEBUG_INFO" defined
- PMU Firmware

Note:
- Export hardware first, then source this script
- Only works for empty SDK workspace

Usage:
- Right click Vivado toolbar and select "Customize Commands"
- Click the green add button, input menu name "BESGEN", set "Source Tcl File" to the location of boot_essential_generator.tcl, make sure "Add to toolbar" is selected
- Click the tcl icon in toolbar when boot essential appliations are needed to be generated