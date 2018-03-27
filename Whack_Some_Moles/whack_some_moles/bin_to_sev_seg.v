`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    10:17:31 02/13/2018 
// Design Name: 
// Module Name:    bin_to_sev_seg
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
module bin_to_sev_seg(
	// inputs
	four_bit_bin,
	// outputs
	sev_seg );

input wire [3:0] four_bit_bin;

output wire [6:0] sev_seg;

assign sev_seg[6:0] = (four_bit_bin[3:0] == 0) ? 7'b0111111 :
							 (four_bit_bin[3:0] == 1) ? 7'b0000110 :
							 (four_bit_bin[3:0] == 2) ? 7'b1011011 :
							 (four_bit_bin[3:0] == 3) ? 7'b1001111 :
							 (four_bit_bin[3:0] == 4) ? 7'b1100110 :
							 (four_bit_bin[3:0] == 5) ? 7'b1101101 :
							 (four_bit_bin[3:0] == 6) ? 7'b1011111 :
							 (four_bit_bin[3:0] == 7) ? 7'b0000111 :
							 (four_bit_bin[3:0] == 8) ? 7'b1111111 : 7'b1100111;

endmodule
