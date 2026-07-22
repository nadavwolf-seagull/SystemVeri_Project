`timescale 1ns / 1ps

interface dma_sequencer_if (
    input logic clk
);

    logic rst_n;

    // DMA control
    logic        dma_wr_start;
    logic        dma_rd_start;
    logic [23:0] img_base;
    logic [15:0] img_width;
    logic [15:0] img_height;

    // DMA status
    logic        busy;
    logic        done;
    logic        error;

    logic [15:0] wr_row_cnt;
    logic [15:0] wr_col_cnt;
    logic [15:0] rd_row_cnt;
    logic [15:0] rd_col_cnt;

    // Sequencer command interface
    logic         seq_cmd_valid;
    logic         seq_cmd_ready;
    logic         seq_cmd_write;
    logic [23:0]  seq_cmd_addr;
    logic [127:0] seq_cmd_wdata;

    // Sequencer response interface
    logic         seq_rsp_valid;
    logic         seq_rsp_ready;
    logic         seq_rsp_error;
    logic [127:0] seq_rsp_rdata;

    // RX FIFO side
    logic [2:0]  rx_fifo_empty;
    logic [2:0]  rx_fifo_data_valid;
    logic [31:0] rx_fifo_r_data;
    logic [31:0] rx_fifo_g_data;
    logic [31:0] rx_fifo_b_data;
    logic [2:0]  rx_fifo_pop;

    // TX FIFO side
    logic [2:0]  tx_fifo_ready;
    logic [2:0]  tx_fifo_push;
    logic [31:0] tx_fifo_r_data;
    logic [31:0] tx_fifo_g_data;
    logic [31:0] tx_fifo_b_data;

    task automatic drive_idle();
        dma_wr_start       = 1'b0;
        dma_rd_start       = 1'b0;
        img_base           = '0;
        img_width          = '0;
        img_height         = '0;

        seq_cmd_ready      = 1'b0;

        seq_rsp_valid      = 1'b0;
        seq_rsp_error      = 1'b0;
        seq_rsp_rdata      = '0;

        rx_fifo_empty      = 3'b111;
        rx_fifo_data_valid = 3'b000;
        rx_fifo_r_data     = '0;
        rx_fifo_g_data     = '0;
        rx_fifo_b_data     = '0;

        tx_fifo_ready      = 3'b000;
    endtask

endinterface