module labTwo(switches, leds, digit0,digit1,digit2,digit3,digit4,digit5);
	//since this is the top level, it should include all of your IO as ports
	//Inputs: switches
	//Outputs: leds, 6 seven segment signals (dig5, dig4, dig3, dig2, dig1, dig0) that are 8 bits each
	//Other reg/wires:
	 reg [3:0] input5, input4, input3, input2, input1, input0; //These are inputs for your six seven-seg displays 
	 reg [19:0] decimalValue;

	/*
	----------PART ONE----------
	Assign your LED pin outs based on your switch inputs. 
	This should be very simple (assign statements) and can go directly in the top level
	*/
	input [9:0] switches;
	output [9:0] leds;
	output [7:0] digit0;
	output [7:0] digit1;
	output [7:0] digit2;
	output [7:0] digit3;
	output [7:0] digit4;
	output [7:0] digit5;
	assign leds = switches;
	/*
	----------PART ONE----------
	*/
	
	/*
	----------PART TWO----------
	First, fill out the code for the sevenSegDigit module.

	Instantiate 6 copies of sevenSegDigit, using the dig5, dig4, etc as inputs like so:
	sevenSegDigit digit5(input5, dig5); //Instantiation of the leftmost seven-seg display. Note that dig5 should be connected to the pins corresponding to the leftmost display

	In an always_comb block, you can set inputs to these digits to numbers you want to check!

	After finishing part two, comment out these 6 instantiations and the logic to set the inputs so that it does not interfere with part three
	----------PART TWO----------
	*/
	reg [19:0] value;
	
	//SEND TO ALU
	minialu dAlu(switches[9:6],switches[5:2],switches[1],value);
	wire [7:0] digit5int;
	wire [7:0] digit4int;
	wire [7:0] digit3int;
	wire [7:0] digit2int;
	wire [7:0] digit1int;
	wire [7:0] digit0int;

	
	
	sevenSegDisp disp(value, digit5int, digit4int, digit3int, digit2int, digit1int, digit0int );

	
	
	
	/*
	----------PART FOUR----------
	First, fill out the code for the sevenSegDisp module.
	Instantiate the sevenSegDisp module using decimalValue as the input, and connecting the outputs to the six 8-bit seven segment display signal pins in your top level
	Instantiate miniALU with the appropriate signals from the switch inputs as inputs (based on the spec) and decimalValue as the output.
	----------PART FOUR----------
	*/

	/*
	----------PART FIVE----------
	We've used 8 of the switches for inputs A and B that are four bits each. One switch is the operation.
	Now, the last switch will act as an enable for the display. If the last switch is high, the display should work as intended.
	If the last switch is low, the display should be blank regardless of the math in part four. 
	We want to add a step between the output for sevenSegDisp and the actual output that goes to the display that sets the actual output to drive a blank display if the switch is low.
	----------PART FIVE----------
	*/
	
	assign digit0 = digit0int | {8{~switches[0]}};
	assign digit1 = digit1int | {8{~switches[0]}};
	assign digit2 = digit2int | {8{~switches[0]}};
	assign digit3 = digit3int | {8{~switches[0]}};
	assign digit4 = digit4int | {8{~switches[0]}};
	assign digit5 = digit5int | {8{~switches[0]}};
	
	

endmodule