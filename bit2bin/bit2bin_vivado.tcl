# bit2bin.tcl
#
# This tcl helps to generate bin files for MPSoC Linux to configure PL FPGA
#
# Tasks:
# - Find all bit files in current project
# - Generate corresponding bin files by writing bif files
#
# Note:
# - Existing bif and bin files for bit files will be overwritten with warnings
# - All bit files in current project will be converted
# - Tested in Vivado 2016.3
#
# Usage:
# - Right click Vivado toolbar and select "Customize Commands"
# - Click the green add button, input menu name "bit2bin", set "Source Tcl File" to the location of bit2bin_vivado.tcl, make sure "Add to toolbar" is selected
# - Click the tcl icon in toolbar when bit2bin conversion is needed

# generate_output_file
# @bit_file_list: a list of bit file name
proc generate_output_file {bit_file_list} {
	foreach bit_file $bit_file_list {
		set bit_file_path [file dirname $bit_file]
		set bit_file_name [file tail $bit_file]
		set bit_file_root [file rootname $bit_file_name]
		puts "BIT2BIN: bit_file_path: $bit_file_path"
		puts "BIT2BIN: bit_file_name: $bit_file_name"

		upvar project_dir project_dir
		cd $project_dir
		cd $bit_file_path

		# generate bif file
		set bif_file_name "bit2bin.bif"

		set f [open $bif_file_name w]
		puts $f "all:"
		puts $f "{"
	    puts $f "    $bit_file_name"
		puts $f "}"
		close $f 
		puts "BIT2BIN: BIF file $bif_file_name created in $bit_file_path"

		# file existing warning
		set bin_file_name ${bit_file_root}.bit.bin
		# puts "bin_file_name: $bin_file_name"
		# puts "file $bin_file_name [file exists $bin_file_name]"
		if {[file exists $bin_file_name]} {
			puts "BIT2BIN: WARNING: $bin_file_name exists. It will be overwritten."
			file delete $bin_file_name
		}

		# call bootgen
		set ret [exec bootgen -image $bif_file_name -arch zynqmp -process_bitstream bin]
		if {[file exists $bin_file_name]} {
			puts "BIT2BIN: $bin_file_name is generated successfully"
		}

	}
}

# glob-r
# provids recursive search functions
# borrowed from http://wiki.tcl.tk/1474
proc glob-r {{dir .} args} {
    set res {}
    foreach i [lsort [glob -nocomplain -dir $dir *]] {
        if {[file isdirectory $i]} {
            eval [list lappend res] [eval [linsert $args 0 glob-r $i]]
        } else {
            if {[llength $args]} {
                foreach arg $args {
                    if {[string match $arg $i]} {
                        lappend res $i
                        break
                    }
                }
            } else {
                lappend res $i
            }
        }
    }
    return $res
} ;

# main function
proc main {} {
	# find bit files
	set project_dir [get_property DIRECTORY [current_project ]]
	cd $project_dir
	set bit_file_list [glob-r . *.bit]

	# Generate bin file
	generate_output_file $bit_file_list


}

main