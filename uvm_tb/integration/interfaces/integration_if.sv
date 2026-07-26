`ifndef INTEGRATION_IF_SV
`define INTEGRATION_IF_SV

interface integration_if;

    // =========================================================
    // Clocks and resets
    // =========================================================
    logic clk_ctrl;
    logic rst_ctrl_n;

    logic clk_img;
    logic rst_img_n;

    logic clk_uart;
    logic rst_uart_n;

    // =========================================================
    // External DUT inputs
    // =========================================================
    logic start;
    logic RX;
    logic tx_en;
    logic cts_n;

    // =========================================================
    // UART and flow-control outputs
    // =========================================================
    logic TX;
    logic rts;
    logic clk_sel;

    // =========================================================
    // Status outputs
    // =========================================================
    logic seq_transfer_done;
    logic image_tx_done;

    logic seq_busy;
    logic composer_busy;
    logic packet_busy;

    logic [$clog2(lab12_pkg::FIFO_DEPTH + 1)-1:0]
        fifo_level;

    logic fifo_empty;
    logic fifo_almost_empty;
    logic fifo_half_full;
    logic fifo_almost_full;
    logic fifo_full;
    logic fifo_error;

    logic [9:0] seq_row_cnt;
    logic [9:0] seq_col_cnt;

    logic [lab12_pkg::ROW_WIDTH-1:0]
        tx_row_cnt;

    logic [lab12_pkg::COL_WIDTH-1:0]
        tx_col_cnt;

    logic rx_frame_valid;
    logic rx_parse_error;
    logic rx_classifier_error;
    logic rgf_error;

    logic rx_parity_error_dbg;
    logic rx_framing_error_dbg;
    logic parity_enable_dbg;

    logic uart_rx_busy;
    logic uart_tx_busy;

endinterface

`endif
