`timescale 1ns/1ns
module nunchuckDriver_tb (clk, SCLpin, SDApin);
	output reg clk = 0;
	output SCLpin, SDApin;
	
	wire[7:0] stick_x, stick_y;
	wire[9:0] accel_x, accel_y, accel_z;
	wire z, c;
	
	always begin
		#1;
		clk = ~clk;
	end
	
	nunchuckDriver UUT(clk, SDApin, SCLpin ,stick_x, stick_y, accel_x, accel_y, accel_z, z, c, 1'b0);
endmodule