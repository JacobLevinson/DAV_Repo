module Lab3(switches, leds, button0, button1, clockIn, digit0, digit1, digit2, digit3, digit4, digit5, buzzer);
    input [9:0] switches;
	output [9:0] leds;
	output [7:0] digit0;
	output [7:0] digit1;
	output [7:0] digit2;
	output [7:0] digit3;
	output [7:0] digit4;
	output [7:0] digit5;
    wire [7:0] digit5int;
	wire [7:0] digit4int;
	wire [7:0] digit3int;
	wire [7:0] digit2int;
	wire [7:0] digit1int;
	wire [7:0] digit0int;
    output buzzer;
	input button0;
	input button1;
	input clockIn;
    assign leds = switches;
    reg [19:0] value;
    reg outputClock100;
	reg outputClock200;
    reg outputClock2;
    reg outClock;
    clockDivider #(100) clock100 (clockIn, outputClock100);
	clockDivider #(200) clock200 (clockIn, outputClock200);
    clockDivider #(5) clock2 (clockIn, outputClock2);
    

    //The following is for part 1 only:

    // always_comb begin
    //     if(switches[0] == 1'b1) begin
    //         outClock = outputClock200;
    //     end else begin
    //         outClock = outputClock100;
    //     end
    // end
    //stopwatch stopW(button0, button1, outClock, value);
    assign outClock = outputClock100;
	 
	 my_timer timer(switches, button0, button1, outClock, value, buzzer);
	 
	 
	 
    sevenSegDisp disp(value, digit5int, digit4int, digit3int, digit2int, digit1int, digit0int);

    always_comb begin
        if(value == 0) begin
            digit0 = digit0int | {8{outputClock2}};
            digit1 = digit1int | {8{outputClock2}};
            digit2 = digit2int | {8{outputClock2}};
            digit3 = digit3int | {8{outputClock2}};
            digit4 = digit4int | {8{outputClock2}};
            digit5 = digit5int | {8{outputClock2}};
        end else begin 
            digit0 = digit0int;
            digit1 = digit1int;
            digit2 = digit2int;
            digit3 = digit3int;
            digit4 = digit4int;
            digit5 = digit5int;
        end
    end
	 //assign buzzer = outputClock200;
    

endmodule