module vga(
		input vgaclk,           //input pixel clock: how fast should this be?
		input rst,              //synchronous reset
		output hsync,			//horizontal sync out
		output vsync,			//vertical sync out
		output reg [3:0] red,	//red vga output
		output reg [3:0] green, //green vga output
		output reg [3:0] blue	//blue vga output
   );
	
	//TODO: Video protocol constants
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

	assign hsync = (hc < HBP && hc >= HPULSE) ? 0 : 1;
	assign vsync = (vc < VBP && vc >= VPULSE) ? 0 : 1;
	

    //RGB output block: set red, green, blue outputs here.
	always_comb begin
		// check if we're within vertical active video range
		if (hc < HFP && vc < VFP)
		begin
			red = 4'b1111;	
			green = 4'b1111;	
			blue = 4'b0000;
		end
		else begin
            red = 4'b0000;	
			green = 4'b0000;	
			blue = 4'b0000;
		end
	end

endmodule
