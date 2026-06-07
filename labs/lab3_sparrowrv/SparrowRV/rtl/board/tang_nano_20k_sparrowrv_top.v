module tang_nano_20k_sparrowrv_top (
    input wire clk_27m,
    input wire rst_n,
    input wire uart_rx,
    output wire uart_tx,
    output wire led0_n
);

wire [31:0] fpioa;
wire hx_valid;
wire core_ex_trap_ready;

assign uart_tx = fpioa[1];

assign led0_n = ~hx_valid;

sparrow_soc u_sparrow_soc (
    .clk(clk_27m),
    .hard_rst_n(rst_n),
    .hx_valid(hx_valid),
    .JTAG_TCK(1'b0),
    .JTAG_TMS(1'b0),
    .JTAG_TDI(1'b0),
    .JTAG_TDO(),
    .fpioa(fpioa),
    .NorFlash_WP(),
    .NorFlash_Hold(),
    .core_ex_trap_valid(1'b0),
    .core_ex_trap_ready(core_ex_trap_ready)
);

endmodule
