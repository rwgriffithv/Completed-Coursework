`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 		 Robert Griffith
// 
// Create Date:    13:28:07 03/02/2018 
// Design Name: 
// Module Name:    mole_vga_graphic 
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
module mole_vga_graphic(
	// inputs
	mole_state, rn, cn,
	// outputs
	red, green, blue );

input wire [1:0] mole_state;
input wire [9:0] rn; // row number relative to origin of mole graphic, (0,0) at top left
input wire [9:0] cn; // column number relative to origin of mole graphic
output reg [2:0] red;
output reg [2:0] green;
output reg [1:0] blue;

// mole drawing parameters relative to hole
// 90x90 pixel mole
// state 0: empty hole = all black
// state 1: mole coming out:
parameter s1_mole_LTE = 24; // left and top edge distance [0, 24) is black vertically and horizontally
parameter s1_mole_RBE = 66; // right and bottom edge distance [66, 90) is black vert and horiz
parameter s1_indent = 2; // four squares make indents at the corners of the mole
parameter s1_eye_TE = 35; // tope edge
parameter s1_eye_BE = 39; // bottom edge
parameter s1_eye_width = 10;
parameter s1_left_eye_LE = 27; // left edge [27, 27 + 10) is left eye horizontal region 
parameter s1_right_eye_LE = 53;
parameter s1_whisker_width = 5; // uniform whisker width
parameter s1_whisker_T_TE = 46; // whisker height is 1
parameter s1_whisker_LT_LE= 32; // left top whisker
parameter s1_whisker_RT_LE = 53;
parameter s1_whisker_M_TE = 49;
parameter s1_whisker_LM_LE = 30; // left middle whisker
parameter s1_whisker_RM_LE = 55;
parameter s1_whisker_B_TE = 52;
parameter s1_whisker_LB_LE = 31; // left bottom whisker
parameter s1_whisker_RB_LE = 54;
parameter s1_nose_LE = 39;
parameter s1_nose_RE = 51;
parameter s1_nose_TE = 48;
parameter s1_nose_BE = 55;

// state 2: mole out:
parameter s2_mole_LTE = 4; 
parameter s2_mole_RBE = 86;
parameter s2_indent = 6;
parameter s2_eye_TE = 23;
parameter s2_eye_BE = 31;
parameter s2_eye_width = 20;
parameter s2_left_eye_LE = 11; 
parameter s2_right_eye_LE = 59;
parameter s2_whisker_TM_width = 10; // width of top and middle whiskers
parameter s2_whisker_T_TE = 44; // whisker height is 1
parameter s2_whisker_LT_LE= 21;
parameter s2_whisker_RT_LE = 59;
parameter s2_whisker_M_TE = 51;
parameter s2_whisker_LM_LE = 18;
parameter s2_whisker_RM_LE = 62;
parameter s2_whisker_B_width = 8; // width of bottom whiskers
parameter s2_whisker_B_TE = 56;
parameter s2_whisker_LB_LE = 22;
parameter s2_whisker_RB_LE = 60;
parameter s2_nose_LE = 34;
parameter s2_nose_RE = 56;
parameter s2_nose_TE = 47;
parameter s2_nose_BE = 61;

// state 3: injured mole:
// only changes are colors and eyes
parameter s3_left_eye_TE = 17;
parameter s3_left_eye_BE = 35;
parameter s3_left_eye_LE = 11;
parameter s3_left_eye_RE = 37;
parameter s3_right_eye_TE = 21;
parameter s3_right_eye_BE = 33;
parameter s3_right_eye_LE = 57;
parameter s3_right_eye_RE = 79;
parameter s3_pupil_TE = 23; // black pupil within white eye
parameter s3_pupil_BE = 31;
parameter s3_pupil_width = 6;
parameter s3_left_pupil_LE = 14;
parameter s3_right_pupil_LE = 70;


always @(rn or cn) begin
	if (rn < 90 && cn < 90)
		case (mole_state)
		
	/* ================= S T A T E   0 ================= */
			2'b00: begin
				red = 0;
				green = 0;
				blue = 0;
			end // end case 0
			
	/* ================= S T A T E   1 ================= */
			2'b01: begin
				if ((cn >= s1_mole_LTE) && (cn < s1_mole_RBE) &&
					 (rn >= s1_mole_LTE) && (rn < s1_mole_RBE) )
				begin
					// black: corners and eyes
					if ( 
						  // mole indentation at corners
						  (cn < (s1_mole_LTE+s1_indent) && (rn < (s1_mole_LTE+s1_indent) || rn >= (s1_mole_RBE-s1_indent))) || 
						  (cn >= (s1_mole_RBE-s1_indent) && (rn < (s1_mole_LTE+s1_indent) || rn >= (s1_mole_RBE-s1_indent))) ||
						  // mole eyes
						  (rn >= (s1_eye_TE) && rn < (s1_eye_BE) && ( (cn >= (s1_left_eye_LE) && cn < (s1_left_eye_LE+s1_eye_width)) ||
																					  (cn >= (s1_right_eye_LE) && cn < (s1_right_eye_LE+s1_eye_width)) ))
						)
					begin
						red = 0;
						green = 0;
						blue = 0;
					end // end corners and eyes

					// white: whiskers
					else 
					if (
						// top row of whiskers
						(rn == (s1_whisker_T_TE) && ( (cn >= (s1_whisker_LT_LE) && cn < (s1_whisker_LT_LE+s1_whisker_width)) || 
																(cn >= (s1_whisker_RT_LE) && cn < (s1_whisker_RT_LE+s1_whisker_width)) )) ||
						// middle row of whiskers
						(rn == (s1_whisker_M_TE) && ( (cn >= (s1_whisker_LM_LE) && cn < (s1_whisker_LM_LE+s1_whisker_width)) || 
																(cn >= (s1_whisker_RM_LE) && cn < (s1_whisker_RM_LE+s1_whisker_width)) )) ||
						// bottom row of whiskers
						(rn == (s1_whisker_B_TE) && ( (cn >= (s1_whisker_LB_LE) && cn < (s1_whisker_LB_LE+s1_whisker_width)) || 
																(cn >= (s1_whisker_RB_LE) && cn < (s1_whisker_RB_LE+s1_whisker_width)) ))
						)
					begin
						red = 3'b111;
						green = 3'b111;
						blue = 2'b11;
					end // end whiskers

					// pinkish: nose
					else if (rn >= (s1_nose_TE) && rn < (s1_nose_BE) && cn >= (s1_nose_LE) && cn < (s1_nose_RE)) begin
						red = 3'b110;
						green = 3'b100;
						blue = 2'b10;
					end // end nose
					
					// brown: mole face
					else begin
						red = 3'b011;
						green = 3'b010;
						blue = 2'b00;
					end // end face

				end // end mole
				// black hole around mole
				else begin
					red = 0;
					green = 0;
					blue = 0;
				end
				
			end // end state 1
			
	/* ================= S T A T E   2 ================= */
			2'b10: begin
				// if within mole and not black space of hole
				if ((cn >= s2_mole_LTE) && (cn < s2_mole_RBE) &&
					 (rn >= s2_mole_LTE) && (rn < s2_mole_RBE) )
				begin
					// black: corners and eyes
					if ( 
						// mole indentation at corners
						(cn < (s2_mole_LTE+s2_indent) && (rn < (s2_mole_LTE+s2_indent) || rn >= (s2_mole_RBE-s2_indent))) || 
						(cn >= (s2_mole_RBE-s2_indent) && (rn < (s2_mole_LTE+s2_indent) || rn >= (s2_mole_RBE-s2_indent))) ||
						// mole eyes
						(rn >= (s2_eye_TE) && rn < (s2_eye_BE) && ( (cn >= (s2_left_eye_LE) && cn < (s2_left_eye_LE+s2_eye_width)) ||
																				  (cn >= (s2_right_eye_LE) && cn < (s2_right_eye_LE+s2_eye_width)) ))
						)
					begin
						red = 0;
						green = 0;
						blue = 0;
					end // end corners and eyes

					// white: whiskers
					else 
					if ( 
						// top row of whiskers
						(rn == (s2_whisker_T_TE) && ( (cn >= (s2_whisker_LT_LE) && cn < (s2_whisker_LT_LE+s2_whisker_TM_width)) || 
																(cn >= (s2_whisker_RT_LE) && cn < (s2_whisker_RT_LE+s2_whisker_TM_width)) )) ||
						// middle row of whiskers
						(rn == (s2_whisker_M_TE) && ( (cn >= (s2_whisker_LM_LE) && cn < (s2_whisker_LM_LE+s2_whisker_TM_width)) || 
																(cn >= (s2_whisker_RM_LE) && cn < (s2_whisker_RM_LE+s2_whisker_TM_width)) )) ||
						// bottom row of whiskers
						(rn == (s2_whisker_B_TE) && ( (cn >= (s2_whisker_LB_LE) && cn < (s2_whisker_LB_LE+s2_whisker_B_width)) || 
																(cn >= (s2_whisker_RB_LE) && cn < (s2_whisker_RB_LE+s2_whisker_B_width)) ))
						)
					begin
						red = 3'b111;
						green = 3'b111;
						blue = 2'b11;
					end // end whiskers

					// pinkish: nose
					else if (rn >= (s2_nose_TE) && rn < (s2_nose_BE) && cn >= (s2_nose_LE) && cn < (s2_nose_RE)) begin
						red = 3'b110;
						green = 3'b100;
						blue = 2'b10;
					end // end nose
					
					// brown: mole face
					else begin
						red = 3'b011;
						green = 3'b010;
						blue = 2'b00;
					end // end face

				end // end mole
				// black hole around mole
				else begin
					red = 0;
					green = 0;
					blue = 0;
				end

			end // end state 2
			
	/* ================= S T A T E   3 ================= */
			2'b11: begin
				// if within mole and not black space of hole
				if ((cn >= s2_mole_LTE) && (cn < s2_mole_RBE) &&
					 (rn >= s2_mole_LTE) && (rn < s2_mole_RBE) )
				begin
					// black: corners and pupils
					if ( 
						// mole indentation at corners
						(cn < (s2_mole_LTE+s2_indent) && (rn < (s2_mole_LTE+s2_indent) || rn >= (s2_mole_RBE-s2_indent))) || 
						(cn >= (s2_mole_RBE-s2_indent) &&(rn < (s2_mole_LTE+s2_indent) || rn >= (s2_mole_RBE-s2_indent))) ||
						// mole pupils
						(rn >= (s3_pupil_TE) && rn < (s3_pupil_BE) && ( (cn >= (s3_left_pupil_LE) && cn < (s3_left_pupil_LE+s3_pupil_width)) ||
																						(cn >= (s3_right_pupil_LE) && cn < (s3_right_pupil_LE+s3_pupil_width)) ))
					)
					begin
						red = 0;
						green = 0;
						blue = 0;
					end // end corners and pupils

					// white: whiskers and whites of eyes
					else 
					if ( 
						// top row of whiskers
						(rn == (s2_whisker_T_TE) && ( (cn >= (s2_whisker_LT_LE) && cn < (s2_whisker_LT_LE+s2_whisker_TM_width)) || 
																(cn >= (s2_whisker_RT_LE) && cn < (s2_whisker_RT_LE+s2_whisker_TM_width)) )) ||
						// middle row of whiskers
						(rn == (s2_whisker_M_TE) && ( (cn >= (s2_whisker_LM_LE) && cn < (s2_whisker_LM_LE+s2_whisker_TM_width)) || 
																(cn >= (s2_whisker_RM_LE) && cn < (s2_whisker_RM_LE+s2_whisker_TM_width)) )) ||
						// bottom row of whiskers
						(rn == (s2_whisker_B_TE) && ( (cn >= (s2_whisker_LB_LE) && cn < (s2_whisker_LB_LE+s2_whisker_B_width)) || 
																(cn >= (s2_whisker_RB_LE) && cn < (s2_whisker_RB_LE+s2_whisker_B_width)) )) ||
						// white of left eye
						(rn >= (s3_left_eye_TE) && rn < (s3_left_eye_BE) && cn >= (s3_left_eye_LE) && cn < (s3_left_eye_RE) ) ||
						// white of right eye
						(rn >= (s3_right_eye_TE) && rn < (s3_right_eye_BE) && cn >= (s3_right_eye_LE) && cn < (s3_right_eye_RE) )
						)
					begin
						red = 3'b111;
						green = 3'b111;
						blue = 2'b11;
					end // end whiskers and whites of eyes

					// redish-pinkish: nose
					else if (rn >= (s2_nose_TE) && rn < (s2_nose_BE) && cn >= (s2_nose_LE) && cn < (s2_nose_RE)) begin
						red = 3'b110;
						green = 3'b010;
						blue = 2'b01;
					end // end nose
					
					// redish-brown: mole face
					else begin
						red = 3'b011;
						green = 3'b001;
						blue = 2'b00;
					end // end face

				end // end mole
				// black hole around mole
				else begin
					red = 0;
					green = 0;
					blue = 0;
				end

			end // end state 3

		endcase
	
	// outside of mole, shouldn't happen but setting rgb to blue leaves no possibilities undefined
	// and dead pixels make it easy to notice an error
	else begin
		red = 0;
		green = 0;
		blue = 2'b11;
	end
	
end // end always

endmodule
