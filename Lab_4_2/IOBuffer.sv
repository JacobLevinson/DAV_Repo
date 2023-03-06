module IOBuffer(input in, input we, output out, inout SDA_pin);
	
	assign SDA_pin = (we) ? in : 1'bz;
    assign out = (we) ? 1'b0 : SDA_pin;

endmodule