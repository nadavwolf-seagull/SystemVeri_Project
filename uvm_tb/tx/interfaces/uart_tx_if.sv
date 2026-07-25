interface uart_tx_if #(
    parameter int unsigned MAX_PACKET_BYTES =
        lab12_pkg::UART_TX_MAX_PACKET_BYTES,

    parameter int unsigned MAX_PACKET_WIDTH =
        lab12_pkg::UART_TX_MAX_PACKET_WIDTH,

    parameter int unsigned PACKET_LEN_WIDTH =
        lab12_pkg::UART_TX_PACKET_LEN_WIDTH
) (
    input logic sys_clk
);

    logic rst_n;
    logic tx_en;
    logic cts_n;

    logic                        packet_valid;
    logic [MAX_PACKET_WIDTH-1:0] packet_data;
    logic [PACKET_LEN_WIDTH-1:0] packet_len;
    logic                        packet_ready;

    logic packet_busy;
    logic packet_done;

    logic TX;

endinterface