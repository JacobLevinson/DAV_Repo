module Lab3(switches, leds, button0, button1, clockIn, digit0, digit1, digit2, digit3, digit4, digit5);
    input [9:0] switches;
	output [9:0] leds;
	output [7:0] digit0;
	output [7:0] digit1;
	output [7:0] digit2;
	output [7:0] digit3;
	output [7:0] digit4;
	output [7:0] digit5;
	input button0;
	input button1;
	input clockIn;
	assign leds = switches;
    reg [19:0] value;
    reg outputClock100;
	reg outputClock200;
    reg outClock;
    clockDivider #(100) clock100 (clockIn, outputClock100);
	clockDivider #(200) clock200 (clockIn, outputClock200);
    always_comb begin
        if(switches[0] == 1'b1) begin
            outClock = outputClock200;
        end else begin
            outClock = outputClock100;
        end
    end
    stopwatch stopW(button0, button1, outClock, value);
    sevenSegDisp disp(value, digit5, digit4, digit3, digit2, digit1, digit0);
    

endmodule