module tickle_AD9837_ctrl(
	input busy,
	input enable,
	input cont,
	input sclk,
	input ss_n,
	input mosi,
	input [15:0] tx_data,
	input [15:0] CMD,
	output reg clk, reset, fwrq, fws, fsel, soft_reset, sleep1, sleep12, opbiten, div2, mode,
	output reg [27:0] FCODE
);

	initial begin
		clk = 0;
		reset = 1;
		fwrq = 0;
		fws = 0;
		fsel = 0;
		soft_reset = 0;
		sleep1 = 0;
		sleep12 = 0;
		opbiten = 0;
		div2 = 0;
		mode = 0;
		FCODE = 28'd100;
		
		#1000 reset = 0;
		#5000 reset = 1;
		#700000
		FCODE = 28'h000_8312;
		fwrq = 1;
		#20000
		fwrq = 0;
//		#10000
//		FCODE = 28'hFFF_FFFF;
//		#120000
//		FCODE = 28'd10_000;
//		#240000
//		fsel = 1;
//		#504000
//		soft_reset = 1;
		
	end
	
	always begin
		#1000 clk = ~clk;
	end
endmodule
