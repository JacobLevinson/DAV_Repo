module nunchuk_translator(input[7:0] data_in [5:0], 		//6 bytes of data in
	output[7:0] stick_x,
	output[7:0]	stick_y; 		// x and y axis values from the nunchuk stick
	output[9:0] accel_x, 
	output[9:0] accel_y, 
	output[9:0] accel_z, // x, y, z axis values from the accelerometer
	output z, 
	output c);				//the two buttons (hint: ACTIVE LOW)

	assign data_in[0] = stick_x





endmodule