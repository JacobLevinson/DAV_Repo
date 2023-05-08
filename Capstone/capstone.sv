module capstone(
    input clkin,
    input rst, //INVERTED RESET
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
    













    //VGA_DISPLAY
    wire [3:0] red_wire_out;
	wire [3:0] green_wire_out;
	wire [3:0] blue_wire_out;
	wire hsync_wire;
	wire vsync_wire;
    wire vga_clk;
    vga_pll vpll(~rst,clkin,vga_clk);
    wire [10:0] ball_x_pos;
    wire [10:0] ball_y_pos;
    wire [10:0] player1_x_pos;
    wire [10:0] player1_y_pos;
    wire [10:0] player2_x_pos; 
    wire [10:0] player2_y_pos;
    wire [7:0] player1_score;
	wire [7:0] player2_score;
    
    //GAME STATE UPDATER
    reg game_rst = 0;
    reg [21:0] rst_delay_counter = 0;

    //delay game reset
    always @(posedge clkin) begin
        if (~rst) begin
            rst_delay_counter <= 22'd0;
            game_rst <= 1;
        end else begin
            if (rst_delay_counter < 2500000) begin
                rst_delay_counter <= rst_delay_counter + 22'd1;
                game_rst <= 1'd1;
            end else begin
                rst_delay_counter <= rst_delay_counter;
                game_rst <= 1'd0;
            end
        end
    end
    wire start;
    assign start = z1;
    
    game_state_updater game(game_rst, start, vsync_wire, stick_X1, stick_Y1, accel_X1, accel_Y1, accel_Z1,
    z1, c1, stick_X2, stick_Y2, accel_X2, accel_Y2, accel_Z2, z2, c2, ball_x_pos, ball_y_pos, player1_x_pos, 
    player1_y_pos, player2_x_pos, player2_y_pos, player1_score, player2_score);





    vga_display vga_maker(vga_clk, ~rst, ball_x_pos, ball_y_pos, player1_x_pos, 
    player1_y_pos, player2_x_pos, player2_y_pos, 
    hsync_wire, vsync_wire, red_wire_out, green_wire_out, blue_wire_out);
    always_comb begin
		red = red_wire_out;
		blue = blue_wire_out;
		green = green_wire_out;
		hsync = hsync_wire;
		vsync = vsync_wire;
	end
endmodule