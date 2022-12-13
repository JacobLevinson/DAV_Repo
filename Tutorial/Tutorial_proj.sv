`timescale 1ns/1ns // Tell Questa what time scale to run at

module Tutorial_proj(counter); //declare a new module named test with one port called counter
	
	output reg[3:0] counter = 0;	//declare counter as a 4-bit output register that initializes to 0
	
	initial begin 	//block that runs once at the beginning (Note, this only compiles in a testbench)
		#100;			//delay for 100 ticks (delcared as 1ns at the top!)
		$stop;		//tell simulator to stop the simuation
	end
	
	
	always begin	//run this loop always (Note, this only compiles in a testbench)
		#1;			//delay for 1 tick 
		counter = counter + 1;	//add 1 to counter
	end
	
endmodule
