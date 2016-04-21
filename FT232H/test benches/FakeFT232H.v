`timescale 1 ps / 1 ps

module FakeFT232H(
	output [7:0] FRPC,
	output reg RXFn,
	output reg TXEn,
	input CLK60, //technically an output, but for faking it we don't care
	input RDn,
	input WRn,
	input OEn,
	input [7:0] TOPC //in theory, FRPC and TOPC should be all one inout, but we have a bidirectional buffer for that
);
	reg [3:0] wrcount;
	reg [7:0] rdcount;
	reg [7:0] data;
	wire rxf;
	wire txe;
	reg rxfnotempty;
	reg oe;
	initial begin
		wrcount = 7;
		rdcount = 7;
		data = 8'h00;
		oe = 0;
		#180000
		rdcount = 255;
		#600000
		wrcount = 0;
	end
	
	assign FRPC = (oe & ~OEn) ? data : 8'bz;
	assign txe = wrcount < 15;
	assign rxf = (|rdcount) | (|data);
	
	always @(posedge CLK60) begin
		oe <= ~OEn;
		RXFn <= ~rxf;
		TXEn <= ~txe;
		data <= rdcount;
	end
	
	always @(negedge CLK60) begin
		if (((~OEn & ~RDn) & rxf) & (rdcount == data)) begin
			rdcount <= rdcount - 1;
		end
		if (~WRn & txe) begin
			wrcount <= wrcount + 1;
		end
	end
endmodule 