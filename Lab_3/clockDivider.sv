module clockDivider #(parameter SPEED=100)(clock,outClock);
	input clock;
	output reg outClock = 0;
	localparam threshold = 50000000/(2*SPEED);
	reg [18:0]counter = 0;
	always@(posedge clock) begin
		counter <= counter + 1'd1;
		if(counter == threshold-1) begin
			counter <= 0;
			outClock <= ~outClock;
		end
	end
	
	
	
	/*
	reg [25:0] counterLimit = 0;

	
	reg [18:0]counter = 0;
	
	
	always@(posedge clock) begin
		counter = counter + 1'd1;
		if(counter == counterLimit*2'd2) begin
			counter = 0;
		end
	end
	
	always_comb begin
	counterLimit = (26'd50000000/speed)/2'd2;
	
		if(counter <= counterLimit) begin
			outClock = 1'd0;
		end else if (counter > counterLimit && counter <= counterLimit*2'd2) begin
			outClock = 1'd1;
		end else begin
			outClock = 1'd1;
		end
	end
	*/
endmodule
	
	