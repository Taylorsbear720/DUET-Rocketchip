
################################################################
# This is a generated script based on design: pardcore
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
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source pardcore_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# ExampleRocketSystem

# Please add the sources of those modules before sourcing this Tcl script.

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:c_shift_ram:12.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:xlslice:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
ExampleRocketSystem\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set M_AXI_MEM [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MEM ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.FREQ_HZ {50000000} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M_AXI_MEM

  set M_AXI_MMIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MMIO ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {31} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.FREQ_HZ {50000000} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4} \
   ] $M_AXI_MMIO

  set S_AXI_DMA [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_DMA ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {40} \
   CONFIG.ARUSER_WIDTH {5} \
   CONFIG.AWUSER_WIDTH {5} \
   CONFIG.BUSER_WIDTH {5} \
   CONFIG.DATA_WIDTH {64} \
   CONFIG.FREQ_HZ {50000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {8} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {5} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {5} \
   ] $S_AXI_DMA


  # Create ports
  set coreclk [ create_bd_port -dir I coreclk ]
  set corersts [ create_bd_port -dir I -from 1 -to 0 corersts ]
  set diff_commit_instr_0 [ create_bd_port -dir O -from 31 -to 0 diff_commit_instr_0 ]
  set diff_commit_instr_cnt_0 [ create_bd_port -dir O -from 63 -to 0 diff_commit_instr_cnt_0 ]
  set diff_commit_is_delayed_0 [ create_bd_port -dir O diff_commit_is_delayed_0 ]
  set diff_commit_pc_0 [ create_bd_port -dir O -from 39 -to 0 diff_commit_pc_0 ]
  set diff_commit_rfwen_0 [ create_bd_port -dir O diff_commit_rfwen_0 ]
  set diff_commit_skip_0 [ create_bd_port -dir O diff_commit_skip_0 ]
  set diff_commit_valid_0 [ create_bd_port -dir O diff_commit_valid_0 ]
  set diff_commit_wdata_0 [ create_bd_port -dir O -from 63 -to 0 diff_commit_wdata_0 ]
  set diff_commit_wdest_0 [ create_bd_port -dir O -from 4 -to 0 diff_commit_wdest_0 ]
  set diff_delayed_rfwen_0 [ create_bd_port -dir O diff_delayed_rfwen_0 ]
  set interconnect_aresetn [ create_bd_port -dir I interconnect_aresetn ]
  set intrs [ create_bd_port -dir I -from 4 -to 0 intrs ]
  set uncoreclk [ create_bd_port -dir I -type clk uncoreclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M_AXI_MEM:S_AXI_DMA:M_AXI_MMIO} \
   CONFIG.FREQ_HZ {50000000} \
 ] $uncoreclk

  # Create instance: ExampleRocketSystem_0, and set properties
  set block_name ExampleRocketSystem
  set block_cell_name ExampleRocketSystem_0
  if { [catch {set ExampleRocketSystem_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ExampleRocketSystem_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect_1

  # Create instance: axi_interconnect_2, and set properties
  set axi_interconnect_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_2 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $axi_interconnect_2

  # Create instance: c_shift_ram_0, and set properties
  set c_shift_ram_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_0 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.CE {false} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $c_shift_ram_0

  # Create instance: c_shift_ram_1, and set properties
  set c_shift_ram_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_shift_ram:12.0 c_shift_ram_1 ]
  set_property -dict [ list \
   CONFIG.AsyncInitVal {0} \
   CONFIG.CE {false} \
   CONFIG.DefaultData {0} \
   CONFIG.Depth {1} \
   CONFIG.SyncInitVal {0} \
   CONFIG.Width {1} \
 ] $c_shift_ram_1

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.ALL_PROBE_SAME_MU {false} \
   CONFIG.C_BRAM_CNT {27.5} \
   CONFIG.C_MON_TYPE {MIX} \
   CONFIG.C_NUM_MONITOR_SLOTS {3} \
   CONFIG.C_NUM_OF_PROBES {15} \
   CONFIG.C_PROBE10_WIDTH {64} \
   CONFIG.C_PROBE11_WIDTH {64} \
   CONFIG.C_PROBE12_WIDTH {5} \
   CONFIG.C_PROBE1_WIDTH {40} \
   CONFIG.C_PROBE3_WIDTH {5} \
   CONFIG.C_PROBE4_WIDTH {32} \
   CONFIG.C_PROBE5_WIDTH {64} \
   CONFIG.C_PROBE9_WIDTH {64} \
   CONFIG.C_PROBE_WIDTH_PROPAGATION {MANUAL} \
   CONFIG.C_SLOT_0_MAX_RD_BURSTS {8} \
   CONFIG.C_SLOT_0_MAX_WR_BURSTS {8} \
 ] $system_ila_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {0} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {2} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net ExampleRocketSystem_0_mem_axi4_0 [get_bd_intf_pins ExampleRocketSystem_0/mem_axi4_0] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net ExampleRocketSystem_0_mmio_axi4_0 [get_bd_intf_pins ExampleRocketSystem_0/mmio_axi4_0] [get_bd_intf_pins axi_interconnect_2/S00_AXI]
  connect_bd_intf_net -intf_net S_AXI_DMA_1 [get_bd_intf_ports S_AXI_DMA] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets S_AXI_DMA_1] [get_bd_intf_ports S_AXI_DMA] [get_bd_intf_pins system_ila_0/SLOT_2_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_ports M_AXI_MEM] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_0_M00_AXI] [get_bd_intf_ports M_AXI_MEM] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI1 [get_bd_intf_pins ExampleRocketSystem_0/l2_frontend_bus_axi4_0] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_ports M_AXI_MMIO] [get_bd_intf_pins axi_interconnect_2/M00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_1_M00_AXI] [get_bd_intf_ports M_AXI_MMIO] [get_bd_intf_pins system_ila_0/SLOT_1_AXI]

  # Create port connections
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_instr [get_bd_ports diff_commit_instr_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_instr] [get_bd_pins system_ila_0/probe4]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_instr_cnt [get_bd_ports diff_commit_instr_cnt_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_instr_cnt] [get_bd_pins system_ila_0/probe5]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_is_delayed [get_bd_ports diff_commit_is_delayed_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_is_delayed] [get_bd_pins system_ila_0/probe6]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_pc [get_bd_ports diff_commit_pc_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_pc] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_rfwen [get_bd_ports diff_commit_rfwen_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_rfwen]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_skip [get_bd_ports diff_commit_skip_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_skip] [get_bd_pins system_ila_0/probe7]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_valid [get_bd_ports diff_commit_valid_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_valid] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net ExampleRocketSystem_0_diff_commit_wdest [get_bd_ports diff_commit_wdest_0] [get_bd_pins ExampleRocketSystem_0/diff_commit_wdest]
  connect_bd_net -net ExampleRocketSystem_0_diff_delayed_rfwen [get_bd_ports diff_delayed_rfwen_0] [get_bd_pins ExampleRocketSystem_0/diff_delayed_rfwen] [get_bd_pins system_ila_0/probe8]
  connect_bd_net -net ExampleRocketSystem_0_diff_delayed_wdest [get_bd_pins ExampleRocketSystem_0/diff_delayed_wdest] [get_bd_pins system_ila_0/probe12]
  connect_bd_net -net ExampleRocketSystem_0_diff_gpr_8 [get_bd_pins ExampleRocketSystem_0/diff_gpr_8] [get_bd_pins system_ila_0/probe9]
  connect_bd_net -net ExampleRocketSystem_0_diff_gpr_10 [get_bd_pins ExampleRocketSystem_0/diff_gpr_10] [get_bd_pins system_ila_0/probe10]
  connect_bd_net -net ExampleRocketSystem_0_diff_gpr_11 [get_bd_pins ExampleRocketSystem_0/diff_gpr_11] [get_bd_pins system_ila_0/probe11]
  connect_bd_net -net ExampleRocketSystem_0_diff_rf_wdata [get_bd_ports diff_commit_wdata_0] [get_bd_pins ExampleRocketSystem_0/diff_rf_wdata]
  connect_bd_net -net c_shift_ram_0_Q [get_bd_pins c_shift_ram_0/Q] [get_bd_pins c_shift_ram_1/D]
  connect_bd_net -net c_shift_ram_1_Q [get_bd_pins ExampleRocketSystem_0/reset] [get_bd_pins c_shift_ram_1/Q]
  connect_bd_net -net clk_1 [get_bd_ports uncoreclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_2/ACLK] [get_bd_pins axi_interconnect_2/M00_ACLK] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net coreclk_1 [get_bd_ports coreclk] [get_bd_pins ExampleRocketSystem_0/clock] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_2/S00_ACLK] [get_bd_pins c_shift_ram_0/CLK] [get_bd_pins c_shift_ram_1/CLK] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net corersts_1 [get_bd_ports corersts] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net interconnect_aresetn_1 [get_bd_ports interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_2/ARESETN] [get_bd_pins axi_interconnect_2/M00_ARESETN] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net intrs_1 [get_bd_ports intrs] [get_bd_pins ExampleRocketSystem_0/interrupts] [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_2/S00_ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins c_shift_ram_0/D] [get_bd_pins system_ila_0/probe2] [get_bd_pins xlslice_0/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x000100000000 [get_bd_addr_spaces ExampleRocketSystem_0/mem_axi4_0] [get_bd_addr_segs M_AXI_MEM/Reg] SEG_M_AXI_MEM_Reg
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces ExampleRocketSystem_0/mmio_axi4_0] [get_bd_addr_segs M_AXI_MMIO/Reg] SEG_M_AXI_MMIO_Reg
  create_bd_addr_seg -range 0x000200000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_DMA] [get_bd_addr_segs ExampleRocketSystem_0/l2_frontend_bus_axi4_0/reg0] SEG_ExampleRocketSystem_0_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

}
# End of create_root_design()




proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "#"
   puts "# The following procedures will create hiearchical blocks with addressing "
   puts "# for IPs within those blocks and their sub-hierarchical blocks. Addressing "
   puts "# will not be handled outside those blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
