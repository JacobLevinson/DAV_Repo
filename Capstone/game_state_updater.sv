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
	output reg [7:0] player2_score,
	output wire [1:0] state_out
);
	reg [9:0] ball_x_vel;
	reg [9:0] ball_y_vel;
	reg ball_x_direction;
	reg ball_y_direction;
	localparam LEFT = 1'd0;
	localparam RIGHT = 1'd1;
	localparam DOWN = 1'd0;
	localparam UP = 1'd1;
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
		ball_x_vel = 10'd0;
		ball_y_vel = 10'd0;
		ball_x_direction = LEFT;
		ball_y_direction = DOWN;
		player1_score = 8'd0;
		player2_score = 8'd0;
	end
	localparam RESET = 0;
	localparam PLAY_NEXT = 1;
	localparam PLAY = 2;
	reg [1:0] state = 0;
	assign state_out = state;
	reg tmp_stick_Y1;
	reg tmp_stick_Y2;
	//state update
	always @(posedge vsync) begin
		if(rst) begin
			state <= RESET;

			ball_x_pos <= 11'd320;
			ball_y_pos <= 11'd240;
			ball_x_vel <= 10'd0;
			ball_y_vel <= 10'd0;
			ball_x_direction <= LEFT;
			ball_y_direction <= DOWN;
			player1_x_pos <= 11'd0; //constant 
			player1_y_pos <= 11'd240;
			player2_x_pos <= 11'd634; //constant 
			player2_y_pos <= 11'd240;
			player1_score <= 8'd0;
			player2_score <= 8'd0;
		end else begin
			if(state == RESET) begin
				ball_x_pos <= 11'd320;
				ball_y_pos <= 11'd240;
				ball_x_vel <= 10'd0;
				ball_y_vel <= 10'd0;
				ball_x_direction <= LEFT;
				ball_y_direction <= DOWN;
				player1_x_pos <= 11'd0; //constant 
				player1_y_pos <= 11'd240;
				player2_x_pos <= 11'd634; //constant 
				player2_y_pos <= 11'd240;
				player1_score <= 8'd0;
				player2_score <= 8'd0;
				if(start) begin
					state <= PLAY_NEXT;
				end else begin
					state <= RESET;
				end
			end else if(state == PLAY_NEXT) begin
				if(start) begin
					state <= PLAY;
				end else begin
					state <= PLAY_NEXT;
				end

				player1_x_pos = 11'd0; //constant 
				player2_x_pos <= 11'd634; //constant 
				ball_x_pos = 11'd320;
				ball_y_pos = 11'd240;
				ball_x_vel = 10'd8;
				ball_y_vel = 10'd3;
				ball_x_direction = LEFT;
				ball_y_direction = DOWN;
				player1_y_pos = 11'd240;
				player2_y_pos = 11'd240;
				player1_score <= player1_score;
				player2_score <= player2_score;
			end else if(state == PLAY) begin
				player1_x_pos <= 11'd0; //constant 
				player2_x_pos <= 11'd634; //constant 
				ball_x_vel <= ball_x_vel;
				
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
				

				//ball collisions

				//left wall
				if(ball_x_direction == LEFT) begin
					//check if hitting wall/stick barrier
					if(ball_x_pos - (ball_x_vel + STICK_WIDTH) >= 640) begin //will overflow -> will hit left wall
						//check if will hit left stick
						if(ball_y_pos >= player1_y_pos && ball_y_pos < player1_y_pos + STICK_HEIGHT) begin //will hit stick
							ball_x_pos <= ball_x_pos + ball_x_vel;
							//ball_y_pos <= ball_y_pos;
							ball_x_direction <= RIGHT;
							//ball_y_direction <= ball_y_direction;
							player1_score <= player1_score;
							player2_score <= player2_score;
							state <= PLAY;
							//
							ball_y_direction <= (stick_Y1 >= 128) ? UP : DOWN;
							ball_y_vel <= (stick_Y1 >= 128) ? (stick_Y1-128)/32 : (128 - stick_Y1)/32;

						end else begin //will hit wall - give point to other team and go to play_next
							ball_x_pos <= ball_x_pos + ball_x_vel;
							//ball_y_pos <= ball_y_pos;
							ball_x_direction <= RIGHT;
							//ball_y_direction <= ball_y_direction;
							player1_score <= player1_score;
							player2_score <= player2_score + 1;
							state <= PLAY_NEXT;
						end
					end else begin //will not hit left wall
						ball_x_pos <= ball_x_pos - ball_x_vel;
						ball_x_direction <= ball_x_direction;
						player1_score <= player1_score;
						player2_score <= player2_score;
						state <= PLAY;
					end
				end else if(ball_x_direction == RIGHT) begin
					//check if hitting wall/stick barrier
					if((ball_x_pos + BALL_SIZE) + (ball_x_vel + STICK_WIDTH) >= 640) begin //will overflow go over, hit!
						//check if will hit right stick
						if(ball_y_pos > player2_y_pos && ball_y_pos < player2_y_pos + STICK_HEIGHT) begin //will hit stick
							ball_x_pos <= ball_x_pos - ball_x_vel;
							ball_x_direction <= LEFT;
							player1_score <= player1_score;
							player2_score <= player2_score;
							state <= PLAY;
							//
							ball_y_direction <= (stick_Y2 >= 128) ? UP : DOWN;
							ball_y_vel <= (stick_Y2 >= 128) ? (stick_Y2-128)/32 : (128 - stick_Y2)/32;
							

							
						end else begin //will hit wall - give point to other team and go to play_next
							ball_x_pos <= ball_x_pos - ball_x_vel;
							ball_x_direction <= LEFT;
							player1_score <= player1_score + 1;
							player2_score <= player2_score;
							state <= PLAY_NEXT;
						end
					end else begin //will not hit left wall
						ball_x_pos <= ball_x_pos + ball_x_vel;
						ball_x_direction <= ball_x_direction;
						player1_score <= player1_score;
						player2_score <= player2_score;
						state <= PLAY;
					end
				end					

				//Now check top and bottom
				if(ball_y_direction == DOWN) begin
					if((ball_y_pos + BALL_SIZE) + (ball_y_vel) >= 480) begin //will hit bottom wall, bounce
						ball_y_pos <= ball_y_pos - ball_y_vel;
						ball_y_direction <= UP;
					end else begin //else will not hit 
						ball_y_pos <= ball_y_pos + ball_y_vel;
						//ball_y_direction <= ball_y_direction;
					end
				end else if(ball_y_direction == UP) begin
					if((ball_y_pos) - (ball_y_vel) >= 480) begin //will hit top wall, bounce (overflow)
						ball_y_pos <= ball_y_pos + ball_y_vel;
						ball_y_direction <= DOWN;
					end else begin //will not hit top wall
						ball_y_pos <= ball_y_pos - ball_y_vel;
						//ball_y_direction <= ball_y_direction;
					end
				end





				///////
			end else begin
				state <= RESET;
				ball_x_pos <= 11'd320;
				ball_y_pos <= 11'd240;
				ball_x_vel <= 10'd0;
				ball_y_vel <= 10'd0;
				ball_x_direction <= LEFT;
				ball_y_direction <= DOWN;
				player1_x_pos <= 11'd0; //constant 
				player1_y_pos <= 11'd240;
				player2_x_pos <= 11'd634; //constant 
				player2_y_pos <= 11'd240;
			end
		end 
	end


endmodule