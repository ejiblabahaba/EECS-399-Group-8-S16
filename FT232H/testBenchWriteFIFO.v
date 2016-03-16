`timescale 1 ps / 1 ps

module testBenchWriteFIFO;
	
	wire wrclk, rst_n, wrfull, wrreq, rdreq, rdclk, rdempty, txe_n, rxf_n, oe_n, rd_n, wr_n;
	wire [7:0] data;
	wire [7:0] q;
	wire [7:0] rdusedw;
	wire [7:0] toFIFO;
	
	assign rd_n = 1;
	assign oe_n = 1;
	
	USB_FIFO usbfifo(~rst_n, data, rdclk, rdreq, wrclk, wrreq, q, rdempty, rdusedw, wrfull);
	helloWorld hw(wrclk, rst_n, wrfull, wrreq, data);
	FIFOtoFT232H f2f(q, rdclk, rst_n, rdempty, rdusedw, txe_n, oe_n, toFIFO, wr_n, rdreq);
	pretendFT232H pf(toFIFO, rxf_n, txe_n, rdclk, rd_n, wr_n, oe_n);
	tickleWriteFIFO tw(wrclk, rst_n);

endmodule
