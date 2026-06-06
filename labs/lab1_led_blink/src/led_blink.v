`timescale 1ns / 1ps

module led_blink #(
    parameter integer TOGGLE_TICKS = 13500000
) (
    input wire clk_27m,
    output reg led0_n
);

    reg [23:0] tick_count;

    initial begin
        tick_count = 24'd0;
        led0_n = 1'b1;
    end

    always @(posedge clk_27m) begin
        if (tick_count == TOGGLE_TICKS - 1) begin
            tick_count <= 24'd0;
            led0_n <= ~led0_n;
        end else begin
            tick_count <= tick_count + 24'd1;
        end
    end

endmodule
