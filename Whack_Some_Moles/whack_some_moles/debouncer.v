`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    04:45:40 02/16/2018 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
	// inputs
	clk, btn_raw,
	// outputs
	btn_state );

input wire clk;
input wire btn_raw;
output reg btn_state;

reg btn_sync0;
reg btn_sync1;

always @ (posedge clk) begin
	btn_sync0 <= ~btn_raw; // btn_sync0 is active high
	btn_sync1 <= btn_sync0; // delay
end
	
// takes about 5.24 ms to fill the counter and register a push
reg [18:0] push_btn_cnt; //18:0
wire [19:0] cnt_inc; //19:0
wire cnt_maxed;
assign cnt_maxed = &push_btn_cnt;

wire btn_idle; // see if button is changing value
assign btn_idle = (btn_state == btn_sync1);

assign cnt_inc = push_btn_cnt + 1;

always @ (posedge clk) begin
	if (btn_idle)
		push_btn_cnt <= 0; // button is idle, reset count
	else begin
		push_btn_cnt <= cnt_inc[18:0];
		if (cnt_maxed)
			btn_state <= ~btn_state; // invert state
	end
end

endmodule
