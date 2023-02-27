module nunchuck_test(clk, rst, sda, scl,leds);
	
	
	//TODO: Modify this file to do something meaningful with the nunchuck!
	input clk;
	input rst;
	inout sda;
	output scl;
	output [9:0] leds;
	wire [7:0] stick_X;
	wire [7:0] stick_Y;
	wire [9:0] accel_X;
	wire [9:0] accel_Y;
	wire [9:0] accel_Z;
	wire z;
	wire c;
	
	nunchuckDriver nDrive(clk,sda,scl, stick_X, stick_Y, accel_X, accel_Y, accel_Z, rst);
	assign leds[0] = accel_X[0];
	assign leds[1] = accel_X[1];
	assign leds[2] = accel_X[2];
	assign leds[3] = accel_X[3];
	assign leds[4] = accel_X[4];
	assign leds[5] = accel_X[5];
	assign leds[6] = accel_X[6];
	assign leds[7] = accel_X[7];
	assign leds[8] = accel_X[8];
	assign leds[9] = accel_X[9];

	
	
endmodule