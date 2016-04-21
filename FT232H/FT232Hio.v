`timescale 1 ps / 1 ps

module FT232Hio(
//=================command inputs================
	input RSTn,
	input clk50,
	input [1:0] CMD,
//=================LT2323 inputs=================
	input [7:0] TOPC,
	input rdemptyin,
//=================AD9837 inputs=================
	input rdreqin,
	input rdemptyout,
//=================FT232H signals================
	input clk60,
	input RXFn,
	input TXEn,
	inout [7:0] FTBUS,
	output OEn,
	output RDn,
	output WRn,
//=================command outputs===============
	output [7:0] generatedCmds,
	output rdreqout
);

	wire [7:0] OE8;
	wire [7:0] FRPC;
	wire wrreqin;
	wire wrfullin;
	
	FT232H_Interface2 FT232H(RSTn, CMD, rdemptyout, wrfullin, clk60, RXFn, TXEn, OEn, RDn, WRn, rdreqout, wrreqin, OE8);
	iobuf io(TOPC, OE8, FTBUS, FRPC);
	USB_FIFO FPGAIN(~RSTn, FRPC, clk50, rdreqin, ~clk60, wrreqin, generatedCmds, rdemptyin, wrfullin);

endmodule
