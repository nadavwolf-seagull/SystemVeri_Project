`timescale 1ns / 1ps

// Integration boundary for partner 2 + partner 3 logic. Partner 1 connects
// the BAR/RGF command ports and the fast-domain deinterleaver/packer ports.
module final_project_dma_cluster #(
    parameter int unsigned FIFO_DEPTH = lab12_pkg::FIFO_DEPTH
) (
    input  logic clk_fast,
    input  logic rst_fast_n,
    input  logic clk_sys,
    input  logic rst_sys_n,

    // RGF control/status, already in the 100 MHz system domain.
    input  logic        dma_wr_start,
    input  logic        dma_rd_start,
    input  logic [23:0] img_base,
    input  logic [15:0] img_width,
    input  logic [15:0] img_height,
    output logic        dma_busy,
    output logic        dma_done,
    output logic        dma_error,
    output logic [15:0] wr_row_cnt,
    output logic [15:0] wr_col_cnt,
    output logic [15:0] rd_row_cnt,
    output logic [15:0] rd_col_cnt,

    // BAR single-pixel command/response, in the system domain.
    input  logic                                  bar_cmd_valid,
    output logic                                  bar_cmd_ready,
    input  logic                                  bar_cmd_write,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]  bar_cmd_addr,
    input  logic [lab12_pkg::CMD_DATA_WIDTH-1:0]  bar_cmd_data,
    output logic                                  bar_rsp_valid,
    input  logic                                  bar_rsp_ready,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]  bar_rsp_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0]  bar_rsp_data,
    output logic                                  bar_rsp_error,
    output logic                                  ahb_error_pulse,

    // Deinterleaver -> RX FIFO bank, fast domain.
    input  logic        rx_push_fast,
    input  logic [31:0] rx_r_data_fast,
    input  logic [31:0] rx_g_data_fast,
    input  logic [31:0] rx_b_data_fast,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] rx_af_free_level_fast,
    output logic        rx_ready_fast,
    output logic        rx_almost_full_fast,
    output logic        rx_overflow_fast,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] rx_level_fast,

    // TX FIFO bank -> packer, fast domain.
    input  logic        tx_pop_fast,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] tx_ae_level_fast,
    output logic [31:0] tx_r_data_fast,
    output logic [31:0] tx_g_data_fast,
    output logic [31:0] tx_b_data_fast,
    output logic        tx_data_valid_fast,
    output logic        tx_empty_fast,
    output logic        tx_underflow_fast,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] tx_level_fast,

    // System-domain FIFO error summaries for RGF/debug.
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] rx_ae_level_sys,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] tx_af_free_level_sys,
    output logic        rx_underflow_sys,
    output logic        tx_overflow_sys,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] rx_level_sys,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] tx_level_sys
);

    ahb_lite_if ahb (
        .HCLK   (clk_sys),
        .HRESETn(rst_sys_n)
    );

    logic seq_cmd_valid;
    logic seq_cmd_ready;
    logic seq_cmd_write;
    logic [23:0] seq_cmd_addr;
    logic [127:0] seq_cmd_wdata;
    logic seq_rsp_valid;
    logic seq_rsp_ready;
    logic seq_rsp_error;
    logic [127:0] seq_rsp_rdata;

    logic [2:0] rx_pop_sys;
    logic [31:0] rx_r_data_sys;
    logic [31:0] rx_g_data_sys;
    logic [31:0] rx_b_data_sys;
    logic [2:0] rx_data_valid_sys;
    logic [2:0] rx_empty_sys;

    logic [2:0] tx_push_sys;
    logic [31:0] tx_r_data_sys;
    logic [31:0] tx_g_data_sys;
    logic [31:0] tx_b_data_sys;
    logic [2:0] tx_ready_sys;
    logic [2:0] tx_almost_full_sys;

    logic ahb_bar_cmd_ready;
    logic bar_access_allowed;

    // Preserve image-transfer atomicity. A BAR request may be held valid while
    // DMA is active, but it is accepted only after dma_busy returns low. Start
    // pulses are included so a BAR request cannot slip in on the start cycle.
    assign bar_access_allowed =
        !dma_busy && !dma_wr_start && !dma_rd_start;
    assign bar_cmd_ready = ahb_bar_cmd_ready && bar_access_allowed;

    rgb_dma_sequencer u_sequencer (
        .clk               (clk_sys),
        .rst_n             (rst_sys_n),
        .dma_wr_start      (dma_wr_start),
        .dma_rd_start      (dma_rd_start),
        .img_base          (img_base),
        .img_width         (img_width),
        .img_height        (img_height),
        .busy              (dma_busy),
        .done              (dma_done),
        .error             (dma_error),
        .wr_row_cnt        (wr_row_cnt),
        .wr_col_cnt        (wr_col_cnt),
        .rd_row_cnt        (rd_row_cnt),
        .rd_col_cnt        (rd_col_cnt),
        .seq_cmd_valid     (seq_cmd_valid),
        .seq_cmd_ready     (seq_cmd_ready),
        .seq_cmd_write     (seq_cmd_write),
        .seq_cmd_addr      (seq_cmd_addr),
        .seq_cmd_wdata     (seq_cmd_wdata),
        .seq_rsp_valid     (seq_rsp_valid),
        .seq_rsp_ready     (seq_rsp_ready),
        .seq_rsp_error     (seq_rsp_error),
        .seq_rsp_rdata     (seq_rsp_rdata),
        .rx_fifo_empty     (rx_empty_sys),
        .rx_fifo_data_valid(rx_data_valid_sys),
        .rx_fifo_r_data    (rx_r_data_sys),
        .rx_fifo_g_data    (rx_g_data_sys),
        .rx_fifo_b_data    (rx_b_data_sys),
        .rx_fifo_pop       (rx_pop_sys),
        .tx_fifo_ready     (tx_ready_sys),
        .tx_fifo_push      (tx_push_sys),
        .tx_fifo_r_data    (tx_r_data_sys),
        .tx_fifo_g_data    (tx_g_data_sys),
        .tx_fifo_b_data    (tx_b_data_sys)
    );

    final_project_ahb_master_fsm u_ahb_master_fsm (
        .clk             (clk_sys),
        .rst_n           (rst_sys_n),
        .bar_cmd_valid   (bar_cmd_valid && bar_access_allowed),
        .bar_cmd_ready   (ahb_bar_cmd_ready),
        .bar_cmd_write   (bar_cmd_write),
        .bar_cmd_addr    (bar_cmd_addr),
        .bar_cmd_data    (bar_cmd_data),
        .bar_rsp_valid   (bar_rsp_valid),
        .bar_rsp_ready   (bar_rsp_ready),
        .bar_rsp_addr    (bar_rsp_addr),
        .bar_rsp_data    (bar_rsp_data),
        .bar_rsp_error   (bar_rsp_error),
        .seq_cmd_valid   (seq_cmd_valid),
        .seq_cmd_ready   (seq_cmd_ready),
        .seq_cmd_write   (seq_cmd_write),
        .seq_cmd_addr    (seq_cmd_addr),
        .seq_cmd_wdata   (seq_cmd_wdata),
        .seq_rsp_valid   (seq_rsp_valid),
        .seq_rsp_ready   (seq_rsp_ready),
        .seq_rsp_error   (seq_rsp_error),
        .seq_rsp_rdata   (seq_rsp_rdata),
        .ahb_error_pulse (ahb_error_pulse),
        .ahb             (ahb)
    );

    final_project_memory_cluster #(
        .FIFO_WIDTH(32),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) u_memory_cluster (
        .clk_fast              (clk_fast),
        .rst_fast_n            (rst_fast_n),
        .ahb                   (ahb),
        .rx_push_fast          (rx_push_fast),
        .rx_r_data_fast        (rx_r_data_fast),
        .rx_g_data_fast        (rx_g_data_fast),
        .rx_b_data_fast        (rx_b_data_fast),
        .rx_af_free_level_fast (rx_af_free_level_fast),
        .rx_ready_fast         (rx_ready_fast),
        .rx_almost_full_fast   (rx_almost_full_fast),
        .rx_overflow_fast      (rx_overflow_fast),
        .rx_level_fast         (rx_level_fast),
        .rx_pop_sys            (rx_pop_sys),
        .rx_ae_level_sys       (rx_ae_level_sys),
        .rx_r_data_sys         (rx_r_data_sys),
        .rx_g_data_sys         (rx_g_data_sys),
        .rx_b_data_sys         (rx_b_data_sys),
        .rx_data_valid_sys     (rx_data_valid_sys),
        .rx_empty_sys          (rx_empty_sys),
        .rx_underflow_sys      (rx_underflow_sys),
        .rx_level_sys          (rx_level_sys),
        .tx_push_sys           (tx_push_sys),
        .tx_r_data_sys         (tx_r_data_sys),
        .tx_g_data_sys         (tx_g_data_sys),
        .tx_b_data_sys         (tx_b_data_sys),
        .tx_af_free_level_sys  (tx_af_free_level_sys),
        .tx_ready_sys          (tx_ready_sys),
        .tx_almost_full_sys    (tx_almost_full_sys),
        .tx_overflow_sys       (tx_overflow_sys),
        .tx_level_sys          (tx_level_sys),
        .tx_pop_fast           (tx_pop_fast),
        .tx_ae_level_fast      (tx_ae_level_fast),
        .tx_r_data_fast        (tx_r_data_fast),
        .tx_g_data_fast        (tx_g_data_fast),
        .tx_b_data_fast        (tx_b_data_fast),
        .tx_data_valid_fast    (tx_data_valid_fast),
        .tx_empty_fast         (tx_empty_fast),
        .tx_underflow_fast     (tx_underflow_fast),
        .tx_level_fast         (tx_level_fast)
    );

endmodule
