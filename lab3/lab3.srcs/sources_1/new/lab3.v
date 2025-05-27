`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2025 15:36:01
// Design Name: 
// Module Name: lab3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab3(
input clk_i, rst_i, RXD_i,
output reg TXD_o 
    );
    
    reg  start;
    reg [9:0] data;
    reg [9:0] const = 10'h040;
    parameter N = 320;
    integer count, bit_count;
    
    
    initial begin
        count <= 1;
        start <= 1;
        bit_count <= 1;
        data [9:0] <= 10'h001;
    end
    
    
    
    always @ (posedge clk_i or posedge rst_i)
    begin
        if (rst_i == 1) begin
            count <= 1;
            start <= 1;
        end
        else begin
            if (start) begin
                if (count < N/2-1) begin
                    count <= count + 1;
                end
                else begin
                    count <= 1;
                    start <= RXD_i;
                end
            end
            else if (!start) begin
                if (count < N-1) begin
                    count <= count + 1;
                end
                else if (bit_count < 9) begin
                    count <= 1;
                    bit_count <= bit_count+1;
                    data [bit_count] <= RXD_i;
                end
                else begin
                    TXD_o <= data [bit_count-7];
                    bit_count <= bit_count+1;
                    count <= 1;
                    if (bit_count == 17) begin
                        start <= 1;
                        bit_count <= 1;
                    end
                end
            end
            else begin
                count <= 1;
                start <= 1;
            end
        end
    end
    
    
endmodule
