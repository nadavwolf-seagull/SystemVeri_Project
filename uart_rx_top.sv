timeunit 1ns;
timeprecision 1ps;

module uart_rx_top #(
    parameter int unsigned CLK_FREQ_HZ =
        lab12_pkg::UART_CLK_FREQ_HZ,

    parameter int unsigned BAUD =
        lab12_pkg::UART_BAUD_RATE,

    parameter int unsigned MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES
) (
    input logic clk,
    input logic rst_n,

    input logic rx,
    input logic soft_reset,

    // Byte-level PHY outputs
    output logic [7:0] rx_byte,
    output logic       rx_byte_valid,

    // Complete received frame
    output logic [MAX_FRAME_BYTES*8-1:0] frame_data,
    output logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] frame_len,
    output logic frame_valid,

    // Error and status outputs
    output logic rx_framing_err,
    output logic rx_parity_err,
    output logic rx_frame_error,
    output logic rx_busy
);

    logic framing_err;
    logic parity_err;
    logic phy_error;

    assign phy_error = framing_err | parity_err;

    // ============================================================
    // UART RX PHY
    // ============================================================
    uart_rx_phy #(
        .CLK_FREQ_HZ (CLK_FREQ_HZ),
        .BAUD        (BAUD)
    ) u_uart_rx_phy (
        .clk           (clk),
        .rst_n         (rst_n),

        .rx            (rx),

        .rx_byte       (rx_byte),
        .rx_byte_valid (rx_byte_valid),
        .framing_err   (framing_err),
        .parity_err    (parity_err),
        .rx_busy       (rx_busy)
    );

    // ============================================================
    // Frame collector
    // ============================================================
    rx_frame_collector #(
        .MAX_FRAME_BYTES (MAX_FRAME_BYTES)
    ) u_rx_frame_collector (
        .clk           (clk),
        .rst_n         (rst_n),

        .rx_byte       (rx_byte),
        .rx_byte_valid (rx_byte_valid),
        .framing_err   (phy_error),
        .soft_reset    (soft_reset),

        .frame_data    (frame_data),
        .frame_len     (frame_len),
        .frame_valid   (frame_valid),
        .frame_error   (rx_frame_error)
    );

    assign rx_framing_err = framing_err;
    assign rx_parity_err  = parity_err;

endmodule