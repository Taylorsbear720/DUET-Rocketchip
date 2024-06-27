`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/03 10:27:04
// Design Name: 
// Module Name: Data_Pack
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


module Data_Pack(      
 input   [0:0]     s_axi_aclk,                        
  input   [0:0]     s_axi_aresetn,
  input [127:0] commitevent,
  input  [127:0] archevent,
  input  [63:0] delayevent,
  input  [63:0] rfevent,
  input [127:0] storeevent,
  input [191:0] trapevent,
  input  [1087:0] csr_data_out,
  input  [6:0]  event_valid,
  input [16:0] csr_valid,
  input [39:0] co_data,
  
  output [9:0]datasize1,
  output [10:0]datasize2,
  output [1855:0]data
    );
    //commit,arch,delay,rf,store,trap 
    //wire  datasize1;
    assign datasize=event_valid[0]*128+event_valid[1]*128+event_valid[2]*64+event_valid[3]*64+event_valid[4]*128+event_valid[5]*191;
    //wire  datasize2;
    assign datasize2=csr_valid[0]*64+csr_valid[1]*64+csr_valid[2]*64+csr_valid[3]*64+csr_valid[4]*64+csr_valid[5]*64+csr_valid[6]*64+csr_valid[7]*64+csr_valid[8]*64+csr_valid[9]*64+csr_valid[10]*64+csr_valid[11]*64+csr_valid[12]*64+csr_valid[13]*64+csr_valid[14]*64+csr_valid[15]*64+csr_valid[16]*64;
    
    
endmodule
