`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    18:18:30 02/08/2018 
// Design Name: 
// Module Name:    mod_7_down_cntr 
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
module mod_7_down_cntr( 
	// inputs
	clr, clk, cnt, 
	// outputs
	o_data );
	
input wire clr;
input clk;
input wire cnt;
output reg[3:0] o_data = 4'b0110;

wire [3:0] data_dec;
assign data_dec = o_data - 1;

always @ (posedge clk or posedge clr) begin
	if (clr) begin
		o_data <= 4'b0110;
	end
	else if (cnt) begin
		if (~|o_data)
			o_data <= 4'b0110;
		else
			o_data <= data_dec[3:0];
	end
	else
	o_data <= o_data; // maintain value when no cnt is given
end

endmodule
