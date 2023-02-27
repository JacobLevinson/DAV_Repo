module IOBuffer(input in, input we, output out, inout SDA);
	
	
	always_comb begin
    if(we == 1'b1) begin
        SDA <= in;
        out <= 1'b0;
    end else begin
        SDA <=1'bz;
        out <= SDA;
    end
	end

endmodule