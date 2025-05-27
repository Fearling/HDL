`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2025 11:35:38 AM
// Design Name: 
// Module Name: lab4
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


module lab4(
input wire clk_i, rst_i, button_hr_i, button_min_i, button_test_i,
output reg led7_seg_o, led7_an_o
    );
    
    parameter delay = 2000;
    integer N = 100000000;
    reg c_state = 0, p_state = 0;
    integer count = 0, deley_c = 0, sec_c = 0;
    integer min = 0, h = 0;
    reg [7:0] min_r = 8'hff, h_r = 8'hff;
    reg sec = 1;
    
    
    always @ (posedge clk_i or posedge rst_i)    
    begin
        count = count + 1;
        c_state = button_hr_i || button_min_i || button_test_i;
        if(rst_i) begin
            min <= 8'h00; 
            h <= 8'h00;
            c_state <= 0; 
            p_state <= 0;
            N <= 100000000;
            deley_c <= 0;
        end
        else if(c_state == 0 && p_state == 1) begin
            deley_c = 0;
            p_state = c_state;
        end
        else if(c_state == 1 && p_state == 0) begin
           deley_c = deley_c + 1;
           if (deley_c > delay) begin
            deley_c = 0;
            p_state = c_state; 
                if(button_hr_i) begin
                    h = h + 1;
                end
                if(button_min_i) begin
                    min = min + 1;
                end
                if(button_test_i) begin
                    if(N==100000000)begin
                        N = 100000;
                    end
                    else begin
                        N = 100000000;
                    end    
                end
           end
        end
        
        if (count == N/2) begin
            sec = ~sec;
            sec_c = sec_c + 1;
        end
        if (h > 23 && min > 59 && sec_c > 119) begin
             min = 0;
             h = 0;   
             sec_c = 0;           
        end
        else if (sec_c > 119) begin
             sec_c = 0;
             min = min + 1;
        end
        if (min > 59) begin
             min = 0;
             h = h + 1;              
        end
    end
endmodule
