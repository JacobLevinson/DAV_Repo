module minialu(Ai, Bi, op, res);
		input [3:0] Ai;
		input [3:0] Bi;
		input op;
		output reg [19:0] res;
	always @ (*) begin
		if(!op) begin //op is 0
			res = Ai + Bi;
		end else begin
			res = Ai << Bi;
		end
	end
endmodule