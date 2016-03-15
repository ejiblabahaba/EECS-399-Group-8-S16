module AD9837_ctrl(
	input clk,
	input busy,
	input reset_n,
	input fwrq,  //frequency write request
	input fws,   //frequency write select; 0=FREQ0, 1=FREQ1
	input fsel,  //frequency read  select; 0=FREQ0, 1=FREQ1
	input reset,
	input sleep1,
	input sleep12,
	input opbiten,
	input div2,
	input mode,
	input [27:0] FCODE,
	
	output reg enable,
	output cpol,
	output cpha,
	output cont,
	output [31:0] clk_div,
	output [31:0] addr,
	output reg [15:0] tx_data
);
	reg [27:0] FREQ0 = 28'h000_068D;
	reg [27:0] FREQ1 = 28'h000_0000;
	reg [15:0] CMD = 16'h0000;
	reg [1:0] step = 2'b00;
	reg execute = 0;
	reg wl0l = 0;
	reg wl0h = 0;
	reg wl1l = 0;
	reg wl1h = 0;
	
	wire [15:0] CMD_in;
	wire B28,f0w,f1w,mode_wire,go;
	
	assign cpol      = 1;
	assign cpha      = 0;
	assign cont      = 0;
	assign addr      = 0;
	assign clk_div   = 2;
	assign go        = ~(busy | enable);
	assign mode_wire = mode & ~opbiten;
	assign f0w       = (FREQ0 != FCODE) & ~fws;
	assign f1w       = (FREQ1 != FCODE) &  fws;
	assign B28       = (f0w | f1w) & fwrq;
	assign CMD_in    = {2'b00,B28,1'b0,fsel,2'b00,reset,sleep1,sleep12,opbiten,1'b0,div2,1'b0,mode_wire,1'b0};
	
	always @(posedge clk, negedge reset_n) begin
		if (~reset_n) begin
			enable  <=        0;
			execute <=        0;
			step    <=    2'b00;
			CMD     <= 16'h0000;
		end else begin
			//execute 0: reset the part
			if (~execute) begin
				//reset step 0: toggle reset in cmd reg
				if (step == 2'b00) begin
					tx_data <= 16'h0100;
					if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable <= 0;
						step <= 2'b01;
					end
				//reset step 1: do a B28 command write
				end else if (step == 2'b01) begin
					tx_data <= 16'h2100;
					if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable <= 0;
						step <= 2'b10;
					end
				//reset step 2: write 14 LSBs
				end else if (step == 2'b10) begin
					tx_data <= 16'h468D;
					if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable = 0;
						step <= 2'b11;
					end
				//reset step 3: write 14 MSBs
				end else if (step == 2'b11) begin
					tx_data <= 16'h4000;
					if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable <= 0;
						step <= 2'b00;
						execute <= 1;
					end
				end
			//execute 1: command write, normal B28 write, idle
			end else if (execute) begin
				//step 0: command write
				if (step == 2'b00) begin
					tx_data <= CMD;
					if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable <= 0;
						if (CMD[13]) begin
							CMD[13] <= 0;
							step <= 2'b01;
							if (f0w) begin
								wl0l = 1; // make sure low and high get updated
								wl0h = 1;
							end else if (f1w) begin
								wl1l = 1;
								wl1h = 1;
							end
						end else begin
							step = 2'b11;
						end
					end
				//step 1: write 14 LSBs
				end else if (step == 2'b01) begin
					if (wl0l) begin
						FREQ0[13:0] <= FCODE[13:0];
						tx_data <= {1'b0,1'b1,FCODE[13:0]};
						wl0l <= 0;
					end else if (wl1l) begin
						FREQ1[13:0] <= FCODE[13:0];
						tx_data <= {1'b1,1'b0,FCODE[13:0]};
						wl1l <= 0;
					end else if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable <= 0;
						step <= 2'b10;
					end
				//step 2: write 14 MSBs
				end else if (step == 2'b10) begin
					if (wl0h) begin
						FREQ0[27:14] <= FCODE[27:14];
						tx_data <= {1'b0,1'b1,FCODE[27:14]};
						wl0h <= 0;
					end else if (wl1h) begin
						FREQ1[27:14] <= FCODE[27:14];
						tx_data <= {1'b1,1'b0,FCODE[27:14]};
						wl1h <= 0;
					end else if (go) begin
						enable <= 1;
					end else if (enable) begin
						enable <= 0;
						step <= 2'b11;
					end		
				//step 3: idle (watch for CMD register updates, freq updates)
				end else	if ((step == 2'b11) & go) begin
					if (CMD != CMD_in) begin
						CMD <= CMD_in;
						step <= 2'b00;
					end
				end
			end
		end
	end
endmodule
