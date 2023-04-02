module butterfly_unit #(parameter WIDTH = 32)(
input signed [WIDTH-1:0] A,
input signed [WIDTH-1:0] B,
input signed [WIDTH-1:0] W,
output wire signed [WIDTH-1:0] X, // A + W*B
output wire signed [WIDTH-1:0] Y  // A + W*B
);
wire signed [(WIDTH/2)-1:0] W_real;
wire signed [(WIDTH/2)-1:0] W_imag;
wire signed [(WIDTH/2)-1:0] A_real;
wire signed [(WIDTH/2)-1:0] A_imag;
wire signed [(WIDTH/2)-1:0] B_real;
wire signed [(WIDTH/2)-1:0] B_imag;
reg signed [(WIDTH/2)-1:0] X_real;
reg signed [(WIDTH/2)-1:0] X_imag;
reg signed [(WIDTH/2)-1:0] Y_real;
reg signed [(WIDTH/2)-1:0] Y_imag;

reg signed [WIDTH-1:0] W_B_real_large;
reg signed [WIDTH-1:0] W_B_imag_large;
reg signed [WIDTH/2-1:0] W_B_real;
reg signed [WIDTH/2-1:0] W_B_imag;

assign W_real = W[(WIDTH-1):(WIDTH/2)];
assign W_imag = W[((WIDTH/2)-1):0];
assign A_real = A[(WIDTH-1):(WIDTH/2)];
assign B_real = B[(WIDTH-1):(WIDTH/2)];
assign A_imag = A[((WIDTH/2)-1):0];
assign B_imag = B[((WIDTH/2)-1):0];


assign W_B_real_large = W_real * B_real - W_imag * B_imag;
assign W_B_real = W_B_real_large[(WIDTH-2):(WIDTH/2-1)];
assign W_B_imag_large = W_imag * B_real + W_real * B_imag;
assign W_B_imag = W_B_imag_large[(WIDTH-2):(WIDTH/2-1)];

assign X_real = A_real + W_B_real;
assign X_imag = A_imag + W_B_imag;
assign Y_real = A_real - W_B_real;
assign Y_imag = A_imag - W_B_imag;    

assign X = {X_real,X_imag};
assign Y = {Y_real,Y_imag};


endmodule