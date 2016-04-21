`timescale 1 ps / 1 ps

module testBench_fakeADCinput(
	output [7:0] q,
	output wrreqout
);

	wire [15:0] da, db;
	wire [31:0] dabLatched;
	wire cnvclk, clk50, good;
	
	reg wrfullout = 0;
	reg RSTn = 1;
	
	initial begin
		#5000 RSTn = 0;
		#5000 RSTn = 1;
		#490000 wrfullout = 1;
		#250000 wrfullout = 0;
	end
	
	fakeADCinput faaaake(RSTn, da, db, cnvclk);
	latchDIN latch(RSTn, clk50, da, db, cnvclk, dabLatched, good);
	CLK50GEN clk(clk50);
	ser32to8 WOMP(RSTn, clk50, dabLatched, good, q, wrreqout, wrfullout, 1'b1);
	
endmodule
