`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date:    11:23:11 03/06/2018 
// Design Name: 
// Module Name:    level_selector 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module level_selector(
	sw,
	selected_level
);

input wire [2:0] sw;
output wire [1:0] selected_level;

assign selected_level = ((sw[0] == 1) && (sw[1] == 0) && (sw[2] == 0)) ? 2'b01 :
								((sw[1] == 1) && (sw[2] == 0)) ? 2'b10 :
								(sw[2] == 1) ? 2'b11 : 2'b00;

endmodule
