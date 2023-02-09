module nunchuk_translator(input[7:0] data_in [5:0], 		//6 bytes of data in
	output[7:0] stick_x,
	output[7:0]	stick_y, 		// x and y axis values from the nunchuk stick
	output[9:0] accel_x, 
	output[9:0] accel_y, 
	output[9:0] accel_z, // x, y, z axis values from the accelerometer
	output z, 
	output c);				//the two buttons (hint: ACTIVE LOW)

	assign stick_x = data_in[0];
	assign stick_y = data_in[1];
	assign accel_x = {data_in[2],data_in[5][3:2]};
	assign accel_y = {data_in[3],data_in[5][5:4]};
	assign accel_z = {data_in[4],data_in[5][7:6]};
	assign z = data_in[5][0];
	assign c = data_in[5][1];



endmodule