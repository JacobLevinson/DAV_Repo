module Lab_6(clk_in, rst, red, green, blue, hsync, vsync);
	input wire clk_in;
	input wire rst;
	output reg [3:0] red;
	output reg [3:0] green;
	output reg [3:0] blue;
	output reg hsync;
	output reg vsync;

 
	wire clk;
	wire rst_inv;
	assign rst_inv = ~rst;
	vga_pll vpll(rst_rst,clk_in,clk);

	wire [3:0] red_wire;
	wire [3:0] green_wire;
	wire [3:0] blue_wire;
	wire hsync_wire;
	wire vsync_wire;
	

	vga vga_maker(clk, rst_inv, hsync_wire, vsync_wire, red_wire, green_wire, blue_wire);
	always_comb begin
		red = red_wire;
		blue = blue_wire;
		green = green_wire;
		hsync = hsync_wire;
		vsync = vsync_wire;
	end


endmodule