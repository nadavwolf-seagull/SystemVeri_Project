`timescale 1ns / 1ps

// Simple dual-port RAM for an asynchronous FIFO.
// Write and read ports have independent clocks. rd_data is valid immediately
// after the rd_clk edge that accepts rd_en.
module ram_1r1w #(
    parameter int unsigned RAM_WIDTH = 24,
    parameter int unsigned RAM_DEPTH = 32
) (
    // Write port
    input  logic                           wr_clk,
    input  logic                           wr_en,
    input  logic [$clog2(RAM_DEPTH)-1:0]   wr_addr,
    input  logic [RAM_WIDTH-1:0]           data_in,

    // Read port
    input  logic                           rd_clk,
    input  logic                           rd_rst_n,
    input  logic                           rd_en,
    input  logic [$clog2(RAM_DEPTH)-1:0]   rd_addr,
    output logic [RAM_WIDTH-1:0]           data_out
);

    logic [RAM_WIDTH-1:0] mem [0:RAM_DEPTH-1];

    always_ff @(posedge wr_clk) begin
        if (wr_en)
            mem[wr_addr] <= data_in;
    end

    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n)
            data_out <= '0;
        else if (rd_en)
            data_out <= mem[rd_addr];
    end

endmodule

