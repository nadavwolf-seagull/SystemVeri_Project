`timescale 1ns / 1ps

// Complete integration boundary owned by the memory/CDC partner.
// It contains six physical FIFOs (two RGB banks) and the AHB RGB SRAM.
module final_project_memory_cluster #(
    parameter int unsigned FIFO_WIDTH = lab12_pkg::RGB_FIFO_WIDTH,
    parameter int unsigned FIFO_DEPTH = lab12_pkg::FIFO_DEPTH,
    parameter int unsigned SRAM_DEPTH = lab12_pkg::ROM_DEPTH,
    parameter int unsigned SRAM_ADDR_W = lab12_pkg::ROM_ADDR_WIDTH
) (
    input  logic clk_uart,
    input  logic rst_uart_n,

    // 100 MHz AHB connection. ahb.HCLK/HRESETn are also the DMA clock/reset.
    ahb_lite_if.slave ahb,

    // RX image stream: partner 1 (280 MHz) -> DMA (100 MHz)
    input  logic                    rx_push_uart,
    input  logic [FIFO_WIDTH-1:0]   rx_r_data_uart,
    input  logic [FIFO_WIDTH-1:0]   rx_g_data_uart,
    input  logic [FIFO_WIDTH-1:0]   rx_b_data_uart,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] rx_af_free_level_uart,
    output logic                    rx_ready_uart,
    output logic                    rx_almost_full_uart,
    output logic                    rx_overflow_uart,

    input  logic                    rx_pop_sys,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] rx_ae_level_sys,
    output logic [FIFO_WIDTH-1:0]   rx_r_data_sys,
    output logic [FIFO_WIDTH-1:0]   rx_g_data_sys,
    output logic [FIFO_WIDTH-1:0]   rx_b_data_sys,
    output logic                    rx_data_valid_sys,
    output logic                    rx_empty_sys,
    output logic                    rx_underflow_sys,

    // TX image stream: DMA (100 MHz) -> partner 1 (280 MHz)
    input  logic                    tx_push_sys,
    input  logic [FIFO_WIDTH-1:0]   tx_r_data_sys,
    input  logic [FIFO_WIDTH-1:0]   tx_g_data_sys,
    input  logic [FIFO_WIDTH-1:0]   tx_b_data_sys,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] tx_af_free_level_sys,
    output logic                    tx_ready_sys,
    output logic                    tx_almost_full_sys,
    output logic                    tx_overflow_sys,

    input  logic                    tx_pop_uart,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] tx_ae_level_uart,
    output logic [FIFO_WIDTH-1:0]   tx_r_data_uart,
    output logic [FIFO_WIDTH-1:0]   tx_g_data_uart,
    output logic [FIFO_WIDTH-1:0]   tx_b_data_uart,
    output logic                    tx_data_valid_uart,
    output logic                    tx_empty_uart,
    output logic                    tx_underflow_uart
);

    logic rx_full_uart;
    logic rx_almost_empty_sys;
    logic [$clog2(FIFO_DEPTH+1)-1:0] rx_wr_level_uart;
    logic [$clog2(FIFO_DEPTH+1)-1:0] rx_rd_level_sys;

    logic tx_full_sys;
    logic tx_almost_empty_uart;
    logic [$clog2(FIFO_DEPTH+1)-1:0] tx_wr_level_sys;
    logic [$clog2(FIFO_DEPTH+1)-1:0] tx_rd_level_uart;

    rgb_async_fifo_bank #(
        .DATA_WIDTH (FIFO_WIDTH),
        .DEPTH      (FIFO_DEPTH)
    ) u_rx_rgb_fifo_bank (
        .wr_clk              (clk_uart),
        .wr_rst_n            (rst_uart_n),
        .wr_push             (rx_push_uart),
        .wr_r_data           (rx_r_data_uart),
        .wr_g_data           (rx_g_data_uart),
        .wr_b_data           (rx_b_data_uart),
        .wr_af_free_level    (rx_af_free_level_uart),
        .wr_ready            (rx_ready_uart),
        .wr_full             (rx_full_uart),
        .wr_almost_full      (rx_almost_full_uart),
        .wr_level            (rx_wr_level_uart),
        .wr_overflow         (rx_overflow_uart),
        .rd_clk              (ahb.HCLK),
        .rd_rst_n            (ahb.HRESETn),
        .rd_pop              (rx_pop_sys),
        .rd_ae_level         (rx_ae_level_sys),
        .rd_r_data           (rx_r_data_sys),
        .rd_g_data           (rx_g_data_sys),
        .rd_b_data           (rx_b_data_sys),
        .rd_data_valid       (rx_data_valid_sys),
        .rd_empty            (rx_empty_sys),
        .rd_almost_empty     (rx_almost_empty_sys),
        .rd_level            (rx_rd_level_sys),
        .rd_underflow        (rx_underflow_sys)
    );

    rgb_async_fifo_bank #(
        .DATA_WIDTH (FIFO_WIDTH),
        .DEPTH      (FIFO_DEPTH)
    ) u_tx_rgb_fifo_bank (
        .wr_clk              (ahb.HCLK),
        .wr_rst_n            (ahb.HRESETn),
        .wr_push             (tx_push_sys),
        .wr_r_data           (tx_r_data_sys),
        .wr_g_data           (tx_g_data_sys),
        .wr_b_data           (tx_b_data_sys),
        .wr_af_free_level    (tx_af_free_level_sys),
        .wr_ready            (tx_ready_sys),
        .wr_full             (tx_full_sys),
        .wr_almost_full      (tx_almost_full_sys),
        .wr_level            (tx_wr_level_sys),
        .wr_overflow         (tx_overflow_sys),
        .rd_clk              (clk_uart),
        .rd_rst_n            (rst_uart_n),
        .rd_pop              (tx_pop_uart),
        .rd_ae_level         (tx_ae_level_uart),
        .rd_r_data           (tx_r_data_uart),
        .rd_g_data           (tx_g_data_uart),
        .rd_b_data           (tx_b_data_uart),
        .rd_data_valid       (tx_data_valid_uart),
        .rd_empty            (tx_empty_uart),
        .rd_almost_empty     (tx_almost_empty_uart),
        .rd_level            (tx_rd_level_uart),
        .rd_underflow        (tx_underflow_uart)
    );

    ahb_rgb_sram_subsystem #(
        .SRAM_DEPTH (SRAM_DEPTH),
        .SRAM_ADDR_W(SRAM_ADDR_W)
    ) u_ahb_rgb_sram_subsystem (
        .ahb (ahb)
    );

endmodule
