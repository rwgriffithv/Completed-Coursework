`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 	    Robert Griffith
// 
// Create Date:    11:00:43 03/08/2018 
// Design Name: 
// Module Name:    whack_some_moles 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 	Game is played with digilent pmodKYPD 16 numpad, three
//									switches to select level, two on-board buttons (start
//									and reset) -- numpad is played with upside-down so as
//									to not have the player's hand resting on top of the board
//
//////////////////////////////////////////////////////////////////////////////////

module whack_some_moles(
	// input
	clk, sw, btnL, btnR,
	// inout
	JA,
	// output
	vgaRed, vgaGreen, vgaBlue, Hsync, Vsync );

// Inputs:	 
input clk;					// 100 MHz master clock
input wire [2:0] sw;		// first 3 switches
input wire btnL;
input wire btnR;

// Inouts:
inout [7:0] JA;

// Outputs:
output wire [2:0] vgaRed;
output wire [2:0] vgaGreen;
output wire [1:0] vgaBlue;
output wire Hsync;
output wire Vsync;


// ======================== DEBOUNCING ==========================

wire not_rst;
wire rst;
wire start;
wire not_start;

debouncer Debounce_btnL (
	// inputs
			.clk				(clk),
			.btn_raw			(btnL),
	// outputs
			.btn_state		(not_start) );
			
debouncer Debounce_btnR (
	// inputs
			.clk				(clk),
			.btn_raw			(btnR),
	// outputs
			.btn_state		(not_rst) );
			
assign start = ~not_start;
assign rst = ~not_rst;


// == SELECT LEVEL and RUN LOGIC ==

wire [1:0] sel_level;
reg [1:0] level = 0;

level_selector level_selector_object (
	//inputs
		.sw (sw[2:0]),
	//outputs
		.selected_level (sel_level) );
    
reg run_game = 0;
  
// start game and level initialization
always @ (posedge start or posedge rst) begin
	if (rst)
		run_game <= 0;
	else if((sel_level != 0) && (~run_game)) begin
		run_game <= 1;
		level <= sel_level;
  end
end

wire game_rst;
assign game_rst = ((~run_game) & start) | rst;


//  == CLOCKS == 

wire clk_1Hz;
wire animation_clk;
wire clk_25MHz;
wire lfsr_clk;

clk_divider Divide_clks (
	// inputs
			.clk						(clk),
			.rst						(game_rst),
			.lvl						(level),
	// outputs
			.clk_1Hz					(clk_1Hz),
			.animation_clk			(animation_clk),
			.clk_25MHz				(clk_25MHz),
			.lfsr_clk				(lfsr_clk) );


// ====== TIMER =======

wire [3:0] time_tens;
wire [3:0] time_ones;
wire game_pause;

minute_timer timer (
	// inputs
	.clr			(game_rst),
	.clk			(clk_1Hz),
	.cnt      	(~game_pause),
	// outputs
	.tens			(time_tens),
	.ones			(time_ones) );


assign game_pause = (~run_game) || ((time_tens[3:0] == 0) && (time_ones[3:0] == 0));


// == LFSR ==

wire [15:0] mole_signals;
LFSR_10 lfsr (
	// inputs
		.clk					(lfsr_clk),
		.rst_n				(~game_pause),
	// outputs
		.mole_location		(mole_signals) );


// == NUMPAD ==

wire [15:0] mole_btns;
numpad mole_buttons (
	// inputs
		.clk (clk),
		.JA	(JA[7:0]),
	// outputs
		.numpadStates	(mole_btns) );
		

// == MOLES ==

wire [31:0] mole_states;
wire [3:0] score_hundreds;
wire [3:0] score_tens;
wire [3:0] score_ones;

sixteen_moles moles (
	// inputs
		.animation_clk		(animation_clk),
		.rst					(game_rst),
		.pause				(game_pause),
		.start_moles      (mole_signals),
		.mole_btns        (mole_btns),
	// outputs
		.mole_states		(mole_states[31:0]),
		.score_h				(score_hundreds), 
		.score_t				(score_tens), 
		.score_o				(score_ones) );


// ======== 7 SEG CONVERSION =========

wire [6:0] score_h7;
wire [6:0] score_t7;
wire [6:0] score_o7;
wire [6:0] level_7;
wire [6:0] timer_t7;
wire [6:0] timer_o7;

bin_to_sev_seg scoreH_seg (
	// inputs
	.four_bit_bin	(score_hundreds),
	// outputs
	.sev_seg			(score_h7) );

bin_to_sev_seg scoreT_seg (
	// inputs
	.four_bit_bin	(score_tens),
	// outputs
	.sev_seg			(score_t7) );

bin_to_sev_seg scoreO_seg (
	// inputs
	.four_bit_bin	(score_ones),
	// outputs
	.sev_seg			(score_o7) );

bin_to_sev_seg level_seg (
	// inputs
	.four_bit_bin	({2'b00, level}),
	// outputs
	.sev_seg			(level_7) );
	
bin_to_sev_seg timerT_seg (
	// inputs
	.four_bit_bin	(time_tens),
	// outputs
	.sev_seg			(timer_t7) );
	
bin_to_sev_seg timerO_seg (
	// inputs
	.four_bit_bin	(time_ones),
	// outputs
	.sev_seg			(timer_o7) );
	

// ====== DISPLAY ==========

display_vga640x480 VGA_display(
	// inputs
	.dclk				(clk_25MHz),		//pixel clock: 25MHz
	.clr				(game_rst),			//asynchronous reset
	.mole_states	(mole_states), 	//what mole states to display, 16 holes, 4 states, 2 bits / hole   mole_states
	.score_o			(score_o7), 		//7seg encoding of score 1s digit
	.score_t			(score_t7),			//7seg encoding of score 10s digit
	.score_h			(score_h7),			//7seg encoding of score 100s digit
	.level			(level_7),			//7seg, level [1-4]
	.timer_t			(timer_t7),			//7seg, timer tens
	.timer_o			(timer_o7),			//7seg, timer ones
	.hsync			(Hsync),				//horizontal sync out
	.vsync			(Vsync),				//vertical sync out
	.red				(vgaRed[2:0]),		//red vga output
	.green			(vgaGreen[2:0]),	//green vga output
	.blue				(vgaBlue[1:0]) );	//blue vga output


endmodule
