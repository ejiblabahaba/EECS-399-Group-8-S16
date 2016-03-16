`timescale 1 ps / 1 ps

module FIFOtoFT232H(
	input [7:0] q,
	input rdclk,
	input rst_n,
	input rdempty,
	input [7:0] rdusedw,
	input txe_n,
	input oe_n,
	output reg [7:0] toFIFO,
	output reg wr_n,
	output reg rdreq
);

	reg dequeue = 0;
	initial begin
		toFIFO = 8'bZ;
		wr_n = 1;
		rdreq = 0;
	end
	
	always @(negedge rst_n, negedge rdclk) begin
		if (~rst_n) begin
			dequeue <= 0;
			rdreq <= 0;
			toFIFO <= 8'bZ;
			wr_n <= 1;
		end else begin
			if (~dequeue) begin
				if (rdusedw == 13) begin
					dequeue <= 1;
					rdreq <= 1;
					toFIFO <= 8'bZ;
					wr_n <= 1;
				end else begin
					dequeue <= 0;
					rdreq <= 0;
					toFIFO <= 8'bZ;
					wr_n <= 1;
				end
			end else begin
				if (rdempty) begin
					dequeue <= 0;
					rdreq <= 0;
					toFIFO <= q;
					wr_n <= 0;
				end else if (txe_n | ~oe_n) begin
					dequeue <= 1;
					rdreq <= 0;
					toFIFO <= 8'bZ;
					wr_n <= 1;
				end else begin
					dequeue <= 1;
					rdreq <= 1;
					toFIFO <= q;
					wr_n <= 0;
				end
			end
		end
	end
endmodule
