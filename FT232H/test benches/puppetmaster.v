`timescale 1 ps / 1 ps

module puppetmaster(
	input RSTn,
	output reg clk50,
	output reg clk60,
	output reg [1:0] CMD,
	input [7:0] OE8,
	input [7:0] generatedCmds,
	input [7:0] rdusedwin,
	input [7:0] rdusedwout,
	input rdemptyin
);

	initial begin
		//play with CMD timings here
		clk50 = 0;
		clk60 = 0;
		CMD = 2'b00;
		#20000
		CMD = 2'b01;
		#600000
		CMD = 2'b00;
		#20000
		CMD = 2'b10;
		#100000
		CMD = 2'b00;
		#20000
		CMD = 2'b01;
	end
	
	always begin
		#10000 clk50 = (RSTn) ? ~clk50 : 1'b0;
	end
	
	always begin
		#8333 clk60 = (RSTn) ? ~clk60 : 1'b0;
	end
endmodule
