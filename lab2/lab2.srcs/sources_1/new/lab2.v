`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 09:06:17
// Design Name: 
// Module Name: lab2
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


module lab2(
input wire clk_i, rst_i,
output reg led_o

    );
    reg  out;
    parameter N = 32;
    integer count;
    
    initial begin
        count = 1;
    end
    
    
    
    always @ (posedge clk_i, rst_i)
    begin
        if (count < N/2) begin
            led_o <= 0;
            count <= count + 1;
        end
        else if (count < N+1) begin
            count <= count + 1;
            led_o <= 1;
        end
        else begin
            count <= 1;
            led_o <= 0;
        end
        
    end
    
    always @ (rst_i)
    begin
     count <= 0;
     led_o <= "0";
    end
    
endmodule
