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
output reg led7_seg_o, led7_an_o
    );
    
    reg test = 0;
    parameter N = 100000000;
    reg sec = 0;
    reg [1:0] h_10 = 0, seg_state = 0;
    reg [3:0] h_1 = 0, min_10 = 0, min_1 = 0, led7_translated = 4'hf, led7_current = 4'hf;
    reg [7:0] sec_c = 0;
    integer count;
    
    
    debouncer d (
        .clk_i(clk_i),
        .button_hr_i(h_up),
        .button_min_i(min_up),
        .button_test_i(test),
        .rst_i(rst_i),
        .h_1(h_1),
        .min_1(min_1),
        .test(test_p)
    );
    
    
    always @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            h_10 <= 0;
            h_1 <= 0;
            min_10 <= 0;
            min_1 <= 0;
            test <= 0;
        end
        else begin
            count <= count + 1;
            if (count > N / (1000 * test) - 1) begin
                count <= 0;
                sec <= ~sec;
                sec_c <= sec_c + 1; 
                if (sec_c > 58) begin
                    sec_c <= 0;
                    min_1 <= min_1 + 1;
                end
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
                if (h_1 > 9) begin
                    h_1 <= 0;
                    h_10 <= h_10 + 1;
                end
            end
            
            case (seg_state)
                00 : begin
                    led7_seg_o <= 8'b11111110;
                    seg_state <= seg_state + 1;
                    led7_translated[7] <= 0;
                    led7_current <= min_1;
                end
                01 : begin
                    led7_seg_o <= 8'b11111101;
                    seg_state <= seg_state + 1;
                    led7_translated[7] <= 0;
                    led7_current <= min_10;
                end
                10 : begin
                    led7_seg_o <= 8'b11111011;
                    seg_state <= seg_state + 1;
                    led7_translated[7] <= sec;
                    led7_current <= h_1;
                end
                11 : begin
                    led7_seg_o <= 8'b11110111;
                    seg_state <= seg_state + 1;
                    led7_translated[7] <= 0;
                    led7_current <= h_10;
                end
            endcase 
            
            case (led7_current)
                0000 : led7_translated[6:0] <= 7'b1000000;
                0001 : led7_translated[6:0] <= 7'b1111001;
                0010 : led7_translated[6:0] <= 7'b0100000;
                0011 : led7_translated[6:0] <= 7'b0110000;
                0100 : led7_translated[6:0] <= 7'b0011001;
                0101 : led7_translated[6:0] <= 7'b0010010;
                0110 : led7_translated[6:0] <= 7'b0000011;
                0111 : led7_translated[6:0] <= 7'b1111000;
                1000 : led7_translated[6:0] <= 7'b0000000;
                1001 : led7_translated[6:0] <= 7'b0010000;
            endcase
            
            
            
        end
    end
endmodule
