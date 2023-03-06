`timescale 1ns/1ns

module nunchuck_test(clk, rst, sda, scl, dig0, dig1, dig2, dig3, dig4, dig5,leds);
	
	
	//TODO: Modify this file to do something meaningful with the nunchuck!
	input clk;
	input rst;
	inout sda;
	output [7:0] dig0, dig1, dig2, dig3, dig4, dig5;
	output scl;
	output [9:0] leds;
	wire [7:0] stick_X;
	wire [7:0] stick_Y;
	wire [9:0] accel_X;
	wire [9:0] accel_Y;
	wire [9:0] accel_Z;
	wire z;
	wire c;
	wire [7:0] dig0_int, dig5_int;
	


	wire [19:0] value;
	assign value = stick_Y * 1000 + stick_X;

	nunchuckDriver nDrive(clk,sda,scl, stick_X, stick_Y, accel_X, accel_Y, accel_Z, z, c, ~rst);

	sevenSegDisp disp(value, dig5_int, dig4, dig3, dig2, dig1, dig0_int);
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

	assign dig5 = {z,dig5_int[6:0]};
	assign dig0 = {c,dig0_int[6:0]};
	
	
	
endmodule