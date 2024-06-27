







create_pblock pblock_RoCCAccelerator
add_cells_to_pblock [get_pblocks pblock_RoCCAccelerator] [get_cells -quiet [list ExampleRocketSystem_0/tile_prci_domain/tile_reset_domain/tile/RoCCAccelerator]]
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {SLICE_X5Y282:SLICE_X38Y659}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {CMACE4_X0Y1:CMACE4_X0Y3}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {DSP48E2_X0Y114:DSP48E2_X5Y263}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {ILKNE4_X0Y0:ILKNE4_X0Y2}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {PCIE40E4_X0Y3:PCIE40E4_X0Y3}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {RAMB18_X0Y114:RAMB18_X3Y263}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {RAMB36_X0Y57:RAMB36_X3Y131}
resize_pblock [get_pblocks pblock_RoCCAccelerator] -add {URAM288_X0Y28:URAM288_X0Y127}
set_property SNAPPING_MODE ON [get_pblocks pblock_RoCCAccelerator]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pardcore_coreclk]
