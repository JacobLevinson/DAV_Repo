module IOBuffer(in, out, enable, port);
	
	
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