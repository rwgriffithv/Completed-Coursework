`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:     
// Design Name: 
// Module Name:    display_vga640x480 
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
module display_vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input wire [31:0] mole_states, //what mole states to display, 16 holes, 4 states, 2 bits / hole
	input wire [6:0] score_o,	//7seg encoding of score 1s digit
	input wire [6:0] score_t,	//7seg encoding of score 10s digit
	input wire [6:0] score_h,	//7seg encoding of score 100s digit
	input wire [6:0] level,			//7seg, level [1-4]
	input wire [6:0] timer_t,	//7seg, timer tens
	input wire [6:0] timer_o,	//7seg, timer ones
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output wire [2:0] red,	//red vga output
	output wire [2:0] green, //green vga output
	output wire [1:0] blue	//blue vga output
	);


// video structure constants
parameter hpixels = 800; // horizontal pixels per line
parameter vlines = 521;  // vertical lines per frame
parameter hpulse = 96; 	 // hsync pulse length
parameter vpulse = 2; 	 // vsync pulse length
parameter hbp = 144; 	 // end of horizontal back porch
parameter hfp = 784; 	 // beginning of horizontal front porch
parameter vbp = 31; 		 // end of vertical back porch
parameter vfp = 511; 	 // beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480


// grid limits
// whitespace is 20 pixels between holes
// rw0 = row whitespace 0
// cw0 = column whitespace 0
// header, footer, and banners are space for graphics
// vertical parameters (for vc)
parameter header = 31;	// [31,61) is header
parameter rw0 = 65;		// [65, 71) is first row of whitespace
parameter rh0 = 71;		// [71, 161) is first row of holes
parameter rw1 = 161;		// [161, 171) is second row of whitespace
parameter rh1 = 181;
parameter rw2 = 271;
parameter rh2 = 291;
parameter rw3 = 381;
parameter rh3 = 401;
parameter rw4 = 491; // [491, 501) is last row of whitespace
parameter footer = 501;	// [501, 511) is footer
// horizontal parameters (for hc)
parameter bannerL = 144;	// [144, 234) is left banner
parameter cw0 = 234;			// [234, 254) is first column of whitespace
parameter ch0 = 254;			// [254, 344) is first column of holes
parameter cw1 = 344;
parameter ch1 = 364;
parameter cw2 = 454;
parameter ch2 = 474;
parameter cw3 = 564;
parameter ch3 = 584;
parameter cw4 = 674;
parameter bannerR = 694;	// [694, 784) is right banner


// header parameters
// seg_weight: thickness of segments and distance between top and bottom edges of colons
// also distance between colon and its letter
parameter seg_weight = 3;
parameter colon_top_TE = 42;
parameter colon_low_TE = 48;
parameter num_distance = 6;
parameter vseg_TE = 35; // top edge of vertical segment of any letter (for level display)
parameter vseg_BE = 60;
parameter L_LE = 158;
parameter L_RE = 177;
parameter P_LE = 254;
parameter P_RE = 271;
parameter P_top_BE = 49;
parameter T_LE = 695;
parameter T_RE = 718;
parameter T_vseg_LE = 705;
parameter numseg_G_TE = 46;
parameter level_LE = 189; // level number segs F and E left edge
parameter level_RE = 206; // level number segs B and C right edge
parameter pts_h_LE = 283; // points hundreds place left edge
parameter pts_h_RE = 300;
parameter pts_t_LE = 306; // points tens place left edge
parameter pts_t_RE = 323;
parameter pts_o_LE = 329;	// points ones place left edge
parameter pts_o_RE = 346;
parameter time_t_LE = 730; // timer tens value segs F and E left edge
parameter time_t_RE = 747;
parameter time_o_LE = 753;
parameter time_o_RE = 770;

// banner flower parameters
parameter flower_h = 14;
parameter flower_w = 15;
parameter petal_weight = 5;
parameter flower1_LE = 163;
parameter flower1_TE = 120;
parameter flower2_LE = 197;
parameter flower2_TE = 187;
parameter flower3_LE = 165;
parameter flower3_TE = 291;
parameter flower4_LE = 188;
parameter flower4_TE = 357;
parameter flower5_LE = 170;
parameter flower5_TE = 443;


// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// background rgb values
reg [2:0] red_bgrnd;
reg [2:0] green_bgrnd;
reg [1:0] blue_bgrnd;

// mole rgb values
wire [2:0] red_mole;
wire [2:0] green_mole;
wire [1:0] blue_mole;

// connected to mole_vga_graphic module along with mole rgb values
reg [1:0] sel_mole_state;
reg [9:0] mole_hc;
reg [9:0] mole_vc;

wire draw_bgrnd; // high if vc and hc are in not in a hole


// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	if ( (vc >= vbp) && (vc < vfp) && (hc >= hbp) && (hc < hfp) ) begin
	
/* ========================= H E A D E R ========================= */
		if (vc >= header && vc < rw0) begin
			// print letters and numbers
			if ((vc >= vseg_TE) && (vc < vseg_BE)) begin
				// level tag L
				if ((hc >= 158) && (hc < 177) && ((hc < (161)) || (vc >= (57))))
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end L

					// level number
				else
				if (hc >= 189 && hc < 206 && (
						// seg F and E
						(hc < (192) && ( (vc < (49) && level[5]) ||
																	((vc >= 46) && level[4]) )) ||
						// seg A, G, and D
						(hc >= (189) && hc < (206) && ( 
							// seg A
							((vc < (38)) && level[0]) || 
							// seg G
							(vc >= 46 && (vc < 49) && level[6]) ||
							// seg D
							((vc >= 57) && level[3]) 
							)) ||
						// seg B and C
						(hc >= (203) && ( (vc < (49) && level[1]) || 
																	 (vc >= 46 && level[2]) ))
					))
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end level number
			
				// points tag P
				else if (hc >= P_LE && hc < P_RE && (
						hc < (P_LE+seg_weight) || vc < (38) || ((hc >= (P_RE-seg_weight)) && (vc < P_top_BE)) || 
						(vc >= (P_top_BE-seg_weight) && vc < P_top_BE)
					))
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end P
				
				// points numbers
				else
				if (
					// hundreds
					(hc >= pts_h_LE && hc < pts_h_RE && (
						// seg F and E
						(hc < (286) && ( ((vc < 49) && score_h[5]) ||
																	((vc >= 46) && score_h[4]) )) ||
						// seg A, G, and D
						(hc >= (pts_h_LE) && hc < (pts_h_RE) && ( 
							// seg A
							((vc < 38) && score_h[0]) || 
							// seg G
							((vc >= 46) && (vc < 49) && score_h[6]) ||
							// seg D
							((vc >= 57) && score_h[3]) 
						 )) ||
						// seg B and C
						(hc >= (pts_h_RE-seg_weight) && ( ((vc < 49) && score_h[1]) || 
																	 ((vc >= 46) && score_h[2]) ))
					)) ||
					// tens
					(hc >= pts_t_LE && hc < pts_t_RE && (
						// seg F and E
						(hc < (pts_t_LE+seg_weight) && ( ((vc < 49) && score_t[5]) ||
																	((vc >= 46) && score_t[4]) )) ||
						// seg A, G, and D
						(hc >= (pts_t_LE) && hc < (pts_t_RE) && ( 
							// seg A
							((vc < 38) && score_t[0]) || 
							// seg G
							((vc >= 46) && (vc < 49) && score_t[6]) ||
							// seg D
							((vc >= 57) && score_t[3]) 
						 )) ||
						// seg B and C
						(hc >= (pts_t_RE-seg_weight) && ( ((vc < 49) && score_t[1]) || 
																	 ((vc >= 46) && score_t[2]) ))
					)) ||
					// ones
					(hc >= pts_o_LE && hc < pts_o_RE && (
						// seg F and E
						(hc < (pts_o_LE+seg_weight) && ( ((vc < 49) && score_o[5]) ||
																	((vc >= 46) && score_o[4]) )) ||
						// seg A, G, and D
						(hc >= (pts_o_LE) && hc < (pts_o_RE) && ( 
							// seg A
							((vc < 38) && score_o[0]) || 
							// seg G
							((vc >= 46) && (vc < 49) && score_o[6]) ||
							// seg D
							((vc >= 57) && score_o[3]) 
						 )) ||
						// seg B and C
						(hc >= (pts_o_RE-seg_weight) && ( ((vc < 49) && score_o[1]) || 
																	 ((vc >= 46) && score_o[2]) ))
					))
				   )
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end pts hund number

				// timer tag T
				else if (hc >= T_LE && hc < T_RE && ( ((hc >= T_vseg_LE) && (hc < (T_vseg_LE+seg_weight))) ||
															(vc < (38)) ))
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end L
				
				// timer numbers
				else
				if (
					// tens
					(hc >= time_t_LE && hc < time_t_RE && (
						// seg F and E
						(hc < (time_t_LE+seg_weight) && ( ((vc < 49) && timer_t[5]) ||
																	((vc >= 46) && timer_t[4]) )) ||
						// seg A, G, and D
						(hc >= (time_t_LE) && hc < (time_t_RE) && ( 
							// seg A
							((vc < 38) && timer_t[0]) || 
							// seg G
							((vc >= 46) && (vc < 49) && timer_t[6]) ||
							// seg D
							((vc >= 57) && timer_t[3]) 
						 )) ||
						// seg B and C
						(hc >= (time_t_RE-seg_weight) && ( ((vc < 49) && timer_t[1]) || 
																	 ((vc >= 46) && timer_t[2]) ))
					)) ||
					// ones
					(hc >= time_o_LE && hc < time_o_RE && (
						// seg F and E
						(hc < (time_o_LE+seg_weight) && ( ((vc < 49) && timer_o[5]) ||
																	((vc >= 46) && timer_o[4]) )) ||
						// seg A, G, and D
						(hc >= (time_o_LE) && hc < (time_o_RE) && ( 
							// seg A
							((vc < 38) && timer_o[0]) || 
							// seg G
							((vc >= numseg_G_TE) && (vc < 49) && timer_o[6]) ||
							// seg D
							((vc >= 57) && timer_o[3]) 
						 )) ||
						// seg B and C
						(hc >= (time_o_RE-seg_weight) && ( ((vc < 49) && timer_o[1]) || 
																	 ((vc >= 46) && timer_o[2]) ))
					))
				   )
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end pts hund number
				
				// colons
				else
				if ( ( (vc >= colon_top_TE && vc < (colon_top_TE+seg_weight)) || 
						 (vc >= colon_low_TE && vc< (colon_low_TE+seg_weight)) ) && (
						  // level colon
						  (hc >= (L_RE+seg_weight) && hc < (level_LE-num_distance)) || 
						  // points colon
						  (hc >= (P_RE+seg_weight) && hc < (pts_h_LE-num_distance)) || 
						  // timer colon
						  (hc >= (T_RE+seg_weight) && hc < (time_t_LE-num_distance))
					  )
					)
				begin
					red_bgrnd = 0;
					green_bgrnd = 0;
					blue_bgrnd = 0;
				end // end colons

				// white around characters
				else begin
					red_bgrnd = 3'b111;
					green_bgrnd = 3'b111;
					blue_bgrnd = 2'b11;
				end
			end // end characters
			
			// header underline
			else if (vc >= (rw0-seg_weight)) begin
				red_bgrnd = 0;
				green_bgrnd = 0;
				blue_bgrnd = 0;
			end // end underline
			
			else begin // header background not in row of characters
				red_bgrnd = 3'b111;
				green_bgrnd = 3'b111;
				blue_bgrnd = 2'b11;
			end // end background
		
		end // end header
		
		
/* ================== L E F T   B A N N E R ================== */
		else if (hc >= bannerL && hc < cw0) begin
			// flower cores
			if ( ( (hc >= flower1_LE) && (hc < (flower1_LE + flower_w)) && (vc >= flower1_TE) && (vc < (flower1_TE + flower_h)) ) ||
				  ( (hc >= flower2_LE) && (hc < (flower2_LE + flower_w)) && (vc >= flower2_TE) && (vc < (flower2_TE + flower_h)) ) ||
				  ( (hc >= flower3_LE) && (hc < (flower3_LE + flower_w)) && (vc >= flower3_TE) && (vc < (flower3_TE + flower_h)) ) ||
				  ( (hc >= flower4_LE) && (hc < (flower4_LE + flower_w)) && (vc >= flower4_TE) && (vc < (flower4_TE + flower_h)) ) ||
				  ( (hc >= flower5_LE) && (hc < (flower5_LE + flower_w)) && (vc >= flower5_TE) && (vc < (flower5_TE + flower_h)) ) )
			begin
				if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, yellow
					red_bgrnd = 3'b111;
					green_bgrnd = 3'b110;
					blue_bgrnd = 2'b00;
				end
				else if (level == 7'b1011011) begin // level 2, slightly darker light brown
					red_bgrnd = 3'b101;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1001111) begin // level 3, light gray
					red_bgrnd = 3'b100;
					green_bgrnd = 3'b100;
					blue_bgrnd = 2'b10;
				end
			end // end flower cores
			
			// flower petals
			else if (
				// left petals
				( (hc >= (flower1_LE - petal_weight)) && (hc < flower1_LE) && (vc >= flower1_TE) && (vc < (flower1_TE + flower_h)) ) ||
				( (hc >= (flower2_LE - petal_weight)) && (hc < flower2_LE) && (vc >= flower2_TE) && (vc < (flower2_TE + flower_h)) ) ||
				( (hc >= (flower3_LE - petal_weight)) && (hc < flower3_LE) && (vc >= flower3_TE) && (vc < (flower3_TE + flower_h)) ) ||
				( (hc >= (flower4_LE - petal_weight)) && (hc < flower4_LE) && (vc >= flower4_TE) && (vc < (flower4_TE + flower_h)) ) ||
				( (hc >= (flower5_LE - petal_weight)) && (hc < flower5_LE) && (vc >= flower5_TE) && (vc < (flower5_TE + flower_h)) ) ||
				// right petals
				( (hc >= (flower1_LE + flower_w)) && (hc < (flower1_LE + flower_w + petal_weight)) && (vc >= flower1_TE) && (vc < (flower1_TE + flower_h)) ) ||
				( (hc >= (flower2_LE + flower_w)) && (hc < (flower2_LE + flower_w + petal_weight)) && (vc >= flower2_TE) && (vc < (flower2_TE + flower_h)) ) ||
				( (hc >= (flower3_LE + flower_w)) && (hc < (flower3_LE + flower_w + petal_weight)) && (vc >= flower3_TE) && (vc < (flower3_TE + flower_h)) ) ||
				( (hc >= (flower4_LE + flower_w)) && (hc < (flower4_LE + flower_w + petal_weight)) && (vc >= flower4_TE) && (vc < (flower4_TE + flower_h)) ) ||
				( (hc >= (flower5_LE + flower_w)) && (hc < (flower5_LE + flower_w + petal_weight)) && (vc >= flower5_TE) && (vc < (flower5_TE + flower_h)) ) ||
				// top petals
				( (hc >= flower1_LE) && (hc < (flower1_LE + flower_w)) && (vc >= (flower1_TE - petal_weight)) && (vc < flower1_TE) ) ||
				( (hc >= flower2_LE) && (hc < (flower2_LE + flower_w)) && (vc >= (flower2_TE - petal_weight)) && (vc < flower2_TE) ) ||
				( (hc >= flower3_LE) && (hc < (flower3_LE + flower_w)) && (vc >= (flower3_TE - petal_weight)) && (vc < flower3_TE) ) ||
				( (hc >= flower4_LE) && (hc < (flower4_LE + flower_w)) && (vc >= (flower4_TE - petal_weight)) && (vc < flower4_TE) ) ||
				( (hc >= flower5_LE) && (hc < (flower5_LE + flower_w)) && (vc >= (flower5_TE - petal_weight)) && (vc < flower5_TE) ) ||
				// bottom petals
				( (hc >= flower1_LE) && (hc < (flower1_LE + flower_w)) && (vc >= (flower1_TE + flower_h)) && (vc < (flower1_TE + flower_h + petal_weight)) ) ||
				( (hc >= flower2_LE) && (hc < (flower2_LE + flower_w)) && (vc >= (flower2_TE + flower_h)) && (vc < (flower2_TE + flower_h + petal_weight)) ) ||
				( (hc >= flower3_LE) && (hc < (flower3_LE + flower_w)) && (vc >= (flower3_TE + flower_h)) && (vc < (flower3_TE + flower_h + petal_weight)) ) ||
				( (hc >= flower4_LE) && (hc < (flower4_LE + flower_w)) && (vc >= (flower4_TE + flower_h)) && (vc < (flower4_TE + flower_h + petal_weight)) ) ||
				( (hc >= flower5_LE) && (hc < (flower5_LE + flower_w)) && (vc >= (flower5_TE + flower_h)) && (vc < (flower5_TE + flower_h + petal_weight)) )
			)
			begin
				if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, red
					red_bgrnd = 3'b110;
					green_bgrnd = 3'b001;
					blue_bgrnd = 2'b00;
				end
				else if (level == 7'b1011011) begin // level 2, light brown
					red_bgrnd = 3'b101;
					green_bgrnd = 3'b100;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1001111) begin // level 3, dark gray
					red_bgrnd = 3'b011;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
			end //end petals
			
			// background color
			else begin
				if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, dark green
					red_bgrnd = 3'b001;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1011011) begin // level 2, dry savanna green
					red_bgrnd = 3'b011;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1001111) begin // level 3, bright red
					red_bgrnd = 3'b110;
					green_bgrnd = 3'b000;
					blue_bgrnd = 2'b00;
				end
			end // end background color
			
		end // end left banner

		
/* ================= R I G H T   B A N N E R ================= */
		else if (hc >= bannerR && hc < hfp) begin
			// flower cores
			if ( ( (hc < (hbp + hfp - flower1_LE)) && (hc >= (hbp + hfp - (flower1_LE + flower_w))) && (vc >= flower1_TE) && (vc < (flower1_TE + flower_h)) ) ||
				  ( (hc < (hbp + hfp - flower2_LE)) && (hc >= (hbp + hfp - (flower2_LE + flower_w))) && (vc >= flower2_TE) && (vc < (flower2_TE + flower_h)) ) ||
				  ( (hc < (hbp + hfp - flower3_LE)) && (hc >= (hbp + hfp - (flower3_LE + flower_w))) && (vc >= flower3_TE) && (vc < (flower3_TE + flower_h)) ) ||
				  ( (hc < (hbp + hfp - flower4_LE)) && (hc >= (hbp + hfp - (flower4_LE + flower_w))) && (vc >= flower4_TE) && (vc < (flower4_TE + flower_h)) ) ||
				  ( (hc < (hbp + hfp - flower5_LE)) && (hc >= (hbp + hfp - (flower5_LE + flower_w))) && (vc >= flower5_TE) && (vc < (flower5_TE + flower_h)) ) )
			begin
				if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, yellow
					red_bgrnd = 3'b111;
					green_bgrnd = 3'b110;
					blue_bgrnd = 2'b00;
				end
				else if (level == 7'b1011011) begin // level 2, slightly darker light brown
					red_bgrnd = 3'b101;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1001111) begin // level 3, light gray
					red_bgrnd = 3'b100;
					green_bgrnd = 3'b100;
					blue_bgrnd = 2'b10;
				end
			end // end flower cores
			
			// flower petals
			else if (
				// left petals
				( (hc < (hbp + hfp - (flower1_LE - petal_weight))) && (hc >= (hbp + hfp - flower1_LE)) && (vc >= flower1_TE) && (vc < (flower1_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower2_LE - petal_weight))) && (hc >= (hbp + hfp - flower2_LE)) && (vc >= flower2_TE) && (vc < (flower2_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower3_LE - petal_weight))) && (hc >= (hbp + hfp - flower3_LE)) && (vc >= flower3_TE) && (vc < (flower3_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower4_LE - petal_weight))) && (hc >= (hbp + hfp - flower4_LE)) && (vc >= flower4_TE) && (vc < (flower4_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower5_LE - petal_weight))) && (hc >= (hbp + hfp - flower5_LE)) && (vc >= flower5_TE) && (vc < (flower5_TE + flower_h)) ) ||
				// right petals
				( (hc < (hbp + hfp - (flower1_LE + flower_w))) && (hc >= (hbp + hfp - (flower1_LE + flower_w + petal_weight))) && (vc >= flower1_TE) && (vc < (flower1_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower2_LE + flower_w))) && (hc >= (hbp + hfp - (flower2_LE + flower_w + petal_weight))) && (vc >= flower2_TE) && (vc < (flower2_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower3_LE + flower_w))) && (hc >= (hbp + hfp - (flower3_LE + flower_w + petal_weight))) && (vc >= flower3_TE) && (vc < (flower3_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower4_LE + flower_w))) && (hc >= (hbp + hfp - (flower4_LE + flower_w + petal_weight))) && (vc >= flower4_TE) && (vc < (flower4_TE + flower_h)) ) ||
				( (hc < (hbp + hfp - (flower5_LE + flower_w))) && (hc >= (hbp + hfp - (flower5_LE + flower_w + petal_weight))) && (vc >= flower5_TE) && (vc < (flower5_TE + flower_h)) ) ||
				// top petals
				( (hc < (hbp + hfp - flower1_LE)) && (hc >= (hbp + hfp - (flower1_LE + flower_w))) && (vc >= (flower1_TE - petal_weight)) && (vc < (flower1_TE)) ) ||
				( (hc < (hbp + hfp - flower2_LE)) && (hc >= (hbp + hfp - (flower2_LE + flower_w))) && (vc >= (flower2_TE - petal_weight)) && (vc < (flower2_TE)) ) ||
				( (hc < (hbp + hfp - flower3_LE)) && (hc >= (hbp + hfp - (flower3_LE + flower_w))) && (vc >= (flower3_TE - petal_weight)) && (vc < (flower3_TE)) ) ||
				( (hc < (hbp + hfp - flower4_LE)) && (hc >= (hbp + hfp - (flower4_LE + flower_w))) && (vc >= (flower4_TE - petal_weight)) && (vc < (flower4_TE)) ) ||
				( (hc < (hbp + hfp - flower5_LE)) && (hc >= (hbp + hfp - (flower5_LE + flower_w))) && (vc >= (flower5_TE - petal_weight)) && (vc < (flower5_TE)) ) ||
				// bottom petals
				( (hc < (hbp + hfp - flower1_LE)) && (hc >= (hbp + hfp - (flower1_LE + flower_w))) && (vc >= (flower1_TE + flower_h)) && (vc < (flower1_TE + flower_h + petal_weight)) ) ||
				( (hc < (hbp + hfp - flower2_LE)) && (hc >= (hbp + hfp - (flower2_LE + flower_w))) && (vc >= (flower2_TE + flower_h)) && (vc < (flower2_TE + flower_h + petal_weight)) ) ||
				( (hc < (hbp + hfp - flower3_LE)) && (hc >= (hbp + hfp - (flower3_LE + flower_w))) && (vc >= (flower3_TE + flower_h)) && (vc < (flower3_TE + flower_h + petal_weight)) ) ||
				( (hc < (hbp + hfp - flower4_LE)) && (hc >= (hbp + hfp - (flower4_LE + flower_w))) && (vc >= (flower4_TE + flower_h)) && (vc < (flower4_TE + flower_h + petal_weight)) ) ||
				( (hc < (hbp + hfp - flower5_LE)) && (hc >= (hbp + hfp - (flower5_LE + flower_w))) && (vc >= (flower5_TE + flower_h)) && (vc < (flower5_TE + flower_h + petal_weight)) )
			)
			begin
				if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, red
					red_bgrnd = 3'b110;
					green_bgrnd = 3'b001;
					blue_bgrnd = 2'b00;
				end
				else if (level == 7'b1011011) begin // level 2, light brown
					red_bgrnd = 3'b101;
					green_bgrnd = 3'b100;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1001111) begin // level 3, dark gray
					red_bgrnd = 3'b011;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
			end //end petals
			
			// background color
			else begin
				if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, dark green
					red_bgrnd = 3'b001;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1011011) begin // level 2, dry savanna green
					red_bgrnd = 3'b011;
					green_bgrnd = 3'b011;
					blue_bgrnd = 2'b01;
				end
				else if (level == 7'b1001111) begin // level 3, bright red
					red_bgrnd = 3'b110;
					green_bgrnd = 3'b000;
					blue_bgrnd = 2'b00;
				end
			end // end background color
			
		end // end right banner

		
/* ====================== F O O T E R ====================== */
		else if (vc >= footer && vc < vfp) begin
			if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, dark green
				red_bgrnd = 3'b001;
				green_bgrnd = 3'b011;
				blue_bgrnd = 2'b01;
			end
			else if (level == 7'b1011011) begin // level 2, dry savanna green
				red_bgrnd = 3'b011;
				green_bgrnd = 3'b011;
				blue_bgrnd = 2'b01;
			end
			else if (level == 7'b1001111) begin // level 3, bright red
				red_bgrnd = 3'b110;
				green_bgrnd = 3'b000;
				blue_bgrnd = 2'b00;
			end
		end


/* =================== G R I D =================== */
		else if (
					(vc >= rw0 && vc < rh0) || (vc >= rw1 && vc < rh1) || (vc >= rw2 && vc < rh2) || 
					(vc >= rw3 && vc < rh3) || (vc >= rw4) ||
					(hc >= cw0 && hc < ch0) || (hc >= cw1 && hc < ch1) || (hc >= cw2 && hc < ch2) || 
					(hc >= cw3 && hc < ch3) || (hc >= cw4)
					) begin
			if ((level == 7'b0000110) || (level == 7'b0111111)) begin // level 0 or 1, healthy green
				red_bgrnd = 3'b001;
				green_bgrnd = 3'b100;
				blue_bgrnd = 2'b00;
			end
			else if (level == 7'b1011011) begin // level 2, light brown
				red_bgrnd = 3'b101;
				green_bgrnd = 3'b100;
				blue_bgrnd = 2'b01;
			end
			else if (level == 7'b1001111) begin // level 3, dark red
				red_bgrnd = 3'b011;
				green_bgrnd = 3'b000;
				blue_bgrnd = 2'b00;
			end
		end
		

/* ====================== M O L E   H O L E S ====================== */
		// row 0
		else if (vc >= rh0 && vc < rw1) begin
			mole_vc = vc - rh0;
			// hole (0,0)
			if (hc >= ch0 && hc < cw1) begin
				sel_mole_state = mole_states[31:30];
				mole_hc = hc - ch0;
			end // end hole (0,0)

			// hole (0,1)
			else if (hc >= ch1 && hc < cw2) begin
				sel_mole_state = mole_states[29:28];
				mole_hc = hc - ch1;
			end // end hole (0,1)

			// hole (0,2)
			else if (hc >= ch2 && hc < cw3) begin
				sel_mole_state = mole_states[27:26];
				mole_hc = hc - ch2;
			end // end hole (0,2)
			
			// hole (0,3)
			else if (hc >= ch3 && hc < cw4) begin
				sel_mole_state = mole_states[25:24];
				mole_hc = hc - ch3;
			end // end hole (0,3)
      
			else begin
			  red_bgrnd = 3'b111;
			  green_bgrnd = 3'b111;
			  blue_bgrnd = 2'b11;
			end
			
		end // end row 0 of holes


		// row 1
		else if (vc >= rh1 && vc < rw2) begin
			mole_vc = vc - rh1;
			// hole (1,0)
			if (hc >= ch0 && hc < cw1) begin
				sel_mole_state = mole_states[23:22];
				mole_hc = hc - ch0;
			end // end hole (1,0)
			
			// hole (1, 1)
			else if  (hc >= ch1 && hc < cw2) begin
				sel_mole_state = mole_states[21:20];
				mole_hc = hc - ch1;
			end // end hole (1,1)
			
			// hole (1, 2)
			else if (hc >= ch2 && hc < cw3) begin
				sel_mole_state = mole_states[19:18];
				mole_hc = hc - ch2;
			end // end hole (1,2)
			
			// hole (1, 3)
			else if (hc >= ch3 && hc < cw4) begin
				sel_mole_state = mole_states[17:16];
				mole_hc = hc - ch3;
			end // end hole (1,3)
      
			else begin
			  red_bgrnd = 3'b111;
			  green_bgrnd = 3'b111;
			  blue_bgrnd = 2'b11;
			end
			
		end // end row 1 of holes


		// row 2
		else if (vc >= rh2 && vc < rw3) begin
			mole_vc = vc - rh2;
			// hole (2, 0)
			if (hc >= ch0 && hc < cw1) begin
				sel_mole_state = mole_states[15:14];
				mole_hc = hc - ch0;
			end // end hole (2,0)

			// hole (2, 1)
			else if (hc >= ch1 && hc < cw2) begin
				sel_mole_state = mole_states[13:12];
				mole_hc = hc - ch1;
			end // end hole (2,1)
			
			// hole (2, 2)
			else if (hc >= ch2 && hc < cw3) begin
				sel_mole_state = mole_states[11:10];
				mole_hc = hc - ch2;
			end // end hole (2,2)
			
			// hole (2, 3)
			else if (hc >= ch3 && hc < cw4) begin
				sel_mole_state = mole_states[9:8];
				mole_hc = hc - ch3;
			end // end hole (2,3)
	
			else begin
			  red_bgrnd = 3'b111;
			  green_bgrnd = 3'b111;
			  blue_bgrnd = 2'b11;
			end
      
		end // end row 2 of holes
	
	
		// row 3
		else if (vc >= rh3 && vc < rw4) begin
			mole_vc = vc - rh3;
			// hole (3, 0)
			if (hc >= ch0 && hc < cw1) begin
				sel_mole_state = mole_states[7:6];
				mole_hc = hc - ch0;
			end // end hole (3,0)
			
			// hole (3, 1)
			else if (hc >= ch1 && hc < cw2) begin
				sel_mole_state = mole_states[5:4];
				mole_hc = hc - ch1;
			end // end hole (3,1)
			
			// hole (3, 2)
			else if (hc >= ch2 && hc < cw3) begin
				sel_mole_state = mole_states[3:2];
				mole_hc = hc - ch2;
			end // end hole (3,2)
			
			// hole (3, 3)
			else if (hc >= ch3 && hc < cw4) begin
				sel_mole_state = mole_states[1:0];
				mole_hc = hc - ch3;
			end // end hole (3,3)
      
			else begin
			  red_bgrnd = 3'b111;
			  green_bgrnd = 3'b111;
			  blue_bgrnd = 2'b11;
			end
			
		end // end row 3 of holes


	end // end of video range

	else begin // black border
		red_bgrnd = 0;
		green_bgrnd = 0;
		blue_bgrnd = 0;
	end
end


// process mole graphic
mole_vga_graphic mole_graphic (
	// inputs
			.mole_state		(sel_mole_state),
			.rn				(mole_vc),
			.cn				(mole_hc),
	// outputs
			.red				(red_mole),
			.green			(green_mole),
			.blue				(blue_mole) );

assign draw_bgrnd =  (vc >= 0 && vc < rh0) || (vc >= rw1 && vc < rh1) || (vc >= rw2 && vc < rh2) || 
							(vc >= rw3 && vc < rh3) || (vc >= rw4) ||
							(hc >= 0 && hc < ch0) || (hc >= cw1 && hc < ch1) || (hc >= cw2 && hc < ch2) || 
							(hc >= cw3 && hc < ch3) || (hc >= cw4);

assign red = (draw_bgrnd) ?  red_bgrnd : red_mole;
assign green = (draw_bgrnd) ? green_bgrnd : green_mole;
assign blue = (draw_bgrnd) ? blue_bgrnd : blue_mole;

endmodule
