`timescale 1ns / 1ps

module seq_img_cluster #(
    parameter int unsigned IMG_WIDTH   = 256,
    parameter int unsigned IMG_HEIGHT  = 256,

    parameter int unsigned ROM_DEPTH   = 16384,
    parameter int unsigned ROM_WIDTH   = 32,
    parameter int unsigned ROM_ADDR_W  = 14,

    parameter int unsigned FIFO_WIDTH  = 24,
    parameter int unsigned FIFO_DEPTH  = 32,

    parameter string RED_INIT_FILE     = "red_hex.mem",
    parameter string GREEN_INIT_FILE   = "green_hex.mem",
    parameter string BLUE_INIT_FILE    = "blue_hex.mem"
) (
    // Image producer domain
    input logic wr_clk,
    input logic wr_rst_n,

    // UART / Composer consumer domain
    input logic rd_clk,
    input logic rd_rst_n,

    // Starts image transfer
    input  logic                            start,

    // Temporary external UART indication
    //input  logic                            uart_tx_ready,

    // FIFO pop side: will later connect to Composer
    input  logic                            fifo_pop_req,

    // FIFO thresholds: will later connect to RGF
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] ae_level,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] af_level,

    // FIFO output toward future Composer
    output logic [FIFO_WIDTH-1:0]           fifo_data_out,

    // FIFO status toward RGF / debug
    output logic [$clog2(FIFO_DEPTH+1)-1:0] fifo_level,
    output logic                            fifo_empty,
    output logic                            fifo_almost_empty,
    output logic                            fifo_half_full,
    output logic                            fifo_almost_full,
    output logic                            fifo_full,
    output logic                            fifo_error,

    // AHB Slave internal SRAM port
    input  logic                      sram_bus_en,
    input  logic                      sram_bus_write,
    input  logic [ROM_ADDR_W-1:0]     sram_bus_addr,

    input  logic [ROM_WIDTH-1:0]      sram_r_wdata,
    input  logic [ROM_WIDTH-1:0]      sram_g_wdata,
    input  logic [ROM_WIDTH-1:0]      sram_b_wdata,

    input  logic [3:0]                sram_byte_en,

    output logic [ROM_WIDTH-1:0]      sram_r_rdata,
    output logic [ROM_WIDTH-1:0]      sram_g_rdata,
    output logic [ROM_WIDTH-1:0]      sram_b_rdata,

    // Sequencer monitor outputs
    output logic [9:0]                      row_cnt,
    output logic [9:0]                      col_cnt,
    output logic                            transfer_done,
    output logic                            busy,
    output logic                            rts
    
);

    // ------------------------------------------------------------
    // Internal Sequencer SRAM read-port connections
    // ------------------------------------------------------------
    logic [ROM_ADDR_W-1:0] rom_addr;

    logic [ROM_WIDTH-1:0]  rom_r_data;
    logic [ROM_WIDTH-1:0]  rom_g_data;
    logic [ROM_WIDTH-1:0]  rom_b_data;

    // ------------------------------------------------------------
    // Internal Sequencer-to-FIFO connections
    // ------------------------------------------------------------
    logic                  fifo_wr_en;
    logic [FIFO_WIDTH-1:0] fifo_data_in;
    logic rom_pause;
    // ------------------------------------------------------------
    // RGB SRAM subsystem
    // ------------------------------------------------------------
    rgb_sram_subsystem #(
        .SRAM_DEPTH      (ROM_DEPTH),
        .WORD_WIDTH      (ROM_WIDTH),
        .ADDR_WIDTH      (ROM_ADDR_W),

        .RED_INIT_FILE   (RED_INIT_FILE),
        .GREEN_INIT_FILE (GREEN_INIT_FILE),
        .BLUE_INIT_FILE  (BLUE_INIT_FILE)
    ) u_rgb_sram_subsystem (
        .clk_i            (wr_clk),

        // Port A: Sequencer
        .seq_addr_i       (rom_addr),
        .seq_r_data_o     (rom_r_data),
        .seq_g_data_o     (rom_g_data),
        .seq_b_data_o     (rom_b_data),

        // Port B: AHB Slave
        .bus_en_i         (sram_bus_en),
        .bus_write_i      (sram_bus_write),
        .bus_addr_i       (sram_bus_addr),

        .bus_r_wdata_i    (sram_r_wdata),
        .bus_g_wdata_i    (sram_g_wdata),
        .bus_b_wdata_i    (sram_b_wdata),

        .bus_byte_en_i    (sram_byte_en),

        .bus_r_rdata_o    (sram_r_rdata),
        .bus_g_rdata_o    (sram_g_rdata),
        .bus_b_rdata_o    (sram_b_rdata)
    );

    // ------------------------------------------------------------
    // Sequencer
    // ------------------------------------------------------------
    sequencer #(
        .IMG_WIDTH  (IMG_WIDTH),
        .IMG_HEIGHT (IMG_HEIGHT),
        .ROM_DEPTH  (ROM_DEPTH),
        .ROM_ADDR_W (ROM_ADDR_W)
    ) u_sequencer (
        .clk              (wr_clk),
        .rst_n            (wr_rst_n),
        .start            (start),

        .rom_pause        (rom_pause),

        .rom_r_data       (rom_r_data),
        .rom_g_data       (rom_g_data),
        .rom_b_data       (rom_b_data),

        .fifo_wr_en       (fifo_wr_en),
        .fifo_data        (fifo_data_in),

        .rom_addr         (rom_addr),

        .row_cnt          (row_cnt),
        .col_cnt          (col_cnt),
        .transfer_done    (transfer_done),
        .busy             (busy),
        .rts              (rts)
    );
    
    // ------------------------------------------------------------
    // Sequencer TX image FIFO
    // ------------------------------------------------------------
    seq_tx_img_fifo #(
        .FIFO_WIDTH (FIFO_WIDTH),
        .FIFO_DEPTH (FIFO_DEPTH)
    ) u_seq_tx_img_fifo (
        .wr_clk          (wr_clk),
        .wr_rst_n        (wr_rst_n),
        .rd_clk          (rd_clk),
        .rd_rst_n        (rd_rst_n),

        .push_req     (fifo_wr_en),
        .pop_req      (fifo_pop_req),

        .data_in      (fifo_data_in),

        .ae_level     (ae_level),
        .af_level     (af_level),
        .rom_pause    (rom_pause),
        .data_out     (fifo_data_out),

        .fifo_level   (fifo_level),
        .empty        (fifo_empty),
        .almost_empty (fifo_almost_empty),
        .half_full    (fifo_half_full),
        .almost_full  (fifo_almost_full),
        .full         (fifo_full),
        .error        (fifo_error)
    );

endmodule