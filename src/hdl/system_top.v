`include "axi.vh"

module system_top (
  input [0:0]CLK_IN_D_clk_n,
  input [0:0]CLK_IN_D_clk_p,
  input [0:0]pcie_mgt_rxn,
  input [0:0]pcie_mgt_rxp,
  output [0:0]pcie_mgt_txn,
  output [0:0]pcie_mgt_txp
);

  `axi_wire(AXI_MEM_MAPPED, 64, 4);
  `axi_wire(AXI_MEM, 64, 4);
  `axi_wire(AXI_MMIO, 64, 4);
  `axi_wire(AXI_DMA, 64, 8);
  `axi_wire(AXI4_mem, 64, 4);
  `axi_wire(AXI4_mmio, 64, 4);
  `axi_wire(AXI4_dma, 64, 8);


  wire pardcore_coreclk;
  wire [1:0] pardcore_corerstn;
  wire pardcore_uncoreclk;
  wire interconnect_aresetn;

  wire [4:0] pardcore_intrs;

  // interruption logic
  wire  roketchipclk;
  wire nutshell_clk;
  wire en;
  wire  sig_break;
  wire  sig_break2;
  wire  debug_break_df;
  wire  reset;
  reg corerstn_sync[1:0];
  wire  break_full;
 wire[63:0] instrcnt;

  // diff zynq soc

  // diff pardcore
  wire [31:0] io_ila_WBUInstr_0;
  wire [63:0]io_ila_WBUrfData_0;
  wire [4:0]io_ila_WBUrfDest_0;
  wire io_ila_WBUrfWen_0;
  wire io_ila_isMMIO_0;
  wire [7:0] special;
  
    wire diff_commit_is_delayed_0;
  wire diff_delayed_rfwen_0;
  wire [4:0]diff_delayed_wdest_0;
  
  wire lrscvalid;
 wire success ;

wire storevalid; 
 wire [63:0] storeaddress;
 wire [63:0] masked_data;
 wire [7:0] mask;


    wire delayvalid;
    wire [7:0] delayaddress;
    wire [63:0] delaydata; 
    wire  [7:0] nack; 
    
    wire [63:0] rf_wdata;
    wire rf_wen;
    wire [7:0] rf_waddr;
  
  
  wire  io_ila_rfwen;
    wire io_ila_isMMIO;
    wire io_ila_isRVC;
  
  wire [7:0] io_ila_priviledgeMode;
   wire [63:0] io_ila_mstatus;
    wire [63:0] io_ila_sstatus;
    wire [63:0] io_ila_mepc;
    wire [63:0] io_ila_sepc;
    wire [63:0] io_ila_mtval;
  wire  [63:0] io_ila_stval;
    wire [63:0] io_ila_mtvec;
    wire [63:0] io_ila_stvec;
   wire  [63:0] io_ila_mcause;
   wire  [63:0] io_ila_scause;
   wire  [63:0] io_ila_satp;
  wire  [63:0]  io_ila_mipReg;
   wire  [63:0] io_ila_mie;
 wire   [63:0]  io_ila_mscratch;
 wire   [63:0]  io_ila_sscratch;
  wire  [63:0]  io_ila_mideleg;
   wire [63:0]  io_ila_medeleg;
   
   wire diff_archvalid_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
  wire[31:0] diff_exception_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
     wire [31:0] diff_interrupt_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    wire [63:0] diff_exceptionPC_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    wire  [31:0] diff_exceptionInst_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      
    wire  diff_difftestTrap_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    wire [63:0]  diff_instrCnt_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    wire  [63:0] diff_trappc_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
     wire [63:0] diff_cycleCnt_0;
    
    wire  [63:0] io_ila_exceptionPC;
  wire  [31:0] io_ila_exceptionInst;
    

   wire[63:0] io_ila_pc;
   wire [63:0]  io_ila_cycleCnt;
   wire  [63:0] io_ila_WBUInstr;
   
   wire [39:0] diff_commit_pc_0;
  
   //wire diff_archvalid_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
  
     //wire [31:0] diff_interrupt_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
  
   // wire  diff_difftestTrap_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    wire [63:0]  diff_instrCnt_0; // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]

    
  wire [63:0]debug_counter;
  
  wire [63:0] gpr_10;
  
  // connect dut diff_signal to zynq

//  interruption_logic_v1reg il_v1(
//    .sys_clk(pardcore_coreclk),
//    .sys_resetn(corerstn_sync[1]),
//    .diff_commit_instr_0(diff_commit_instr_0),
//    .difftest_break(irq2_0),
//    .task_clk(task_clk),
//    .sig_break(sig_break),
//    .sig_break2(sig_break2),
//    .debug_break_df(debug_break_df)
//  );


  zynq_soc zynq_soc_i (
    `axi_connect_if(S_AXI_MEM, AXI_MEM_MAPPED),
    `axi_connect_if(S_AXI_MMIO, AXI_MMIO),
    `axi_connect_if(M_AXI_DMA, AXI_DMA),

    .CLK_IN_D_clk_n(CLK_IN_D_clk_n),
    .CLK_IN_D_clk_p(CLK_IN_D_clk_p),
    .pcie_mgt_rxn(pcie_mgt_rxn),
    .pcie_mgt_rxp(pcie_mgt_rxp),
    .pcie_mgt_txn(pcie_mgt_txn),
    .pcie_mgt_txp(pcie_mgt_txp),
    
    .Rooketchipclk(Roketchipclk),
    .en(en),
    .pardcore_intrs(pardcore_intrs),
    .pardcore_coreclk(pardcore_coreclk),
    .pardcore_corerstn(pardcore_corerstn),
    .pardcore_uncoreclk(pardcore_uncoreclk),
    .interconnect_aresetn(interconnect_aresetn),
     .break_full(break_full),
    //.debug_counter(debug_counter),
   // .debug_break_df(debug_break_df),
   
    .instrcnt(instrcnt),
     .isMMIO(io_ila_isMMIO_0),
    .dut_diff_pc({dut_valid,io_ila_rfwen,io_ila_isMMIO_0 ,io_ila_WBUrfDest_0,{1'd0},delayvalid,lrscvalid,success,storevalid,rf_wen,diff_archvalid_0,diff_difftestTrap_0,rf_waddr,diff_commit_pc_0}),    
    .io_ila_rfwen(io_ila_rfwen),
    .dut_valid(dut_valid),
    .io_ila_WBUInstr(io_ila_WBUInstr_0), 
    .diff_special(special),
    
    
    
    .io_ila_priviledgeMode(io_ila_priviledgeMode),
    .io_ila_mstatus(io_ila_mstatus),
    .io_ila_sstatus(io_ila_sstatus),
    .io_ila_mepc(io_ila_mepc),
    .io_ila_sepc(io_ila_sepc),
    .io_ila_mtval(io_ila_mtval),
    .io_ila_stval(io_ila_stval),
    .io_ila_mtvec(io_ila_mtvec),
    .io_ila_stvec(io_ila_stvec),
    .io_ila_mcause(io_ila_mcause),
    .io_ila_scause(io_ila_scause),
    .io_ila_satp(io_ila_satp),
    .io_ila_mipReg(io_ila_mipReg),
    .io_ila_mie(io_ila_mie),
    .io_ila_mscratch(io_ila_mscratch),
    .io_ila_sscratch(io_ila_sscratch),
    .io_ila_mideleg(io_ila_mideleg),
    .io_ila_medeleg(io_ila_medeleg),
    
    .diff_archvalid(diff_archvalid_0),
    .io_ila_exceptionPC(io_ila_exceptionPC),
    .io_ila_exceptionInst(io_ila_exceptionInst),
     .diff_exception(diff_exception_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    .diff_interrupt(diff_interrupt_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
    
    .diff_difftestTrap(diff_difftestTrap_0),
    .io_ila_code(0),
    .io_ila_pc(io_ila_pc),
    .io_ila_cycleCnt(io_ila_cycleCnt),
     .diff_instrCnt(diff_instrCnt_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
     
     .diff_delayvalid(delayvalid),
    .diff_delayaddress(delayaddress),
    .diff_delaydata(delaydata),
    .diff_nack(nack),
    
    .diff_rf_wdata(rf_wdata),
    .diff_rf_waddr(rf_waddr),
    .diff_rf_wen(rf_wen),
    
    .diff_lrscvalid(lrscvalid),
    .diff_success(success),
    
    .diff_storevalid(storevalid),
    .diff_storeaddress(storeaddress),
    .diff_masked_data(masked_data),
    .diff_mask(mask),
    
    .gpr_10(gpr_10)
    
  );
  
    always@(posedge pardcore_coreclk) begin
    corerstn_sync[0] <= pardcore_corerstn[0];
    corerstn_sync[1] <= corerstn_sync[0];
  end
  
   interrupt_gen  gen1(
    .sys_clk(pardcore_coreclk),
    .full_break(break_full),
    .nutshell_clk(nutshell_clk),
    .en(en)   
  );  

  addr_mapper addr_mapper_i(
    `axi_connect_if(s_axi, AXI_MEM),
    `axi_connect_if(m_axi, AXI_MEM_MAPPED)
  );

  //bus cross clock domain block design
  pardcore pardcore_i(
    //AXI4 interface input from RocketChip
    `axi_connect_if(M_AXI_MEM, AXI_MEM),
    `axi_connect_if(M_AXI_MMIO, AXI_MMIO),
    `axi_connect_if(S_AXI_DMA, AXI_DMA),
    //AXI4 interface output to zynq bd
    `axi_connect_if(mem_axi4_0, AXI4_mem),
    `axi_connect_if(mmio_axi4_0, AXI4_mmio),
    `axi_connect_if(l2_frontend_bus_axi4_0, AXI4_dma),

    .coreclk(nutshell_clk),
    .corersts(~pardcore_corerstn),
    .uncoreclk(pardcore_uncoreclk),
    .interconnect_aresetn(interconnect_aresetn),
    .reset(reset)
  );

  ExampleRocketSystem ExampleRocketSystem_0 ( // @[src/main/scala/system/FuzzHarness.scala 90:19]
    `axi_connect_if(mem_axi4_0, AXI4_mem),
    `axi_connect_if(mmio_axi4_0, AXI4_mmio),
    `axi_connect_if(l2_frontend_bus_axi4_0, AXI4_dma),

    .clock(nutshell_clk),
    .reset(reset),
    .interrupts(5'd0),
    
    
    .diff_commit_instr_cnt(instrcnt),
    .diff_commit_valid(dut_valid),
    .diff_commit_pc(diff_commit_pc_0),
    .diff_commit_instr(io_ila_WBUInstr_0),
    .diff_commit_rfwen(io_ila_rfwen),
    .diff_commit_wdest(io_ila_WBUrfDest_0),
    .diff_commit_skip(io_ila_isMMIO_0),
    .diff_special(special),
    
    
    .diff_rf_wen(rf_wen), 
    .diff_rf_wdata(rf_wdata),
    .diff_rf_waddr(rf_waddr), 
    
//    .diff_gpr_0(),
//    .diff_gpr_1(),
//    .diff_gpr_2(),
//    .diff_gpr_3(),
//    .diff_gpr_4(),
//    .diff_gpr_5(),
//    .diff_gpr_6(),
//    .diff_gpr_7(),
//    .diff_gpr_8(),
//    .diff_gpr_9(),
     .diff_gpr_10(gpr_10),
//    .diff_gpr_11(),
//    .diff_gpr_12(),
//    .diff_gpr_13(),
//    .diff_gpr_14(),
//    .diff_gpr_15(),
//    .diff_gpr_16(),
//    .diff_gpr_17(),
//    .diff_gpr_18(),
//    .diff_gpr_19(),
//    .diff_gpr_20(),
//    .diff_gpr_21(),
//    .diff_gpr_22(),
//    .diff_gpr_23(),
//    .diff_gpr_24(),
//    .diff_gpr_25(),
//    .diff_gpr_26(),
//    .diff_gpr_27(),
//    .diff_gpr_28(),
//    .diff_gpr_29(),
//    .diff_gpr_30(),
//    .diff_gpr_31(),
   
    .diff_priviledgeMode(io_ila_priviledgeMode),
    .diff_mstatus(io_ila_mstatus),
    .diff_sstatus(io_ila_sstatus),
    .diff_mepc(io_ila_mepc),
    .diff_sepc(io_ila_sepc),
    .diff_mtval(io_ila_mtval),
    .diff_stval(io_ila_stval),
    .diff_mtvec(io_ila_mtvec),
    .diff_stvec(io_ila_stvec),
    .diff_mcause(io_ila_mcause),
    .diff_scause(io_ila_scause),
    .diff_satp(io_ila_satp),
    .diff_mipReg(io_ila_mipReg),
    .diff_mie(io_ila_mie),
    .diff_mscratch(io_ila_mscratch),
    .diff_sscratch(io_ila_sscratch),
    .diff_mideleg(io_ila_mideleg),
    .diff_medeleg(io_ila_medeleg),
      
      
    .diff_lrscvalid(lrscvalid), 
     .diff_success(success), 
     
     .diff_storevalid(storevalid), 
    .diff_storeaddress(storeaddress), 
    .diff_masked_data(masked_data),
    .diff_mask(mask),
    
    .diff_delayvalid(delayvalid), 
    .diff_delayaddress(delayaddress), 
     .diff_delaydata(delaydata), 
    .diff_nack(nack), 
      
        .diff_archvalid(diff_archvalid_0),
        .diff_exception(diff_exception_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      .diff_interrupt(diff_interrupt_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      .diff_exceptionPC(io_ila_exceptionPC), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      .diff_exceptionInst(io_ila_exceptionInst), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      
      .diff_difftestTrap(diff_difftestTrap_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      .diff_instrCnt(diff_instrCnt_0), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      .diff_trappc(io_ila_pc), // @[src/main/scala/system/ExampleRocketSystem.scala 32:16]
      .diff_cycleCnt(io_ila_cycleCnt)
  );

endmodule
