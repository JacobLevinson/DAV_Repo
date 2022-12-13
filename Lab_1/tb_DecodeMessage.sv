`timescale 1 ns / 1 ns //Tells the simulator how long 1 "tick" is

`define NUM_MESSAGES 8 //Defines the number of 192-bit lines we're trying to decode


// The testbench is defined simiarly to any other module!
module tb_DecodeMessage(recovered);
  
  output [191:0] recovered; //Output the final decoded message
  
  reg [191:0] messageIn; //Wire to connect to decoder!
  
  integer i;	// Integer to keep track of for loop
					// Note: SystemVerilog interprets this as a 32-bit signed value!
  
  // Instantiate the module we're testing (and you're writing!)
  decodeMessage U1T(messageIn, recovered);
  
  // Array to hold all of the lines of the encoded message
  reg[191:0] messages[0:`NUM_MESSAGES-1];

  // Run this once at startup
  initial begin
  
		//Read a hex file into memory
		$readmemh("C:/Users/jacob/OneDrive/2022-2023/DAV/Lab 1/encoded_text.txt", messages);
		
		// For all the lines in messages, convert them and display!
		for(i = 0; i < `NUM_MESSAGES; i++) begin
			messageIn = messages[i];
			#5; //Wait 5 ticks between loop cycles
			$display("Input to decoder was %h , output is %s", messages[i], recovered);
		end

		$stop;

	end
	
endmodule