`timescale 1 ps / 1 ps

module tbADCtoUSB(needed);
	output needed;

	wire RSTn;
	wire clk50, clk60;
	wire rdreqin, rdreqout, wrreqin, wrreqout;
	wire rdemptyin, wrfullin, rdemptyout, wrfullout;
	wire RXFn, TXEn, OEn, RDn, WRn;
	wire cnvclk, good;
	wire [31:0] dabLatched;
	wire [15:0] da, db;
	wire [7:0] generatedData, generatedCmds;
	wire [7:0] rdusedwin, rdusedwout;
	wire [7:0] TOFPGA, FRFPGA;
	wire [7:0] TOPC, FRPC;
	wire [7:0] interface;
	wire [7:0] OE8;
	wire [1:0] CMD;
	reg resetn;
	reg RRQIN;
	assign rdreqin = RRQIN;
	assign RSTn = resetn;
	assign needed = rdemptyin;
	USB_FIFO FPGAOUT(~RSTn, generatedData, clk60, rdreqout, clk50, wrreqout, FRFPGA, rdemptyout, rdusedwout, wrfullout);//to USB
	USB_FIFO FPGAIN(~RSTn, TOFPGA, clk50, rdreqin, ~clk60, wrreqin, generatedCmds, rdemptyin, rdusedwin, wrfullin);    //to FPGA
	FT232H_Interface2 fti(RSTn, CMD, rdemptyout, wrfullin, clk60, RXFn, TXEn, OEn, RDn, WRn, rdreqout, wrreqin, OE8);
	iobuf iobFPGAside(FRFPGA, OE8, interface, TOFPGA);
	iobuf iobUSBside(FRPC, {8{~OEn}}, interface, TOPC);
	FakeFT232H FT232H(FRPC, RXFn, TXEn, clk60, RDn, WRn, OEn, TOPC);
	fakeADCinput LT2323(RSTn, da, db, cnvclk);
	latchDIN latch(RSTn, clk50, da, db, cnvclk, dabLatched, good);
	ser32to8 ser(RSTn, clk50, dabLatched, good, generatedData, wrreqout, wrfullout, 1'b1);
	puppetmaster pm(RSTn, clk50, clk60, CMD, OE8, generatedCmds, rdusedwin, rdusedwout, rdemptyin);

	initial begin
		resetn = 0;
		RRQIN = 0;
		#5000
		resetn = 1;
		#700000
		RRQIN = 1;
	end
	
endmodule
