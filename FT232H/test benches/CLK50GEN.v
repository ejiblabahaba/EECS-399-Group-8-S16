`timescale 1 ps / 1 ps

module CLK50GEN(output reg CLK50);
	initial begin
		CLK50 = 0;
	end
	always begin
		#10000 CLK50 = ~CLK50;
	end
endmodule
