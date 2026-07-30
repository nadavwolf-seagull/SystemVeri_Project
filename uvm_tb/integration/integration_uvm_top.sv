timeunit 1ns;
timeprecision 1ps;

module integration_uvm_top;

    import uvm_pkg::*;
    import integration_uvm_pkg::*;

    integration_if vif();

    // =========================================================
    // Control clock: 100 MHz
    // =========================================================
    initial begin
        vif.clk_ctrl = 1'b0;

        forever
            #5ns vif.clk_ctrl = ~vif.clk_ctrl;
    end

    // =========================================================
    // Image clock: 100 MHz
    // =========================================================
    initial begin
        vif.clk_img = 1'b0;

        forever
            #5ns vif.clk_img = ~vif.clk_img;
    end

    // =========================================================
    // UART clock: 256 MHz
    // Period = 3.90625 ns
    // =========================================================
    initial begin
        vif.clk_uart = 1'b0;

        forever
            #1.953125ns vif.clk_uart = ~vif.clk_uart;
    end

    // =========================================================
    // Reset and default input handling
    // =========================================================
    initial begin
        vif.rst_ctrl_n = 1'b0;
        vif.rst_img_n  = 1'b0;
        vif.rst_uart_n = 1'b0;

        vif.start = 1'b0;

        // UART lines are idle-high.
        vif.RX    = 1'b1;
        vif.tx_en = 1'b1;

        // Active-low CTS: transmission is allowed.
        vif.cts_n = 1'b0;

        repeat (10)
            @(posedge vif.clk_ctrl);

        vif.rst_ctrl_n = 1'b1;

        repeat (4)
            @(posedge vif.clk_img);

        vif.rst_img_n = 1'b1;

        repeat (4)
            @(posedge vif.clk_uart);

        vif.rst_uart_n = 1'b1;
    end

    // =========================================================
    // DUT
    // =========================================================
    chip_top dut (
        .clk_ctrl              (vif.clk_ctrl),
        .rst_ctrl_n            (vif.rst_ctrl_n),

        .clk_img               (vif.clk_img),
        .rst_img_n             (vif.rst_img_n),

        .clk_uart              (vif.clk_uart),
        .rst_uart_n            (vif.rst_uart_n),

        .start                 (vif.start),

        .RX                    (vif.RX),
        .tx_en                 (vif.tx_en),
        .cts_n                 (vif.cts_n),
        .TX                    (vif.TX),

        .rts                   (vif.rts),
        .clk_sel               (vif.clk_sel),

        .seq_transfer_done     (vif.seq_transfer_done),
        .image_tx_done         (vif.image_tx_done),

        .seq_busy              (vif.seq_busy),
        .composer_busy         (vif.composer_busy),
        .packet_busy           (vif.packet_busy),

        .fifo_level            (vif.fifo_level),
        .fifo_empty            (vif.fifo_empty),
        .fifo_almost_empty     (vif.fifo_almost_empty),
        .fifo_half_full        (vif.fifo_half_full),
        .fifo_almost_full      (vif.fifo_almost_full),
        .fifo_full             (vif.fifo_full),
        .fifo_error            (vif.fifo_error),

        .seq_row_cnt           (vif.seq_row_cnt),
        .seq_col_cnt           (vif.seq_col_cnt),

        .tx_row_cnt            (vif.tx_row_cnt),
        .tx_col_cnt            (vif.tx_col_cnt),

        .rx_frame_valid        (vif.rx_frame_valid),
        .rx_parse_error        (vif.rx_parse_error),
        .rx_classifier_error   (vif.rx_classifier_error),
        .rgf_error             (vif.rgf_error),

        .rx_parity_error_dbg   (vif.rx_parity_error_dbg),
        .rx_framing_error_dbg  (vif.rx_framing_error_dbg),
        .parity_enable_dbg     (vif.parity_enable_dbg),

        .uart_rx_busy          (vif.uart_rx_busy),
        .uart_tx_busy          (vif.uart_tx_busy)
    );

    // =========================================================
    // AHB observation connections
    //
    // The AHB interface belongs to the real DMA cluster inside
    // chip_top. These assignments expose it to the UVM test for
    // protocol checking only.
    // =========================================================
    assign vif.ahb_haddr =
        dut.u_final_project_dma_cluster.ahb.HADDR;

    assign vif.ahb_hwrite =
        dut.u_final_project_dma_cluster.ahb.HWRITE;

    assign vif.ahb_htrans =
        dut.u_final_project_dma_cluster.ahb.HTRANS;

    assign vif.ahb_hburst =
        dut.u_final_project_dma_cluster.ahb.HBURST;

    assign vif.ahb_hsize =
        dut.u_final_project_dma_cluster.ahb.HSIZE;

    assign vif.ahb_hwdata =
        dut.u_final_project_dma_cluster.ahb.HWDATA;

    assign vif.ahb_hrdata =
        dut.u_final_project_dma_cluster.ahb.HRDATA;

    assign vif.ahb_hready =
        dut.u_final_project_dma_cluster.ahb.HREADY;

    assign vif.ahb_hresp =
        dut.u_final_project_dma_cluster.ahb.HRESP;

    // =========================================================
    // UVM startup
    // =========================================================
    initial begin
        uvm_config_db#(virtual integration_if)::set(
            null,
            "*",
            "vif",
            vif
        );

        run_test();
    end

    // =========================================================
    // Waveform
    // =========================================================
    initial begin
        $dumpfile("integration_uvm_top.fst");
        $dumpvars(0, integration_uvm_top);
    end

endmodule
