
################################################################
# This is a generated script based on design: zynq_soc
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source zynq_soc_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# DataChange, axi_write

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu19eg-ffvc1760-2-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name zynq_soc

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:zynq_ultra_ps_e:3.3\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axi_crossbar:2.1\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axi_clock_converter:2.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
DataChange\
axi_write\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: hier_slowddr
proc create_hier_cell_hier_slowddr { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_slowddr() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_MEM


  # Create pins
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I -type rst m_axi_aresetn
  create_bd_pin -dir I -type clk pardcore_coreclk
  create_bd_pin -dir I -type clk slowest_sync_clk

  # Create instance: axi_clock_converter_0, and set properties
  set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]

  # Create instance: axi_clock_converter_1, and set properties
  set axi_clock_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_1 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_MEM_1 [get_bd_intf_pins S_AXI_MEM] [get_bd_intf_pins axi_clock_converter_0/S_AXI]
  connect_bd_intf_net -intf_net axi_clock_converter_0_M_AXI [get_bd_intf_pins axi_clock_converter_0/M_AXI] [get_bd_intf_pins axi_clock_converter_1/S_AXI]
  connect_bd_intf_net -intf_net axi_clock_converter_1_M_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_clock_converter_1/M_AXI]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pardcore_coreclk] [get_bd_pins axi_clock_converter_0/s_axi_aclk] [get_bd_pins axi_clock_converter_1/m_axi_aclk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins slowest_sync_clk] [get_bd_pins axi_clock_converter_0/m_axi_aclk] [get_bd_pins axi_clock_converter_1/s_axi_aclk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net pardcore_uncorerst_interconnect_aresetn [get_bd_pins m_axi_aresetn] [get_bd_pins axi_clock_converter_0/s_axi_aresetn] [get_bd_pins axi_clock_converter_1/m_axi_aresetn]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_clock_converter_0/m_axi_aresetn] [get_bd_pins axi_clock_converter_1/s_axi_aresetn] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_uart
proc create_hier_cell_hier_uart { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_uart() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1


  # Create pins
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -type intr interrupt1
  create_bd_pin -dir O -type intr interrupt2
  create_bd_pin -dir O -type intr interrupt3
  create_bd_pin -dir I -type clk pardcore_uncoreclk
  create_bd_pin -dir I -type rst pardcore_uncorerstn

  # Create instance: axi_crossbar_arm, and set properties
  set axi_crossbar_arm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_arm ]
  set_property -dict [ list \
   CONFIG.CONNECTIVITY_MODE {SASD} \
   CONFIG.M00_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_READ_ISSUING {1} \
   CONFIG.M00_WRITE_ISSUING {1} \
   CONFIG.M01_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_READ_ISSUING {1} \
   CONFIG.M01_WRITE_ISSUING {1} \
   CONFIG.M02_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_READ_ISSUING {1} \
   CONFIG.M02_WRITE_ISSUING {1} \
   CONFIG.M03_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_READ_ISSUING {1} \
   CONFIG.M03_WRITE_ISSUING {1} \
   CONFIG.M04_A00_ADDR_WIDTH {0} \
   CONFIG.M04_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_READ_ISSUING {1} \
   CONFIG.M04_WRITE_ISSUING {1} \
   CONFIG.M05_A00_ADDR_WIDTH {0} \
   CONFIG.M05_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_READ_ISSUING {1} \
   CONFIG.M05_WRITE_ISSUING {1} \
   CONFIG.M06_A00_ADDR_WIDTH {0} \
   CONFIG.M06_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_READ_ISSUING {1} \
   CONFIG.M06_WRITE_ISSUING {1} \
   CONFIG.M07_A00_ADDR_WIDTH {0} \
   CONFIG.M07_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_READ_ISSUING {1} \
   CONFIG.M07_WRITE_ISSUING {1} \
   CONFIG.M08_A00_ADDR_WIDTH {0} \
   CONFIG.M08_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_READ_ISSUING {1} \
   CONFIG.M08_WRITE_ISSUING {1} \
   CONFIG.M09_A00_ADDR_WIDTH {0} \
   CONFIG.M09_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_READ_ISSUING {1} \
   CONFIG.M09_WRITE_ISSUING {1} \
   CONFIG.M10_A00_ADDR_WIDTH {0} \
   CONFIG.M10_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_READ_ISSUING {1} \
   CONFIG.M10_WRITE_ISSUING {1} \
   CONFIG.M11_A00_ADDR_WIDTH {0} \
   CONFIG.M11_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_READ_ISSUING {1} \
   CONFIG.M11_WRITE_ISSUING {1} \
   CONFIG.M12_A00_ADDR_WIDTH {0} \
   CONFIG.M12_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_READ_ISSUING {1} \
   CONFIG.M12_WRITE_ISSUING {1} \
   CONFIG.M13_A00_ADDR_WIDTH {0} \
   CONFIG.M13_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_READ_ISSUING {1} \
   CONFIG.M13_WRITE_ISSUING {1} \
   CONFIG.M14_A00_ADDR_WIDTH {0} \
   CONFIG.M14_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_READ_ISSUING {1} \
   CONFIG.M14_WRITE_ISSUING {1} \
   CONFIG.M15_A00_ADDR_WIDTH {0} \
   CONFIG.M15_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_READ_ISSUING {1} \
   CONFIG.M15_WRITE_ISSUING {1} \
   CONFIG.NUM_MI {4} \
   CONFIG.R_REGISTER {1} \
   CONFIG.S00_READ_ACCEPTANCE {1} \
   CONFIG.S00_SINGLE_THREAD {1} \
   CONFIG.S00_WRITE_ACCEPTANCE {1} \
   CONFIG.S01_READ_ACCEPTANCE {1} \
   CONFIG.S01_WRITE_ACCEPTANCE {1} \
   CONFIG.S02_READ_ACCEPTANCE {1} \
   CONFIG.S02_WRITE_ACCEPTANCE {1} \
   CONFIG.S03_READ_ACCEPTANCE {1} \
   CONFIG.S03_WRITE_ACCEPTANCE {1} \
   CONFIG.S04_READ_ACCEPTANCE {1} \
   CONFIG.S04_WRITE_ACCEPTANCE {1} \
   CONFIG.S05_READ_ACCEPTANCE {1} \
   CONFIG.S05_WRITE_ACCEPTANCE {1} \
   CONFIG.S06_READ_ACCEPTANCE {1} \
   CONFIG.S06_WRITE_ACCEPTANCE {1} \
   CONFIG.S07_READ_ACCEPTANCE {1} \
   CONFIG.S07_WRITE_ACCEPTANCE {1} \
   CONFIG.S08_READ_ACCEPTANCE {1} \
   CONFIG.S08_WRITE_ACCEPTANCE {1} \
   CONFIG.S09_READ_ACCEPTANCE {1} \
   CONFIG.S09_WRITE_ACCEPTANCE {1} \
   CONFIG.S10_READ_ACCEPTANCE {1} \
   CONFIG.S10_WRITE_ACCEPTANCE {1} \
   CONFIG.S11_READ_ACCEPTANCE {1} \
   CONFIG.S11_WRITE_ACCEPTANCE {1} \
   CONFIG.S12_READ_ACCEPTANCE {1} \
   CONFIG.S12_WRITE_ACCEPTANCE {1} \
   CONFIG.S13_READ_ACCEPTANCE {1} \
   CONFIG.S13_WRITE_ACCEPTANCE {1} \
   CONFIG.S14_READ_ACCEPTANCE {1} \
   CONFIG.S14_WRITE_ACCEPTANCE {1} \
   CONFIG.S15_READ_ACCEPTANCE {1} \
   CONFIG.S15_WRITE_ACCEPTANCE {1} \
 ] $axi_crossbar_arm

  # Create instance: axi_crossbar_pardcore, and set properties
  set axi_crossbar_pardcore [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_crossbar:2.1 axi_crossbar_pardcore ]
  set_property -dict [ list \
   CONFIG.CONNECTIVITY_MODE {SASD} \
   CONFIG.M00_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M00_READ_ISSUING {1} \
   CONFIG.M00_WRITE_ISSUING {1} \
   CONFIG.M01_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M01_READ_ISSUING {1} \
   CONFIG.M01_WRITE_ISSUING {1} \
   CONFIG.M02_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M02_READ_ISSUING {1} \
   CONFIG.M02_WRITE_ISSUING {1} \
   CONFIG.M03_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M03_READ_ISSUING {1} \
   CONFIG.M03_WRITE_ISSUING {1} \
   CONFIG.M04_A00_ADDR_WIDTH {0} \
   CONFIG.M04_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M04_READ_ISSUING {1} \
   CONFIG.M04_WRITE_ISSUING {1} \
   CONFIG.M05_A00_ADDR_WIDTH {0} \
   CONFIG.M05_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M05_READ_ISSUING {1} \
   CONFIG.M05_WRITE_ISSUING {1} \
   CONFIG.M06_A00_ADDR_WIDTH {0} \
   CONFIG.M06_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M06_READ_ISSUING {1} \
   CONFIG.M06_WRITE_ISSUING {1} \
   CONFIG.M07_A00_ADDR_WIDTH {0} \
   CONFIG.M07_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M07_READ_ISSUING {1} \
   CONFIG.M07_WRITE_ISSUING {1} \
   CONFIG.M08_A00_ADDR_WIDTH {0} \
   CONFIG.M08_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M08_READ_ISSUING {1} \
   CONFIG.M08_WRITE_ISSUING {1} \
   CONFIG.M09_A00_ADDR_WIDTH {0} \
   CONFIG.M09_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M09_READ_ISSUING {1} \
   CONFIG.M09_WRITE_ISSUING {1} \
   CONFIG.M10_A00_ADDR_WIDTH {0} \
   CONFIG.M10_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M10_READ_ISSUING {1} \
   CONFIG.M10_WRITE_ISSUING {1} \
   CONFIG.M11_A00_ADDR_WIDTH {0} \
   CONFIG.M11_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M11_READ_ISSUING {1} \
   CONFIG.M11_WRITE_ISSUING {1} \
   CONFIG.M12_A00_ADDR_WIDTH {0} \
   CONFIG.M12_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M12_READ_ISSUING {1} \
   CONFIG.M12_WRITE_ISSUING {1} \
   CONFIG.M13_A00_ADDR_WIDTH {0} \
   CONFIG.M13_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M13_READ_ISSUING {1} \
   CONFIG.M13_WRITE_ISSUING {1} \
   CONFIG.M14_A00_ADDR_WIDTH {0} \
   CONFIG.M14_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M14_READ_ISSUING {1} \
   CONFIG.M14_WRITE_ISSUING {1} \
   CONFIG.M15_A00_ADDR_WIDTH {0} \
   CONFIG.M15_A00_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A01_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A02_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A03_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A04_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A05_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A06_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A07_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A08_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A09_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A10_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A11_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A12_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A13_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A14_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_A15_BASE_ADDR {0xffffffffffffffff} \
   CONFIG.M15_READ_ISSUING {1} \
   CONFIG.M15_WRITE_ISSUING {1} \
   CONFIG.NUM_MI {4} \
   CONFIG.R_REGISTER {1} \
   CONFIG.S00_READ_ACCEPTANCE {1} \
   CONFIG.S00_SINGLE_THREAD {1} \
   CONFIG.S00_WRITE_ACCEPTANCE {1} \
   CONFIG.S01_READ_ACCEPTANCE {1} \
   CONFIG.S01_WRITE_ACCEPTANCE {1} \
   CONFIG.S02_READ_ACCEPTANCE {1} \
   CONFIG.S02_WRITE_ACCEPTANCE {1} \
   CONFIG.S03_READ_ACCEPTANCE {1} \
   CONFIG.S03_WRITE_ACCEPTANCE {1} \
   CONFIG.S04_READ_ACCEPTANCE {1} \
   CONFIG.S04_WRITE_ACCEPTANCE {1} \
   CONFIG.S05_READ_ACCEPTANCE {1} \
   CONFIG.S05_WRITE_ACCEPTANCE {1} \
   CONFIG.S06_READ_ACCEPTANCE {1} \
   CONFIG.S06_WRITE_ACCEPTANCE {1} \
   CONFIG.S07_READ_ACCEPTANCE {1} \
   CONFIG.S07_WRITE_ACCEPTANCE {1} \
   CONFIG.S08_READ_ACCEPTANCE {1} \
   CONFIG.S08_WRITE_ACCEPTANCE {1} \
   CONFIG.S09_READ_ACCEPTANCE {1} \
   CONFIG.S09_WRITE_ACCEPTANCE {1} \
   CONFIG.S10_READ_ACCEPTANCE {1} \
   CONFIG.S10_WRITE_ACCEPTANCE {1} \
   CONFIG.S11_READ_ACCEPTANCE {1} \
   CONFIG.S11_WRITE_ACCEPTANCE {1} \
   CONFIG.S12_READ_ACCEPTANCE {1} \
   CONFIG.S12_WRITE_ACCEPTANCE {1} \
   CONFIG.S13_READ_ACCEPTANCE {1} \
   CONFIG.S13_WRITE_ACCEPTANCE {1} \
   CONFIG.S14_READ_ACCEPTANCE {1} \
   CONFIG.S14_WRITE_ACCEPTANCE {1} \
   CONFIG.S15_READ_ACCEPTANCE {1} \
   CONFIG.S15_WRITE_ACCEPTANCE {1} \
 ] $axi_crossbar_pardcore

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_0

  # Create instance: axi_uartlite_1, and set properties
  set axi_uartlite_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_1 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_1

  # Create instance: axi_uartlite_2, and set properties
  set axi_uartlite_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_2 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_2

  # Create instance: axi_uartlite_3, and set properties
  set axi_uartlite_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_3 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_3

  # Create instance: axi_uartlite_pardcore_0, and set properties
  set axi_uartlite_pardcore_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_pardcore_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_pardcore_0

  # Create instance: axi_uartlite_pardcore_1, and set properties
  set axi_uartlite_pardcore_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_pardcore_1 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_pardcore_1

  # Create instance: axi_uartlite_pardcore_2, and set properties
  set axi_uartlite_pardcore_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_pardcore_2 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_pardcore_2

  # Create instance: axi_uartlite_pardcore_3, and set properties
  set axi_uartlite_pardcore_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_pardcore_3 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $axi_uartlite_pardcore_3

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI1_1 [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins axi_crossbar_arm/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_crossbar_pardcore/S00_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M00_AXI [get_bd_intf_pins axi_crossbar_arm/M00_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M01_AXI [get_bd_intf_pins axi_crossbar_arm/M01_AXI] [get_bd_intf_pins axi_uartlite_1/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M02_AXI [get_bd_intf_pins axi_crossbar_arm/M02_AXI] [get_bd_intf_pins axi_uartlite_2/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_0_M03_AXI [get_bd_intf_pins axi_crossbar_arm/M03_AXI] [get_bd_intf_pins axi_uartlite_3/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_1_M00_AXI [get_bd_intf_pins axi_crossbar_pardcore/M00_AXI] [get_bd_intf_pins axi_uartlite_pardcore_0/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_1_M01_AXI [get_bd_intf_pins axi_crossbar_pardcore/M01_AXI] [get_bd_intf_pins axi_uartlite_pardcore_1/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_1_M02_AXI [get_bd_intf_pins axi_crossbar_pardcore/M02_AXI] [get_bd_intf_pins axi_uartlite_pardcore_2/S_AXI]
  connect_bd_intf_net -intf_net axi_crossbar_1_M03_AXI [get_bd_intf_pins axi_crossbar_pardcore/M03_AXI] [get_bd_intf_pins axi_uartlite_pardcore_3/S_AXI]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins axi_crossbar_arm/aresetn] [get_bd_pins axi_crossbar_pardcore/aresetn]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins interrupt3] [get_bd_pins axi_uartlite_0/interrupt]
  connect_bd_net -net axi_uartlite_0_tx [get_bd_pins axi_uartlite_0/tx] [get_bd_pins axi_uartlite_pardcore_0/rx]
  connect_bd_net -net axi_uartlite_1_interrupt [get_bd_pins interrupt] [get_bd_pins axi_uartlite_1/interrupt]
  connect_bd_net -net axi_uartlite_1_tx [get_bd_pins axi_uartlite_1/tx] [get_bd_pins axi_uartlite_pardcore_1/rx]
  connect_bd_net -net axi_uartlite_2_interrupt [get_bd_pins interrupt1] [get_bd_pins axi_uartlite_2/interrupt]
  connect_bd_net -net axi_uartlite_2_tx [get_bd_pins axi_uartlite_2/tx] [get_bd_pins axi_uartlite_pardcore_2/rx]
  connect_bd_net -net axi_uartlite_3_interrupt [get_bd_pins interrupt2] [get_bd_pins axi_uartlite_3/interrupt]
  connect_bd_net -net axi_uartlite_3_tx [get_bd_pins axi_uartlite_3/tx] [get_bd_pins axi_uartlite_pardcore_3/rx]
  connect_bd_net -net axi_uartlite_pardcore_0_tx [get_bd_pins axi_uartlite_0/rx] [get_bd_pins axi_uartlite_pardcore_0/tx]
  connect_bd_net -net axi_uartlite_pardcore_1_tx [get_bd_pins axi_uartlite_1/rx] [get_bd_pins axi_uartlite_pardcore_1/tx]
  connect_bd_net -net axi_uartlite_pardcore_2_tx [get_bd_pins axi_uartlite_2/rx] [get_bd_pins axi_uartlite_pardcore_2/tx]
  connect_bd_net -net axi_uartlite_pardcore_3_tx [get_bd_pins axi_uartlite_3/rx] [get_bd_pins axi_uartlite_pardcore_3/tx]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pardcore_uncoreclk] [get_bd_pins axi_crossbar_arm/aclk] [get_bd_pins axi_crossbar_pardcore/aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axi_uartlite_1/s_axi_aclk] [get_bd_pins axi_uartlite_2/s_axi_aclk] [get_bd_pins axi_uartlite_3/s_axi_aclk] [get_bd_pins axi_uartlite_pardcore_0/s_axi_aclk] [get_bd_pins axi_uartlite_pardcore_1/s_axi_aclk] [get_bd_pins axi_uartlite_pardcore_2/s_axi_aclk] [get_bd_pins axi_uartlite_pardcore_3/s_axi_aclk]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins pardcore_uncorerstn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axi_uartlite_1/s_axi_aresetn] [get_bd_pins axi_uartlite_2/s_axi_aresetn] [get_bd_pins axi_uartlite_pardcore_0/s_axi_aresetn] [get_bd_pins axi_uartlite_pardcore_1/s_axi_aresetn] [get_bd_pins axi_uartlite_pardcore_2/s_axi_aresetn] [get_bd_pins axi_uartlite_pardcore_3/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_prm_peripheral
proc create_hier_cell_hier_prm_peripheral { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_prm_peripheral() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_MEM


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 Dout
  create_bd_pin -dir I -type rst S00_ARESETN
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -from 1 -to 0 pardcore_corerstn
  create_bd_pin -dir I -type clk pardcore_uncoreclk
  create_bd_pin -dir I -type rst pardcore_uncorerstn
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: axi_dma_arm, and set properties
  set axi_dma_arm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_arm ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {16} \
 ] $axi_dma_arm

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {4} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
 ] $axi_interconnect_1

  # Create instance: hier_slowddr
  create_hier_cell_hier_slowddr $hier_obj hier_slowddr

  # Create instance: pardcore_corerst, and set properties
  set pardcore_corerst [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pardcore_corerst ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {2} \
   CONFIG.GPIO_BOARD_INTERFACE {Custom} \
 ] $pardcore_corerst

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_MEM] [get_bd_intf_pins hier_slowddr/S_AXI_MEM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M00_AXI1] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net S00_AXI1_1 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_dma_arm/M_AXI_SG] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_dma_arm/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins axi_dma_arm/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net S_AXIS_S2MM_1 [get_bd_intf_pins S_AXIS_S2MM] [get_bd_intf_pins axi_dma_arm/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_dma_arm_M_AXIS_MM2S [get_bd_intf_pins M_AXIS_MM2S] [get_bd_intf_pins axi_dma_arm/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axi_interconnect_1/M01_AXI] [get_bd_intf_pins pardcore_corerst/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_dma_arm/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_1/M02_AXI]
  connect_bd_intf_net -intf_net hier_slowddr_M_AXI [get_bd_intf_pins axi_interconnect_0/S03_AXI] [get_bd_intf_pins hier_slowddr/M_AXI]

  # Create port connections
  connect_bd_net -net axi_dma_arm_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_dma_arm/mm2s_introut]
  connect_bd_net -net axi_dma_arm_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_dma_arm/s2mm_introut]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins pardcore_corerstn] [get_bd_pins pardcore_corerst/gpio_io_o] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pardcore_uncoreclk] [get_bd_pins axi_dma_arm/m_axi_mm2s_aclk] [get_bd_pins axi_dma_arm/m_axi_s2mm_aclk] [get_bd_pins axi_dma_arm/m_axi_sg_aclk] [get_bd_pins axi_dma_arm/s_axi_lite_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins axi_interconnect_0/S02_ACLK] [get_bd_pins axi_interconnect_0/S03_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins hier_slowddr/pardcore_coreclk] [get_bd_pins hier_slowddr/slowest_sync_clk] [get_bd_pins pardcore_corerst/s_axi_aclk]
  connect_bd_net -net dcm_locked_1 [get_bd_pins dcm_locked] [get_bd_pins hier_slowddr/dcm_locked]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins hier_slowddr/ext_reset_in]
  connect_bd_net -net pardcore_uncorerst_interconnect_aresetn [get_bd_pins S00_ARESETN] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins axi_interconnect_0/S02_ARESETN] [get_bd_pins axi_interconnect_0/S03_ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins hier_slowddr/m_axi_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins pardcore_uncorerstn] [get_bd_pins axi_dma_arm/axi_resetn] [get_bd_pins pardcore_corerst/s_axi_aresetn]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins Dout] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_pardcore_peripheral
proc create_hier_cell_hier_pardcore_peripheral { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_pardcore_peripheral() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DMA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXILITE_MMIO

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt


  # Create pins
  create_bd_pin -dir I -type rst ARESETN
  create_bd_pin -dir I -type rst S03_ARESETN
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir O -from 4 -to 0 pardcore_intrs
  create_bd_pin -dir I -type clk pardcore_uncoreclk
  create_bd_pin -dir I -type rst sys_rst_n

  # Create instance: axi_dma_pardcore, and set properties
  set axi_dma_pardcore [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_pardcore ]
  set_property -dict [ list \
   CONFIG.c_addr_width {40} \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {16} \
 ] $axi_dma_pardcore

  # Create instance: axi_interconnect_pardcore_dma, and set properties
  set axi_interconnect_pardcore_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_pardcore_dma ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {5} \
 ] $axi_interconnect_pardcore_dma

  # Create instance: axi_interconnect_pardcore_mmio, and set properties
  set axi_interconnect_pardcore_mmio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_pardcore_mmio ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
 ] $axi_interconnect_pardcore_mmio

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf_0

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [ list \
   CONFIG.BASEADDR {0x00000000} \
   CONFIG.HIGHADDR {0x001FFFFF} \
   CONFIG.PF0_DEVICE_ID_mqdma {9131} \
   CONFIG.PF2_DEVICE_ID_mqdma {9131} \
   CONFIG.PF3_DEVICE_ID_mqdma {9131} \
   CONFIG.axi_addr_width {40} \
   CONFIG.axibar2pciebar_0 {0x0000000070000000} \
   CONFIG.axisten_freq {125} \
   CONFIG.bar_indicator {BAR_1:0} \
   CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
   CONFIG.dma_reset_source_sel {Phy_Ready} \
   CONFIG.en_gt_selection {true} \
   CONFIG.enable_gen4 {false} \
   CONFIG.functional_mode {AXI_Bridge} \
   CONFIG.mode_selection {Advanced} \
   CONFIG.msi_rx_pin_en {TRUE} \
   CONFIG.pciebar2axibar_0 {0x0000000100000000} \
   CONFIG.pf0_bar0_64bit {true} \
   CONFIG.pf0_bar0_scale {Megabytes} \
   CONFIG.pf0_bar0_size {64} \
   CONFIG.pf0_bar0_type_mqdma {Memory} \
   CONFIG.pf0_base_class_menu {Bridge_device} \
   CONFIG.pf0_base_class_menu_mqdma {Bridge_device} \
   CONFIG.pf0_class_code {060400} \
   CONFIG.pf0_class_code_base {06} \
   CONFIG.pf0_class_code_base_mqdma {06} \
   CONFIG.pf0_class_code_interface {00} \
   CONFIG.pf0_class_code_mqdma {068000} \
   CONFIG.pf0_class_code_sub {04} \
   CONFIG.pf0_device_id {9131} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_1:0} \
   CONFIG.pf0_msix_cap_table_bir {BAR_1:0} \
   CONFIG.pf0_rbar_cap_bar0 {0xffffffffffff} \
   CONFIG.pf0_sriov_bar0_type {Memory} \
   CONFIG.pf0_sub_class_interface_menu {CardBus_bridge} \
   CONFIG.pf1_bar0_type_mqdma {Memory} \
   CONFIG.pf1_bar2_64bit {false} \
   CONFIG.pf1_bar2_enabled {false} \
   CONFIG.pf1_bar4_64bit {false} \
   CONFIG.pf1_bar4_enabled {false} \
   CONFIG.pf1_base_class_menu {Bridge_device} \
   CONFIG.pf1_base_class_menu_mqdma {Bridge_device} \
   CONFIG.pf1_class_code {060700} \
   CONFIG.pf1_class_code_base {06} \
   CONFIG.pf1_class_code_base_mqdma {06} \
   CONFIG.pf1_class_code_interface {00} \
   CONFIG.pf1_class_code_mqdma {068000} \
   CONFIG.pf1_class_code_sub {07} \
   CONFIG.pf1_msix_cap_table_size {020} \
   CONFIG.pf1_rbar_cap_bar0 {0xffffffffffff} \
   CONFIG.pf1_sriov_bar0_type {Memory} \
   CONFIG.pf1_sub_class_interface_menu {CardBus_bridge} \
   CONFIG.pf2_bar0_type_mqdma {Memory} \
   CONFIG.pf2_base_class_menu_mqdma {Bridge_device} \
   CONFIG.pf2_class_code_base_mqdma {06} \
   CONFIG.pf2_class_code_mqdma {068000} \
   CONFIG.pf2_rbar_cap_bar0 {0xffffffffffff} \
   CONFIG.pf2_sriov_bar0_type {Memory} \
   CONFIG.pf3_bar0_type_mqdma {Memory} \
   CONFIG.pf3_base_class_menu_mqdma {Bridge_device} \
   CONFIG.pf3_class_code_base_mqdma {06} \
   CONFIG.pf3_class_code_mqdma {068000} \
   CONFIG.pf3_rbar_cap_bar0 {0xffffffffffff} \
   CONFIG.pf3_sriov_bar0_type {Memory} \
   CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
   CONFIG.plltype {QPLL1} \
   CONFIG.select_quad {GTY_Quad_128} \
   CONFIG.type1_membase_memlimit_enable {Enabled} \
   CONFIG.type1_prefetchable_membase_memlimit {64bit_Enabled} \
   CONFIG.xdma_axilite_slave {true} \
   CONFIG.xlnx_ref_board {None} \
 ] $xdma_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {5} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_pins CLK_IN_D] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_S2MM] [get_bd_intf_pins axi_dma_pardcore/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXIS_MM2S] [get_bd_intf_pins axi_dma_pardcore/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins M02_AXI] [get_bd_intf_pins axi_interconnect_pardcore_mmio/M02_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_dma_pardcore/M_AXI_SG] [get_bd_intf_pins axi_interconnect_pardcore_dma/S01_AXI]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins axi_dma_pardcore/M_AXI_MM2S] [get_bd_intf_pins axi_interconnect_pardcore_dma/S02_AXI]
  connect_bd_intf_net -intf_net S03_AXI_1 [get_bd_intf_pins axi_dma_pardcore/M_AXI_S2MM] [get_bd_intf_pins axi_interconnect_pardcore_dma/S03_AXI]
  connect_bd_intf_net -intf_net S04_AXI_1 [get_bd_intf_pins axi_interconnect_pardcore_dma/S04_AXI] [get_bd_intf_pins xdma_0/M_AXI_B]
  connect_bd_intf_net -intf_net S_AXILITE_MMIO_1 [get_bd_intf_pins S_AXILITE_MMIO] [get_bd_intf_pins axi_interconnect_pardcore_mmio/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins M_AXI_DMA] [get_bd_intf_pins axi_interconnect_pardcore_dma/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_pardcore_mmio_M00_AXI [get_bd_intf_pins axi_interconnect_pardcore_mmio/M00_AXI] [get_bd_intf_pins xdma_0/S_AXI_B]
  connect_bd_intf_net -intf_net axi_interconnect_pardcore_mmio_M01_AXI [get_bd_intf_pins axi_interconnect_pardcore_mmio/M01_AXI] [get_bd_intf_pins xdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_pardcore_mmio_M03_AXI [get_bd_intf_pins axi_dma_pardcore/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_pardcore_mmio/M03_AXI]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_pins pcie_mgt] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net M00_ACLK_1 [get_bd_pins axi_interconnect_pardcore_dma/S04_ACLK] [get_bd_pins axi_interconnect_pardcore_mmio/M00_ACLK] [get_bd_pins axi_interconnect_pardcore_mmio/M01_ACLK] [get_bd_pins xdma_0/axi_aclk]
  connect_bd_net -net M01_ARESETN_1 [get_bd_pins axi_interconnect_pardcore_mmio/M01_ARESETN] [get_bd_pins xdma_0/axi_ctl_aresetn]
  connect_bd_net -net axi_dma_pardcore_mm2s_introut [get_bd_pins axi_dma_pardcore/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_pardcore_s2mm_introut [get_bd_pins axi_dma_pardcore/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axi_dma_pardcore/axi_resetn]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pardcore_uncoreclk] [get_bd_pins axi_dma_pardcore/m_axi_mm2s_aclk] [get_bd_pins axi_dma_pardcore/m_axi_s2mm_aclk] [get_bd_pins axi_dma_pardcore/m_axi_sg_aclk] [get_bd_pins axi_dma_pardcore/s_axi_lite_aclk] [get_bd_pins axi_interconnect_pardcore_dma/ACLK] [get_bd_pins axi_interconnect_pardcore_dma/M00_ACLK] [get_bd_pins axi_interconnect_pardcore_dma/S00_ACLK] [get_bd_pins axi_interconnect_pardcore_dma/S01_ACLK] [get_bd_pins axi_interconnect_pardcore_dma/S02_ACLK] [get_bd_pins axi_interconnect_pardcore_dma/S03_ACLK] [get_bd_pins axi_interconnect_pardcore_mmio/ACLK] [get_bd_pins axi_interconnect_pardcore_mmio/M02_ACLK] [get_bd_pins axi_interconnect_pardcore_mmio/M03_ACLK] [get_bd_pins axi_interconnect_pardcore_mmio/S00_ACLK]
  connect_bd_net -net pardcore_uncorerst_interconnect_aresetn [get_bd_pins ARESETN] [get_bd_pins axi_interconnect_pardcore_dma/ARESETN] [get_bd_pins axi_interconnect_pardcore_dma/M00_ARESETN] [get_bd_pins axi_interconnect_pardcore_dma/S00_ARESETN] [get_bd_pins axi_interconnect_pardcore_mmio/ARESETN] [get_bd_pins axi_interconnect_pardcore_mmio/M02_ARESETN] [get_bd_pins axi_interconnect_pardcore_mmio/M03_ARESETN] [get_bd_pins axi_interconnect_pardcore_mmio/S00_ARESETN]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins S03_ARESETN] [get_bd_pins axi_interconnect_pardcore_dma/S01_ARESETN] [get_bd_pins axi_interconnect_pardcore_dma/S02_ARESETN] [get_bd_pins axi_interconnect_pardcore_dma/S03_ARESETN]
  connect_bd_net -net sys_rst_n_1 [get_bd_pins sys_rst_n] [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net util_ds_buf_0_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net xdma_0_axi_aresetn [get_bd_pins axi_interconnect_pardcore_dma/S04_ARESETN] [get_bd_pins axi_interconnect_pardcore_mmio/M00_ARESETN] [get_bd_pins xdma_0/axi_aresetn]
  connect_bd_net -net xdma_0_interrupt_out [get_bd_pins xdma_0/interrupt_out] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net xdma_0_interrupt_out_msi_vec32to63 [get_bd_pins xdma_0/interrupt_out_msi_vec32to63] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins pardcore_intrs] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xdma_0/interrupt_out_msi_vec0to31] [get_bd_pins xlconcat_0/In3]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hier_clkrst
proc create_hier_cell_hier_clkrst { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hier_clkrst() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -type clk hdft_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn2
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn3
  create_bd_pin -dir O locked
  create_bd_pin -dir O -type clk pardcore_uncoreclk
  create_bd_pin -dir O -from 0 -to 0 -type rst pardcore_uncorerstn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir I -type rst resetn

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {200.0} \
   CONFIG.CLKOUT1_JITTER {139.127} \
   CONFIG.CLKOUT1_PHASE_ERROR {154.678} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_JITTER {265.122} \
   CONFIG.CLKOUT2_PHASE_ERROR {154.678} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {10.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {129.922} \
   CONFIG.CLKOUT3_PHASE_ERROR {154.678} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {150.000} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLKOUT4_JITTER {139.127} \
   CONFIG.CLKOUT4_PHASE_ERROR {154.678} \
   CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100} \
   CONFIG.CLKOUT4_USED {true} \
   CONFIG.CLK_OUT3_PORT {clk_out3} \
   CONFIG.CLK_OUT4_PORT {hdft_clk} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {24.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {20.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {120} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
   CONFIG.MMCM_CLKOUT3_DIVIDE {12} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {4} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: corerst, and set properties
  set corerst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 corerst ]

  # Create instance: pardcore_uncorerst, and set properties
  set pardcore_uncorerst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 pardcore_uncorerst ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins pardcore_uncoreclk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins corerst/slowest_sync_clk] [get_bd_pins pardcore_uncorerst/slowest_sync_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_hdft_clk [get_bd_pins hdft_clk] [get_bd_pins clk_wiz_0/hdft_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins locked] [get_bd_pins clk_wiz_0/locked] [get_bd_pins corerst/dcm_locked] [get_bd_pins pardcore_uncorerst/dcm_locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net corerst_interconnect_aresetn [get_bd_pins interconnect_aresetn3] [get_bd_pins corerst/interconnect_aresetn]
  connect_bd_net -net corerst_peripheral_aresetn [get_bd_pins peripheral_aresetn1] [get_bd_pins corerst/peripheral_aresetn]
  connect_bd_net -net hier_prm_peripheral_Dout [get_bd_pins ext_reset_in] [get_bd_pins corerst/ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net pardcore_uncorerst_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins pardcore_uncorerst/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins interconnect_aresetn1] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins interconnect_aresetn2] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins pardcore_uncorerstn] [get_bd_pins pardcore_uncorerst/peripheral_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins clk_in1] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins resetn] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins pardcore_uncorerst/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CLK_IN_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D ]

  set M_AXI_DMA [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DMA ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M_AXI_DMA

  set S_AXI_MEM [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_MEM ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {1} \
   CONFIG.AWUSER_WIDTH {1} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {4} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {16} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {16} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_MEM

  set S_AXI_MMIO [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_MMIO ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {4} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S_AXI_MMIO

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]


  # Create ports
  set Rooketchipclk [ create_bd_port -dir O Rooketchipclk ]
  set break_full [ create_bd_port -dir O break_full ]
  set diff_archvalid [ create_bd_port -dir I diff_archvalid ]
  set diff_delayaddress [ create_bd_port -dir I -from 7 -to 0 diff_delayaddress ]
  set diff_delaydata [ create_bd_port -dir I -from 63 -to 0 diff_delaydata ]
  set diff_delayvalid [ create_bd_port -dir I diff_delayvalid ]
  set diff_difftestTrap [ create_bd_port -dir I diff_difftestTrap ]
  set diff_exception [ create_bd_port -dir I -from 31 -to 0 diff_exception ]
  set diff_instrCnt [ create_bd_port -dir I -from 63 -to 0 diff_instrCnt ]
  set diff_interrupt [ create_bd_port -dir I -from 31 -to 0 diff_interrupt ]
  set diff_lrscvalid [ create_bd_port -dir I diff_lrscvalid ]
  set diff_mask [ create_bd_port -dir I -from 7 -to 0 diff_mask ]
  set diff_masked_data [ create_bd_port -dir I -from 63 -to 0 diff_masked_data ]
  set diff_nack [ create_bd_port -dir I -from 7 -to 0 diff_nack ]
  set diff_rf_waddr [ create_bd_port -dir I -from 7 -to 0 diff_rf_waddr ]
  set diff_rf_wdata [ create_bd_port -dir I -from 63 -to 0 diff_rf_wdata ]
  set diff_rf_wen [ create_bd_port -dir I diff_rf_wen ]
  set diff_special [ create_bd_port -dir I -from 7 -to 0 diff_special ]
  set diff_storeaddress [ create_bd_port -dir I -from 63 -to 0 diff_storeaddress ]
  set diff_storevalid [ create_bd_port -dir I diff_storevalid ]
  set diff_success [ create_bd_port -dir I diff_success ]
  set dut_diff_pc [ create_bd_port -dir I -from 63 -to 0 dut_diff_pc ]
  set dut_valid [ create_bd_port -dir I -from 0 -to 0 dut_valid ]
  set en [ create_bd_port -dir I en ]
  set gpr_10 [ create_bd_port -dir I -from 63 -to 0 gpr_10 ]
  set instrcnt [ create_bd_port -dir I -from 63 -to 0 instrcnt ]
  set interconnect_aresetn [ create_bd_port -dir O -from 0 -to 0 interconnect_aresetn ]
  set io_ila_WBUInstr [ create_bd_port -dir I -from 31 -to 0 io_ila_WBUInstr ]
  set io_ila_code [ create_bd_port -dir I -from 7 -to 0 io_ila_code ]
  set io_ila_cycleCnt [ create_bd_port -dir I -from 63 -to 0 io_ila_cycleCnt ]
  set io_ila_exceptionInst [ create_bd_port -dir I -from 31 -to 0 io_ila_exceptionInst ]
  set io_ila_exceptionPC [ create_bd_port -dir I -from 63 -to 0 io_ila_exceptionPC ]
  set io_ila_mcause [ create_bd_port -dir I -from 63 -to 0 io_ila_mcause ]
  set io_ila_medeleg [ create_bd_port -dir I -from 63 -to 0 io_ila_medeleg ]
  set io_ila_mepc [ create_bd_port -dir I -from 63 -to 0 io_ila_mepc ]
  set io_ila_mideleg [ create_bd_port -dir I -from 63 -to 0 io_ila_mideleg ]
  set io_ila_mie [ create_bd_port -dir I -from 63 -to 0 io_ila_mie ]
  set io_ila_mipReg [ create_bd_port -dir I -from 63 -to 0 io_ila_mipReg ]
  set io_ila_mscratch [ create_bd_port -dir I -from 63 -to 0 io_ila_mscratch ]
  set io_ila_mstatus [ create_bd_port -dir I -from 63 -to 0 io_ila_mstatus ]
  set io_ila_mtval [ create_bd_port -dir I -from 63 -to 0 io_ila_mtval ]
  set io_ila_mtvec [ create_bd_port -dir I -from 63 -to 0 io_ila_mtvec ]
  set io_ila_pc [ create_bd_port -dir I -from 63 -to 0 io_ila_pc ]
  set io_ila_priviledgeMode [ create_bd_port -dir I -from 7 -to 0 io_ila_priviledgeMode ]
  set io_ila_rfwen [ create_bd_port -dir I io_ila_rfwen ]
  set io_ila_satp [ create_bd_port -dir I -from 63 -to 0 io_ila_satp ]
  set io_ila_scause [ create_bd_port -dir I -from 63 -to 0 io_ila_scause ]
  set io_ila_sepc [ create_bd_port -dir I -from 63 -to 0 io_ila_sepc ]
  set io_ila_sscratch [ create_bd_port -dir I -from 63 -to 0 io_ila_sscratch ]
  set io_ila_sstatus [ create_bd_port -dir I -from 63 -to 0 io_ila_sstatus ]
  set io_ila_stval [ create_bd_port -dir I -from 63 -to 0 io_ila_stval ]
  set io_ila_stvec [ create_bd_port -dir I -from 63 -to 0 io_ila_stvec ]
  set isMMIO [ create_bd_port -dir I isMMIO ]
  set pardcore_coreclk [ create_bd_port -dir O -type clk pardcore_coreclk ]
  set pardcore_corerstn [ create_bd_port -dir O -from 1 -to 0 pardcore_corerstn ]
  set pardcore_intrs [ create_bd_port -dir O -from 4 -to 0 pardcore_intrs ]
  set pardcore_uncoreclk [ create_bd_port -dir O -type clk pardcore_uncoreclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S_AXI_MEM:S_AXI_MMIO:M_AXI_DMA} \
 ] $pardcore_uncoreclk
  set wenable [ create_bd_port -dir I wenable ]

  # Create instance: DataChange_0, and set properties
  set block_name DataChange
  set block_cell_name DataChange_0
  if { [catch {set DataChange_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DataChange_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_write_0, and set properties
  set block_name axi_write
  set block_cell_name axi_write_0
  if { [catch {set axi_write_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axi_write_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: hier_clkrst
  create_hier_cell_hier_clkrst [current_bd_instance .] hier_clkrst

  # Create instance: hier_pardcore_peripheral
  create_hier_cell_hier_pardcore_peripheral [current_bd_instance .] hier_pardcore_peripheral

  # Create instance: hier_prm_peripheral
  create_hier_cell_hier_prm_peripheral [current_bd_instance .] hier_prm_peripheral

  # Create instance: hier_uart
  create_hier_cell_hier_uart [current_bd_instance .] hier_uart

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU {true} \
   CONFIG.C_BRAM_CNT {13} \
   CONFIG.C_MON_TYPE {MIX} \
   CONFIG.C_NUM_MONITOR_SLOTS {1} \
   CONFIG.C_NUM_OF_PROBES {12} \
   CONFIG.C_PROBE0_WIDTH {1} \
   CONFIG.C_PROBE10_WIDTH {1} \
   CONFIG.C_PROBE13_WIDTH {1} \
   CONFIG.C_PROBE22_WIDTH {1} \
   CONFIG.C_PROBE23_WIDTH {1} \
   CONFIG.C_PROBE25_WIDTH {1} \
   CONFIG.C_PROBE26_WIDTH {1} \
   CONFIG.C_PROBE30_WIDTH {1} \
   CONFIG.C_PROBE32_WIDTH {1} \
   CONFIG.C_PROBE33_WIDTH {1} \
   CONFIG.C_PROBE36_WIDTH {1} \
   CONFIG.C_PROBE37_WIDTH {1} \
   CONFIG.C_PROBE38_WIDTH {1} \
   CONFIG.C_PROBE40_WIDTH {1} \
   CONFIG.C_PROBE6_WIDTH {1} \
   CONFIG.C_PROBE9_WIDTH {1} \
   CONFIG.C_PROBE_WIDTH_PROPAGATION {AUTO} \
   CONFIG.C_SLOT {0} \
 ] $system_ila_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {17} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_1

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.CAN0_BOARD_INTERFACE {custom} \
   CONFIG.CAN1_BOARD_INTERFACE {custom} \
   CONFIG.CSU_BOARD_INTERFACE {custom} \
   CONFIG.DP_BOARD_INTERFACE {custom} \
   CONFIG.GEM0_BOARD_INTERFACE {custom} \
   CONFIG.GEM1_BOARD_INTERFACE {custom} \
   CONFIG.GEM2_BOARD_INTERFACE {custom} \
   CONFIG.GEM3_BOARD_INTERFACE {custom} \
   CONFIG.GPIO_BOARD_INTERFACE {custom} \
   CONFIG.IIC0_BOARD_INTERFACE {custom} \
   CONFIG.IIC1_BOARD_INTERFACE {custom} \
   CONFIG.NAND_BOARD_INTERFACE {custom} \
   CONFIG.PCIE_BOARD_INTERFACE {custom} \
   CONFIG.PJTAG_BOARD_INTERFACE {custom} \
   CONFIG.PMU_BOARD_INTERFACE {custom} \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS33} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0x3FFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {0} \
   CONFIG.PSU_IMPORT_BOARD_PRESET {} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_0_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_0_SLEW {slow} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_10_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_10_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_10_POLARITY {Default} \
   CONFIG.PSU_MIO_10_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_10_SLEW {slow} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_11_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_11_POLARITY {Default} \
   CONFIG.PSU_MIO_11_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_11_SLEW {slow} \
   CONFIG.PSU_MIO_12_DIRECTION {out} \
   CONFIG.PSU_MIO_12_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_12_POLARITY {Default} \
   CONFIG.PSU_MIO_12_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_12_SLEW {slow} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_13_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_13_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_13_SLEW {slow} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_14_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_14_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_14_SLEW {slow} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_15_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_15_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_15_SLEW {slow} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_16_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_16_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_16_SLEW {slow} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_17_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_17_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_17_SLEW {slow} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_18_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_18_SLEW {fast} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_19_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_19_SLEW {slow} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_1_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_1_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_1_SLEW {slow} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_20_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_20_SLEW {slow} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_21_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_21_SLEW {slow} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_22_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_22_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_22_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_22_SLEW {slow} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_23_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_23_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_23_SLEW {slow} \
   CONFIG.PSU_MIO_24_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_24_PULLUPDOWN {pulldown} \
   CONFIG.PSU_MIO_24_SLEW {slow} \
   CONFIG.PSU_MIO_25_DIRECTION {inout} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_25_PULLUPDOWN {pulldown} \
   CONFIG.PSU_MIO_25_SLEW {slow} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_26_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_26_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_26_SLEW {slow} \
   CONFIG.PSU_MIO_27_DIRECTION {inout} \
   CONFIG.PSU_MIO_27_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_27_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_27_SLEW {slow} \
   CONFIG.PSU_MIO_28_DIRECTION {inout} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_28_SLEW {slow} \
   CONFIG.PSU_MIO_29_DIRECTION {inout} \
   CONFIG.PSU_MIO_29_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_29_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_29_SLEW {slow} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_2_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_2_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_2_SLEW {slow} \
   CONFIG.PSU_MIO_30_DIRECTION {inout} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_30_SLEW {slow} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_31_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_31_POLARITY {Default} \
   CONFIG.PSU_MIO_31_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_31_SLEW {slow} \
   CONFIG.PSU_MIO_32_DIRECTION {inout} \
   CONFIG.PSU_MIO_32_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_32_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_32_POLARITY {Default} \
   CONFIG.PSU_MIO_32_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_32_SLEW {slow} \
   CONFIG.PSU_MIO_33_DIRECTION {inout} \
   CONFIG.PSU_MIO_33_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_33_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_33_POLARITY {Default} \
   CONFIG.PSU_MIO_33_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_33_SLEW {slow} \
   CONFIG.PSU_MIO_34_DIRECTION {inout} \
   CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_34_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_34_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_34_SLEW {slow} \
   CONFIG.PSU_MIO_35_DIRECTION {inout} \
   CONFIG.PSU_MIO_35_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_35_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_35_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_35_SLEW {slow} \
   CONFIG.PSU_MIO_36_DIRECTION {inout} \
   CONFIG.PSU_MIO_36_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_36_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_36_POLARITY {Default} \
   CONFIG.PSU_MIO_36_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_36_SLEW {slow} \
   CONFIG.PSU_MIO_37_DIRECTION {inout} \
   CONFIG.PSU_MIO_37_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_37_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_37_POLARITY {Default} \
   CONFIG.PSU_MIO_37_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_37_SLEW {slow} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_38_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_38_POLARITY {Default} \
   CONFIG.PSU_MIO_38_PULLUPDOWN {disable} \
   CONFIG.PSU_MIO_38_SLEW {slow} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_39_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_39_POLARITY {Default} \
   CONFIG.PSU_MIO_39_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_39_SLEW {slow} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_3_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_3_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_3_SLEW {slow} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_40_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_40_POLARITY {Default} \
   CONFIG.PSU_MIO_40_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_40_SLEW {slow} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_41_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_41_POLARITY {Default} \
   CONFIG.PSU_MIO_41_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_41_SLEW {slow} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_42_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_42_POLARITY {Default} \
   CONFIG.PSU_MIO_42_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_42_SLEW {slow} \
   CONFIG.PSU_MIO_43_DIRECTION {out} \
   CONFIG.PSU_MIO_43_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_43_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_43_POLARITY {Default} \
   CONFIG.PSU_MIO_43_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_43_SLEW {slow} \
   CONFIG.PSU_MIO_44_DIRECTION {in} \
   CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_44_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_44_POLARITY {Default} \
   CONFIG.PSU_MIO_44_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_44_SLEW {fast} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_45_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_45_SLEW {fast} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_46_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_46_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_46_SLEW {slow} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_47_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_47_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_47_SLEW {slow} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_48_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_48_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_48_SLEW {slow} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_49_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_49_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_49_SLEW {slow} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_4_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_4_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_4_SLEW {slow} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_50_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_50_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_50_SLEW {slow} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_51_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_51_SLEW {slow} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_52_SLEW {slow} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_53_SLEW {slow} \
   CONFIG.PSU_MIO_54_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_54_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_54_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_54_SLEW {slow} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_55_SLEW {slow} \
   CONFIG.PSU_MIO_56_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_56_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_56_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_56_SLEW {slow} \
   CONFIG.PSU_MIO_57_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_57_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_57_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_57_SLEW {slow} \
   CONFIG.PSU_MIO_58_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_58_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_58_SLEW {slow} \
   CONFIG.PSU_MIO_59_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_59_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_59_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_59_SLEW {slow} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_5_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_5_SLEW {slow} \
   CONFIG.PSU_MIO_60_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_60_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_60_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_60_SLEW {slow} \
   CONFIG.PSU_MIO_61_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_61_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_61_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_61_SLEW {slow} \
   CONFIG.PSU_MIO_62_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_62_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_62_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_62_SLEW {slow} \
   CONFIG.PSU_MIO_63_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_63_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_63_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_63_SLEW {slow} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_64_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_64_SLEW {slow} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_65_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_65_SLEW {slow} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_66_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_66_SLEW {slow} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_67_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_67_SLEW {slow} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_68_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_68_SLEW {slow} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_69_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_69_SLEW {slow} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_6_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_6_SLEW {slow} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_70_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_70_SLEW {fast} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_71_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_71_SLEW {fast} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_72_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_72_SLEW {fast} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_73_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_73_SLEW {fast} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_74_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_74_SLEW {fast} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_75_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_75_SLEW {fast} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_76_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_76_SLEW {slow} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_77_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_77_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_77_SLEW {slow} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_7_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_7_SLEW {slow} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_8_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_8_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_8_POLARITY {Default} \
   CONFIG.PSU_MIO_8_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_8_SLEW {slow} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_9_INPUT_TYPE {schmitt} \
   CONFIG.PSU_MIO_9_POLARITY {Default} \
   CONFIG.PSU_MIO_9_PULLUPDOWN {pullup} \
   CONFIG.PSU_MIO_9_SLEW {slow} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS { \
     ##############I2C 0#I2C \
     0####################SD 1#SD \
     0#I2C 1#I2C \
     1#SD 1#############Gem \
     1#SD 1#############Gem \
     1#SD 1#############Gem \
     1#SD 1#############Gem \
     1#SD 1#############Gem \
     1#SD 1#############Gem \
     1#UART 0#UART \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#Gem 3#MDIO \
     3#MDIO 3 \
   } \
   CONFIG.PSU_MIO_TREE_SIGNALS {##############scl_out#sda_out#scl_out#sda_out#rxd#txd####################sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#sdio1_bus_pow#sdio1_wp#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#############rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_PERIPHERAL_BOARD_PRESET {} \
   CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_SMC_CYCLE_T0 {NA} \
   CONFIG.PSU_SMC_CYCLE_T1 {NA} \
   CONFIG.PSU_SMC_CYCLE_T2 {NA} \
   CONFIG.PSU_SMC_CYCLE_T3 {NA} \
   CONFIG.PSU_SMC_CYCLE_T4 {NA} \
   CONFIG.PSU_SMC_CYCLE_T5 {NA} \
   CONFIG.PSU_SMC_CYCLE_T6 {NA} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {0} \
   CONFIG.PSU_VALUE_SILVERSION {3} \
   CONFIG.PSU__ACPU0__POWER__ON {1} \
   CONFIG.PSU__ACPU1__POWER__ON {1} \
   CONFIG.PSU__ACPU2__POWER__ON {1} \
   CONFIG.PSU__ACPU3__POWER__ON {1} \
   CONFIG.PSU__ACTUAL__IP {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.666626} \
   CONFIG.PSU__AFI0_COHERENCY {0} \
   CONFIG.PSU__AFI1_COHERENCY {0} \
   CONFIG.PSU__AUX_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__CAN0_LOOP_CAN1__ENABLE {0} \
   CONFIG.PSU__CAN0__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__ACPU__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI0_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI1_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI2_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI3_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI4_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__ACT_FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__FREQMHZ {667} \
   CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__AFI5_REF__ENABLE {0} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__APM_CTRL__ACT_FREQMHZ {1} \
   CONFIG.PSU__CRF_APB__APM_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__APM_CTRL__FREQMHZ {1} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.333313} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {533.333313} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {25} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {63} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__FREQMHZ {25} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {27} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {10} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__FREQMHZ {27} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {320} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__FREQMHZ {320} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {533.333313} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__ACT_FREQMHZ {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__DIVISOR0 {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__FREQMHZ {-1} \
   CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__SRCSEL {NA} \
   CONFIG.PSU__CRF_APB__GTGREF0__ENABLE {NA} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {525.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {63} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6__ENABLE {0} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {51.724136} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {29} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__FREQMHZ {52} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {99.999} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.999} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {180} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__FREQMHZ {180} \
   CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {SysOsc} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__ACT_FREQMHZ {1000} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__FREQMHZ {1000} \
   CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__FREQMHZ {1500} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {125.000000} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__ACT_FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {166.666672} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {9} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {167} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {50.000000} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {50} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {199.998} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {299.997} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {300} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {27.138} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {214} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {214} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {15} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {0} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {0} \
   CONFIG.PSU__CSU_COHERENCY {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_0__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_0__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_10__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_10__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_11__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_11__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_12__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_12__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_1__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_1__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_2__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_2__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_3__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_3__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_4__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_4__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_5__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_5__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_6__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_6__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_7__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_7__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_8__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_8__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_9__ENABLE {0} \
   CONFIG.PSU__CSU__CSU_TAMPER_9__ERASE_BBRAM {0} \
   CONFIG.PSU__CSU__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__AL {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {1} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ECC_SCRUB {0} \
   CONFIG.PSU__DDRC__ENABLE {1} \
   CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
   CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__FREQ_MHZ {1} \
   CONFIG.PSU__DDRC__LPDDR3_DUALRANK_SDP {0} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__PLL_BYPASS {0} \
   CONFIG.PSU__DDRC__PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__RD_DQS_CENTER {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {21.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {46.5} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VIDEO_BUFFER_SIZE {0} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR_QOS_ENABLE {0} \
   CONFIG.PSU__DDR_QOS_FIX_HP0_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP0_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP1_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP1_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP2_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP2_WRQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP3_RDQOS {} \
   CONFIG.PSU__DDR_QOS_FIX_HP3_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP0_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP0_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP1_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP1_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP2_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP2_WRQOS {} \
   CONFIG.PSU__DDR_QOS_HP3_RDQOS {} \
   CONFIG.PSU__DDR_QOS_HP3_WRQOS {} \
   CONFIG.PSU__DDR_QOS_RD_HPR_THRSHLD {} \
   CONFIG.PSU__DDR_QOS_RD_LPR_THRSHLD {} \
   CONFIG.PSU__DDR_QOS_WR_THRSHLD {} \
   CONFIG.PSU__DDR_SW_REFRESH_ENABLED {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DEVICE_TYPE {EG} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {0} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENABLE__DDR__REFRESH__SIGNALS {0} \
   CONFIG.PSU__ENET0__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET0__PTP__ENABLE {0} \
   CONFIG.PSU__ENET0__TSU__ENABLE {0} \
   CONFIG.PSU__ENET1__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET1__PTP__ENABLE {0} \
   CONFIG.PSU__ENET1__TSU__ENABLE {0} \
   CONFIG.PSU__ENET2__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET2__GRP_MDIO__ENABLE {0} \
   CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__ENET2__PTP__ENABLE {0} \
   CONFIG.PSU__ENET2__TSU__ENABLE {0} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__EN_AXI_STATUS_PORTS {0} \
   CONFIG.PSU__EN_EMIO_TRACE {0} \
   CONFIG.PSU__EP__IP {0} \
   CONFIG.PSU__EXPAND__CORESIGHT {0} \
   CONFIG.PSU__EXPAND__FPD_SLAVES {0} \
   CONFIG.PSU__EXPAND__GIC {0} \
   CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {1} \
   CONFIG.PSU__EXPAND__UPPER_LPS_SLAVES {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__FPGA_PL1_ENABLE {0} \
   CONFIG.PSU__FPGA_PL2_ENABLE {0} \
   CONFIG.PSU__FPGA_PL3_ENABLE {0} \
   CONFIG.PSU__FP__POWER__ON {1} \
   CONFIG.PSU__FTM__CTI_IN_0 {0} \
   CONFIG.PSU__FTM__CTI_IN_1 {0} \
   CONFIG.PSU__FTM__CTI_IN_2 {0} \
   CONFIG.PSU__FTM__CTI_IN_3 {0} \
   CONFIG.PSU__FTM__CTI_OUT_0 {0} \
   CONFIG.PSU__FTM__CTI_OUT_1 {0} \
   CONFIG.PSU__FTM__CTI_OUT_2 {0} \
   CONFIG.PSU__FTM__CTI_OUT_3 {0} \
   CONFIG.PSU__FTM__GPI {0} \
   CONFIG.PSU__FTM__GPO {0} \
   CONFIG.PSU__GEM0_COHERENCY {0} \
   CONFIG.PSU__GEM0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM1_COHERENCY {0} \
   CONFIG.PSU__GEM1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM2_COHERENCY {0} \
   CONFIG.PSU__GEM2_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GEN_IPI_0__MASTER {APU} \
   CONFIG.PSU__GEN_IPI_10__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_1__MASTER {RPU0} \
   CONFIG.PSU__GEN_IPI_2__MASTER {RPU1} \
   CONFIG.PSU__GEN_IPI_3__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_4__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_5__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_6__MASTER {PMU} \
   CONFIG.PSU__GEN_IPI_7__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_8__MASTER {NONE} \
   CONFIG.PSU__GEN_IPI_9__MASTER {NONE} \
   CONFIG.PSU__GPIO0_MIO__IO {<Select>} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO1_MIO__IO {<Select>} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO_EMIO_WIDTH {1} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {<Select>} \
   CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
   CONFIG.PSU__GPU_PP0__POWER__ON {1} \
   CONFIG.PSU__GPU_PP1__POWER__ON {1} \
   CONFIG.PSU__GT_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__HPM0_FPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM0_FPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__HPM0_LPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM0_LPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__HPM1_FPD__NUM_READ_THREADS {4} \
   CONFIG.PSU__HPM1_FPD__NUM_WRITE_THREADS {4} \
   CONFIG.PSU__I2C0_LOOP_I2C1__ENABLE {0} \
   CONFIG.PSU__I2C0__GRP_INT__ENABLE {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__GRP_INT__ENABLE {0} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__IRQ_P2F_ADMA_CHAN__INT {0} \
   CONFIG.PSU__IRQ_P2F_AIB_AXI__INT {0} \
   CONFIG.PSU__IRQ_P2F_AMS__INT {0} \
   CONFIG.PSU__IRQ_P2F_APM_FPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_COMM__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_CPUMNT__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_CTI__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_EXTERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_L2ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_PMU__INT {0} \
   CONFIG.PSU__IRQ_P2F_APU_REGS__INT {0} \
   CONFIG.PSU__IRQ_P2F_ATB_LPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_CAN0__INT {0} \
   CONFIG.PSU__IRQ_P2F_CAN1__INT {0} \
   CONFIG.PSU__IRQ_P2F_CLKMON__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSUPMU_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSU_DMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_CSU__INT {0} \
   CONFIG.PSU__IRQ_P2F_DDR_SS__INT {0} \
   CONFIG.PSU__IRQ_P2F_DPDMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_DPORT__INT {0} \
   CONFIG.PSU__IRQ_P2F_EFUSE__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT0_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT0__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT1_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT1__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT2_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT2__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT3_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_ENT3__INT {0} \
   CONFIG.PSU__IRQ_P2F_FPD_APB__INT {0} \
   CONFIG.PSU__IRQ_P2F_FPD_ATB_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_FP_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_GDMA_CHAN__INT {0} \
   CONFIG.PSU__IRQ_P2F_GPIO__INT {0} \
   CONFIG.PSU__IRQ_P2F_GPU__INT {0} \
   CONFIG.PSU__IRQ_P2F_I2C0__INT {0} \
   CONFIG.PSU__IRQ_P2F_I2C1__INT {0} \
   CONFIG.PSU__IRQ_P2F_LPD_APB__INT {0} \
   CONFIG.PSU__IRQ_P2F_LPD_APM__INT {0} \
   CONFIG.PSU__IRQ_P2F_LP_WDT__INT {0} \
   CONFIG.PSU__IRQ_P2F_NAND__INT {0} \
   CONFIG.PSU__IRQ_P2F_OCM_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_DMA__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_LEGACY__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_MSC__INT {0} \
   CONFIG.PSU__IRQ_P2F_PCIE_MSI__INT {0} \
   CONFIG.PSU__IRQ_P2F_PL_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_QSPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_R5_CORE0_ECC_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_R5_CORE1_ECC_ERR__INT {0} \
   CONFIG.PSU__IRQ_P2F_RPU_IPI__INT {0} \
   CONFIG.PSU__IRQ_P2F_RPU_PERMON__INT {0} \
   CONFIG.PSU__IRQ_P2F_RTC_ALARM__INT {0} \
   CONFIG.PSU__IRQ_P2F_RTC_SECONDS__INT {0} \
   CONFIG.PSU__IRQ_P2F_SATA__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO0_WAKE__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO0__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO1_WAKE__INT {0} \
   CONFIG.PSU__IRQ_P2F_SDIO1__INT {0} \
   CONFIG.PSU__IRQ_P2F_SPI0__INT {0} \
   CONFIG.PSU__IRQ_P2F_SPI1__INT {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC0__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC1__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC2__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_TTC3__INT2 {0} \
   CONFIG.PSU__IRQ_P2F_UART0__INT {0} \
   CONFIG.PSU__IRQ_P2F_UART1__INT {0} \
   CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_OTG__INT0 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_OTG__INT1 {0} \
   CONFIG.PSU__IRQ_P2F_USB3_PMU_WAKEUP__INT {0} \
   CONFIG.PSU__IRQ_P2F_XMPU_FPD__INT {0} \
   CONFIG.PSU__IRQ_P2F_XMPU_LPD__INT {0} \
   CONFIG.PSU__IRQ_P2F__INTF_FPD_SMMU__INT {0} \
   CONFIG.PSU__IRQ_P2F__INTF_PPD_CCI__INT {0} \
   CONFIG.PSU__L2_BANK0__POWER__ON {1} \
   CONFIG.PSU__LPDMA0_COHERENCY {0} \
   CONFIG.PSU__LPDMA1_COHERENCY {0} \
   CONFIG.PSU__LPDMA2_COHERENCY {0} \
   CONFIG.PSU__LPDMA3_COHERENCY {0} \
   CONFIG.PSU__LPDMA4_COHERENCY {0} \
   CONFIG.PSU__LPDMA5_COHERENCY {0} \
   CONFIG.PSU__LPDMA6_COHERENCY {0} \
   CONFIG.PSU__LPDMA7_COHERENCY {0} \
   CONFIG.PSU__LPD_SLCR__CSUPMU_WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__M_AXI_GP0_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__M_AXI_GP1_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__M_AXI_GP2_SUPPORTS_NARROW_BURST {1} \
   CONFIG.PSU__NAND_COHERENCY {0} \
   CONFIG.PSU__NAND_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__NAND__CHIP_ENABLE__ENABLE {0} \
   CONFIG.PSU__NAND__DATA_STROBE__ENABLE {0} \
   CONFIG.PSU__NAND__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__NAND__READY0_BUSY__ENABLE {0} \
   CONFIG.PSU__NAND__READY1_BUSY__ENABLE {0} \
   CONFIG.PSU__NAND__READY_BUSY__ENABLE {0} \
   CONFIG.PSU__NUM_FABRIC_RESETS {1} \
   CONFIG.PSU__OCM_BANK0__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK1__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK2__POWER__ON {1} \
   CONFIG.PSU__OCM_BANK3__POWER__ON {1} \
   CONFIG.PSU__OVERRIDE_HPX_QOS {0} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
   CONFIG.PSU__PCIE__ACS_VIOLATION {0} \
   CONFIG.PSU__PCIE__AER_CAPABILITY {0} \
   CONFIG.PSU__PCIE__ATOMICOP_EGRESS_BLOCKED {0} \
   CONFIG.PSU__PCIE__BAR0_64BIT {0} \
   CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR0_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR0_VAL {} \
   CONFIG.PSU__PCIE__BAR1_64BIT {0} \
   CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR1_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR1_VAL {} \
   CONFIG.PSU__PCIE__BAR2_64BIT {0} \
   CONFIG.PSU__PCIE__BAR2_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR2_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR2_VAL {} \
   CONFIG.PSU__PCIE__BAR3_64BIT {0} \
   CONFIG.PSU__PCIE__BAR3_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR3_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR3_VAL {} \
   CONFIG.PSU__PCIE__BAR4_64BIT {0} \
   CONFIG.PSU__PCIE__BAR4_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR4_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR4_VAL {} \
   CONFIG.PSU__PCIE__BAR5_64BIT {0} \
   CONFIG.PSU__PCIE__BAR5_ENABLE {0} \
   CONFIG.PSU__PCIE__BAR5_PREFETCHABLE {0} \
   CONFIG.PSU__PCIE__BAR5_VAL {} \
   CONFIG.PSU__PCIE__CLASS_CODE_BASE {} \
   CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {} \
   CONFIG.PSU__PCIE__CLASS_CODE_SUB {} \
   CONFIG.PSU__PCIE__CLASS_CODE_VALUE {} \
   CONFIG.PSU__PCIE__COMPLETER_ABORT {0} \
   CONFIG.PSU__PCIE__COMPLTION_TIMEOUT {0} \
   CONFIG.PSU__PCIE__CORRECTABLE_INT_ERR {0} \
   CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {0} \
   CONFIG.PSU__PCIE__DEVICE_ID {} \
   CONFIG.PSU__PCIE__ECRC_CHECK {0} \
   CONFIG.PSU__PCIE__ECRC_ERR {0} \
   CONFIG.PSU__PCIE__ECRC_GEN {0} \
   CONFIG.PSU__PCIE__EROM_ENABLE {0} \
   CONFIG.PSU__PCIE__EROM_VAL {} \
   CONFIG.PSU__PCIE__FLOW_CONTROL_ERR {0} \
   CONFIG.PSU__PCIE__FLOW_CONTROL_PROTOCOL_ERR {0} \
   CONFIG.PSU__PCIE__HEADER_LOG_OVERFLOW {0} \
   CONFIG.PSU__PCIE__INTX_GENERATION {0} \
   CONFIG.PSU__PCIE__LANE0__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
   CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
   CONFIG.PSU__PCIE__MC_BLOCKED_TLP {0} \
   CONFIG.PSU__PCIE__MSIX_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MSIX_PBA_BAR_INDICATOR {} \
   CONFIG.PSU__PCIE__MSIX_PBA_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_OFFSET {0} \
   CONFIG.PSU__PCIE__MSIX_TABLE_SIZE {0} \
   CONFIG.PSU__PCIE__MSI_64BIT_ADDR_CAPABLE {0} \
   CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
   CONFIG.PSU__PCIE__MULTIHEADER {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {1} \
   CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {0} \
   CONFIG.PSU__PCIE__PERM_ROOT_ERR_UPDATE {0} \
   CONFIG.PSU__PCIE__RECEIVER_ERR {0} \
   CONFIG.PSU__PCIE__RECEIVER_OVERFLOW {0} \
   CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
   CONFIG.PSU__PCIE__REVISION_ID {} \
   CONFIG.PSU__PCIE__SUBSYSTEM_ID {} \
   CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {} \
   CONFIG.PSU__PCIE__SURPRISE_DOWN {0} \
   CONFIG.PSU__PCIE__TLP_PREFIX_BLOCKED {0} \
   CONFIG.PSU__PCIE__UNCORRECTABL_INT_ERR {0} \
   CONFIG.PSU__PCIE__VENDOR_ID {} \
   CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PL_CLK1_BUF {FALSE} \
   CONFIG.PSU__PL_CLK2_BUF {FALSE} \
   CONFIG.PSU__PL_CLK3_BUF {FALSE} \
   CONFIG.PSU__PL__POWER__ON {1} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {0} \
   CONFIG.PSU__PMU__GPO1__ENABLE {0} \
   CONFIG.PSU__PMU__GPO2__ENABLE {0} \
   CONFIG.PSU__PMU__GPO3__ENABLE {0} \
   CONFIG.PSU__PMU__GPO4__ENABLE {0} \
   CONFIG.PSU__PMU__GPO5__ENABLE {0} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {0} \
   CONFIG.PSU__PROTECTION__DDR_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__DEBUG {0} \
   CONFIG.PSU__PROTECTION__ENABLE {0} \
   CONFIG.PSU__PROTECTION__FPD_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__LOCK_UNUSED_SEGMENTS {0} \
   CONFIG.PSU__PROTECTION__LPD_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;0|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;0|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__MASTERS_TZ {GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure} \
   CONFIG.PSU__PROTECTION__OCM_SEGMENTS {NONE} \
   CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
   CONFIG.PSU__PROTECTION__SLAVES { \
     LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;0|LPD;USB3_0;FF9D0000;FF9DFFFF;0|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;0|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;B7FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1 \
   } \
   CONFIG.PSU__PROTECTION__SUBSYSTEMS {NONE} \
   CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0} \
   CONFIG.PSU__PSS_ALT_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.3333333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {<Select>} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {<Select>} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {<Select>} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {<Select>} \
   CONFIG.PSU__REPORT__DBGLOG {0} \
   CONFIG.PSU__RPU_COHERENCY {0} \
   CONFIG.PSU__RPU__POWER__ON {1} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {0} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {64} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP6__DATA_WIDTH {128} \
   CONFIG.PSU__SD0_COHERENCY {0} \
   CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD0__GRP_CD__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SD0__RESET__ENABLE {0} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_POW__IO {MIO 43} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
   CONFIG.PSU__SPI0_LOOP_SPI1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS0__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI0__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS0__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS1__ENABLE {0} \
   CONFIG.PSU__SPI1__GRP_SS2__ENABLE {0} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__IO {NA} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__IO {NA} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TCM0A__POWER__ON {1} \
   CONFIG.PSU__TCM0B__POWER__ON {1} \
   CONFIG.PSU__TCM1A__POWER__ON {1} \
   CONFIG.PSU__TCM1B__POWER__ON {1} \
   CONFIG.PSU__TESTSCAN__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PSU__TRACE__INTERNAL_WIDTH {32} \
   CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TRISTATE__INVERTED {1} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__IO {NA} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0_LOOP_UART1__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {<Select>} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {<Select>} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1_COHERENCY {0} \
   CONFIG.PSU__USB1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USB3_1__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP0 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP1 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP2 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP3 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP4 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP5 {0} \
   CONFIG.PSU__USE_DIFF_RW_CLK_GP6 {0} \
   CONFIG.PSU__USE__ADMA {0} \
   CONFIG.PSU__USE__APU_LEGACY_INTERRUPT {0} \
   CONFIG.PSU__USE__AUDIO {0} \
   CONFIG.PSU__USE__CLK {0} \
   CONFIG.PSU__USE__CLK0 {0} \
   CONFIG.PSU__USE__CLK1 {0} \
   CONFIG.PSU__USE__CLK2 {0} \
   CONFIG.PSU__USE__CLK3 {0} \
   CONFIG.PSU__USE__CROSS_TRIGGER {0} \
   CONFIG.PSU__USE__DDR_INTF_REQUESTED {1} \
   CONFIG.PSU__USE__DEBUG__TEST {0} \
   CONFIG.PSU__USE__EVENT_RPU {0} \
   CONFIG.PSU__USE__FABRIC__RST {1} \
   CONFIG.PSU__USE__FTM {0} \
   CONFIG.PSU__USE__GDMA {0} \
   CONFIG.PSU__USE__IRQ {0} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {0} \
   CONFIG.PSU__USE__M_AXI_GP0 {0} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {1} \
   CONFIG.PSU__USE__PROC_EVENT_BUS {0} \
   CONFIG.PSU__USE__RPU_LEGACY_INTERRUPT {0} \
   CONFIG.PSU__USE__RST0 {0} \
   CONFIG.PSU__USE__RST1 {0} \
   CONFIG.PSU__USE__RST2 {0} \
   CONFIG.PSU__USE__RST3 {0} \
   CONFIG.PSU__USE__RTC {0} \
   CONFIG.PSU__USE__STM {0} \
   CONFIG.PSU__USE__S_AXI_ACE {0} \
   CONFIG.PSU__USE__S_AXI_ACP {0} \
   CONFIG.PSU__USE__S_AXI_GP0 {0} \
   CONFIG.PSU__USE__S_AXI_GP1 {0} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {0} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {0} \
   CONFIG.PSU__USE__S_AXI_GP6 {0} \
   CONFIG.PSU__USE__USB3_0_HUB {0} \
   CONFIG.PSU__USE__USB3_1_HUB {0} \
   CONFIG.PSU__USE__VIDEO {0} \
   CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0} \
   CONFIG.PSU__VIDEO_REF_CLK__FREQMHZ {33.333} \
   CONFIG.QSPI_BOARD_INTERFACE {custom} \
   CONFIG.SATA_BOARD_INTERFACE {custom} \
   CONFIG.SD0_BOARD_INTERFACE {custom} \
   CONFIG.SD1_BOARD_INTERFACE {custom} \
   CONFIG.SPI0_BOARD_INTERFACE {custom} \
   CONFIG.SPI1_BOARD_INTERFACE {custom} \
   CONFIG.SUBPRESET1 {Custom} \
   CONFIG.SUBPRESET2 {Custom} \
   CONFIG.SWDT0_BOARD_INTERFACE {custom} \
   CONFIG.SWDT1_BOARD_INTERFACE {custom} \
   CONFIG.TRACE_BOARD_INTERFACE {custom} \
   CONFIG.TTC0_BOARD_INTERFACE {custom} \
   CONFIG.TTC1_BOARD_INTERFACE {custom} \
   CONFIG.TTC2_BOARD_INTERFACE {custom} \
   CONFIG.TTC3_BOARD_INTERFACE {custom} \
   CONFIG.UART0_BOARD_INTERFACE {custom} \
   CONFIG.UART1_BOARD_INTERFACE {custom} \
   CONFIG.USB0_BOARD_INTERFACE {custom} \
   CONFIG.USB1_BOARD_INTERFACE {custom} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports CLK_IN_D] [get_bd_intf_pins hier_pardcore_peripheral/CLK_IN_D]
  connect_bd_intf_net -intf_net S00_AXI1_1 [get_bd_intf_pins hier_prm_peripheral/M00_AXI] [get_bd_intf_pins hier_uart/S00_AXI1]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins hier_pardcore_peripheral/M02_AXI] [get_bd_intf_pins hier_uart/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins hier_prm_peripheral/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD]
  connect_bd_intf_net -intf_net S_AXILITE_MMIO_1 [get_bd_intf_ports S_AXI_MMIO] [get_bd_intf_pins hier_pardcore_peripheral/S_AXILITE_MMIO]
  connect_bd_intf_net -intf_net S_AXIS_S2MM_1 [get_bd_intf_pins hier_pardcore_peripheral/M_AXIS_MM2S] [get_bd_intf_pins hier_prm_peripheral/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net S_AXI_MEM_1 [get_bd_intf_ports S_AXI_MEM] [get_bd_intf_pins hier_prm_peripheral/S_AXI_MEM]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_ports M_AXI_DMA] [get_bd_intf_pins hier_pardcore_peripheral/M_AXI_DMA]
  connect_bd_intf_net -intf_net axi_write_0_S_AXI [get_bd_intf_pins axi_write_0/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_write_0_S_AXI] [get_bd_intf_pins axi_write_0/S_AXI] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net hier_prm_peripheral_M00_AXI1 [get_bd_intf_pins hier_prm_peripheral/M00_AXI1] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net hier_prm_peripheral_M_AXIS_MM2S [get_bd_intf_pins hier_pardcore_peripheral/S_AXIS_S2MM] [get_bd_intf_pins hier_prm_peripheral/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins hier_pardcore_peripheral/pcie_mgt]

  # Create port connections
  connect_bd_net -net DataChange_0_axi_read_en [get_bd_pins DataChange_0/axi_read_en] [get_bd_pins axi_write_0/axi_read_en]
  connect_bd_net -net DataChange_0_break_full [get_bd_ports break_full] [get_bd_pins DataChange_0/break_full] [get_bd_pins system_ila_0/probe8]
  connect_bd_net -net DataChange_0_data [get_bd_pins axi_write_0/data] [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_ports pardcore_corerstn] [get_bd_pins hier_prm_peripheral/pardcore_corerstn]
  connect_bd_net -net axi_write_0_address_count [get_bd_pins axi_write_0/address_count] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net axi_write_0_data_next [get_bd_pins DataChange_0/data_next] [get_bd_pins axi_write_0/data_next]
  connect_bd_net -net axi_write_0_readsstate [get_bd_pins axi_write_0/readsstate] [get_bd_pins system_ila_0/probe7]
  connect_bd_net -net axi_write_0_sstate [get_bd_pins axi_write_0/sstate] [get_bd_pins system_ila_0/probe6]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports pardcore_coreclk] [get_bd_ports pardcore_uncoreclk] [get_bd_pins hier_clkrst/pardcore_uncoreclk] [get_bd_pins hier_pardcore_peripheral/pardcore_uncoreclk] [get_bd_pins hier_prm_peripheral/pardcore_uncoreclk] [get_bd_pins hier_uart/pardcore_uncoreclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net diff_archvalid_1 [get_bd_ports diff_archvalid] [get_bd_pins DataChange_0/diff_archvalid]
  connect_bd_net -net diff_delayaddress_1 [get_bd_ports diff_delayaddress] [get_bd_pins DataChange_0/diff_delayaddress]
  connect_bd_net -net diff_delaydata_1 [get_bd_ports diff_delaydata] [get_bd_pins DataChange_0/diff_delaydata]
  connect_bd_net -net diff_delayvalid_1 [get_bd_ports diff_delayvalid] [get_bd_pins DataChange_0/diff_delayvalid] [get_bd_pins system_ila_0/probe9]
  connect_bd_net -net diff_difftestTrap_1 [get_bd_ports diff_difftestTrap] [get_bd_pins DataChange_0/diff_difftestTrap]
  connect_bd_net -net diff_exception_1 [get_bd_ports diff_exception] [get_bd_pins DataChange_0/diff_exception]
  connect_bd_net -net diff_instrCnt_1 [get_bd_ports diff_instrCnt] [get_bd_pins DataChange_0/diff_instrCnt] [get_bd_pins system_ila_0/probe5]
  connect_bd_net -net diff_interrupt_1 [get_bd_ports diff_interrupt] [get_bd_pins DataChange_0/diff_interrupt]
  connect_bd_net -net diff_lrscvalid_1 [get_bd_ports diff_lrscvalid] [get_bd_pins DataChange_0/diff_lrscvalid]
  connect_bd_net -net diff_mask_1 [get_bd_ports diff_mask] [get_bd_pins DataChange_0/diff_mask]
  connect_bd_net -net diff_masked_data_1 [get_bd_ports diff_masked_data] [get_bd_pins DataChange_0/diff_masked_data]
  connect_bd_net -net diff_nack_1 [get_bd_ports diff_nack] [get_bd_pins DataChange_0/diff_nack]
  connect_bd_net -net diff_rf_waddr_1 [get_bd_ports diff_rf_waddr] [get_bd_pins DataChange_0/diff_rf_waddr]
  connect_bd_net -net diff_rf_wdata_1 [get_bd_ports diff_rf_wdata] [get_bd_pins DataChange_0/diff_rf_wdata]
  connect_bd_net -net diff_rf_wen_1 [get_bd_ports diff_rf_wen] [get_bd_pins DataChange_0/diff_rf_wen]
  connect_bd_net -net diff_special_1 [get_bd_ports diff_special] [get_bd_pins DataChange_0/diff_special]
  connect_bd_net -net diff_storeaddress_1 [get_bd_ports diff_storeaddress] [get_bd_pins DataChange_0/diff_storeaddress]
  connect_bd_net -net diff_storevalid_1 [get_bd_ports diff_storevalid] [get_bd_pins DataChange_0/diff_storevalid]
  connect_bd_net -net diff_success_1 [get_bd_ports diff_success] [get_bd_pins DataChange_0/diff_success]
  connect_bd_net -net dut_diff_pc_1 [get_bd_ports dut_diff_pc] [get_bd_pins DataChange_0/dut_diff_pc] [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net dut_valid_1 [get_bd_ports dut_valid] [get_bd_pins DataChange_0/dut_valid] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net en_1 [get_bd_ports en] [get_bd_pins DataChange_0/en] [get_bd_pins axi_write_0/en]
  connect_bd_net -net gpr_10_1 [get_bd_ports gpr_10] [get_bd_pins system_ila_0/probe11]
  connect_bd_net -net hier_clkrst_hdft_clk [get_bd_ports Rooketchipclk] [get_bd_pins DataChange_0/s_axi_aclk] [get_bd_pins axi_write_0/s_axi_aclk] [get_bd_pins hier_clkrst/hdft_clk] [get_bd_pins system_ila_0/clk] [get_bd_pins zynq_ultra_ps_e_0/saxihp2_fpd_aclk]
  connect_bd_net -net hier_clkrst_interconnect_aresetn2 [get_bd_pins DataChange_0/s_axi_aresetn] [get_bd_pins axi_write_0/s_axi_aresetn] [get_bd_pins hier_clkrst/interconnect_aresetn2] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net hier_clkrst_locked [get_bd_pins hier_clkrst/locked] [get_bd_pins hier_prm_peripheral/dcm_locked]
  connect_bd_net -net hier_dma_mm2s_introut [get_bd_pins hier_prm_peripheral/mm2s_introut] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net hier_dma_s2mm_introut [get_bd_pins hier_prm_peripheral/s2mm_introut] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net hier_pardcore_peripheral_pardcore_intrs [get_bd_ports pardcore_intrs] [get_bd_pins hier_pardcore_peripheral/pardcore_intrs]
  connect_bd_net -net hier_prm_peripheral_Dout [get_bd_pins hier_clkrst/ext_reset_in] [get_bd_pins hier_prm_peripheral/Dout]
  connect_bd_net -net hier_uart_interrupt [get_bd_pins hier_uart/interrupt] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net hier_uart_interrupt1 [get_bd_pins hier_uart/interrupt1] [get_bd_pins xlconcat_1/In4]
  connect_bd_net -net hier_uart_interrupt2 [get_bd_pins hier_uart/interrupt2] [get_bd_pins xlconcat_1/In5]
  connect_bd_net -net hier_uart_interrupt3 [get_bd_pins hier_uart/interrupt3] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net instrcnt_1 [get_bd_ports instrcnt] [get_bd_pins DataChange_0/instrcnt]
  connect_bd_net -net io_ila_WBUInstr_1 [get_bd_ports io_ila_WBUInstr] [get_bd_pins DataChange_0/io_ila_WBUInstr] [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net io_ila_code_1 [get_bd_ports io_ila_code] [get_bd_pins DataChange_0/io_ila_code]
  connect_bd_net -net io_ila_cycleCnt_1 [get_bd_ports io_ila_cycleCnt] [get_bd_pins DataChange_0/io_ila_cycleCnt]
  connect_bd_net -net io_ila_exceptionInst_1 [get_bd_ports io_ila_exceptionInst] [get_bd_pins DataChange_0/io_ila_exceptionInst]
  connect_bd_net -net io_ila_exceptionPC_1 [get_bd_ports io_ila_exceptionPC] [get_bd_pins DataChange_0/io_ila_exceptionPC]
  connect_bd_net -net io_ila_mcause_1 [get_bd_ports io_ila_mcause] [get_bd_pins DataChange_0/io_ila_mcause] [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net io_ila_medeleg_1 [get_bd_ports io_ila_medeleg] [get_bd_pins DataChange_0/io_ila_medeleg] [get_bd_pins xlconcat_0/In16]
  connect_bd_net -net io_ila_mepc_1 [get_bd_ports io_ila_mepc] [get_bd_pins DataChange_0/io_ila_mepc] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net io_ila_mideleg_1 [get_bd_ports io_ila_mideleg] [get_bd_pins DataChange_0/io_ila_mideleg] [get_bd_pins xlconcat_0/In15]
  connect_bd_net -net io_ila_mie_1 [get_bd_ports io_ila_mie] [get_bd_pins DataChange_0/io_ila_mie] [get_bd_pins xlconcat_0/In12]
  connect_bd_net -net io_ila_mipReg_1 [get_bd_ports io_ila_mipReg] [get_bd_pins DataChange_0/io_ila_mipReg] [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net io_ila_mscratch_1 [get_bd_ports io_ila_mscratch] [get_bd_pins DataChange_0/io_ila_mscratch] [get_bd_pins xlconcat_0/In13]
  connect_bd_net -net io_ila_mstatus_1 [get_bd_ports io_ila_mstatus] [get_bd_pins DataChange_0/io_ila_mstatus] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net io_ila_mtval_1 [get_bd_ports io_ila_mtval] [get_bd_pins DataChange_0/io_ila_mtval] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net io_ila_mtvec_1 [get_bd_ports io_ila_mtvec] [get_bd_pins DataChange_0/io_ila_mtvec] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net io_ila_pc_1 [get_bd_ports io_ila_pc] [get_bd_pins DataChange_0/io_ila_pc]
  connect_bd_net -net io_ila_priviledgeMode_1 [get_bd_ports io_ila_priviledgeMode] [get_bd_pins DataChange_0/io_ila_priviledgeMode]
  connect_bd_net -net io_ila_rfwen_1 [get_bd_ports io_ila_rfwen] [get_bd_pins DataChange_0/io_ila_rfwen]
  connect_bd_net -net io_ila_satp_1 [get_bd_ports io_ila_satp] [get_bd_pins DataChange_0/io_ila_satp] [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net io_ila_scause_1 [get_bd_ports io_ila_scause] [get_bd_pins DataChange_0/io_ila_scause] [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net io_ila_sepc_1 [get_bd_ports io_ila_sepc] [get_bd_pins DataChange_0/io_ila_sepc] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net io_ila_sscratch_1 [get_bd_ports io_ila_sscratch] [get_bd_pins DataChange_0/io_ila_sscratch] [get_bd_pins xlconcat_0/In14]
  connect_bd_net -net io_ila_sstatus_1 [get_bd_ports io_ila_sstatus] [get_bd_pins DataChange_0/io_ila_sstatus] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net io_ila_stval_1 [get_bd_ports io_ila_stval] [get_bd_pins DataChange_0/io_ila_stval] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net io_ila_stvec_1 [get_bd_ports io_ila_stvec] [get_bd_pins DataChange_0/io_ila_stvec] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net isMMIO_1 [get_bd_ports isMMIO] [get_bd_pins DataChange_0/isMMio] [get_bd_pins system_ila_0/probe10]
  connect_bd_net -net pardcore_uncorerst_interconnect_aresetn [get_bd_ports interconnect_aresetn] [get_bd_pins hier_clkrst/interconnect_aresetn] [get_bd_pins hier_pardcore_peripheral/ARESETN] [get_bd_pins hier_prm_peripheral/S00_ARESETN] [get_bd_pins hier_uart/aresetn]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins hier_clkrst/interconnect_aresetn1] [get_bd_pins hier_pardcore_peripheral/S03_ARESETN]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins hier_clkrst/peripheral_aresetn] [get_bd_pins hier_pardcore_peripheral/axi_resetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins hier_clkrst/pardcore_uncorerstn] [get_bd_pins hier_prm_peripheral/pardcore_uncorerstn] [get_bd_pins hier_uart/pardcore_uncorerstn]
  connect_bd_net -net wenable_1 [get_bd_ports wenable] [get_bd_pins DataChange_0/wen] [get_bd_pins axi_write_0/wen]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins hier_clkrst/clk_in1] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins hier_clkrst/resetn] [get_bd_pins hier_pardcore_peripheral/sys_rst_n] [get_bd_pins hier_prm_peripheral/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  assign_bd_address -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_AFIFM6] -force
  assign_bd_address -offset 0xFFA50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_AMS] -force
  assign_bd_address -offset 0xFFA00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_APM] -force
  assign_bd_address -offset 0xFF500000 -range 0x00100000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_CRL_APB] -force
  assign_bd_address -offset 0xFFCA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_CSU] -force
  assign_bd_address -offset 0xFFC80000 -range 0x00020000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_CSUDMA] -force
  assign_bd_address -offset 0x00000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] -force
  assign_bd_address -offset 0xFFCC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_EFUSE] -force
  assign_bd_address -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_GEM3] -force
  assign_bd_address -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_I2C0] -force
  assign_bd_address -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_I2C1] -force
  assign_bd_address -offset 0xFF180000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_IOUSLCR] -force
  assign_bd_address -offset 0xFF250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_IOU_SCNTR] -force
  assign_bd_address -offset 0xFF260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_IOU_SCNTRS] -force
  assign_bd_address -offset 0xFF240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_IOU_SECURE_SLCR] -force
  assign_bd_address -offset 0xFF300000 -range 0x00100000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_IPI] -force
  assign_bd_address -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_IPI_BUFFERS] -force
  assign_bd_address -offset 0xFFA80000 -range 0x00080000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LDMA] -force
  assign_bd_address -offset 0xFF400000 -range 0x00100000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPD_SLCR] -force
  assign_bd_address -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPD_XPPU] -force
  assign_bd_address -offset 0xFF9C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPD_XPPU_SINK] -force
  assign_bd_address -offset 0xFFCF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_MBISTJTAG] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_OCM] -force
  assign_bd_address -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_OCM_CTRL] -force
  assign_bd_address -offset 0xFFA70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_OCM_XMPU_CFG] -force
  assign_bd_address -offset 0xFFD80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_PMU_GLOBAL] -force
  assign_bd_address -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_RPU] -force
  assign_bd_address -offset 0xFFCE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_RSA] -force
  assign_bd_address -offset 0xFFA60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_RTC] -force
  assign_bd_address -offset 0xFF170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_SD1] -force
  assign_bd_address -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_write_0/S_AXI] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_UART0] -force
  assign_bd_address -offset 0x80020000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hier_prm_peripheral/axi_dma_arm/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hier_prm_peripheral/pardcore_corerst/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hier_uart/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hier_uart/axi_uartlite_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x80002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hier_uart/axi_uartlite_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x80003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hier_uart/axi_uartlite_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces hier_pardcore_peripheral/axi_dma_pardcore/Data_SG] [get_bd_addr_segs M_AXI_DMA/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces hier_pardcore_peripheral/axi_dma_pardcore/Data_MM2S] [get_bd_addr_segs M_AXI_DMA/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces hier_pardcore_peripheral/axi_dma_pardcore/Data_S2MM] [get_bd_addr_segs M_AXI_DMA/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x010000000000 -target_address_space [get_bd_addr_spaces hier_pardcore_peripheral/xdma_0/M_AXI_B] [get_bd_addr_segs M_AXI_DMA/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM] -force
  assign_bd_address -offset 0x60010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_pardcore_peripheral/axi_dma_pardcore/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x60000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_uart/axi_uartlite_pardcore_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x60001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_uart/axi_uartlite_pardcore_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x60002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_uart/axi_uartlite_pardcore_2/S_AXI/Reg] -force
  assign_bd_address -offset 0x60003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_uart/axi_uartlite_pardcore_3/S_AXI/Reg] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_pardcore_peripheral/xdma_0/S_AXI_B/BAR0] -force
  assign_bd_address -offset 0x40000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces S_AXI_MMIO] [get_bd_addr_segs hier_pardcore_peripheral/xdma_0/S_AXI_LITE/CTL0] -force
  assign_bd_address -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AFIFM6] -force
  assign_bd_address -offset 0xFFA50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AMS] -force
  assign_bd_address -offset 0xFFA00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_APM] -force
  assign_bd_address -offset 0xFF500000 -range 0x00100000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CRL_APB] -force
  assign_bd_address -offset 0xFFCA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSU] -force
  assign_bd_address -offset 0xFFC80000 -range 0x00020000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSUDMA] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFFCC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_EFUSE] -force
  assign_bd_address -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_GEM3] -force
  assign_bd_address -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C0] -force
  assign_bd_address -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C1] -force
  assign_bd_address -offset 0xFF180000 -range 0x00080000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOUSLCR] -force
  assign_bd_address -offset 0xFF250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTR] -force
  assign_bd_address -offset 0xFF260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTRS] -force
  assign_bd_address -offset 0xFF240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SECURE_SLCR] -force
  assign_bd_address -offset 0xFF300000 -range 0x00100000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI] -force
  assign_bd_address -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI_BUFFERS] -force
  assign_bd_address -offset 0xFFA80000 -range 0x00080000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LDMA] -force
  assign_bd_address -offset 0xFF400000 -range 0x00100000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_SLCR] -force
  assign_bd_address -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU] -force
  assign_bd_address -offset 0xFF9C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU_SINK] -force
  assign_bd_address -offset 0xFFCF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_MBISTJTAG] -force
  assign_bd_address -offset 0xFFFC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM] -force
  assign_bd_address -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_CTRL] -force
  assign_bd_address -offset 0xFFA70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_XMPU_CFG] -force
  assign_bd_address -offset 0xFFD80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PMU_GLOBAL] -force
  assign_bd_address -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RPU] -force
  assign_bd_address -offset 0xFFCE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RSA] -force
  assign_bd_address -offset 0xFFA60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RTC] -force
  assign_bd_address -offset 0xFF170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_SD1] -force
  assign_bd_address -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S_AXI_MEM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_UART0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AFIFM6]
  exclude_bd_addr_seg -offset 0xFFA50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AMS]
  exclude_bd_addr_seg -offset 0xFFA00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_APM]
  exclude_bd_addr_seg -offset 0xFF500000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CRL_APB]
  exclude_bd_addr_seg -offset 0xFFCA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSU]
  exclude_bd_addr_seg -offset 0xFFC80000 -range 0x00020000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSUDMA]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFFCC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_EFUSE]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_GEM3]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C1]
  exclude_bd_addr_seg -offset 0xFF180000 -range 0x00080000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOUSLCR]
  exclude_bd_addr_seg -offset 0xFF250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTR]
  exclude_bd_addr_seg -offset 0xFF260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTRS]
  exclude_bd_addr_seg -offset 0xFF240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SECURE_SLCR]
  exclude_bd_addr_seg -offset 0xFF300000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI_BUFFERS]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00080000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LDMA]
  exclude_bd_addr_seg -offset 0xFF400000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_SLCR]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU]
  exclude_bd_addr_seg -offset 0xFF9C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU_SINK]
  exclude_bd_addr_seg -offset 0xFFCF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_MBISTJTAG]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_CTRL]
  exclude_bd_addr_seg -offset 0xFFA70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_XMPU_CFG]
  exclude_bd_addr_seg -offset 0xFFD80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PMU_GLOBAL]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RPU]
  exclude_bd_addr_seg -offset 0xFFCE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RSA]
  exclude_bd_addr_seg -offset 0xFFA60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RTC]
  exclude_bd_addr_seg -offset 0xFF170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_SD1]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_UART0]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AFIFM6]
  exclude_bd_addr_seg -offset 0xFFA50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AMS]
  exclude_bd_addr_seg -offset 0xFFA00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_APM]
  exclude_bd_addr_seg -offset 0xFF500000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CRL_APB]
  exclude_bd_addr_seg -offset 0xFFCA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSU]
  exclude_bd_addr_seg -offset 0xFFC80000 -range 0x00020000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSUDMA]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFFCC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_EFUSE]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_GEM3]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C1]
  exclude_bd_addr_seg -offset 0xFF180000 -range 0x00080000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOUSLCR]
  exclude_bd_addr_seg -offset 0xFF250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTR]
  exclude_bd_addr_seg -offset 0xFF260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTRS]
  exclude_bd_addr_seg -offset 0xFF240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SECURE_SLCR]
  exclude_bd_addr_seg -offset 0xFF300000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI_BUFFERS]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00080000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LDMA]
  exclude_bd_addr_seg -offset 0xFF400000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_SLCR]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU]
  exclude_bd_addr_seg -offset 0xFF9C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU_SINK]
  exclude_bd_addr_seg -offset 0xFFCF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_MBISTJTAG]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_CTRL]
  exclude_bd_addr_seg -offset 0xFFA70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_XMPU_CFG]
  exclude_bd_addr_seg -offset 0xFFD80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PMU_GLOBAL]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RPU]
  exclude_bd_addr_seg -offset 0xFFCE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RSA]
  exclude_bd_addr_seg -offset 0xFFA60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RTC]
  exclude_bd_addr_seg -offset 0xFF170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_SD1]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_UART0]
  exclude_bd_addr_seg -offset 0xFF9B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AFIFM6]
  exclude_bd_addr_seg -offset 0xFFA50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_AMS]
  exclude_bd_addr_seg -offset 0xFFA00000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_APM]
  exclude_bd_addr_seg -offset 0xFF500000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CRL_APB]
  exclude_bd_addr_seg -offset 0xFFCA0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSU]
  exclude_bd_addr_seg -offset 0xFFC80000 -range 0x00020000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_CSUDMA]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFFCC0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_EFUSE]
  exclude_bd_addr_seg -offset 0xFF0E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_GEM3]
  exclude_bd_addr_seg -offset 0xFF020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C0]
  exclude_bd_addr_seg -offset 0xFF030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_I2C1]
  exclude_bd_addr_seg -offset 0xFF180000 -range 0x00080000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOUSLCR]
  exclude_bd_addr_seg -offset 0xFF250000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTR]
  exclude_bd_addr_seg -offset 0xFF260000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SCNTRS]
  exclude_bd_addr_seg -offset 0xFF240000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IOU_SECURE_SLCR]
  exclude_bd_addr_seg -offset 0xFF300000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI]
  exclude_bd_addr_seg -offset 0xFF990000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_IPI_BUFFERS]
  exclude_bd_addr_seg -offset 0xFFA80000 -range 0x00080000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LDMA]
  exclude_bd_addr_seg -offset 0xFF400000 -range 0x00100000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_SLCR]
  exclude_bd_addr_seg -offset 0xFF980000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU]
  exclude_bd_addr_seg -offset 0xFF9C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPD_XPPU_SINK]
  exclude_bd_addr_seg -offset 0xFFCF0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_MBISTJTAG]
  exclude_bd_addr_seg -offset 0xFF960000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_CTRL]
  exclude_bd_addr_seg -offset 0xFFA70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_OCM_XMPU_CFG]
  exclude_bd_addr_seg -offset 0xFFD80000 -range 0x00040000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PMU_GLOBAL]
  exclude_bd_addr_seg -offset 0xFF9A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RPU]
  exclude_bd_addr_seg -offset 0xFFCE0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RSA]
  exclude_bd_addr_seg -offset 0xFFA60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_RTC]
  exclude_bd_addr_seg -offset 0xFF170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_SD1]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces hier_prm_peripheral/axi_dma_arm/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_UART0]


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."
