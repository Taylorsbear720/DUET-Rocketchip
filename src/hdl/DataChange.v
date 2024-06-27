`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/02 14:46:58
// Design Name: 
// Module Name: DataChange
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataChange(
  input   [0:0]     s_axi_aclk,                        
  input   [0:0]     s_axi_aresetn,
  
  input   [0:0]     data_next, 
  

  input   [0:0]         wen,
  input   [0:0]          en,

 input   [63:0] dut_diff_pc,
    
  input   [0:0]  dut_valid,
  input   [0:0]  isMMio,
  input    io_ila_rfwen,
  input   [4:0] diff_commit_wdest,
  input   [7:0]  diff_special,
  input   [63:0] instrcnt,
  input   [31:0] io_ila_WBUInstr,
  input   [39:0] diff_commit_pc,
 
  
  input  diff_archvalid,
  input  [63:0] io_ila_exceptionPC,
  input  [31:0] io_ila_exceptionInst,
  input  [31:0] diff_exception,
  input  [31:0] diff_interrupt,
  
 
    
   input  [7:0] io_ila_priviledgeMode,
   input  [63:0] io_ila_mstatus,
   input  [63:0] io_ila_sstatus,
   input  [63:0] io_ila_mepc,
   input  [63:0] io_ila_sepc,
   input  [63:0] io_ila_mtval,
   input  [63:0] io_ila_stval,
   input  [63:0] io_ila_mtvec,
   input  [63:0] io_ila_stvec,
   input  [63:0] io_ila_mcause,
   input  [63:0] io_ila_scause,
   input  [63:0] io_ila_satp,
   input  [63:0]  io_ila_mipReg,
   input  [63:0] io_ila_mie,
   input  [63:0]  io_ila_mscratch,
   input  [63:0]  io_ila_sscratch,
   input  [63:0]  io_ila_mideleg,
   input  [63:0]  io_ila_medeleg,
   
   input [1087:0] csr_data_in,
    
    input diff_delayvalid,
    input [7:0] diff_delayaddress,
    input [63:0] diff_delaydata,
    input [7:0] diff_nack,
    

    
    input diff_rf_wen,
    input [63:0] diff_rf_wdata,
    input [7:0] diff_rf_waddr,
 
    
    input diff_lrscvalid,
    input diff_success,
    
    input diff_storevalid,
    input [63:0] diff_storeaddress,
    input [63:0] diff_masked_data,
    input [7:0] diff_mask,

       
   input diff_difftestTrap,
   input [7:0] io_ila_code,
   input [63:0] io_ila_pc,
   input [63:0]  io_ila_cycleCnt,
   input [63:0] diff_instrCnt,
   
 
   output reg  axi_read_en,
   
   output reg [127:0] commitevent,
//   output reg [127:0] archevent,
//   output reg [63:0] delayevent,
//   output reg [63:0] rfevent,
//   output reg [127:0] storeevent,
   output reg [199:0] Validevent,
   output reg [1087:0] csr_data_out,
   output wire  [6:0]  event_valid,
   output reg [16:0] csr_valid,
  // output reg [39:0] co_data,
   
   //output reg [1919:0] data,
   output reg break_full
  
  
  // output  [16:0] valid
    );
   // reg [63:0] csr_data_reg[16:0];
    //assign csr_data_reg=csr_data_in;
   
   wire [127:0] COMMITEVENT;
   assign COMMITEVENT={io_ila_WBUInstr,diff_commit_pc,io_ila_rfwen,isMMio,diff_special[0:0],diff_commit_wdest,instrcnt[47:0]};
   wire [159:0] ARCHEVENT;
   assign ARCHEVENT={diff_interrupt,diff_exception,io_ila_exceptionInst,io_ila_exceptionPC}; 
   wire [79:0] DELAYEVENT;
   assign DELAYEVENT={diff_delaydata,diff_delayaddress,diff_nack};
   wire [71:0] RFEVENT;
   assign RFEVENT={diff_rf_wdata,diff_rf_waddr};
   wire [135:0] STOREEVENT;
   assign STOREEVENT={diff_masked_data,diff_storeaddress,diff_mask};
   wire [199:0] TRAPEVENT;
   assign TRAPEVENT={io_ila_pc,io_ila_cycleCnt,diff_instrCnt,io_ila_code};
   reg [63:0] csr_data_old[16:0];
   
   
   parameter ARCHEVENT_VALID= 5'b00001;
   parameter DELAYEVENT_VALID= 5'b00010;
   parameter RFEVENT_VALID= 5'b00100;
   parameter STOREEVENT_VALID= 5'b01000;
   parameter TRAPEVENT_VALID= 5'b10000;
   
   assign event_valid={1'b0,diff_difftestTrap,diff_storevalid,diff_rf_wen,diff_delayvalid,diff_archvalid,dut_valid};
   
   integer i;
   always@(posedge s_axi_aresetn) begin
        for(i=0;i<17;i=i+1) begin
            csr_data_old[i]<=64'd0;
        end    
    end
     always@(posedge s_axi_aclk) begin
        if(!s_axi_aresetn || !en) begin
        end  else begin
//            for(i=0;i<17;i=i+1) begin
//                if(csr_data_in[i*64+63:i*64]!=csr_data_old[i]) begin
//                    csr_valid[i]<=1'b1;
//                    csr_data_old[i]<=csr_data_in[i*64+63:i*64];
//                end else begin
//                    csr_valid[i]<=1'b0;
//                end
//            end
            
             if(csr_data_in[63+64*0:0*64]!=csr_data_old[0]) begin
                    csr_valid[0]<=1'b1;
                    csr_data_old[0]<=csr_data_in[63+64*0:0*64];
                end else begin
                    csr_valid[0]<=1'b0;
                end 
             if(csr_data_in[63+64*1:1*64]!=csr_data_old[1]) begin
                    csr_valid[1]<=1'b1;
                    csr_data_old[1]<=csr_data_in[63+64*1:1*64];
                end else begin
                    csr_valid[1]<=1'b0;
                end 
             if(csr_data_in[63+64*2:2*64]!=csr_data_old[2]) begin
                    csr_valid[2]<=1'b1;
                    csr_data_old[2]<=csr_data_in[63+64*2:2*64];
                end else begin
                    csr_valid[2]<=1'b0;
                end 
             if(csr_data_in[63+64*3:3*64]!=csr_data_old[3]) begin
                    csr_valid[3]<=1'b1;
                    csr_data_old[3]<=csr_data_in[63+64*3:3*64];
                end else begin
                    csr_valid[3]<=1'b0;
                end 
             if(csr_data_in[63+64*4:4*64]!=csr_data_old[4]) begin
                    csr_valid[4]<=1'b1;
                    csr_data_old[4]<=csr_data_in[63+64*4:4*64];
                end else begin
                    csr_valid[4]<=1'b0;
                end 
             if(csr_data_in[63+64*5:5*64]!=csr_data_old[5]) begin
                    csr_valid[5]<=1'b1;
                    csr_data_old[5]<=csr_data_in[63+64*5:5*64];
                end else begin
                    csr_valid[5]<=1'b0;
                end 
             if(csr_data_in[63+64*6:6*64]!=csr_data_old[6]) begin
                    csr_valid[6]<=1'b1;
                    csr_data_old[6]<=csr_data_in[63+64*6:6*64];
                end else begin
                    csr_valid[6]<=1'b0;
                end 
             if(csr_data_in[63+64*7:7*64]!=csr_data_old[7]) begin
                    csr_valid[7]<=1'b1;
                    csr_data_old[7]<=csr_data_in[63+64*7:7*64];
                end else begin
                    csr_valid[7]<=1'b0;
                end 
             if(csr_data_in[63+64*8:8*64]!=csr_data_old[8]) begin
                    csr_valid[8]<=1'b1;
                    csr_data_old[8]<=csr_data_in[63+64*8:8*64];
                end else begin
                    csr_valid[8]<=1'b0;
                end 
             if(csr_data_in[63+64*9:9*64]!=csr_data_old[9]) begin
                    csr_valid[9]<=1'b1;
                    csr_data_old[9]<=csr_data_in[63+64*9:9*64];
                end else begin
                    csr_valid[9]<=1'b0;
                end 
             if(csr_data_in[63+64*10:10*64]!=csr_data_old[10]) begin
                    csr_valid[10]<=1'b1;
                    csr_data_old[10]<=csr_data_in[63+64*10:10*64];
                end else begin
                    csr_valid[10]<=1'b0;
                end 
             if(csr_data_in[63+64*11:11*64]!=csr_data_old[11]) begin
                    csr_valid[11]<=1'b1;
                    csr_data_old[11]<=csr_data_in[63+64*11:11*64];
                end else begin
                    csr_valid[11]<=1'b0;
                end 
             if(csr_data_in[63+64*12:12*64]!=csr_data_old[12]) begin
                    csr_valid[12]<=1'b1;
                    csr_data_old[12]<=csr_data_in[63+64*12:12*64];
                end else begin
                    csr_valid[12]<=1'b0;
                end 
             if(csr_data_in[63+64*13:13*64]!=csr_data_old[13]) begin
                    csr_valid[13]<=1'b1;
                    csr_data_old[13]<=csr_data_in[63+64*13:13*64];
                end else begin
                    csr_valid[13]<=1'b0;
                end 
             if(csr_data_in[63+64*14:14*64]!=csr_data_old[14]) begin
                    csr_valid[14]<=1'b1;
                    csr_data_old[14]<=csr_data_in[63+64*14:14*64];
                end else begin
                    csr_valid[14]<=1'b0;
                end 
             if(csr_data_in[63+64*15:15*64]!=csr_data_old[15]) begin
                    csr_valid[15]<=1'b1;
                    csr_data_old[15]<=csr_data_in[63+64*15:15*64];
                end else begin
                    csr_valid[15]<=1'b0;
                end 
             if(csr_data_in[63+64*16:16*64]!=csr_data_old[16]) begin
                    csr_valid[16]<=1'b1;
                    csr_data_old[16]<=csr_data_in[63+64*16:16*64];
                end else begin
                    csr_valid[16]<=1'b0;
                end 
            
            if(event_valid) begin
                commitevent<=COMMITEVENT;
            end else begin
                commitevent<=128'b0;
            end
            
            
            case (event_valid[5:1])
            ARCHEVENT_VALID: begin
            Validevent<=ARCHEVENT;
            end 
            DELAYEVENT_VALID: begin
             Validevent<=DELAYEVENT;
            end
            RFEVENT_VALID: begin
             Validevent<=RFEVENT;
            end
            STOREEVENT_VALID:begin
             Validevent<=STOREEVENT;
            end
            TRAPEVENT_VALID:begin
             Validevent<=TRAPEVENT;
            end
            
            endcase
            
            csr_data_out<=csr_data_in;
        end       
     end
    

//     reg isFirst;
//    reg compare;

    
//    reg [1663:0] Next_data;
 
//    always@(posedge s_axi_aclk) begin
//        if(!s_axi_aresetn || !en) begin
//            break_full<=0;
//            data<=0;
//            compare=1;
//            axi_read_en<=0;
////            Next_data<=0;
//        end else begin
                
//            if((dut_valid || diff_delayvalid) && !break_full) begin  
//                 // axi_read_en<=0;     
//              //   if(compare==1000) begin   
//                 data<={io_ila_mstatus,io_ila_sstatus,io_ila_mepc, io_ila_sepc,io_ila_mtval, io_ila_stval,io_ila_mtvec,io_ila_stvec,io_ila_mcause, io_ila_scause,io_ila_satp,io_ila_mipReg,
//                 io_ila_mie,  io_ila_mscratch,io_ila_sscratch, io_ila_mideleg,io_ila_medeleg,codata,diff_instrCnt,io_ila_cycleCnt,io_ila_pc,diff_masked_data,diff_storeaddress,diff_rf_wdata,diff_delaydata ,
//                 dut_diff_pc,diff_exception,diff_interrupt,io_ila_exceptionPC,io_ila_exceptionInst, io_ila_WBUInstr,instrcnt};  
////                    data<={0};
////                   compare<=1;
////                 end else begin
////                 data<={ syn_reg2,syn_reg1,{7'd0},io_ila_isRVC,io_ila_priviledgeMode,{7'd0},io_ila_nutcoretrap,io_ila_code,io_ila_intrNO, 
////                   io_ila_cause,io_ila_exceptionInst,io_ila_exceptionPC,io_ila_pc, io_ila_WBUInstr,instrcnt}; 
////                   compare<=compare+1; 
////                 end
//                 axi_read_en<=1;
//                 break_full<=1'b1;
//            end else if (data_next) begin
//                 axi_read_en<=0;
//                 data<=0;
//                 break_full<=1'b0;
//            end else begin
//                axi_read_en<=0;
//            end
//        end
    
//    end
    
endmodule
