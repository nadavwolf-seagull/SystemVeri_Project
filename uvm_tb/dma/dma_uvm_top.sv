`timescale 1ns / 1ps

module dma_uvm_top;

    import uvm_pkg::*;
    import dma_uvm_pkg::*;

    logic clk;

    // Clock: 100 MHz
    initial clk = 1'b0;
    always #5ns clk = ~clk;

    dma_sequencer_if dma_if (
        .clk(clk)
    );

    rgb_dma_sequencer dut (
        .clk                (clk),
        .rst_n              (dma_if.rst_n),

        .dma_wr_start       (dma_if.dma_wr_start),
        .dma_rd_start       (dma_if.dma_rd_start),
        .img_base           (dma_if.img_base),
        .img_width          (dma_if.img_width),
        .img_height         (dma_if.img_height),

        .busy               (dma_if.busy),
        .done               (dma_if.done),
        .error              (dma_if.error),

        .wr_row_cnt         (dma_if.wr_row_cnt),
        .wr_col_cnt         (dma_if.wr_col_cnt),
        .rd_row_cnt         (dma_if.rd_row_cnt),
        .rd_col_cnt         (dma_if.rd_col_cnt),

        .seq_cmd_valid      (dma_if.seq_cmd_valid),
        .seq_cmd_ready      (dma_if.seq_cmd_ready),
        .seq_cmd_write      (dma_if.seq_cmd_write),
        .seq_cmd_addr       (dma_if.seq_cmd_addr),
        .seq_cmd_wdata      (dma_if.seq_cmd_wdata),

        .seq_rsp_valid      (dma_if.seq_rsp_valid),
        .seq_rsp_ready      (dma_if.seq_rsp_ready),
        .seq_rsp_error      (dma_if.seq_rsp_error),
        .seq_rsp_rdata      (dma_if.seq_rsp_rdata),

        .rx_fifo_empty      (dma_if.rx_fifo_empty),
        .rx_fifo_data_valid (dma_if.rx_fifo_data_valid),
        .rx_fifo_r_data     (dma_if.rx_fifo_r_data),
        .rx_fifo_g_data     (dma_if.rx_fifo_g_data),
        .rx_fifo_b_data     (dma_if.rx_fifo_b_data),
        .rx_fifo_pop        (dma_if.rx_fifo_pop),

        .tx_fifo_ready      (dma_if.tx_fifo_ready),
        .tx_fifo_push       (dma_if.tx_fifo_push),
        .tx_fifo_r_data     (dma_if.tx_fifo_r_data),
        .tx_fifo_g_data     (dma_if.tx_fifo_g_data),
        .tx_fifo_b_data     (dma_if.tx_fifo_b_data)
    );

    initial begin
        dma_if.drive_idle();

        dma_if.rst_n = 1'b0;
        repeat (5) @(posedge clk);
        dma_if.rst_n = 1'b1;
    end

    initial begin
        uvm_config_db#(virtual dma_sequencer_if)::set(
            null,
            "*",
            "vif",
            dma_if
        );

        run_test("dma_uvm_smoke_test");
    end

endmodule