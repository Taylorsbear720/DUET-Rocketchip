`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2022 10:47:06 AM
// Design Name: 
// Module Name: interruption_logic_v1reg
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

module interruption_logic_v1reg(
//`ifdef MODEL_TECH   
//	input 				clk_en,
//	input [31:0] 		breakpoint,
//	input [63:0]  		breakpoint_reg_64,
//	input 				rst,
//`endif
	input 				sys_clk,
    input               sys_resetn,
	input [31:0]        diff_commit_instr_0,
	input               difftest_break,
	
	output 				task_clk,
	output              sig_break,
	output              sig_break2,
	output              debug_break_df
);

	reg [63:0] 			counter;
	reg 				break;
	wire                break2;
	reg                 break_df;

	assign sig_break = break;
	assign sig_break2 = break2;
	assign debug_break_df = break_df;
	
//`ifndef MODEL_TECH
	wire 				clk_en;
	wire [31:0] 		breakpoint;
	wire [63:0] 		breakpoint_reg_64;
	wire                encore_en;
//`endif

    assign break2 = 1'b0;
//`ifndef MODEL_TECH
	vio_0 il_vio (
		.clk			(sys_clk),
		.probe_out0		(breakpoint),
		.probe_out1		(clk_en),
		.probe_out2		(breakpoint_reg_64),
		.probe_out3		(encore_en)
	);
//`endif
   
    always @(posedge sys_clk)begin
        if(!sys_resetn)begin
            break_df <= 0;
        end
        else begin
            break_df <= difftest_break;
        end
    end
   
	always @(posedge sys_clk)
	begin
		if (!sys_resetn)
		begin
			break <= 1'b0;
		end
		else if (clk_en)
		begin
			if (diff_commit_instr_0 == breakpoint)
			begin
				break <= 1'b1;
			end
		end
	end

    
    
	BUFGCE inst_bufgce (
		.O(task_clk),
		.I(sys_clk),
		.CE(clk_en & ~break & ~break2 & (~break_df | ~encore_en)) //test new rocket-chip
	);

endmodule
