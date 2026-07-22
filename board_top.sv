`timescale 1ns / 1ps

module board_top (
    input  logic        CLK100MHZ,
    input  logic        CPU_RESETN,

    input  logic        RX,
    output logic        TX,

    // UART hardware flow control
    input  logic        UART_RTS,
    output logic        UART_CTS,

    output logic [15:0] LED
);

    import lab12_pkg::*;

    // =========================================================
    // FINAL-PROJECT CLOCKS AND RESETS
    // =========================================================
    logic clk_ctrl;
    logic clk_img;
    logic clk_uart;

    logic rst_ctrl_n;
    logic rst_img_n;
    logic rst_uart_n;

    logic pll_locked;
    logic clk_mux_sel_dbg;

    // Legacy RGF output retained for interface/debug compatibility.
    // It no longer controls the board clock mux.
    logic clk_sel;

    // =========================================================
    // STATUS AND DEBUG SIGNALS
    // =========================================================
    logic parity_enable_dbg;

    logic tx_en;
    logic cts_n;
    logic rts;

    logic seq_transfer_done;
    logic image_tx_done;

    logic seq_busy;
    logic composer_busy;
    logic packet_busy;

    logic uart_rx_busy;
    logic uart_tx_busy;

    logic [$clog2(FIFO_DEPTH+1)-1:0] fifo_level;

    logic fifo_empty;
    logic fifo_almost_empty;
    logic fifo_half_full;
    logic fifo_almost_full;
    logic fifo_full;
    logic fifo_error;

    logic [9:0] seq_row_cnt;
    logic [9:0] seq_col_cnt;

    logic [ROW_WIDTH-1:0] tx_row_cnt;
    logic [COL_WIDTH-1:0] tx_col_cnt;

    logic rx_frame_valid;
    logic rx_parse_error;
    logic rx_classifier_error;

    logic rgf_error;

    logic rx_parity_error_dbg;
    logic rx_framing_error_dbg;

    // =========================================================
    // FINAL-PROJECT CLOCK AND RESET WRAPPER
    // =========================================================
    // Keep the legacy instance name because lab12_timing_impl.xdc addresses
    // the clock mux through this hierarchy path.
    final_project_clock_wrapper u_lab12_clock_wrapper (
        .clk_100mhz (CLK100MHZ),
        .arst_n     (CPU_RESETN),

        .clk_sys    (clk_ctrl),
        .clk_fast   (clk_uart),

        .rst_sys_n  (rst_ctrl_n),
        .rst_fast_n (rst_uart_n),

        .pll_locked (pll_locked)
    );

    // The DMA, AHB and SRAM image path belongs to the 100 MHz system domain.
    // These aliases preserve chip_top's existing three-clock interface.
    assign clk_img   = clk_ctrl;
    assign rst_img_n = rst_ctrl_n;

    // Legacy debug alias: the fast clock selects 280 MHz after PLL lock.
    assign clk_mux_sel_dbg = pll_locked;

    // =========================================================
    // UART FLOW-CONTROL SYNCHRONIZATION
    // =========================================================
    logic uart_rts_sync;

    // UART_RTS is an asynchronous single-bit level.
    cdc_2ff_sync #(
        .RESET_VALUE (1'b1)
    ) u_uart_rts_2ff (
        .clk      (clk_uart),
        .rst_n    (rst_uart_n),
        .async_in (UART_RTS),
        .sync_out (uart_rts_sync)
    );

    // TX path is always enabled.
    assign tx_en = 1'b1;

    // Active-low permission for FPGA transmission.
    assign cts_n = uart_rts_sync;

    // Active-low receive flow control toward the PC:
    // 0 = FPGA may receive, 1 = PC must pause.
    assign UART_CTS = rts;

    // =========================================================
    // MAIN DESIGN
    // =========================================================
    chip_top dut (
        .clk_ctrl           (clk_ctrl),
        .rst_ctrl_n         (rst_ctrl_n),

        .clk_img            (clk_img),
        .rst_img_n          (rst_img_n),

        .clk_uart           (clk_uart),
        .rst_uart_n         (rst_uart_n),

        // Image transmission is started through a UART command.
        .start              (1'b0),

        .RX                 (RX),

        .tx_en              (tx_en),
        .cts_n              (cts_n),

        .TX                 (TX),
        .rts                (rts),

        .clk_sel            (clk_sel),

        // AHB-Lite master connection toward the image SRAM subsystem

        .seq_transfer_done  (seq_transfer_done),
        .image_tx_done      (image_tx_done),

        .seq_busy           (seq_busy),
        .composer_busy      (composer_busy),
        .packet_busy        (packet_busy),

        .fifo_level         (fifo_level),
        .fifo_empty         (fifo_empty),
        .fifo_almost_empty  (fifo_almost_empty),
        .fifo_half_full     (fifo_half_full),
        .fifo_almost_full   (fifo_almost_full),
        .fifo_full          (fifo_full),
        .fifo_error         (fifo_error),

        .seq_row_cnt        (seq_row_cnt),
        .seq_col_cnt        (seq_col_cnt),

        .tx_row_cnt         (tx_row_cnt),
        .tx_col_cnt         (tx_col_cnt),

        .rx_frame_valid       (rx_frame_valid),
        .rx_parse_error       (rx_parse_error),
        .rx_classifier_error  (rx_classifier_error),

        .rgf_error            (rgf_error),

        .rx_parity_error_dbg  (rx_parity_error_dbg),
        .rx_framing_error_dbg (rx_framing_error_dbg),
        .parity_enable_dbg    (parity_enable_dbg),

        .uart_rx_busy         (uart_rx_busy),
        .uart_tx_busy         (uart_tx_busy)
    );

    // =========================================================
    // LED DEBUG OUTPUTS
    // =========================================================
    assign LED[0]  = rx_frame_valid;
    assign LED[1]  = seq_busy;
    assign LED[2]  = seq_transfer_done;
    assign LED[3]  = composer_busy;
    assign LED[4]  = packet_busy;
    assign LED[5]  = image_tx_done;

    assign LED[6]  = fifo_empty;
    assign LED[7]  = fifo_half_full;
    assign LED[8]  = fifo_almost_empty;
    assign LED[9]  = fifo_almost_full;
    assign LED[10] = fifo_full;
    assign LED[11] = fifo_error;

    assign LED[12] = rx_parse_error;
    assign LED[13] = rx_classifier_error;

    assign LED[14] =
        rgf_error             |
        rx_parity_error_dbg   |
        rx_framing_error_dbg;

    assign LED[15] =
        parity_enable_dbg |
        clk_sel           |
        pll_locked        |
        clk_mux_sel_dbg   |
        rts               |
        uart_rx_busy      |
        uart_tx_busy      |
        (|fifo_level)     |
        (|seq_row_cnt)    |
        (|seq_col_cnt)    |
        (|tx_row_cnt)     |
        (|tx_col_cnt);

endmodule
