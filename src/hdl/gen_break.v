`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2023 01:01:04 PM
// Design Name: 
// Module Name: gen_break
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


module gen_break(
    input       [0:0]       clk,
    input       [0:0]       resetn,
    input       [0:0]       irq2,
    input       [0:0]       irq2_full,
    input       [0:0]       wenable,
    input       [0:0]       isMMIO,
    input       [0:0]       turn2run,
    input       [0:0]       sync_valid,
    output      [0:0]       break_encore,
    output      [0:0]       irq_mmio,
    output      [2:0]       debug_state
);

    reg     [0:0]       break_mmio;
    reg     [2:0]       state;
    reg                 irq2_1d;
    reg                 irq2_2d;
    reg                 turn2run_1d;
    reg                 turn2run_2d;
    assign debug_state = state;
    assign irq_mmio = break_mmio;
    assign break_encore = (irq2_2d&&(~(isMMIO && wenable))) || irq2_full || break_mmio;
    //assign break_encore = (irq2 || irq2_full || break_mmio)&&(!instr_exed);
    always@(posedge clk)begin
        if(!resetn)begin
            irq2_1d <= 0;
            irq2_2d <= 0;
            turn2run_1d <= 0;
            turn2run_2d <= 0;
        end
        else begin
            irq2_1d <= irq2;
            irq2_2d <= irq2_1d;
            turn2run_1d <= turn2run;
            turn2run_2d <= turn2run_1d;
        end
    end
    always@(posedge clk)begin
        if(!resetn)begin
            break_mmio <= 0;
            state <= 0;
        end
        else begin
            case(state)
                0:begin
                    //Ready
                    break_mmio <= 0;
                    state <= 1;
                end
                1:begin
                    if(sync_valid)begin
                            state <= 2;
                            break_mmio <= 1;
                    end
                    else begin
                        state <= 1;
                        break_mmio <= break_mmio;
                    end
                end
                2:begin //mmio stall
                    if(turn2run_2d)begin
                        state <= 0;
                        break_mmio <= 0;
                    end
                    else begin
                        state <= 2;
                        break_mmio <= break_mmio;
                    end
                end
            endcase

        end
    end
endmodule