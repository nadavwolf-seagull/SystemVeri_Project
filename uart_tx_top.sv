timeunit 1ns;
timeprecision 1ps;

module uart_tx_top #(
    parameter int unsigned PACKET_BYTES = lab12_pkg::TX_PACKET_BYTES,
    parameter int unsigned PACKET_WIDTH = lab12_pkg::TX_PACKET_WIDTH,
    parameter int unsigned CLKS_PER_BIT = lab12_pkg::UART_CLKS_PER_BIT,
    parameter logic        PARITY_EN    = lab12_pkg::UART_PARITY_EN,
    parameter logic        EVEN_PARITY  = lab12_pkg::UART_EVEN_PARITY
) (
    input  logic                    sys_clk,
    input  logic                    rst_n,
    input  logic                    tx_en,

    // Hardware flow control from the PC side.
    // Active-low:
    // cts_n = 0 -> transmission is allowed
    // cts_n = 1 -> pause before starting the next byte
    input  logic                    cts_n,

    // Packet-level interface from Message Composer
    input  logic                    packet_valid,
    input  logic [PACKET_WIDTH-1:0] packet_data,
    output logic                    packet_ready,

    // Packet status
    output logic                    packet_busy,
    output logic                    packet_done,

    // Serial UART output
    output logic                    TX
);

    // ------------------------------------------------------------
    // Internal MAC-to-PHY connections
    // ------------------------------------------------------------
    logic       uart_tx_en;
    logic [7:0] uart_tx_data;
    logic       uart_done;

    // ------------------------------------------------------------
    // UART TX MAC
    // ------------------------------------------------------------
    uart_tx_mac #(
        .PACKET_BYTES (PACKET_BYTES),
        .PACKET_WIDTH (PACKET_WIDTH)
    ) u_uart_tx_mac (
        .sys_clk      (sys_clk),
        .rst_n        (rst_n),
        .tx_en        (tx_en),

        .cts_n        (cts_n),

        .packet_valid (packet_valid),
        .packet_data  (packet_data),
        .packet_ready (packet_ready),

        .uart_done    (uart_done),
        .uart_tx_en   (uart_tx_en),
        .uart_tx_data (uart_tx_data),

        .packet_busy  (packet_busy),
        .packet_done  (packet_done)
    );

    // ------------------------------------------------------------
    // UART TX PHY
    // ------------------------------------------------------------
    uart_tx_phy #(
        .CLKS_PER_BIT (CLKS_PER_BIT),
        .PARITY_EN    (PARITY_EN),
        .EVEN_PARITY  (EVEN_PARITY)
    ) u_uart_tx_phy (
        .sys_clk      (sys_clk),
        .rst_n        (rst_n),
        .tx_en        (tx_en),

        .uart_tx_en   (uart_tx_en),
        .uart_tx_data (uart_tx_data),

        .TX           (TX),
        .uart_done    (uart_done)
    );

endmodule
