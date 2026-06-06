`timescale 1ns / 1ps

module led_blink_tb;

    reg clk_27m;
    wire led0_n;
    integer toggle_count;
    reg last_led0_n;
    integer sample_index;

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
        $dumpfile("build/lab1_led_blink/led_blink_tb.vcd");
        $dumpvars(0, led_blink_tb);

        toggle_count = 0;
        sample_index = 0;
        #1;
        last_led0_n = led0_n;

        for (sample_index = 0; sample_index < 40; sample_index = sample_index + 1) begin
            @(posedge clk_27m);
            #1;
            if (led0_n !== last_led0_n) begin
                toggle_count = toggle_count + 1;
                last_led0_n = led0_n;
            end
        end

        if (toggle_count == 10 && led0_n == 1'b1) begin
            $display("PASS: led0_n toggled 10 times and returned high.");
        end else begin
            $display(
                "FAIL: toggle_count=%0d led0_n=%b, expected 10 toggles and led0_n=1.",
                toggle_count,
                led0_n
            );
            $fatal;
        end

        $finish;
    end

endmodule
