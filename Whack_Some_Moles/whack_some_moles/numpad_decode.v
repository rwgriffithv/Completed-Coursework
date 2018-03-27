`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:35 02/27/2018 
// Design Name: 
// Module Name:    numpad_decode 
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

//Source: We referred to the PmodKYPD Demo here:
//https://reference.digilentinc.com/reference/pmod/pmodkypd/start

module numpad_decode(clk, Rows, Cols, decoded_row, decoded_col);

input clk; //100 MHz master clock
input [3:0] Rows; //Row array for numpad
output reg [3:0] Cols; //Col array for numpad

//Together, these two items will represent a coordinate pair for our grid
output reg [1:0] decoded_row; //Which row was pressed
output reg [1:0] decoded_col; //Which col was pressed

// Count register
reg [19:0] sclk;

// ==============================================================================================
// 												Implementation
// ==============================================================================================

always @(posedge clk) begin

	// 1ms
	if (sclk == 20'b00011000011010100000) begin
		//C1
		Cols <= 4'b0111;
		sclk <= sclk + 1'b1;
	end
	
	// check row pins
	else if(sclk == 20'b00011000011010101000) begin
		//R1
		if (Rows == 4'b0111) begin
			//1 was pressed
			decoded_row <= 0;
			decoded_col <= 0;
		end
		//R2
		else if(Rows == 4'b1011) begin
			//4 was pressed
			decoded_row <= 1;
			decoded_col <= 0;
		end
		//R3
		else if(Rows == 4'b1101) begin
			//7 was pressed
			decoded_row <= 2;
			decoded_col <= 0;
		end
		//R4
		else if(Rows == 4'b1110) begin
			//0 was pressed
			decoded_row <= 3;
			decoded_col <= 0;
		end
		sclk <= sclk + 1'b1;
	end

	// 2ms
	else if(sclk == 20'b00110000110101000000) begin
		//C2
		Cols<= 4'b1011;
		sclk <= sclk + 1'b1;
	end
	
	// check row pins
	else if(sclk == 20'b00110000110101001000) begin
		//R1
		if (Rows == 4'b0111) begin
			//2 was pressed
			decoded_row <= 0;
			decoded_col <= 1;
		end
		//R2
		else if(Rows == 4'b1011) begin
			//5 was pressed
			decoded_row <= 1;
			decoded_col <= 1;
		end
		//R3
		else if(Rows == 4'b1101) begin
			//8 was pressed
			decoded_row <= 2;
			decoded_col <= 1;
		end
		//R4
		else if(Rows == 4'b1110) begin
			//F was pressed
			decoded_row <= 3;
			decoded_col <= 1;
		end
		sclk <= sclk + 1'b1;
	end

	//3ms
	else if(sclk == 20'b01001001001111100000) begin
		//C3
		Cols <= 4'b1101;
		sclk <= sclk + 1'b1;
	end
	
	// check row pins
	else if(sclk == 20'b01001001001111101000) begin
		//R1
		if(Rows == 4'b0111) begin
			//3 was pressed
			decoded_row <= 0;
			decoded_col <= 2;	
		end
		//R2
		else if(Rows == 4'b1011) begin
			//6 was pressed
			decoded_row <= 1;
			decoded_col <= 2;
		end
		//R3
		else if(Rows == 4'b1101) begin
			//9 was pressed
			decoded_row <= 2;
			decoded_col <= 2;
		end
		//R4
		else if(Rows == 4'b1110) begin
			//E was pressed
			decoded_row <= 3;
			decoded_col <= 2;
		end

		sclk <= sclk + 1'b1;
	end

	//4ms
	else if(sclk == 20'b01100001101010000000) begin
		//C4
		Cols <= 4'b1110;
		sclk <= sclk + 1'b1;
	end

	// Check row pins
	else if(sclk == 20'b01100001101010001000) begin
		//R1
		if(Rows == 4'b0111) begin
			//A was pressed
			decoded_row <= 0;
			decoded_col <= 3;
		end
		//R2
		else if(Rows == 4'b1011) begin
			//B was pressed
			decoded_row <= 1;
			decoded_col <= 3;
		end
		//R3
		else if(Rows == 4'b1101) begin
			//C was pressed
			decoded_row <= 2;
			decoded_col <= 3;
		end
		//R4
		else if(Rows == 4'b1110) begin
			//D was pressed
			decoded_row <= 3;
			decoded_col <= 3;
		end
		sclk <= 20'b00000000000000000000;
	end

	// Otherwise increment
	else begin
		sclk <= sclk + 1'b1;
	end
		
end
endmodule
