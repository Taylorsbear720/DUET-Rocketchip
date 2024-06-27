`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2023 12:58:05 PM
// Design Name: 
// Module Name: peripheral_syn_reg
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

module peripheral_syn_reg(
    input       [0:0]       clk,
    input       [0:0]       resetn,
    input       [63:0]      dutpc,          //pc,instrcnt,rfdest,rfwen
    input       [63:0]      rfData,
    input       [0:0]       sync_valid,
    input       [63:0]      instrcnt,
    input       [0:0]       syn_reg1_update,
    output reg  [127:0]     syn_reg1,       //pc,instrcnt,rfdest,rfwen
    output reg  [127:0]     syn_reg2        //rfdata
);


    always@(posedge clk)begin
        if(!resetn)begin
            syn_reg1 <= 0;
        end
        else begin
            if(syn_reg1_update)begin
                syn_reg1 <= {instrcnt, dutpc};
            end
            else begin
                syn_reg1 <= syn_reg1;
            end
        end
    end

    always@(posedge clk)begin
        if(!resetn)begin
            syn_reg2 <= 0;
        end
        else begin
            if(sync_valid)begin
                syn_reg2 <= {64'b0, rfData};
            end
            else begin
                syn_reg2 <= syn_reg2;
            end
        end
    end
endmodule