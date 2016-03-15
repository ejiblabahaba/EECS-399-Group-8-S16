module testBench_AD9837_ctrl;
	wire clk, reset, fwrq, fws, fsel, soft_reset, sleep1, sleep12, opbiten, div2, mode, busy, enable, cont, sclk, ss_n, mosi, cpol, cpha, addr, miso;
	wire [15:0] tx_data;
	wire [27:0] FCODE;
	wire [31:0] clk_div;
	wire [15:0] rx_data;
	wire [15:0] CMD;

	AD9837_ctrl 		 ctrl(clk, busy, reset, fwrq, fws, fsel, soft_reset, sleep1, sleep12, opbiten, div2, mode, FCODE, enable, cpol, cpha, cont, clk_div, addr, tx_data);
	spi_master 			 spi(clk, reset, enable, cpol, cpha, cont, clk_div, addr, tx_data, miso, sclk, ss_n, mosi, busy, rx_data);
	tickle_AD9837_ctrl tickle(busy, enable, cont, sclk, ss_n, mosi, tx_data, CMD, clk, reset, fwrq, fws, fsel, soft_reset, sleep1, sleep12, opbiten, div2, mode, FCODE);
endmodule