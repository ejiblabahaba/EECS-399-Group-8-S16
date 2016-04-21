`timescale 1 ps / 1 ps

module testBenchInterface(needed);
	output needed;

	wire RSTn;
	wire clk50, clk60;
	wire rdreqin, rdreqout, wrreqin, wrreqout;
	wire rdemptyin, wrfullin, rdemptyout, wrfullout;
	wire RXFn, TXEn, OEn, RDn, WRn;
	wire [7:0] generatedData, generatedCmds;
	wire [7:0] rdusedwin, rdusedwout;
	wire [7:0] TOPC, FRPC;
	wire [7:0] OE8;
	wire [1:0] CMD;
	reg resetn;
	reg RRQIN;
	assign rdreqin = RRQIN;
	assign RSTn = resetn;
	assign needed = rdemptyin;
	USB_FIFO FPGAOUT(~RSTn, generatedData, clk60, rdreqout, clk50, wrreqout, TOPC, rdemptyout, rdusedwout, wrfullout);//to USB
	USB_FIFO FPGAIN(~RSTn, FRPC, clk50, rdreqin, ~clk60, wrreqin, generatedCmds, rdemptyin, rdusedwin, wrfullin);    //to FPGA
	FT232H_Interface2 fti(RSTn, CMD, rdemptyout, wrfullin, clk60, RXFn, TXEn, OEn, RDn, WRn, rdreqout, wrreqin, OE8);
	FakeFT232H FT232H(FRPC, RXFn, TXEn, clk60, RDn, WRn, OEn, TOPC);
	helloWorld FPGA(RSTn, clk50, wrfullout, wrreqout, generatedData);
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
