`timescale 1 ps / 1 ps

module tbUSBtoWRFULL(needed);
	output needed;

	wire RSTn;
	wire clk50, clk60;
	wire rdreqin, rdreqout, wrreqin;
	wire rdemptyin, wrfullin, rdemptyout;
	wire RXFn, TXEn, OEn, RDn, WRn;
	wire [7:0] generatedCmds;
	wire [7:0] rdusedwin, rdusedwout;
	wire [7:0] TOPC, FRPC;
	wire [7:0] OE8;
	wire [1:0] CMD;
	
	reg resetn;
	reg RRQIN;
	
	assign rdreqin = RRQIN;
	assign RSTn = resetn;
	assign needed = rdemptyin;
	assign rdemptyout = 1;
	assign TOPC = 0;
	
	USB_FIFO FPGAIN(~RSTn, FRPC, clk50, rdreqin, ~clk60, wrreqin, generatedCmds, rdemptyin, rdusedwin, wrfullin);    //to FPGA
	FT232H_Interface2 fti(RSTn, CMD, rdemptyout, wrfullin, clk60, RXFn, TXEn, OEn, RDn, WRn, rdreqout, wrreqin, OE8);
	FakeFT232H FT232H(FRPC, RXFn, TXEn, clk60, RDn, WRn, OEn, TOPC);
	puppetmaster pm(RSTn, clk50, clk60, CMD, OE8, generatedCmds, rdusedwin, rdusedwout, rdemptyin);

	initial begin
		resetn = 0;
		RRQIN = 0;
		#5000
		resetn = 1;
		#4500000
		RRQIN = 1;
	end
	
endmodule
