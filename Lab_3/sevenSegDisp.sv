module sevenSegDisp(value, dig5, dig4, dig3, dig2, dig1, dig0 );
	input [19:0] value;
	output [7:0] dig5, dig4, dig3, dig2, dig1, dig0; //5 to 0 are the 6 displays on the board from left to right
	reg [3:0] input5; //You will need more of these 
	reg [3:0] input4; //You will need more of these 
	reg [3:0] input3; //You will need more of these 
	reg [3:0] input2; //You will need more of these 
	reg [3:0] input1; //You will need more of these 
	reg [3:0] input0; //You will need more of these 

	/* 
	----------PART THREE----------
	Instantiate six of the sevenSegDigit modules that you wrote, one corresponding to each physical display
	*/
	
	always_comb begin
		 input0 = value % 20'd10;
		 input1 = (value % 20'd100) / 20'd10;
		 input2 = (value % 20'd1000) / 20'd100;
		 input3 = (value % 20'd10000) / 20'd1000;
		 input4 = (value % 20'd100000) / 20'd10000;
		 input5 = (value % 20'd1000000) / 20'd100000;	
		
	end
		
	sevenSegDigit digit5(input5, dig5); //Instantiation of the leftmost seven-seg display
	sevenSegDigit digit4(input4, dig4);
	sevenSegDigit digit3(input3, dig3);
	sevenSegDigit digit2(input2, dig2);
	sevenSegDigit digit1(input1, dig1);
	sevenSegDigit digit0(input0, dig0);
	/*

	Next, you should write logic to convert the 20 bit value into 6 different 4 bit inputs for each of your displays.
	For example, if your value is 146, you want the three leftmost digits to get 0, dig2 to get input 1, dig1 to get input 4, and dig0 to get input 6.
	You will likely need to use the division and mod operators to convert from binary to base10.

	Please wrap your logic in an always_comb block to ensure combinational logic only.
	----------PART THREE----------
	*/
endmodule