`timescale 1ns/1ns

module nunchuck_test(clk, rst, sda, scl, leds);
	
	
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
	
	nunchuckDriver nDrive(clk,sda,scl, stick_X, stick_Y, accel_X, accel_Y, accel_Z, z, c, ~rst);
	assign leds[0] = stick_X[0];
	assign leds[1] = stick_X[1];
	assign leds[2] = stick_X[2];
	assign leds[3] = stick_X[3];
	assign leds[4] = stick_X[4];
	assign leds[5] = stick_X[5];
	assign leds[6] = stick_X[6];
	assign leds[7] = stick_X[7];
	assign leds[8] = z;
	assign leds[9] = c;
	
	
	
endmodule