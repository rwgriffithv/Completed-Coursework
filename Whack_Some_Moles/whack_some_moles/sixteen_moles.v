`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    23:20:19 03/02/2018 
// Design Name: 
// Module Name:    sixteen_moles 
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
module sixteen_moles(
 	// inputs
	animation_clk, rst, pause, start_moles, mole_btns,
	// outputs
	mole_states, score_h, score_t, score_o );

input wire animation_clk;
input wire rst;
input wire pause;
input wire [15:0] start_moles;
input wire [15:0] mole_btns;
output wire [31:0] mole_states;
output wire [3:0] score_h;
output wire [3:0] score_t;
output wire [3:0] score_o;

wire [9:0] total_score;

wire [5:0] points_m00;
wire [5:0] points_m01;
wire [5:0] points_m02;
wire [5:0] points_m03;
wire [5:0] points_m04;
wire [5:0] points_m05;
wire [5:0] points_m06;
wire [5:0] points_m07;
wire [5:0] points_m08;
wire [5:0] points_m09;
wire [5:0] points_m10;
wire [5:0] points_m11;
wire [5:0] points_m12;
wire [5:0] points_m13;
wire [5:0] points_m14;
wire [5:0] points_m15;

mole_object mole_00 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[0]),
			.pause				(pause),
			.btn					(mole_btns[0]),
	// outputs
			.state				(mole_states[1:0]),
			.points_scored		(points_m00) );
			
mole_object mole_01 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[1]),
			.pause				(pause),
			.btn					(mole_btns[1]),
	// outputs
			.state				(mole_states[3:2]),
			.points_scored		(points_m01) );
			
mole_object mole_02 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[2]),
			.pause				(pause),
			.btn					(mole_btns[2]),
	// outputs
			.state				(mole_states[5:4]),
			.points_scored		(points_m02) );

mole_object mole_03 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[3]),
			.pause				(pause),
			.btn					(mole_btns[3]),
	// outputs
			.state				(mole_states[7:6]),
			.points_scored		(points_m03) );

mole_object mole_04 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[4]),
			.pause				(pause),
			.btn					(mole_btns[4]),
	// outputs
			.state				(mole_states[9:8]),
			.points_scored		(points_m04) );

mole_object mole_05 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[5]),
			.pause				(pause),
			.btn					(mole_btns[5]),
	// outputs
			.state				(mole_states[11:10]),
			.points_scored		(points_m05) );

mole_object mole_06 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[6]),
			.pause				(pause),
			.btn					(mole_btns[6]),
	// outputs
			.state				(mole_states[13:12]),
			.points_scored		(points_m06) );

mole_object mole_07 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[7]),
			.pause				(pause),
			.btn					(mole_btns[7]),
	// outputs
			.state				(mole_states[15:14]),
			.points_scored		(points_m07) );

mole_object mole_08 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[8]),
			.pause				(pause),
			.btn					(mole_btns[8]),
	// outputs
			.state				(mole_states[17:16]),
			.points_scored		(points_m08) );

mole_object mole_09 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[9]),
			.pause				(pause),
			.btn					(mole_btns[9]),
	// outputs
			.state				(mole_states[19:18]),
			.points_scored		(points_m09) );

mole_object mole_10 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[10]),
			.pause				(pause),
			.btn					(mole_btns[10]),
	// outputs
			.state				(mole_states[21:20]),
			.points_scored		(points_m10) );

mole_object mole_11 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[11]),
			.pause				(pause),
			.btn					(mole_btns[11]),
	// outputs
			.state				(mole_states[23:22]),
			.points_scored		(points_m11) );

mole_object mole_12 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[12]),
			.pause				(pause),
			.btn					(mole_btns[12]),
	// outputs
			.state				(mole_states[25:24]),
			.points_scored		(points_m12) );

mole_object mole_13 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[13]),
			.pause				(pause),
			.btn					(mole_btns[13]),
	// outputs
			.state				(mole_states[27:26]),
			.points_scored		(points_m13) );

mole_object mole_14 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[14]),
			.pause				(pause),
			.btn					(mole_btns[14]),
	// outputs
			.state				(mole_states[29:28]),
			.points_scored		(points_m14) );

mole_object mole_15 (
	// inputs
			.animation_clk		(animation_clk),
			.rst					(rst),
			.start				(start_moles[15]),
			.pause				(pause),
			.btn					(mole_btns[15]),
	// outputs
			.state				(mole_states[31:30]),
			.points_scored		(points_m15) );


assign total_score = points_m00 + points_m01 + points_m02 + points_m03 + points_m04 + points_m05 + points_m06 + points_m07 +
							points_m08 + points_m09 + points_m10 + points_m11 + points_m12 + points_m13 + points_m14 + points_m15;
							
assign score_h = total_score / 100;
assign score_t = (total_score - 100*score_h) / 10;
assign score_o = (total_score - 100*score_h - 10*score_t);

endmodule
