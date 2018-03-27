`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date:    10:38:28 03/06/2018 
// Design Name: 
// Module Name:    LFSR_10 
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
module LFSR_10(
  input clk,
  input rst_n,

  output wire [15:0] mole_location
);

reg [4:0] data;
reg [4:0] data_next;
wire [3:0] temp;

always @* begin
  data_next[4] = data[4]^data_next[1];
  data_next[3] = data[3]^data_next[0];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge clk or negedge rst_n)
	begin
  if(!rst_n)
    data <= 5'h31f;
  else
    data <= data_next;
	 
	end

assign temp = data % 16;
assign mole_location =(temp == 0) ? 16'b0000000000000001 :
							 (temp == 1) ? 16'b0000000000000010 :
							 (temp == 2) ? 16'b0000000000000100 :
							 (temp == 3) ? 16'b0000000000001000 :
							 (temp == 4) ? 16'b0000000000010000 :
							 (temp == 5) ? 16'b0000000000100000 :
							 (temp == 6) ? 16'b0000000001000000 :
							 (temp == 7) ? 16'b0000000010000000 :
							 (temp == 8) ? 16'b0000000100000000 :
							 (temp == 9) ? 16'b0000001000000000 :
							 (temp == 10) ? 16'b0000010000000000 :
							 (temp == 11) ? 16'b0000100000000000 :
							 (temp == 12) ? 16'b0001000000000000 :
							 (temp == 13) ? 16'b0010000000000000 :
							 (temp == 14) ? 16'b0100000000000000 :
							 (temp == 15) ? 16'b1000000000000000 : 16'b1111111111111111;

endmodule
