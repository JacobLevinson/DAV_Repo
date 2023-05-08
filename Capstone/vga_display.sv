module vga_display(
		input vgaclk,           //input pixel clock: how fast should this be?
		input rst,              //synchronous reset
		input [10:0] ball_x_pos,
		input [10:0] ball_y_pos,
		input [10:0] player1_x_pos,
		input [10:0] player1_y_pos,
		input [10:0] player2_x_pos,
		input [10:0] player2_y_pos,
		output hsync,			//horizontal sync out
		output vsync,			//vertical sync out
		output reg [3:0] red,	//red vga output
		output reg [3:0] green, //green vga output
		output reg [3:0] blue	//blue vga output
   );


	//WE MEASURE ALL COORDINATES BY THEIR TOP LEFT PIXEL

	//vga screen cuts off a bit:


	//Video protocol constants
    // You can find these described in the VGA specification for 640x480
	localparam HPIXELS = 640;  // horizontal pixels per line
	localparam HPULSE = 656; 	// hsync pulse start
	localparam HBP = 752; 	    // start of horizontal back porch
	localparam HFP = 640; 	    // start of horizontal front porch
	localparam HEND = 800;
	
	localparam VLINES = 480;   // vertical lines per frame
	localparam VPULSE = 490; 	// vsync pulse start
	localparam VBP = 492; 		//  vertical back porch start
	localparam VFP = 480; 	    // vertical front porch start
	localparam VEND = 525;

	localparam BALL_SIZE = 10;
	reg [9:0] STICK_HEIGHT = 100;
	localparam STICK_WIDTH = 5;
	
	// registers for storing the horizontal & vertical counters
	reg [9:0] hc = 0;
	reg [9:0] vc = 0;


    //Counter block: change hc and vc correspondingly to the current state.
	always @(posedge vgaclk) begin
		 //reset condition
		if (rst == 1)
		begin
			hc <= 0;
			vc <= 0;
		end
		else
		begin
			//TODO: Implement logic to move counters properly!
			hc <= (hc + 10'd1) % (HEND);
			if((hc + 10'd1) == (HEND)) begin
				vc <= (vc + 1) % (VEND);
			end
		end
	end

	assign hsync = (hc < HBP && hc >= HPULSE) ? 1'd0 : 1'd1;
	assign vsync = (vc < VBP && vc >= VPULSE) ? 1'd0 : 1'd1;
	

    //RGB output block: set red, green, blue outputs here.
	always_comb begin
		// check if we're within vertical active video range
		if (hc < HFP && vc < VFP)
		begin
			//check if horizontal is in overlapping with ball or player1 or player2]
			//first check ball
			if((hc >= ball_x_pos && hc < ball_x_pos + BALL_SIZE) && (vc >= ball_y_pos && vc < ball_y_pos + BALL_SIZE)) begin
				//ball is red
				red = 4'b1111;	
				green = 4'b0000;	
				blue = 4'b0000;
			end else if((hc >= player1_x_pos && hc < player1_x_pos + STICK_WIDTH) && (vc >= player1_y_pos && vc < player1_y_pos + STICK_HEIGHT)) begin
				//stick is yellow 
				red = 4'b1111;	
				green = 4'b1111;	
				blue = 4'b0000;
			end else if((hc >= player2_x_pos && hc < player2_x_pos + STICK_WIDTH) && (vc >= player2_y_pos && vc < player2_y_pos + STICK_HEIGHT)) begin
				//stick is yellow 
				red = 4'b1111;	
				green = 4'b1111;	
				blue = 4'b0000;
			end else begin
				//else black
				red = 4'b0000;	
				green = 4'b0000;	
				blue = 4'b0000;
			end
		end
		else begin
            red = 4'b0000;	
			green = 4'b0000;	
			blue = 4'b0000;
		end
	end

endmodule