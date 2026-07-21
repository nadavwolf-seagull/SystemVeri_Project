`timescale 1ns / 1ps

// CDC and memory boundary for the final-project datapath.
module final_project_memory_cluster #(
    parameter int unsigned FIFO_WIDTH = lab12_pkg::RGB_FIFO_WIDTH,
    parameter int unsigned FIFO_DEPTH = lab12_pkg::FIFO_DEPTH,
    parameter int unsigned SRAM_DEPTH = lab12_pkg::ROM_DEPTH,
    parameter int unsigned SRAM_ADDR_W = lab12_pkg::ROM_ADDR_WIDTH
) (
    input  logic clk_fast,
    input  logic rst_fast_n,

    ahb_lite_if.slave ahb,

    // Fast RX producer: deinterleaver writes aligned RGB triples.
    input  logic                  rx_push_fast,
    input  logic [FIFO_WIDTH-1:0] rx_r_data_fast,
    input  logic [FIFO_WIDTH-1:0] rx_g_data_fast,
    input  logic [FIFO_WIDTH-1:0] rx_b_data_fast,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] rx_af_free_level_fast,
    output logic                  rx_ready_fast,
    output logic                  rx_almost_full_fast,
    output logic                  rx_overflow_fast,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] rx_level_fast,

    // System RX consumer: DMA pops one color at a time.
    input  logic [2:0]            rx_pop_sys,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] rx_ae_level_sys,
    output logic [FIFO_WIDTH-1:0] rx_r_data_sys,
    output logic [FIFO_WIDTH-1:0] rx_g_data_sys,
    output logic [FIFO_WIDTH-1:0] rx_b_data_sys,
    output logic [2:0]            rx_data_valid_sys,
    output logic [2:0]            rx_empty_sys,
    output logic                  rx_underflow_sys,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] rx_level_sys,

    // System TX producer: DMA pushes one color at a time.
    input  logic [2:0]            tx_push_sys,
    input  logic [FIFO_WIDTH-1:0] tx_r_data_sys,
    input  logic [FIFO_WIDTH-1:0] tx_g_data_sys,
    input  logic [FIFO_WIDTH-1:0] tx_b_data_sys,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] tx_af_free_level_sys,
    output logic [2:0]            tx_ready_sys,
    output logic [2:0]            tx_almost_full_sys,
    output logic                  tx_overflow_sys,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] tx_level_sys,

    // Fast TX consumer: packer reads an aligned RGB triple.
    input  logic                  tx_pop_fast,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] tx_ae_level_fast,
    output logic [FIFO_WIDTH-1:0] tx_r_data_fast,
    output logic [FIFO_WIDTH-1:0] tx_g_data_fast,
    output logic [FIFO_WIDTH-1:0] tx_b_data_fast,
    output logic                  tx_data_valid_fast,
    output logic                  tx_empty_fast,
    output logic                  tx_underflow_fast,
    output logic [$clog2(FIFO_DEPTH+1)-1:0] tx_level_fast
);

    localparam int unsigned LEVEL_W = $clog2(FIFO_DEPTH + 1);

    logic [2:0] rx_wr_push;
    logic [2:0] rx_wr_ready;
    logic [2:0] rx_wr_full;
    logic [2:0] rx_wr_almost_full;
    logic [2:0] rx_wr_overflow;
    logic [2:0] rx_rd_almost_empty;
    logic [2:0] rx_rd_underflow;

    logic [2:0] tx_wr_full;
    logic [2:0] tx_wr_overflow;
    logic [2:0] tx_rd_pop;
    logic [2:0] tx_rd_valid;
    logic [2:0] tx_rd_empty;
    logic [2:0] tx_rd_almost_empty;
    logic [2:0] tx_rd_underflow;

    logic [LEVEL_W-1:0] rx_wr_level_r, rx_wr_level_g, rx_wr_level_b;
    logic [LEVEL_W-1:0] rx_rd_level_r, rx_rd_level_g, rx_rd_level_b;
    logic [LEVEL_W-1:0] tx_wr_level_r, tx_wr_level_g, tx_wr_level_b;
    logic [LEVEL_W-1:0] tx_rd_level_r, tx_rd_level_g, tx_rd_level_b;

    function automatic logic [LEVEL_W-1:0] max3(
        input logic [LEVEL_W-1:0] a,
        input logic [LEVEL_W-1:0] b,
        input logic [LEVEL_W-1:0] c
    );
        logic [LEVEL_W-1:0] ab_max;
        begin
            ab_max = (a >= b) ? a : b;
            max3   = (ab_max >= c) ? ab_max : c;
        end
    endfunction

    function automatic logic [LEVEL_W-1:0] min3(
        input logic [LEVEL_W-1:0] a,
        input logic [LEVEL_W-1:0] b,
        input logic [LEVEL_W-1:0] c
    );
        logic [LEVEL_W-1:0] ab_min;
        begin
            ab_min = (a <= b) ? a : b;
            min3   = (ab_min <= c) ? ab_min : c;
        end
    endfunction

    assign rx_ready_fast       = &rx_wr_ready;
    assign rx_almost_full_fast = |rx_wr_almost_full;
    assign rx_wr_push           = {3{rx_push_fast && rx_ready_fast}};
    assign rx_overflow_fast     = (rx_push_fast && !rx_ready_fast) |
                                  (|rx_wr_overflow);
    assign rx_underflow_sys     = |rx_rd_underflow;

    // RX fast/system levels summarize the most constrained view in each
    // domain. Maximum write occupancy is conservative for backpressure;
    // minimum read occupancy counts complete RGB groups available to DMA.
    assign rx_level_fast = max3(rx_wr_level_r, rx_wr_level_g, rx_wr_level_b);
    assign rx_level_sys  = min3(rx_rd_level_r, rx_rd_level_g, rx_rd_level_b);

    assign tx_empty_fast        = |tx_rd_empty;
    assign tx_rd_pop            = {3{tx_pop_fast && !tx_empty_fast}};
    assign tx_data_valid_fast   = &tx_rd_valid;
    assign tx_underflow_fast    = (tx_pop_fast && tx_empty_fast) |
                                  (|tx_rd_underflow);
    assign tx_overflow_sys      = |tx_wr_overflow;
    assign tx_level_sys  = max3(tx_wr_level_r, tx_wr_level_g, tx_wr_level_b);
    assign tx_level_fast = min3(tx_rd_level_r, tx_rd_level_g, tx_rd_level_b);

    rgb_async_fifo_bank #(
        .DATA_WIDTH(FIFO_WIDTH),
        .DEPTH     (FIFO_DEPTH)
    ) u_rx_fifo_bank (
        .wr_clk            (clk_fast),
        .wr_rst_n          (rst_fast_n),
        .wr_push           (rx_wr_push),
        .wr_r_data         (rx_r_data_fast),
        .wr_g_data         (rx_g_data_fast),
        .wr_b_data         (rx_b_data_fast),
        .wr_af_free_level  (rx_af_free_level_fast),
        .wr_ready          (rx_wr_ready),
        .wr_full           (rx_wr_full),
        .wr_almost_full    (rx_wr_almost_full),
        .wr_level_r        (rx_wr_level_r),
        .wr_level_g        (rx_wr_level_g),
        .wr_level_b        (rx_wr_level_b),
        .wr_overflow       (rx_wr_overflow),
        .rd_clk            (ahb.HCLK),
        .rd_rst_n          (ahb.HRESETn),
        .rd_pop            (rx_pop_sys),
        .rd_ae_level       (rx_ae_level_sys),
        .rd_r_data         (rx_r_data_sys),
        .rd_g_data         (rx_g_data_sys),
        .rd_b_data         (rx_b_data_sys),
        .rd_data_valid     (rx_data_valid_sys),
        .rd_empty          (rx_empty_sys),
        .rd_almost_empty   (rx_rd_almost_empty),
        .rd_level_r        (rx_rd_level_r),
        .rd_level_g        (rx_rd_level_g),
        .rd_level_b        (rx_rd_level_b),
        .rd_underflow      (rx_rd_underflow)
    );

    rgb_async_fifo_bank #(
        .DATA_WIDTH(FIFO_WIDTH),
        .DEPTH     (FIFO_DEPTH)
    ) u_tx_fifo_bank (
        .wr_clk            (ahb.HCLK),
        .wr_rst_n          (ahb.HRESETn),
        .wr_push           (tx_push_sys),
        .wr_r_data         (tx_r_data_sys),
        .wr_g_data         (tx_g_data_sys),
        .wr_b_data         (tx_b_data_sys),
        .wr_af_free_level  (tx_af_free_level_sys),
        .wr_ready          (tx_ready_sys),
        .wr_full           (tx_wr_full),
        .wr_almost_full    (tx_almost_full_sys),
        .wr_level_r        (tx_wr_level_r),
        .wr_level_g        (tx_wr_level_g),
        .wr_level_b        (tx_wr_level_b),
        .wr_overflow       (tx_wr_overflow),
        .rd_clk            (clk_fast),
        .rd_rst_n          (rst_fast_n),
        .rd_pop            (tx_rd_pop),
        .rd_ae_level       (tx_ae_level_fast),
        .rd_r_data         (tx_r_data_fast),
        .rd_g_data         (tx_g_data_fast),
        .rd_b_data         (tx_b_data_fast),
        .rd_data_valid     (tx_rd_valid),
        .rd_empty          (tx_rd_empty),
        .rd_almost_empty   (tx_rd_almost_empty),
        .rd_level_r        (tx_rd_level_r),
        .rd_level_g        (tx_rd_level_g),
        .rd_level_b        (tx_rd_level_b),
        .rd_underflow      (tx_rd_underflow)
    );

    ahb_rgb_sram_subsystem #(
        .SRAM_DEPTH (SRAM_DEPTH),
        .SRAM_ADDR_W(SRAM_ADDR_W)
    ) u_ahb_rgb_sram_subsystem (
        .ahb(ahb)
    );

endmodule
