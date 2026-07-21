`timescale 1ns / 1ps

// A lock-step bank of three asynchronous FIFOs, one per color channel.
// Each accepted push/pop operates on R, G, and B together.
module rgb_async_fifo_bank #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned DEPTH = 32
) (
    input  logic                         wr_clk,
    input  logic                         wr_rst_n,
    input  logic                         wr_push,
    input  logic [DATA_WIDTH-1:0]        wr_r_data,
    input  logic [DATA_WIDTH-1:0]        wr_g_data,
    input  logic [DATA_WIDTH-1:0]        wr_b_data,
    input  logic [$clog2(DEPTH+1)-1:0]  wr_af_free_level,
    output logic                         wr_ready,
    output logic                         wr_full,
    output logic                         wr_almost_full,
    output logic [$clog2(DEPTH+1)-1:0]  wr_level,
    output logic                         wr_overflow,

    input  logic                         rd_clk,
    input  logic                         rd_rst_n,
    input  logic                         rd_pop,
    input  logic [$clog2(DEPTH+1)-1:0]  rd_ae_level,
    output logic [DATA_WIDTH-1:0]        rd_r_data,
    output logic [DATA_WIDTH-1:0]        rd_g_data,
    output logic [DATA_WIDTH-1:0]        rd_b_data,
    output logic                         rd_data_valid,
    output logic                         rd_empty,
    output logic                         rd_almost_empty,
    output logic [$clog2(DEPTH+1)-1:0]  rd_level,
    output logic                         rd_underflow
);

    logic [2:0] channel_full;
    logic [2:0] channel_almost_full;
    logic [2:0] channel_empty;
    logic [2:0] channel_almost_empty;
    logic [2:0] channel_data_valid;
    logic [2:0] channel_overflow;
    logic [2:0] channel_underflow;

    logic [$clog2(DEPTH+1)-1:0] wr_level_r, wr_level_g, wr_level_b;
    logic [$clog2(DEPTH+1)-1:0] rd_level_r, rd_level_g, rd_level_b;

    logic bank_push;
    logic bank_pop;

    assign wr_ready       = !(|channel_full);
    assign wr_full        = |channel_full;
    assign wr_almost_full = |channel_almost_full;
    assign wr_level       = wr_level_r;
    assign wr_overflow    = (wr_push && !wr_ready) || (|channel_overflow);

    assign rd_empty        = |channel_empty;
    assign rd_almost_empty = |channel_almost_empty;
    assign rd_level        = rd_level_r;
    assign rd_data_valid   = &channel_data_valid;
    assign rd_underflow    = (rd_pop && rd_empty) || (|channel_underflow);

    assign bank_push = wr_push && wr_ready;
    assign bank_pop  = rd_pop && !rd_empty;

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) u_r_fifo (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n),
        .wr_push(bank_push), .wr_data(wr_r_data),
        .wr_af_free_level(wr_af_free_level),
        .wr_full(channel_full[0]),
        .wr_almost_full(channel_almost_full[0]),
        .wr_level(wr_level_r), .wr_overflow(channel_overflow[0]),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n),
        .rd_pop(bank_pop), .rd_ae_level(rd_ae_level),
        .rd_data(rd_r_data), .rd_data_valid(channel_data_valid[0]),
        .rd_empty(channel_empty[0]),
        .rd_almost_empty(channel_almost_empty[0]),
        .rd_level(rd_level_r), .rd_underflow(channel_underflow[0])
    );

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) u_g_fifo (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n),
        .wr_push(bank_push), .wr_data(wr_g_data),
        .wr_af_free_level(wr_af_free_level),
        .wr_full(channel_full[1]),
        .wr_almost_full(channel_almost_full[1]),
        .wr_level(wr_level_g), .wr_overflow(channel_overflow[1]),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n),
        .rd_pop(bank_pop), .rd_ae_level(rd_ae_level),
        .rd_data(rd_g_data), .rd_data_valid(channel_data_valid[1]),
        .rd_empty(channel_empty[1]),
        .rd_almost_empty(channel_almost_empty[1]),
        .rd_level(rd_level_g), .rd_underflow(channel_underflow[1])
    );

    async_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) u_b_fifo (
        .wr_clk(wr_clk), .wr_rst_n(wr_rst_n),
        .wr_push(bank_push), .wr_data(wr_b_data),
        .wr_af_free_level(wr_af_free_level),
        .wr_full(channel_full[2]),
        .wr_almost_full(channel_almost_full[2]),
        .wr_level(wr_level_b), .wr_overflow(channel_overflow[2]),
        .rd_clk(rd_clk), .rd_rst_n(rd_rst_n),
        .rd_pop(bank_pop), .rd_ae_level(rd_ae_level),
        .rd_data(rd_b_data), .rd_data_valid(channel_data_valid[2]),
        .rd_empty(channel_empty[2]),
        .rd_almost_empty(channel_almost_empty[2]),
        .rd_level(rd_level_b), .rd_underflow(channel_underflow[2])
    );

`ifndef SYNTHESIS
    always_ff @(posedge wr_clk) begin
        if (wr_rst_n && wr_ready) begin
            assert ((wr_level_r == wr_level_g) && (wr_level_g == wr_level_b))
                else $error("rgb_async_fifo_bank: write-domain levels diverged");
        end
    end

    always_ff @(posedge rd_clk) begin
        if (rd_rst_n && !rd_empty) begin
            assert ((rd_level_r == rd_level_g) && (rd_level_g == rd_level_b))
                else $error("rgb_async_fifo_bank: read-domain levels diverged");
        end
    end
`endif

endmodule
