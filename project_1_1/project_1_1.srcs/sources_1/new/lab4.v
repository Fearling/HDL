`timescale 1ns / 1ps
module task_1
#(
)(
  input                               i_clk,
  input                               i_rst,

  input                               i_valid,
  input                               i_first,
  input                               i_last,
  input signed [15:0] i_data,

  output reg                          o_valid,
  output reg                          o_last,
  output reg signed [15:0] o_data
);
    reg [15:0] out = 0;
    reg flag_i = 0;
    reg push_next = 0;

  always@(negedge i_clk or posedge i_rst) begin
    
    
    if (i_rst) begin
        flag_i <= 0;
        out <= 0;
        o_valid <= 0;
        o_last <= 0;
        o_data <= 0;
    end
    else begin
        if (i_first) begin
            flag_i <= 1;
        end
        if (out[15] == i_data[15] && flag_i) begin
            if(out < i_data) begin
                out <= i_data;
            end
        end
        else if (i_data[15] == 0 && flag_i) begin
                out <= i_data;
        end
        
        if (i_last) begin
            flag_i <= 0;
	    push_next <= 1;
        end
	if (push_next) begin
		push_next <= 0;
		o_valid <= 1;
		o_last <= 1;
		o_data <= out;
	end else begin
		o_valid <= 0;
		o_last <= 0;
	end
    end
    
  end

endmodule
