`timescale 1ns / 1ps

module led_blink_tb;

    reg clk_27m;
    wire led0_n;

    led_blink #(
        .TOGGLE_TICKS(4)
    ) dut (
        .clk_27m(clk_27m),
        .led0_n(led0_n)
    );

    initial begin
        clk_27m = 1'b0;
        forever #18.518 clk_27m = ~clk_27m;
    end

    initial begin
        $dumpfile("private/build/lab1_led_blink_tb.vcd");
        $dumpvars(0, led_blink_tb);

        repeat (40) @(posedge clk_27m);
        $finish;
    end

endmodule
