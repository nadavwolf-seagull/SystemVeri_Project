`timescale 1ns / 1ps

// Three independent asynchronous FIFOs, one per color channel.
// The surrounding cluster may use common operations on one side and
// per-channel operations on the DMA side.
module rgb_async_fifo_bank #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned DEPTH = 32
) (
    input  logic                         wr_clk,
    input  logic                         wr_rst_n,
    input  logic [2:0]                   wr_push,
    input  logic [DATA_WIDTH-1:0]        wr_r_data,
    input  logic [DATA_WIDTH-1:0]        wr_g_data,
    input  logic [DATA_WIDTH-1:0]        wr_b_data,
    input  logic [$clog2(DEPTH+1)-1:0]  wr_af_free_level,
    output logic [2:0]                   wr_ready,
    output logic [2:0]                   wr_full,
    output logic [2:0]                   wr_almost_full,
    output logic [$clog2(DEPTH+1)-1:0]  wr_level_r,
    output logic [$clog2(DEPTH+1)-1:0]  wr_level_g,
    output logic [$clog2(DEPTH+1)-1:0]  wr_level_b,
    output logic [2:0]                   wr_overflow,

    input  logic                         rd_clk,
    input  logic                         rd_rst_n,
    input  logic [2:0]                   rd_pop,
    input  logic [$clog2(DEPTH+1)-1:0]  rd_ae_level,
    output logic [DATA_WIDTH-1:0]        rd_r_data,
    output logic [DATA_WIDTH-1:0]        rd_g_data,
    output logic [DATA_WIDTH-1:0]        rd_b_data,
    output logic [2:0]                   rd_data_valid,
    output logic [2:0]                   rd_empty,
    output logic [2:0]                   rd_almost_empty,
    output logic [$clog2(DEPTH+1)-1:0]  rd_level_r,
    output logic [$clog2(DEPTH+1)-1:0]  rd_level_g,
    output logic [$clog2(DEPTH+1)-1:0]  rd_level_b,
    output logic [2:0]                   rd_underflow
);

    assign wr_ready = ~wr_full;

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) u_r_fifo (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n),
        .wr_push(wr_push[0]), .wr_data(wr_r_data),
        .wr_af_free_level(wr_af_free_level),
        .wr_full(wr_full[0]), .wr_almost_full(wr_almost_full[0]),
        .wr_level(wr_level_r), .wr_overflow(wr_overflow[0]),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n),
        .rd_pop(rd_pop[0]), .rd_ae_level(rd_ae_level),
        .rd_data(rd_r_data), .rd_data_valid(rd_data_valid[0]),
        .rd_empty(rd_empty[0]), .rd_almost_empty(rd_almost_empty[0]),
        .rd_level(rd_level_r), .rd_underflow(rd_underflow[0])
    );

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) u_g_fifo (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n),
        .wr_push(wr_push[1]), .wr_data(wr_g_data),
        .wr_af_free_level(wr_af_free_level),
        .wr_full(wr_full[1]), .wr_almost_full(wr_almost_full[1]),
        .wr_level(wr_level_g), .wr_overflow(wr_overflow[1]),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n),
        .rd_pop(rd_pop[1]), .rd_ae_level(rd_ae_level),
        .rd_data(rd_g_data), .rd_data_valid(rd_data_valid[1]),
        .rd_empty(rd_empty[1]), .rd_almost_empty(rd_almost_empty[1]),
        .rd_level(rd_level_g), .rd_underflow(rd_underflow[1])
    );

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) u_b_fifo (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n),
        .wr_push(wr_push[2]), .wr_data(wr_b_data),
        .wr_af_free_level(wr_af_free_level),
        .wr_full(wr_full[2]), .wr_almost_full(wr_almost_full[2]),
        .wr_level(wr_level_b), .wr_overflow(wr_overflow[2]),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n),
        .rd_pop(rd_pop[2]), .rd_ae_level(rd_ae_level),
        .rd_data(rd_b_data), .rd_data_valid(rd_data_valid[2]),
        .rd_empty(rd_empty[2]), .rd_almost_empty(rd_almost_empty[2]),
        .rd_level(rd_level_b), .rd_underflow(rd_underflow[2])
    );

endmodule
