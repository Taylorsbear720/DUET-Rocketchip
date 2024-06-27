`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2022 02:50:53 PM
// Design Name: 
// Module Name: difftest_v1
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


module difftest_v1(

 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_1 ALMOST_EMPTY" *) input   [0:0]     num1_fifo_almost_empty,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_1 EMPTY" *)        input   [0:0]     num1_fifo_empty,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_1 RD_DATA" *)      input   [127:0]   num1_fifo_rd_data,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_1 RD_EN" *)        output  [0:0]     num1_fifo_rd_en,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_2 ALMOST_EMPTY" *) input   [0:0]     num2_fifo_almost_empty,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_2 EMPTY" *)        input   [0:0]     num2_fifo_empty,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_2 RD_DATA" *)      input   [127:0]   num2_fifo_rd_data,
 (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_2 RD_EN" *)        output  [0:0]     num2_fifo_rd_en,
 input      [0:0]           clk,
 input      [0:0]           resetn,
 //input      [0:0]           dequeue,
 output     [0:0]           irq1,               //Used to interrupt the EMU on the PS side
 output     [0:0]           irq2,               //Used to interrupt the DUT on the PL side
 //output     [0:0]           right,
 output     [9:0]           fault_times,
 //debug
 output     [2:0]           debug_state,
 output     [63:0]          debug_counter,     
 output     [8-1:0]         debug_eq_r,
 output                     debug_eq,
 output                     debug_pipeline_mark       
    );
    reg     [0:0]       reg_num1_fifo_rd_en;
    reg     [0:0]       reg_num2_fifo_rd_en;
    reg     [0:0]       reg_irq1;
    reg     [0:0]       reg_irq2;
    //reg     [0:0]       reg_right;
    reg     [9:0]       reg_fault_times;
    reg     [63:0]      reg_debug_counter;
    
    assign num1_fifo_rd_en = reg_num1_fifo_rd_en;
    assign num2_fifo_rd_en = reg_num2_fifo_rd_en;
    assign irq1 = reg_irq1;
    assign irq2 = reg_irq2;
    //assign right = reg_right;
    assign fault_times = reg_fault_times;
    assign debug_counter = reg_debug_counter;
    
    
    reg     [2:0]       state = 0;
    //debug
    assign debug_state = state;
    //
    parameter   N = 8;                          //N is 8, which means eight comparators are used
    reg [N-1:0] eq_r;
    reg         eq;
    reg         pipeline_mark = 0;
    reg [7:0]   irq_counter = 0;
    //debug
    assign debug_eq_r = eq_r;
    assign debug_eq = eq;
    assign debug_pipeline_mark = pipeline_mark;
    
    always@(posedge clk)begin
        if(!resetn) begin
            reg_num1_fifo_rd_en <= 0;
            reg_num2_fifo_rd_en <= 0;
            reg_irq1 <= 0;
            reg_irq2 <= 0;
            //reg_right <= 1;
            reg_fault_times <= 0;
            pipeline_mark <= 0;
            eq_r <= 8'b1111_1111;
            eq <= 1;
            reg_debug_counter <= 0;
            irq_counter <= 0;
            state <= 0;
            
        end
        else begin
            case(state)
            //Status 0, preparation phase
            0:begin             
                reg_irq1 <= 0;
                reg_irq2 <= 0;
                reg_num1_fifo_rd_en <= 0;
                reg_num2_fifo_rd_en <= 0;
                state <= 1;
            end
            //State 1 is the data retrieval stage
            1:begin    
                 // If the FIFO on the DUT and EMU is not empty, enter State 2 for comparison         
                if(!num1_fifo_almost_empty && !num2_fifo_almost_empty)begin        
                    reg_num1_fifo_rd_en <= 1;
                    reg_num2_fifo_rd_en <= 1;
                    state <= 2;
                end
                //If the EMU side FIFO is empty and the DUT side FIFO is not empty, interrupt the DUT
                else if (num1_fifo_almost_empty && !num2_fifo_almost_empty)begin    
                   reg_irq2 <=  1;
                   state <= 3;
                end
                //If the DUT side FIFO is empty and the EMU side FIFO is not empty, interrupt the EMU
                else if (!num1_fifo_almost_empty && num2_fifo_almost_empty)begin    
                    reg_irq1 <= 1;
                    state <= 4;
                end
                //All empty, wait
                else begin          
                    state <= 1;
                end
            end
            //Status 2: N-way pipeline comparison
            2:begin         
                reg_debug_counter <= reg_debug_counter + 1;
                reg_num1_fifo_rd_en <= 0;
                reg_num2_fifo_rd_en <= 0;
                //FIFO_DATA TYPE:
                //[127:64]       [63]       [62]        [61:57]         [56]         [55:40]         [39:0]
                //destregdata    ismmio     wenable     destreg         isdelayed    0               pc
                if((num2_fifo_rd_data[62:55] == {8'h80}) ||(num2_fifo_rd_data[62] == 0)||(num2_fifo_rd_data[63] == 1) || (num2_fifo_rd_data[56] == 1))begin
                    eq_r <= 8'hff;
                end
                else begin
                    eq_r[0] <= ( num1_fifo_rd_data[128/N*0 +:128/N] == num2_fifo_rd_data[128/N*0 +:128/N] );
                    eq_r[1] <= ( num1_fifo_rd_data[128/N*1 +:128/N] == num2_fifo_rd_data[128/N*1 +:128/N] );
                    eq_r[2] <= ( num1_fifo_rd_data[128/N*2 +:128/N] == num2_fifo_rd_data[128/N*2 +:128/N] );
                    eq_r[3] <= ( num1_fifo_rd_data[128/N*3 +:(128/N-2)] == num2_fifo_rd_data[128/N*3 +:(128/N-2)] );
                    eq_r[4] <= ( num1_fifo_rd_data[128/N*4 +:128/N] == num2_fifo_rd_data[128/N*4 +:128/N] );
                    eq_r[5] <= ( num1_fifo_rd_data[128/N*5 +:128/N] == num2_fifo_rd_data[128/N*5 +:128/N] );
                    eq_r[6] <= ( num1_fifo_rd_data[128/N*6 +:128/N] == num2_fifo_rd_data[128/N*6 +:128/N] );
                    eq_r[7] <= ( num1_fifo_rd_data[128/N*7 +:128/N] == num2_fifo_rd_data[128/N*7 +:128/N] );
                end   
                eq <= &eq_r;
                if(!pipeline_mark)begin
                    pipeline_mark <= 1;
                    state <= 1;
                end
                else begin
                    if(eq)begin
                        //reg_right <= 1;
                        state <= 1;
                    end
                    //to wrong state 
                    else begin
                        reg_fault_times <= reg_fault_times + 1;
                        //state <= 5; 
                        state <= 1;
                    end
                end   
            end
            //State 3, interrupt the DUT until the FIFO on the DUT side is not empty, and the interrupt lasts for at least 10 cycles to avoid frequent interrupts
            3:begin                 
                if(!num1_fifo_almost_empty && irq_counter >= 10) begin
                    reg_irq2 <= 0;
                    irq_counter <= 0;
                    state <= 1;
                end
                else begin
                    if(irq_counter <= 10)begin
                        irq_counter <= irq_counter + 1;
                    end
                    else;
                    state <= 3;
                end
            end
            //State 4, interrupt the EMU until the FIFO on the EMU side is not empty, and the interrupt lasts for at least 10 cycles to avoid frequent interrupts
            4:begin                 
                if(!num2_fifo_almost_empty && irq_counter >= 10) begin
                    reg_irq1 <= 0;
                    irq_counter <= 0;
                    state <= 1;
                end
                else begin
                    if(irq_counter <= 10)begin
                        irq_counter <= irq_counter + 1;
                    end
                    else;
                    state <= 4;
                end
            end
            //Status 5. Error is found in CPU status comparison between DUT and EMU, indicating DUT execution error. Set the right signal to 0
            5:begin
               reg_irq1 <= 1;
               //debug :wrong then run nutshell to avoid stall
               reg_irq2 <= 0;
               //reg_irq2 <= 1;
               //reg_right <= 0;
               state <= 6;     
            end
            //Status 6: In order to avoid the bus stuck problem caused by full FIFO, the FIFO is always read after an error occurs
            6:begin                 //debug always read 2
                //reg_right <= 0;
                if(!num1_fifo_almost_empty)begin
                    reg_num1_fifo_rd_en <= 1;
                end
                else begin
                    reg_num1_fifo_rd_en <= 0;
                end
                if(!num2_fifo_almost_empty)begin
                    reg_num2_fifo_rd_en <= 1;
                end
                else begin
                    reg_num2_fifo_rd_en <= 0;
                end
                state <= 6;
            end
         
            
            endcase
        end
    end
    
endmodule

