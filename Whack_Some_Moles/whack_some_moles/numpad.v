`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:30 02/27/2018 
// Design Name: 
// Module Name:    numpad 
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
module numpad(clk, JA, numpadStates);

input clk; //100 MHz master clock
inout [7:0] JA; //JA is on Nexys 3: JA[3:0] is columns, JA[7:4] is rows

wire [1:0] decoded_row;
wire [1:0] decoded_col;

//This 16-bit wire array is used to indicate to the mole module which mole was hit
//All the other 15 bits will be 0
output wire [15:0] numpadStates;

numpad_decode DecodeButton(
	.clk (clk),
	.Rows (JA[7:4]),
	.Cols (JA[3:0]),
	.decoded_row (decoded_row[1:0]),
	.decoded_col (decoded_col[1:0])
);

assign numpadStates = ((decoded_col == 2'b00) && (decoded_row == 2'b00)) ? 16'b0000000000000001 :
							 ((decoded_col == 2'b01) && (decoded_row == 2'b00)) ? 16'b0000000000000010 :
							 ((decoded_col == 2'b10) && (decoded_row == 2'b00)) ? 16'b0000000000000100 :
							 ((decoded_col == 2'b11) && (decoded_row == 2'b00)) ? 16'b0000000000001000 :
							 ((decoded_col == 2'b00) && (decoded_row == 2'b01)) ? 16'b0000000000010000 :
							 ((decoded_col == 2'b01) && (decoded_row == 2'b01)) ? 16'b0000000000100000 :
							 ((decoded_col == 2'b10) && (decoded_row == 2'b01)) ? 16'b0000000001000000 :
							 ((decoded_col == 2'b11) && (decoded_row == 2'b01)) ? 16'b0000000010000000 :
							 ((decoded_col == 2'b00) && (decoded_row == 2'b10)) ? 16'b0000000100000000 :
							 ((decoded_col == 2'b01) && (decoded_row == 2'b10)) ? 16'b0000001000000000 :
							 ((decoded_col == 2'b10) && (decoded_row == 2'b10)) ? 16'b0000010000000000 :
							 ((decoded_col == 2'b11) && (decoded_row == 2'b10)) ? 16'b0000100000000000 :
							 ((decoded_col == 2'b00) && (decoded_row == 2'b11)) ? 16'b0001000000000000 :
							 ((decoded_col == 2'b01) && (decoded_row == 2'b11)) ? 16'b0010000000000000 :
							 ((decoded_col == 2'b10) && (decoded_row == 2'b11)) ? 16'b0100000000000000 :
							 ((decoded_col == 2'b11) && (decoded_row == 2'b11)) ? 16'b1000000000000000 : 16'b0000000000000000;


endmodule
