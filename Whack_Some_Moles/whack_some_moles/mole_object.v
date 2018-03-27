`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    23:06:42 03/02/2018 
// Design Name: 
// Module Name:    mole_object 
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
module mole_object(
	// inputs
	animation_clk, rst, start, pause, btn,
	// outputs
	state, points_scored );

input wire animation_clk;
input wire rst;
input wire start;
input wire pause;
input wire btn; // what is pressed to hit the mole
output reg [1:0] state = 0;
output reg [5:0] points_scored = 0;

wire [6:0] points_scored_inc = points_scored + 1;

reg retreat = 0;
reg [3:0] up_frames = 0; // how long a state is displayed
wire [4:0] up_frames_inc;
assign up_frames_inc = up_frames + 1;

always @ (posedge animation_clk or posedge rst) begin
	if (rst) begin
		state <= 0;
		points_scored <= 0;
		up_frames <= 0;
		retreat <= 0;
	end
	else
		case (state)
			2'b00: begin //empty hole
				if (~pause) begin
					retreat <= 0;
					if (~up_frames[3]) begin
						up_frames <= up_frames_inc[3:0];
					end
					else if (start & (~btn)) begin // mole will not start if button is held or being mashed by a spaz
						state <= 2'b01;
						up_frames <= 0;
					end
				end // end not paused
			end
			2'b01: begin // deep in hole
				if (~pause) begin
					if (up_frames[1]) begin
						if (retreat) begin
							state <= 0;
							up_frames <= 0;
						end
						else begin
							state <= 2'b10;
							up_frames <= 0;
						end
					end
					else if (btn & (~retreat)) begin
						state <= 2'b11;
						retreat <= 1;
						up_frames <= 0;
						points_scored <= points_scored_inc[5:0];
					end
					else begin
						up_frames <= up_frames_inc[3:0];
					end
				end // end not paused
			end
			2'b10: begin //out of hole
				if (~pause) begin
					if (retreat & up_frames[1]) begin
						state <= 2'b01;
						up_frames <= 0;
					end
					else if (&up_frames[3:0]) begin
						state <= 2'b01;
						up_frames <= 0;
						retreat <= 1;
					end
					else if (btn & (~retreat)) begin
						state <= 2'b11;
						up_frames <= 0;
						points_scored <= points_scored_inc[5:0];
						retreat <= 1;
					end
					else begin
						up_frames <= up_frames_inc[3:0];
					end
				end // end not paused
			end
			2'b11: begin // injured
				retreat <= 1;
				if (~pause) begin
					if (up_frames[3]) begin
						state <= 2;
						up_frames <= 0;
					end
					else begin
						up_frames <= up_frames_inc[3:0];
					end
				end // end not paused
				else begin
					state <= state;
					up_frames <= up_frames;
				end
			end
			
		endcase
		
end // end always

endmodule
