
`timescale 1ns/1ns

module tb_Lab3(inputClock, outputClock100, outputClock200, outVal);
	output reg outputClock100;
	output reg outputClock200;
	output reg inputClock = 0;
	output reg [19:0] outVal;
	
	clockDivider #(100) clock100 (inputClock, outputClock100);
	clockDivider #(200) clock200 (inputClock, outputClock200);
	stopwatch stopW(1'b1,1'b1,inputClock, outVal);
	initial begin
		#1000000000 $stop;
	end
	
	always begin //this kind of block only works in simulation and should not be in any other module
     # 1 inputClock = ~inputClock; //we toggle the clock every 10 nanoseconds forever
	//this runs in parallel to the initial begin so it will stop after 10000 nanoseconds
	end
	
	


endmodule