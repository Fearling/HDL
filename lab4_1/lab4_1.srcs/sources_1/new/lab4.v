`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2025 14:20:24
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
output reg [7:0] led7_seg_o = 8'hff, led7_an_o = 8'hff
    );
    
    reg test = 0;
    parameter N = 100000000;
    reg sec = 1;
    wire [1:0] debouncer_command;
    reg [1:0] h_10 = 0, seg_state = 0;
    reg [3:0] h_1 = 0, min_10 = 0, min_1 = 0, led7_current = 4'hf;
    reg [7:0] sec_c = 0, led7_translated = 8'hff;
    integer count = 0, count_2 = 0;
    
    
    debouncer de (
        .clk_i(clk_i),
        .h_up(button_hr_i),
        .min_up(button_min_i),
        .test(button_test_i),
        .rst_i(rst_i),
        .d(debouncer_command)
    );
    
    
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            h_10 <= 0;
            h_1 <= 0;
            min_10 <= 0;
            min_1 <= 0;
            sec <= 1;
            sec_c <= 0;
            test <= 0;
            count <= 0;
        end
        else begin
            count <= count + 1;
            count_2 <= count_2 + 1000;
            if (count == N ) begin
                count <= 0;
                sec <= ~sec;
                sec_c <= sec_c + 1; 
                if (sec_c > 58) begin
                    sec_c <= 0;
                    min_1 <= min_1 + 1;
                end
            end
            
            if (count_2 == N) begin
            count_2 <= 0;
                if (min_1 > 9) begin
                    min_1 <= 0;
                    min_10 <= min_10 + 1;
                end
                if (min_10 > 9) begin
                    min_10 <= 0;
                    h_1 <= h_1 + 1;
                end
                if (h_1 > 9) begin
                    h_1 <= 0;
                    h_10 <= h_10 + 1;
                end
                if (h_10 > 1 && h_1 > 3) begin
                    h_10 <= 0;
                    h_1 <= 0;
                    min_10 <= 0;
                    min_1 <= 0;
                    sec_c <= 0;
                    sec <= 0;
                end
                case (seg_state)
                2'b11 : begin
                    led7_an_o <= 8'b11111110;
                    led7_seg_o <= led7_translated[7:0];
                    seg_state <= 2'b00;
                    led7_translated[0] <= 1;
                    led7_current <= min_1;
                end
                2'b10 : begin
                    led7_an_o <= 8'b11111101;
                    led7_seg_o <= led7_translated[7:0];
                    seg_state <= 2'b11;
                    led7_translated[0] <= sec;
                    led7_current <= min_10;
                end
                2'b01 : begin
                    led7_an_o <= 8'b11111011;
                    led7_seg_o <= led7_translated[7:0];
                    seg_state <= 2'b10;
                    led7_translated[0] <= 1;
                    led7_current <= h_1;
                end
                2'b00 : begin
                    led7_an_o <= 8'b11110111;
                    led7_seg_o <= led7_translated[7:0];
                    seg_state <= 2'b01;
                    led7_translated[0] <= 1;
                    led7_current <= h_10;
                end
                endcase 
            
                case (led7_current)
                    4'b0000 : led7_translated[7:1] <= 7'b0000001;
                    4'b0001 : led7_translated[7:1] <= 7'b1001111;
                    4'b0010 : led7_translated[7:1] <= 7'b0000010;
                    4'b0011 : led7_translated[7:1] <= 7'b0000110;
                    4'b0100 : led7_translated[7:1] <= 7'b1001101;
                    4'b0101 : led7_translated[7:1] <= 7'b0100100;
                    4'b0110 : led7_translated[7:1] <= 7'b1100000;
                    4'b0111 : led7_translated[7:1] <= 7'b0001111;
                    4'b1000 : led7_translated[7:1] <= 7'b0000000;
                    4'b1001 : led7_translated[7:1] <= 7'b0000100;
                endcase
            
                
            
            end
        case(debouncer_command)
            2'b11 : h_1 <= h_1 + 1;
            2'b10 : min_1 <= min_1 + 1;
            2'b01 : test <= ~test;
            default : ;
        endcase
        end
        
    end
endmodule
