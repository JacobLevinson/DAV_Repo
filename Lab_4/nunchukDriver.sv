module nunchukDriver(clock, SDApin, SCLpin, stick_x, stick_y, accel_x, accel_y, accel_z, z, c, reset);
	input clock; //- 50MHz clock input
	inout SDApin; //- SDA pin
	output SCLpin; //- SCL output pin
	output [7:0] stick_x;
	output [7:0] stick_y;
	output [9:0] accel_x;
	output [9:0] accel_y;
	output [9:0] accel_z;
	output z;
	output c;
	//These are various width outputs (refer to the diagram above!) that contain the output values of the nunchuk
	input reset; // - reset pin
	////////////////////////
	wire polling_clock;
	wire i2c_clock;
	clockDivider #(100) polling_clock_generator(clock, polling_clock);
	i2c_clock_pll i2c_clock_generator(reset, clock, i2c_clock);
	////////////////////////////
	reg [6:0] deviceAddr = 7'h52;
	reg [7:0] addr;
	reg [2:0] numBytes;
	reg [5:0] dataIn;
	wire [5:0] dataOut;
	reg write;
	reg start;
	wire done;
	wire SCLpin;
	wire SDApin;
	//I2C UUT(i2c_clock, reset, deviceAddr, addr, numBytes, dataIn, dataOut, write, start, done, SCLpin, SDApin);
	localparam HANDSHAKE1 = 3'd0;
	localparam HANDSHAKE2 = 3'd1;
	localparam WRITE = 3'd2;
	localparam READ = 3'd3;
	localparam DONE = 3'd4;
	reg [2:0] current_state = HANDSHAKE1;
	reg [2:0] next_state = HANDSHAKE2;
	always_comb begin
		case (current_state)
			HANDSHAKE1: begin
				deviceAddr = 7'h52;
				addr = 8'hF0;
				dataIn[0] = 8'h55;
				numBytes = 1;
				write = 1;
				next_state = HANDSHAKE2;
			end
			HANDSHAKE2: begin
				deviceAddr = 7'h52;
				addr = 8'hFB;
				dataIn[0] = 8'h00;
				numBytes = 1;
				write = 1;
				next_state = WRITE;
			end
			WRITE: begin
				deviceAddr = 7'h52;
				addr = 8'h0;
				dataIn[0] = 8'h00;
				numBytes = 0;
				write = 1;
				next_state = READ;
			end
			READ: begin
				deviceAddr = 7'h52;
				addr = 8'h0;
				dataIn[0] = 8'h00;
				numBytes = 6;
				write = 0;
				next_state = DONE;				
			end
			DONE: begin
				deviceAddr = 7'h52;
				addr = 8'h0;
				dataIn[0] = 8'h00;
				numBytes = 0;
				write = 0;
				next_state = polling_clock == 1'b1 ? WRITE : DONE;	
			end
			default: begin
				deviceAddr = 7'h52;
				addr = 8'h0;
				dataIn[0] = 8'h00;
				numBytes = 0;
				write = 0;
				next_state = HANDSHAKE1;
				end
		endcase
	end
	always @ (posedge i2c_clock) begin
		current_state <= next_state;
		if(next_state == HANDSHAKE1 || next_state == HANDSHAKE2 || next_state == WRITE) begin
			start = 1'b1;
		end else if (done == 1'b1) begin 
			start = 1'b0;
		end else begin
			start = start;
		end
	end



endmodule