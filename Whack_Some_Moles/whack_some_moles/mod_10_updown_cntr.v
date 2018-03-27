`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    18:18:30 02/08/2018 
// Design Name: 
// Module Name:    mod_10_updown_cntr 
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
module mod_10_updown_cntr( 
	// inputs
	clr, clk, cnt, up,
	// outputs
	o_data, terminal_cnt );
	
input wire clr;
input clk;
input wire cnt;
input wire up; // 0 for down, 1 for up
output reg[3:0] o_data = 0;
output wire terminal_cnt;

wire [4:0] data_inc;
wire [3:0] data_dec;
assign data_inc = o_data + 1;
assign data_dec = o_data - 1;

assign terminal_cnt = ( ( (o_data[3:0] == 4'b1001) & cnt & up) | ( (~|o_data[3:0]) & cnt & (~up) ) ) & (~clr);

always @ (posedge clk or posedge clr) begin
	if (clr) begin
		o_data[3:0] <= 4'b0000;
	end
	else if (cnt) begin
		if (up) begin
			if (o_data[3:0] == 4'b1001)
				o_data[3:0] <= 4'b0000;
			else
				o_data <= data_inc[3:0];
		end
		else begin // down
			if (~|o_data)
				o_data <= 4'b1001;
			else
				o_data <= data_dec[3:0];
		end
	end
	else
	o_data <= o_data; // maintain value when no cnt is given
end

endmodule
