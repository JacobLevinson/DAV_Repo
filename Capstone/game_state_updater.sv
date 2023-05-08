module game_state_updater(
	input rst,
	input start, //basically any button pressed will trigger this
	input vsync,
	input [7:0] stick_X1,
	input [7:0] stick_Y1,
	input [9:0] accel_X1,
	input [9:0] accel_Y1,
	input [9:0] accel_Z1,
	input z1,
	input c1,
	input [7:0] stick_X2,
	input [7:0] stick_Y2,
	input [9:0] accel_X2,
	input [9:0] accel_Y2,
	input [9:0] accel_Z2,
	input z2,
	input c2,
    output reg [10:0] ball_x_pos,
    output reg [10:0] ball_y_pos,
    output reg [10:0] player1_x_pos,
    output reg [10:0] player1_y_pos,
    output reg [10:0] player2_x_pos,
    output reg [10:0] player2_y_pos,
	output reg [7:0] player1_score,
	output reg [7:0] player2_score
);
	reg [9:0] ball_x_vel;
	reg [9:0] ball_y_vel;
	reg ball_x_direction;
	reg ball_y_direction;
	localparam LEFT = 0;
	localparam RIGHT = 1;
	localparam DOWN = 0;
	localparam UP = 1;
	localparam BALL_SIZE = 10;
	reg [9:0] STICK_HEIGHT = 100;
	localparam STICK_WIDTH = 5;

	initial begin
		ball_x_pos = 11'd300;
		ball_y_pos = 11'd300;
		player1_x_pos = 11'd0;
		player1_y_pos = 11'd100;
		player2_x_pos = 11'd634;
		player2_y_pos = 11'd200;
		ball_x_vel = 11'd0;
		ball_y_vel = 11'd0;
		ball_x_direction = 0;
		ball_y_direction = 0;
	end
	localparam RESET = 0;
	localparam PLAY_NEXT = 1;
	localparam PLAY = 2;
	reg [1:0] state = 0;
	reg [1:0] next_state = 0;
	reg tmp_stick_Y1;
	reg tmp_stick_Y2;
	//state update
	always @(posedge vsync) begin
		if(rst) begin
			next_state <= RESET;

			ball_x_pos <= 11'd320;
			ball_y_pos <= 11'd240;
			ball_x_vel <= 11'd0;
			ball_y_vel <= 11'd0;
			ball_x_direction <= 0;
			ball_y_direction <= 0;
			player1_x_pos <= 11'd0; //constant 
			player1_y_pos <= 11'd240;
			player2_x_pos <= 11'd634; //constant 
			player2_y_pos <= 11'd240;
		end else begin
			if(state == RESET) begin
				ball_x_pos <= 11'd320;
				ball_y_pos <= 11'd240;
				ball_x_vel <= 11'd0;
				ball_y_vel <= 11'd0;
				ball_x_direction <= 0;
				ball_y_direction <= 0;
				player1_x_pos <= 11'd0; //constant 
				player1_y_pos <= 11'd240;
				player2_x_pos <= 11'd634; //constant 
				player2_y_pos <= 11'd240;
				if(start) begin
					next_state <= PLAY_NEXT;
				end else begin
					next_state <= RESET;
				end
			end else if(state == PLAY_NEXT) begin
				next_state <= PLAY;	

				player1_x_pos = 11'd0; //constant 
				player2_x_pos <= 11'd634; //constant 
				ball_x_pos = 11'd320;
				ball_y_pos = 11'd240;
				ball_x_vel = 11'd10;
				ball_y_vel = 11'd0;
				ball_x_direction = 0;
				ball_y_direction = 0;
				player1_y_pos = 11'd240;
				player2_y_pos = 11'd240;
			end else if(state == PLAY) begin
				next_state <= PLAY;
				player1_x_pos <= 11'd0; //constant 
				player2_x_pos <= 11'd634; //constant 
				ball_x_pos <= 11'd320;
				ball_y_pos <= 11'd240;
				ball_x_vel <= 11'd10;
				ball_y_vel <= 11'd0;
				ball_x_direction <= 0;
				ball_y_direction <= 0;
				//move stuff
				//move players 

				//player 1 first
				if(stick_Y1 >= 128) begin //trying to move up
					if(player1_y_pos - (stick_Y1-128)/32 < 480) begin //using overflow here, if it doesn't overflow
						player1_y_pos <= player1_y_pos - (stick_Y1-128)/32;
					end else begin //else will oveflow, just give it min
						player1_y_pos <= 11'd0; 
					end
				end else begin //trying to move down
					if(player1_y_pos + (128 - stick_Y1)/32 < (480 - STICK_HEIGHT)) begin //if it doesnt go over max
						player1_y_pos <= player1_y_pos + (128 - stick_Y1)/32;
					end else begin //else will go over max
						player1_y_pos <= (479-STICK_HEIGHT); 
					end
				end

				//now move player 2
				if(stick_Y2 >= 128) begin //trying to move up
					if(player2_y_pos - (stick_Y2-128)/32 < 480) begin //using overflow here, if it doesn't overflow
						player2_y_pos <= player2_y_pos - (stick_Y2-128)/32;
					end else begin //else will oveflow, just give it min
						player2_y_pos <= 11'd0; 
					end
				end else begin //trying to move down
					if(player2_y_pos + (128 - stick_Y2)/32 < (480 - STICK_HEIGHT)) begin //if it doesnt go over max
						player2_y_pos <= player2_y_pos + (128 - stick_Y2)/32;
					end else begin //else will go over max
						player2_y_pos <= (479-STICK_HEIGHT); 
					end
				end
				
			end else begin
				next_state <= RESET;
				ball_x_pos <= 11'd320;
				ball_y_pos <= 11'd240;
				ball_x_vel <= 11'd0;
				ball_y_vel <= 11'd0;
				ball_x_direction <= 0;
				ball_y_direction <= 0;
				player1_x_pos <= 11'd0; //constant 
				player1_y_pos <= 11'd240;
				player2_x_pos <= 11'd634; //constant 
				player2_y_pos <= 11'd240;
			end
		end 
		state <= next_state;
	end


endmodule