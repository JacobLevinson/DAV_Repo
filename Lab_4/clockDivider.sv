module clockDivider #(parameter SPEED=100)(clock,outClock);
	input clock;
	output reg outClock = 0;
	localparam threshold = 50000000/(2*SPEED);
	reg [25:0]counter = 0;
	always@(posedge clock) begin
		counter <= counter + 1'd1;
		if(counter == threshold-1) begin
			counter <= 0;
			outClock <= ~outClock;
		end
	end
	
endmodule