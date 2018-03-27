`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		Griffith
// 
// Create Date:    18:58:46 02/08/2018 
// Design Name: 
// Module Name:    clk_divider 
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
module clk_divider(
	// input
	clk, rst, lvl,
	// output
	clk_1Hz, clk_25MHz, animation_clk, lfsr_clk
	);
	 
input wire clk;
input wire rst;
input wire [1:0] lvl;
output reg clk_1Hz;
output reg clk_25MHz;
output reg animation_clk;	// starts at 30, increments by 6 with each level
output reg lfsr_clk;  // start at 2Hz, increment by 1Hz every two seconds

reg [26:0] clk_dv_1Hz = 0;
reg [26:0] clk_dv_lfsr_clk = 0;
reg [2:0] clk_dv_25MHz = 0;
reg [23:0] clk_dv_animation_clk = 0;

wire [27:0] clk_dv_inc_1Hz;
wire [27:0] clk_dv_inc_lfsr_clk;
wire [3:0] clk_dv_inc_25MHz;
wire [24:0] clk_dv_inc_animation_clk;
wire [23:0] animation_limit;

assign clk_dv_inc_1Hz = clk_dv_1Hz + 1;
assign clk_dv_inc_lfsr_clk = clk_dv_lfsr_clk + 1;
assign clk_dv_inc_25MHz = clk_dv_25MHz + 1;
assign clk_dv_inc_animation_clk = clk_dv_animation_clk + 1;
assign animation_limit = (lvl == 2) ? 24'h4C4B40 : 
								 (lvl == 3) ? 24'h32DCD5 : 24'h989680;

// lfsr_clk control
reg [26:0] lfsr_rate = 27'h5F5E100; //start at 1Hz
wire [26:0] lfsr_rate_dec;
assign lfsr_rate_dec = lfsr_rate - 27'h393870;
reg [2:0] lfsr_3sec_counter = 3'b001; //every 3 seconds increase lfsr Hz, will end game on 12 Hz
wire [2:0] lfsr_3sec_counter_wire = lfsr_3sec_counter;

// 1Hz clock divider
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		clk_dv_1Hz <= 0;
		clk_1Hz <= 0;
		lfsr_rate <=  27'h5F5E100;
		lfsr_3sec_counter <= 3'b001;
	end
	else begin
		clk_dv_1Hz <= clk_dv_inc_1Hz[26:0];
		if (clk_dv_inc_1Hz[26:0] == 27'h5f5e100) begin
			clk_1Hz <= 1'b1;
			clk_dv_1Hz <= 0;
			
			if (lfsr_3sec_counter[2]) begin
				lfsr_rate <= lfsr_rate_dec;
				lfsr_3sec_counter <= 3'b001;
			end
			else //shift to avoid adding
				lfsr_3sec_counter <= lfsr_3sec_counter_wire << 1;
		
		end
		else
			clk_1Hz <= 0;
	end
end

// lfsr_clk clock divider
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		clk_dv_lfsr_clk <= 0;
		lfsr_clk <= 0;
	end
  
	else begin
		clk_dv_lfsr_clk <= clk_dv_inc_lfsr_clk[26:0];
		if (clk_dv_inc_lfsr_clk[26:0] == lfsr_rate) begin
			lfsr_clk <= 1;
			clk_dv_lfsr_clk <= 0;
		end
		else
			lfsr_clk <= 0;
	end
end

// 25Mhz clock divider
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		clk_dv_25MHz <= 0;
		clk_25MHz <= 0;
	end
	else begin
		clk_dv_25MHz <= clk_dv_inc_25MHz[2:0];
		if (clk_dv_inc_25MHz[2:0] == 3'b100) begin
			clk_25MHz <= 1;
			clk_dv_25MHz <= 0;
		end
		else
			clk_25MHz <= 0;
	end
end

// animation_clk clock divider
always @ (posedge clk or posedge rst) begin
	if (rst) begin
		clk_dv_animation_clk <= 0;
		animation_clk <= 0;
	end
	else begin
		clk_dv_animation_clk <= clk_dv_inc_animation_clk[23:0];
		if (clk_dv_inc_animation_clk[23:0] == animation_limit) begin
			animation_clk <= 1;
			clk_dv_animation_clk <= 0;
		end
		else
			animation_clk <= 0;
	end
end



endmodule
