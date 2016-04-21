`timescale 1 ps / 1 ps

module LT2323input(
//============Control Signals====================
	input RSTn,               //async reset
	input clk50,              //50MHz clk
	input readon,             //should we be reading?
//============LT2323-16 signals==================
	input [15:0] da,          //channel A
	input [15:0] db,          //channel B
	input cnvclk,             //rising edge indicates stable channel a/b
//============FT232H signals=====================
	input clk60,              //60MHz clk
	input rdreqout,           //Read from FIFO
	output [7:0] FRFPGA,      //8-bit FIFO output
	output rdemptyout         //FIFO is empty
);

	wire [31:0] dab;
	wire good;
	wire [7:0] q;
	wire wrreqout;
	wire wrfullout;
	
	latchDIN latch(RSTn, clk50, da, db, cnvclk, dab, good);
	ser32to8 ser(RSTn, clk50, dab, good, q, wrreqout, wrfullout, readon);
	USB_FIFO FPGAOUT(~RSTn, q, clk60, rdreqout, clk50, wrreqout, FRFPGA, rdemptyout, wrfullout);
	
endmodule
