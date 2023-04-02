`timescale 1ns/1ns
module tb_butterfly_unit(X, Y, X_real, X_imag, Y_real, Y_imag);
    localparam WIDTH = 32;
    reg clk = 1;
    reg signed [WIDTH-1:0] A = 32'b00000011111010000000011111010000;
    reg signed [WIDTH-1:0] B = 32'b00001011101110000000111110100000;
    reg signed [WIDTH-1:0] W;
    output wire signed [WIDTH-1:0] X; // A + W*B
    output wire signed [WIDTH-1:0] Y; // A + W*B
    output wire signed [WIDTH/2-1:0] X_real;
    output wire signed [WIDTH/2-1:0] X_imag;
    output wire signed [WIDTH/2-1:0] Y_real;
    output wire signed [WIDTH/2-1:0] Y_imag;

    reg signed [(WIDTH/2)-1:0] W_real;
    reg signed [(WIDTH/2)-1:0] W_imag;
    assign W = {W_real,W_imag};

    butterfly_unit UUT(A,B,W,X,Y);
    assign X_real = X[WIDTH-1:WIDTH/2];
    assign Y_real = Y[WIDTH-1:WIDTH/2];
    assign X_imag = X[WIDTH/2-1:0];
    assign Y_imag = Y[WIDTH/2-1:0];



    integer i;
	initial begin
    for(i = 0; i < 4; i++) begin
        if(i == 0) begin
            W_real = 16'b0111111111111111;
            W_imag = 16'd0;
        end else if(i == 1) begin
            W_real = 16'd0;
            W_imag = 16'b1000000000000000;
        end else if(i == 2) begin
            W_real = 16'b1000000000000000;
            W_imag = 16'd0;
        end else if(i == 3) begin
            W_real = 16'd0;
            W_imag = 16'b0111111111111111;
        end
        #5;
        clk = ~clk;
    end
    $stop;
    end

		

    

endmodule