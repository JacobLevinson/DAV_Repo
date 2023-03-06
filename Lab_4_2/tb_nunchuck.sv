`timescale 1ns/1ns

module tb_nunchuck(clk, z, SDApin, SCLpin);
    output reg clk = 0;
    output reg z;
    inout SDApin;
    output reg SCLpin;
    reg rst = 0;



nunchuckDriver driver(clk, SDApin, SCLpin, stick_x, stick_y, accel_x, accel_y, accel_z, z, c, rst);


	always #1 clk = ~clk;
endmodule
