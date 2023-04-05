module fft_4pt_32bit(
	input clk,
	input rst,
	input start,
	input signed [31:0] A,
	input signed [31:0] B,
	input signed [31:0] C,
	input signed [31:0] D,
	/////////////
	output reg [31:0] W_out,
	output reg [31:0] X_out,
	output reg [31:0] Y_out,
	output reg [31:0] Z_out,
	output reg done
);
reg [1:0] state;
reg  [1:0] next_state;


localparam RESET = 2'd0;
localparam STAGE_1 = 2'd1;
localparam STAGE_2 = 2'd2;
localparam DONE = 2'd3;
//
localparam W_0_2 = 32'b01111111111111110000000000000000;
localparam W_0_4 = 32'b01111111111111110000000000000000;
localparam W_1_4 = 32'b00000000000000001000000000000000;


////
reg [31:0] butterfly0_input_0;
reg [31:0] butterfly0_input_1;
reg [31:0] butterfly1_input_0;
reg [31:0] butterfly1_input_1;

wire [31:0] butterfly0_output_0;
wire [31:0] butterfly0_output_1;
wire [31:0] butterfly1_output_0;
wire [31:0] butterfly1_output_1;
reg [31:0] butterfly0_W;
reg [31:0] butterfly1_W;

reg [31:0] intermediate_butterfly0_output_0;
reg [31:0] intermediate_butterfly0_output_1;
reg [31:0] intermediate_butterfly1_output_0;
reg [31:0] intermediate_butterfly1_output_1;

// State control
always @ (posedge clk) begin
	if(rst == 1) begin
		state <= RESET;
	end else begin
		state <= next_state;
	end
	if(state == STAGE_1) begin
		intermediate_butterfly0_output_0 <= butterfly0_output_0;
		intermediate_butterfly0_output_1 <= butterfly0_output_1;
		intermediate_butterfly1_output_0 <= butterfly1_output_0;
		intermediate_butterfly1_output_1 <= butterfly1_output_1;
	end else begin
		intermediate_butterfly0_output_0 <= intermediate_butterfly0_output_0;
		intermediate_butterfly0_output_1 <= intermediate_butterfly0_output_1;
		intermediate_butterfly1_output_0 <= intermediate_butterfly1_output_0;
		intermediate_butterfly1_output_1 <= intermediate_butterfly1_output_1;
	end
end




butterfly_unit #(32) butterfly0(butterfly0_input_0, butterfly0_input_1, butterfly0_W, butterfly0_output_0, butterfly0_output_1);
butterfly_unit #(32) butterfly1(butterfly1_input_0, butterfly1_input_1, butterfly1_W, butterfly1_output_0, butterfly1_output_1);

// Outputs
always_comb begin
case(state)
	RESET: begin
		if(rst == 1) begin
			next_state = RESET;
			W_out = 0;
			X_out = 0;
			Y_out = 0;
			Z_out = 0;
			done = 0;
		end else if(start == 1) begin
			next_state = STAGE_1;
			W_out = 0;
			X_out = 0;
			Y_out = 0;
			Z_out = 0;
			done = 0;
		end else begin
			next_state = RESET;
			W_out = 0;
			X_out = 0;
			Y_out = 0;
			Z_out = 0;
			done = 0;
		end
		butterfly0_input_0 = 0;
		butterfly0_input_1 = 0;
		butterfly1_input_0 = 0;
		butterfly1_input_1 = 0;
		butterfly0_W = 0;
		butterfly1_W = 0;
	end
	STAGE_1: begin
		next_state = STAGE_2;
		done = 0;
		W_out = 0;
		X_out = 0;
		Y_out = 0;
		Z_out = 0;
		butterfly0_input_0 = A;
		butterfly0_input_1 = C;
		butterfly1_input_0 = B;
		butterfly1_input_1 = D;
		butterfly0_W = W_0_2;
		butterfly1_W = W_0_2;
	end
	STAGE_2: begin
		next_state = DONE;
		done = 0;
		W_out = 0;
		X_out = 0;
		Y_out = 0;
		Z_out = 0;
		butterfly0_input_0 = intermediate_butterfly0_output_0;
		butterfly0_input_1 = intermediate_butterfly1_output_0;
		butterfly1_input_0 = intermediate_butterfly0_output_1;
		butterfly1_input_1 = intermediate_butterfly1_output_1;
		butterfly0_W = W_0_4;
		butterfly1_W = W_1_4;
	end
	DONE: begin
		next_state = DONE;
		done = 1;
		W_out = butterfly0_output_0;
		X_out = butterfly1_output_0;
		Y_out = butterfly0_output_1;
		Z_out = butterfly1_output_1;
		butterfly0_input_0 = intermediate_butterfly0_output_0;
		butterfly0_input_1 = intermediate_butterfly1_output_0;
		butterfly1_input_0 = intermediate_butterfly0_output_1;
		butterfly1_input_1 = intermediate_butterfly1_output_1;
		butterfly0_W = W_0_4;
		butterfly1_W = W_1_4;
	end
	default: begin
		next_state = RESET;
		done = 0;
		W_out = 0;
		X_out = 0;
		Y_out = 0;
		Z_out = 0;
		butterfly0_input_0 = A;
		butterfly0_input_1 = C;
		butterfly1_input_0 = B;
		butterfly1_input_1 = D;
		butterfly0_W = 0;
		butterfly1_W = 0;
	end
endcase

end












endmodule