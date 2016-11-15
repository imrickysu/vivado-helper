# Boot Essential Generator
# Short: BESGEN


######
# Create SDK Workspace
# - Hello world from DDR
# - Hello world from OCM
# - DRAM Test
# - FSBL
# - PMU FW
proc create_zynqmp_apps {hdf_file} {
	puts "BESGEN: Creating ZYNQ MPSoC Applications for $hdf_file. It may take several minutes."

	# write tcl for xsct to file
	set f [open "create_zynqmp_apps.tcl" "w"]


	# Set SDK workspace
	puts $f "setws ./"

	# Check whether old workspace exists. If so, exit because we only create apps in clean workspace.
	puts $f "if \{\[llength \[getprojects\]\] > 0\} {"
	puts $f "    puts \"BESGEN: ERROR: SDK Workspace is not empty.\""
	puts $f "    puts \"BESGEN: BESGEN only works for empty SDK workspace.\""
	puts $f "    puts \"BESGEN: Exit.\""
	puts $f "    exit"
	puts $f "}"

	# Create a HW project
	puts $f "createhw -name hw1 -hwspec $hdf_file"

	# Create a BSP project
	puts $f "createbsp -name standalone_bsp1 -hwproject hw1 -proc psu_cortexa53_0 -os standalone"
	#projects -build -type bsp -name standalone_bsp1
	puts $f "setlib -bsp standalone_bsp1 -lib xilffs"
	puts $f "setlib -bsp standalone_bsp1 -lib xilsecure"
	puts $f "updatemss -mss ./standalone_bsp1/system.mss"
	puts $f "regenbsp -bsp standalone_bsp1"
	#projects -build -type bsp -name standalone_bsp1

	# Create application projects
	# - hello from ddr
	puts $f "createapp -name hello_from_ddr -hwproject hw1 -bsp standalone_bsp1 -proc psu_cortexa53_0 -os standalone -lang C -app {Hello World}"
	# - hello from ocm
	puts $f "createapp -name hello_from_ocm -hwproject hw1 -bsp standalone_bsp1 -proc psu_cortexa53_0 -os standalone -lang C -app {Hello World}"
	puts $f "exec sed -i \"s/> psu_ddr_0_MEM_0/> psu_ocm_ram_0_MEM_0/g\" ./hello_from_ocm/src/lscript.ld"

	# - zynqmp dram tests
	puts $f "createapp -name dram_test -hwproject hw1 -bsp standalone_bsp1 -proc psu_cortexa53_0 -os standalone -lang C -app {Zynq MP DRAM tests}"

	# - zynqmp fsbl
	puts $f "createapp -name fsbl -hwproject hw1 -bsp standalone_bsp1 -proc psu_cortexa53_0 -os standalone -lang C -app {Zynq MP FSBL}"
	puts $f "configapp -app fsbl define-compiler-symbols FSBL_DEBUG_INFO"

	# - PMU Firmware
	puts $f "createbsp -name pmu_bsp1 -hwproject hw1 -proc psu_pmu_0 -os standalone"
	puts $f "setlib -bsp pmu_bsp1 -lib xilfpga"
	# May need to sleep for seconds to wait for bsp generation completion
	puts $f "after 5000"
	puts $f "updatemss -mss ./pmu_bsp1/system.mss"
	puts $f "regenbsp -bsp pmu_bsp1"
	puts $f "createapp -name pmu_firmware -hwproject hw1 -bsp pmu_bsp1 -proc psu_pmu_0 -os standalone -lang C -app {ZynqMP PMU Firmware}"

	# Build all projects
	puts $f "projects -build"

	close $f

	# Execute
	exec xsct create_zynqmp_apps.tcl

	# Check Results
	#set fileList ["hw1", "standalone_bsp1", "hello_from_ddr", "hello_from_ocm", "dram_test", "fsbl"]



}


######
# Create SDK Workspace
# - Hello world from DDR
# - Hello world from OCM
# - DRAM Test
# - FSBL
proc create_zynq_apps {hdf_file} {

	puts "BESGEN: Creating ZYNQ Applications for $hdf_file. It may take several minutes."

	# write tcl for xsct to file
	set f [open "create_zynq_apps.tcl" "w"]

	# Set SDK workspace
	puts $f "setws ./"

	# Check whether old workspace exists. If so, exit because we only create apps in clean workspace.
	puts $f "if \{\[llength \[getprojects\]\] > 0\} {"
	puts $f "    puts \"BESGEN: ERROR: SDK Workspace is not empty.\""
	puts $f "    puts \"BESGEN: BESGEN only works for empty SDK workspace.\""
	puts $f "    puts \"BESGEN: Exit.\""
	puts $f "    exit"
	puts $f "}"

	# Create a HW project
	puts $f "createhw -name hw1 -hwspec $hdf_file"

	# Create a BSP project
	puts $f "createbsp -name standalone_bsp1 -hwproject hw1 -proc ps7_cortexa9_0 -os standalone"
	#projects -build -type bsp -name standalone_bsp1
	puts $f "setlib -hw hw1 -bsp standalone_bsp1 -lib xilffs"
	puts $f "setlib -hw hw1 -bsp standalone_bsp1 -lib xilrsa"
	puts $f "updatemss -hw hw1 -mss ./standalone_bsp1/system.mss"
	puts $f "regenbsp -hw hw1 -bsp standalone_bsp1"
	#projects -build -type bsp -name standalone_bsp1

	# Create application projects
	# - hello from ddr
	puts $f "createapp -name hello_from_ddr -hwproject hw1 -bsp standalone_bsp1 -proc ps7_cortexa9_0 -os standalone -lang C -app {Hello World}"
	# - hello from ocm
	puts $f "createapp -name hello_from_ocm -hwproject hw1 -bsp standalone_bsp1 -proc ps7_cortexa9_0 -os standalone -lang C -app {Hello World}"
	puts $f "exec sed -i \"s/> ps7_ddr_0_S_AXI_BASEADDR/> ps7_ocm_0_S_AXI_BASEADDR/g\" ./hello_from_ocm/src/lscript.ld"

	# - zynq dram tests
	puts $f "createapp -name dram_test -hwproject hw1 -bsp standalone_bsp1 -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq DRAM tests}"

	# - zynq fsbl
	puts $f "createapp -name fsbl -hwproject hw1 -bsp standalone_bsp1 -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL}"
	puts $f "configapp -app fsbl define-compiler-symbols FSBL_DEBUG_INFO"

	# Build all projects
	puts $f "projects -build"

	exec xsct create_zynq_apps.tcl

	# Check Results
	#set fileList ["hw1", "standalone_bsp1", "hello_from_ddr", "hello_from_ocm", "dram_test", "fsbl"]

}

proc main {} {

	set project_dir [get_property DIRECTORY [current_project ]]
	cd $project_dir
	set design_name [get_property NAME [current_project]]
	cd $design_name.sdk


	# Check processor type
	set project_part [get_property PART [current_project ]]

	# Check hdf name
	set top_name [lindex [find_top] 0]

	if { [string match "xczu*" $project_part] } {
		create_zynqmp_apps $top_name.hdf
	} elseif { [string match "xc7z*" $project_part] } {
		create_zynq_apps $top_name.hdf
	} else {
		puts "BESGEN: Error: This is not a ZYNQ or ZYNQ MPSoC Project"
	}

}

main