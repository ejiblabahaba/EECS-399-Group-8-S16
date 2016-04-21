`timescale 1 ps / 1 ps

module CLK60GEN(output reg CLK60);
	initial begin
		CLK60 = 0;
	end
	always begin
		#8333 CLK60 = ~CLK60;
	end
endmodule
