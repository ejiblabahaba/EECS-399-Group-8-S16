`timescale 1 ps / 1 ps

module latchDIN(
	input RSTn,                         //async reset active low
	input clk50,                        //internal clock
	input [15:0] da,                    //channel a, 5MHz update rate
	input [15:0] db,                    //channel b, 5MHz update rate
	input cnvclk,                       //posedge means A and B are stable
	output [31:0] dabLatched,           //latched to avoid glitches
	output good                         //if good, dabLatched is valid
);
	reg syncA, syncB;                   //synchronize da and db with our 50MHz frame
	reg [31:0] din;                     //synchronization buffer
	
	assign good = cnvclk & (syncA & syncB);
	assign dabLatched[31:0] = din[31:0];
	
	initial begin
		syncA = 0;
		syncB = 0;
		din = 32'b0;
	end
	//latch din on every cnvclk
	always @(negedge RSTn, posedge good) begin
		if (~RSTn) begin
			din <= 32'b0;
		end else begin
			din[15:0] <= da[15:0];
			din[31:16] <= db[15:0];
		end
	end
	
	//Make sure din is good
	always @(negedge RSTn, posedge clk50) begin
		if (~RSTn) begin
			syncA <= 0;
			syncB <= 0;
		end else begin
			syncA <= cnvclk;
			syncB <= syncA;
		end
	end
endmodule 