`timescale 1 ps / 1 ps
//SIWUn is just confusing matters, that's someone else's responsibility
module FT232H_Interface2(
	input RSTn,
	input [1:0] CMD,       //00: idle, 01: USB -> FPGA, 10: FPGA -> USB, 11: toggle SIWU
	input rdempty,         //FPGA data FIFO empty?
	input wrfull,          //FPGA cmd FIFO full?
	input clk,             //60MHz

	input RXFn,            //USB -> FPGA rd buffer not full
	input TXEn,            //FPGA -> USB wr buffer not empty
	
	output reg OEn,        //USB Output Enable
	output reg RDn,        //USB -> FPGA
	output reg WRn,        //FPGA -> USB
	
	output rdreqout,       //FPGA -> USB
	output wrreqin,        //USB -> FPGA
	output reg [7:0] OE8   //FPGA Output Onable
);

	wire RD, OEn1, RDn1, WR, OE81, WRn1;
	
	reg dataWasRead = 1;   //this bullshit is necessary to prevent a byte going missing due to TXEn

	assign RD = CMD[0] & ~CMD[1] & WRn;
	assign OEn1 = RD & (OE8 == 8'h00);
	assign RDn1 = RD & (~OEn & (~RXFn & ~wrfull));
	assign wrreqin = ~RDn & ~RXFn; //USB -> FPGA
	
	assign WR = CMD[1] & ~CMD[0] & RDn;
	assign OE81 = WR & OEn;
	assign WRn1 = OE81 & (~rdempty & ~TXEn);
	assign rdreqout = WRn1 & dataWasRead;
	
	initial begin
		OEn <= 1;
		RDn <= 1;
		WRn <= 1;
		OE8 <= 8'b0;
	end

	always @(negedge RSTn, posedge clk) begin
		if (~RSTn) begin
			OEn <= 1;
			RDn <= 1;
			WRn <= 1;
			OE8 <= 8'b0;
		end else if (clk) begin
			OEn <= ~OEn1;
			RDn <= ~RDn1;
			OE8 <= {8{OE81}};
			WRn <= ~WRn1;
		end
	end
	
	always @(negedge RSTn, negedge clk) begin //FPGA -> USB
		if (~RSTn) begin
			dataWasRead <= 1;
		end else begin
			if (~WRn) begin
				dataWasRead <= ~TXEn & ~WRn;
			end
		end
	end
endmodule 