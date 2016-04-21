`timescale 1 ps / 1 ps

module testBenchPuppetMaster(fuckoff);
	output fuckoff;

	wire RSTn, clk50, clk60, rdemptyin;
	wire [1:0] CMD;
	wire [7:0] OE8, generatedCmds, rdusedwin, rdusedwout;
	wire D;
	reg resetn = 0;
	assign RSTn = resetn;
	assign OE8 = {8{1'b0}};
	assign generatedCmds = {8{1'b0}};
	assign rdusedwin = {8{1'b0}};
	assign rdusedwout = {8{1'b0}};
	assign rdemptyin = 0;
	assign fuckoff = D;
	puppetmaster pm(RSTn, clk50, clk60, CMD, OE8, generatedCmds, rdusedwin, rdusedwout, rdemptyin);
	testpuppetmaster tpm(clk50, clk60, CMD, D);
	
	initial begin
		#5000	resetn = 1;
	end

endmodule
