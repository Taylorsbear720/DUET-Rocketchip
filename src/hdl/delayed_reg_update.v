`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2023 12:58:05 PM
// Design Name: 
// Module Name: delayed_reg_update
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

module delayed_reg_update(
    input       [0:0]       clk,
    input       [0:0]       resetn,
    input       [0:0]       delayed_valid,
    input       [0:0]       wenable,
    input       [0:0]       isMMIO,
    input       [0:0]       isdelayed,
    input       [0:0]       instr_exed,
    output      [0:0]       sync_valid,
    output      [0:0]       syn_reg1_update
);
    reg     [0:0]       wait_delayed;

    assign syn_reg1_update = wenable & isMMIO & isdelayed & instr_exed;
    assign sync_valid = delayed_valid & wait_delayed;
    
    always@(posedge clk)begin
        if(!resetn)begin
            wait_delayed <= 1'b0;
        end
        else begin
            if(syn_reg1_update)begin
                wait_delayed <= 1'b1;
            end
            else if(delayed_valid && wait_delayed)begin
                wait_delayed <= 1'b0;
            end
            else begin
                wait_delayed <= wait_delayed;
            end
        end
    end

endmodule