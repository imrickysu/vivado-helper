bit2bin.tcl

This tcl helps to generate bin files for MPSoC Linux to configure PL FPGA

Tasks:
- Find all bit files in current project
- Generate corresponding bin files by writing bif files

Note:
- Existing bif and bin files for bit files will be overwritten with warnings
- All bit files in current project will be converted
- Tested in Vivado 2016.3

Usage:
- Right click Vivado toolbar and select "Customize Commands"
- Click the green add button, input menu name "bit2bin", set "Source Tcl File" to the location of bit2bin_vivado.tcl, make sure "Add to toolbar" is selected
- Click the tcl icon in toolbar when bit2bin conversion is needed