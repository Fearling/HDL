`timescale 1ns / 1ps
module lab5(
    input wire clk_i,
    input wire rst_i,
    input wire ps2_clk_i,
    input wire ps2_data_i,
    output wire [7:0] led7_seg_o,
    output wire [7:0] led7_an_o
);

    wire [7:0] ascii_code;
    wire new_data;
    wire [15:0] display_out;
    wire [15:0] result;

    // Dekoder PS/2
    ps2_keyboard ps2_inst (
        .clk(clk_i),
        .rst_n(~rst_i),
        .ps2_clk(ps2_clk_i),
        .ps2_data(ps2_data_i),
        .data_out(ascii_code),
        .new_data(new_data)
    );

    // FSM kalkulatora
    calculator_fsm fsm_inst (
        .clk(clk_i),
        .rst_n(~rst_i),
        .ascii_code(ascii_code),
        .new_data(new_data),
        .result(result),
        .display_out(display_out)
    );

    // Wyœwietlacz 7-segmentowy
    led7_driver display_inst (
        .clk(clk_i),
        .rst_n(~rst_i),
        .data(display_out),
        .seg(led7_seg_o),
        .an(led7_an_o)
    );

endmodule


// --------------------------- MODU£ FSM ---------------------------
module calculator_fsm (
    input wire clk,
    input wire rst_n,
    input wire [7:0] ascii_code,
    input wire new_data,
    output reg [15:0] result,
    output reg [15:0] display_out
);
    parameter IDLE = 3'd0, READ_A = 3'd1, READ_OP = 3'd2,
              READ_B = 3'd3, EVAL = 3'd4, SHOW_RESULT = 3'd5;

    reg [2:0] state, next_state;
    reg [15:0] operand_a, operand_b, current_input;
    reg [3:0] operator; // 0: +, 1: -

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (new_data && ascii_code >= "0" && ascii_code <= "9") next_state = READ_A;
            READ_A: if (new_data && (ascii_code == "+" || ascii_code == "-")) next_state = READ_OP;
            READ_OP: if (new_data && ascii_code >= "0" && ascii_code <= "9") next_state = READ_B;
            READ_B: if (new_data && ascii_code == "=") next_state = EVAL;
            EVAL: next_state = SHOW_RESULT;
            SHOW_RESULT: if (new_data && ascii_code == 8'h1B) next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            operand_a <= 0; operand_b <= 0; operator <= 0;
            result <= 0; current_input <= 0; display_out <= 0;
        end else if (new_data) begin
            case (state)
                IDLE:
                    if (ascii_code >= "0" && ascii_code <= "9")
                        current_input <= ascii_code - "0";
                READ_A:
                    if (ascii_code >= "0" && ascii_code <= "9")
                        current_input <= current_input * 10 + (ascii_code - "0");
                    else if (ascii_code == "+" || ascii_code == "-") begin
                        operand_a <= current_input;
                        operator <= (ascii_code == "+") ? 0 : 1;
                        current_input <= 0;
                    end
                READ_OP:
                    if (ascii_code >= "0" && ascii_code <= "9")
                        current_input <= ascii_code - "0";
                READ_B:
                    if (ascii_code >= "0" && ascii_code <= "9")
                        current_input <= current_input * 10 + (ascii_code - "0");
                    else if (ascii_code == "=") begin
                        operand_b <= current_input;
                        current_input <= 0;
                    end
                EVAL: begin
                    result <= (operator == 0) ? (operand_a + operand_b) : (operand_a - operand_b);
                    display_out <= (operator == 0) ? (operand_a + operand_b) : (operand_a - operand_b);
                end
                SHOW_RESULT:
                    if (ascii_code == 8'h1B) begin
                        operand_a <= 0; operand_b <= 0; operator <= 0;
                        result <= 0; current_input <= 0; display_out <= 0;
                    end
            endcase
        end
    end
endmodule


// ------------------------ MODU£ PS/2 z mapowaniem ------------------------
module ps2_keyboard(
    input wire clk,
    input wire rst_n,
    input wire ps2_clk,
    input wire ps2_data,
    output reg [7:0] data_out,
    output reg new_data
);
    reg [3:0] bit_count = 0;
    reg [10:0] shift_reg = 0;
    reg ps2_clk_prev = 1;
    reg [7:0] scancode;
    reg released = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 0;
            shift_reg <= 0;
            ps2_clk_prev <= 1;
            new_data <= 0;
            released <= 0;
        end else begin
            ps2_clk_prev <= ps2_clk;
            new_data <= 0;

            if (ps2_clk_prev == 1 && ps2_clk == 0) begin
                shift_reg <= {ps2_data, shift_reg[10:1]};
                bit_count <= bit_count + 1;

                if (bit_count == 10) begin
                    scancode <= shift_reg[8:1];
                    bit_count <= 0;

                    // wykrywamy break code (F0 = key release)
                    if (shift_reg[8:1] == 8'hF0)
                        released <= 1;
                    else if (!released) begin
                        data_out <= scancode_to_ascii(shift_reg[8:1]);
                        new_data <= 1;
                    end else begin
                        released <= 0;
                    end
                end
            end
        end
    end

    // funkcja mapuj¹ca scancode na ASCII
    function [7:0] scancode_to_ascii;
        input [7:0] sc;
        begin
            case (sc)
                8'h16: scancode_to_ascii = "1";
                8'h1E: scancode_to_ascii = "2";
                8'h26: scancode_to_ascii = "3";
                8'h25: scancode_to_ascii = "4";
                8'h2E: scancode_to_ascii = "5";
                8'h36: scancode_to_ascii = "6";
                8'h3D: scancode_to_ascii = "7";
                8'h3E: scancode_to_ascii = "8";
                8'h46: scancode_to_ascii = "9";
                8'h45: scancode_to_ascii = "0";
                8'h79: scancode_to_ascii = "+";    // Keypad +
                8'h7B: scancode_to_ascii = "-";    // Keypad -
                8'h5A: scancode_to_ascii = "=";    // Enter as '='
                8'h76: scancode_to_ascii = 8'h1B;  // ESC
                default: scancode_to_ascii = 8'h00;
            endcase
        end
    endfunction
endmodule



// ------------------- MODU£ WYŒWIETLACZA 7-SEG -------------------
module led7_driver(
    input wire clk,
    input wire rst_n,
    input wire [15:0] data,
    output reg [7:0] seg,
    output reg [7:0] an
);
    reg [1:0] digit_sel = 0;
    reg [3:0] current_digit;
    wire [6:0] seg_raw;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            digit_sel <= 0;
        end else begin
            digit_sel <= digit_sel + 1;
        end
    end

    always @(*) begin
        case (digit_sel)
            2'd0: current_digit = data[3:0];
            2'd1: current_digit = data[7:4];
            2'd2: current_digit = data[11:8];
            2'd3: current_digit = data[15:12];
        endcase
    end

    always @(*) begin
        case (digit_sel)
            2'd0: an = 8'b11111110;
            2'd1: an = 8'b11111101;
            2'd2: an = 8'b11111011;
            2'd3: an = 8'b11110111;
            default: an = 8'b11111111;
        endcase
    end

    // Segment decoder
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0011000;
            default: seg = 7'b1111111;
        endcase
    end

    // Dodanie kropki jako wy³¹czonej
    always @(*) begin
        seg = {1'b1, seg[6:0]};
    end

    // Dodanie kropki jako wy³¹czonej
    always @(*) begin
        seg = {1'b1, seg[6:0]};
    end
endmodule