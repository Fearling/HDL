`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 15:06:58
// Design Name: 
// Module Name: debouncer
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


module debouncer(
input wire clk_i, min_up, h_up, test, rst_i,
output reg [1:0] d
    );
    parameter delay = 500000;
    reg pressing = 0, pressed = 0;
    integer count = 0;
    
    
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            pressed <= 0;
            pressing <= 0;
            d <= 0;
        end
        else begin
            d <= 0;
            pressing <= min_up | h_up | test;
            if (pressing && pressed == 0) begin
                count <= count + 1;
                if (count > delay) begin
                    count <= 0;
                    pressed <= 1;
                    if (h_up) begin
                        d <= 2'b11;
                    end
                    if (min_up) begin
                        d <= 2'b10;
                    end
                    if (test) begin
                        d <= 2'b01;
                    end
                end
            end
            else if (pressing == 0 && pressed) begin
                count <= count + 1;
                if (count > delay) begin
                    count <= 0;
                    pressed <= 0;
                end
            end
            else begin
                d <= 2'b00;
            end
            
        end
    end
    
endmodule
