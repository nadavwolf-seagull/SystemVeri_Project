timeunit 1ns;
timeprecision 1ps;

module tb_config_rgf_start_bits;

    import lab12_pkg::*;

    logic clk;
    logic rst_n;

    logic                  wr_en;
    logic                  rd_en;
    logic [RGF_ADDR_WIDTH-1:0] addr;
    logic [RGF_DATA_WIDTH-1:0] wr_data;
    logic [RGF_DATA_WIDTH-1:0] rd_data;
    logic                  rd_valid;
    logic                  error;

    logic image_start_pulse;
    logic dma_wr_start;
    logic dma_rd_start;
    logic [23:0] img_base;
    logic [15:0] img_width;
    logic [15:0] img_height;
    logic [31:0] fifo_ae_level;
    logic [31:0] fifo_af_level;

    logic clk_sel;
    logic parity_enable;
    logic mac_soft_reset_pulse;

    always #5 clk = ~clk;

    config_rgf dut (
        .clk                  (clk),
        .rst_n                (rst_n),
        .wr_en                (wr_en),
        .rd_en                (rd_en),
        .addr                 (addr),
        .wr_data              (wr_data),
        .rd_data              (rd_data),
        .rd_valid             (rd_valid),
        .error                (error),
        .image_start_pulse    (image_start_pulse),
        .dma_wr_start         (dma_wr_start),
        .dma_rd_start         (dma_rd_start),
        .img_base             (img_base),
        .img_width            (img_width),
        .img_height           (img_height),
        .fifo_ae_level        (fifo_ae_level),
        .fifo_af_level        (fifo_af_level),
        .dma_busy             (1'b0),
        .dma_done             (1'b0),
        .dma_error            (1'b0),
        .wr_row_cnt           (16'd0),
        .wr_col_cnt           (16'd0),
        .rd_row_cnt           (16'd0),
        .rd_col_cnt           (16'd0),
        .fifo_empty           (1'b1),
        .fifo_full            (1'b0),
        .fifo_error           (1'b0),
        .uart_parity_err      (1'b0),
        .uart_framing_err     (1'b0),
        .clk_sel              (clk_sel),
        .parity_enable        (parity_enable),
        .mac_soft_reset_pulse (mac_soft_reset_pulse)
    );

    task automatic write_ctrl(
        input logic [31:0] value,
        input logic expected_wr_start,
        input logic expected_rd_start
    );
        begin
            @(negedge clk);
            addr    = RGF_ADDR_CTRL;
            wr_data = value;
            wr_en   = 1'b1;

            @(posedge clk);
            #1;

            if (dma_wr_start !== expected_wr_start)
                $fatal(1, "Unexpected dma_wr_start for CTRL=%08h", value);

            if (dma_rd_start !== expected_rd_start)
                $fatal(1, "Unexpected dma_rd_start for CTRL=%08h", value);

            if (dma_wr_start && dma_rd_start)
                $fatal(1, "Both DMA start pulses asserted together");

            @(negedge clk);
            wr_en   = 1'b0;
            wr_data = '0;

            @(posedge clk);
            #1;

            if (dma_wr_start || dma_rd_start)
                $fatal(1, "DMA start pulse lasted more than one cycle");
        end
    endtask

    task automatic check_ctrl_readback(
        input logic [31:0] expected_value
    );
        begin
            @(negedge clk);
            addr  = RGF_ADDR_CTRL;
            rd_en = 1'b1;

            @(posedge clk);
            #1;

            if (!rd_valid)
                $fatal(1, "CTRL read did not produce rd_valid");

            if (rd_data !== expected_value)
                $fatal(
                    1,
                    "CTRL readback mismatch: expected=%08h actual=%08h",
                    expected_value,
                    rd_data
                );

            @(negedge clk);
            rd_en = 1'b0;
        end
    endtask

    initial begin
        clk     = 1'b0;
        rst_n   = 1'b0;
        wr_en   = 1'b0;
        rd_en   = 1'b0;
        addr    = '0;
        wr_data = '0;

        repeat (3) @(posedge clk);
        rst_n = 1'b1;

        // Persistent bits 2:1 remain; DMA write bit 3 self-clears.
        write_ctrl(32'h0000_000E, 1'b1, 1'b0);
        check_ctrl_readback(32'h0000_0006);

        // Persistent bits 2:1 remain; DMA read bit 0 self-clears.
        write_ctrl(32'h0000_0007, 1'b0, 1'b1);
        check_ctrl_readback(32'h0000_0006);

        $display("tb_config_rgf_start_bits: PASS");
        $finish;
    end

endmodule