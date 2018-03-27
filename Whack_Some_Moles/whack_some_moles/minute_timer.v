`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    19:38:57 03/01/2018 
// Design Name: 
// Module Name:    minute_timer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: top module must handle what happens when timer reaches 00 
// 					-- send clr signal and set cnt low when tens == 0 and ones == 0
//
//////////////////////////////////////////////////////////////////////////////////
module minute_timer(
	// inputs
	clr, clk, cnt,
	// outputs
	tens, ones );

input wire clr;
input wire clk; // 1 Hz
input wire cnt;
output wire[3:0] tens;
output wire[3:0] ones;

wire term_cnt_ones;
wire cnt_ones = cnt;
wire cnt_tens = cnt & term_cnt_ones;

mod_10_updown_cntr down_sec_ones (
	// inputs
			.clr				(clr),
			.clk				(clk),
			.cnt				(cnt_ones),
			.up				(1'b0),
	// outputs
			.o_data			(ones),
			.terminal_cnt	(term_cnt_ones) );
			
mod_7_down_cntr down_sec_tens (
	// inputs
			.clr				(clr),
			.clk				(clk),
			.cnt				(cnt_tens),
	// outputs
			.o_data			(tens) );

			
endmodule
