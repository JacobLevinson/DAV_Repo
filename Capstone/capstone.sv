module capstone(
    input clkin,
    input rst,
    inout sda1,
    inout sda2,
    output wire scl1,
    output wire scl2,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue,
    output reg hsync,
    output reg vsync,
    output reg [9:0] leds
);





    //NUNCHUCK DRIVER

	wire [7:0] stick_X1;
	wire [7:0] stick_Y1;
	wire [9:0] accel_X1;
	wire [9:0] accel_Y1;
	wire [9:0] accel_Z1;
	wire z1;
	wire c1;
    wire [7:0] stick_X2;
	wire [7:0] stick_Y2;
	wire [9:0] accel_X2;
	wire [9:0] accel_Y2;
	wire [9:0] accel_Z2;
	wire z2;
	wire c2;

    nunchuckDriver nunchuck1(clkin,sda1,scl1, stick_X1, stick_Y1, accel_X1, accel_Y1, accel_Z1, z1, c1, ~rst);
    nunchuckDriver nunchuck2(clkin,sda2,scl2, stick_X2, stick_Y2, accel_X2, accel_Y2, accel_Z2, z2, c2, ~rst);
    always_comb begin
        leds[0] = z1;
        leds[1] = z2;
        leds[9:2] = 8'b11111111;
    end 
    






    //GAME STATE UPDATER







    //GRAPHICS GENERATOR







    //VGA_DISPLAY
    wire [3:0] red_wire_out;
	wire [3:0] green_wire_out;
	wire [3:0] blue_wire_out;
	wire hsync_wire;
	wire vsync_wire;
    vga_pll vpll(~rst,clkin,vga_clk);
    vga_display vga_maker(vga_clk, ~rst, hsync_wire, vsync_wire, red_wire_out, green_wire_out, blue_wire_out);
    always_comb begin
		red = red_wire_out;
		blue = blue_wire_out;
		green = green_wire_out;
		hsync = hsync_wire;
		vsync = vsync_wire;
	end
endmodule