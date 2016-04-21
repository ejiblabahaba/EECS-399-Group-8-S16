`timescale 1 ps / 1 ps

module pretendFT232H(
	inout [7:0] ADBUS,
	output reg rxf_n,
	output reg txe_n,
	output reg clkout,
	input rd_n,
	input wr_n,
	input oe_n
);

	assign ADBUS = oe_n ? 8'bZ : 8'hFF;
	initial begin
		rxf_n = 1;
		txe_n = 0;
		clkout = 0;
		#475000 txe_n = 1;
		#50000 txe_n = 0;
	end
	
	always begin
		#8333 clkout = ~clkout;
	end
endmodule
