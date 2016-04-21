`timescale 1 ps / 1 ps

module fakeADCinput(
	input RSTn,
	output [15:0] da,
	output [15:0] db,
	output reg cnvclk
);

	reg [15:0] counter = 0;             //data source
	
	assign da = counter;
	assign db = ~counter;
	
	initial begin
		cnvclk = 0;
	end
	
	always @(negedge RSTn, posedge cnvclk) begin
		if (~RSTn) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	
	always begin
		#47059  cnvclk = 1;
		#150588 cnvclk = 0;
	end
endmodule
