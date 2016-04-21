`timescale 1 ps / 1 ps

module tickleWriteFIFO( 
	output reg wrclk, 
	output reg rst_n
);

	initial begin
		wrclk = 0;
		rst_n = 0;
		#5000 rst_n = 1;
	end

	always begin
		#10000 wrclk = ~wrclk;
	end
endmodule
