`timescale 1ns/1ps

module tb_top;

    import uvm_pkg::*;
    import uart_rx_pkg::*;

    //--------------------------------------------------------
    // Clock
    //--------------------------------------------------------

    logic clk;

    initial begin
        clk = 0;
        forever #1.953125 clk = ~clk;    // 256MHz
    end

    //--------------------------------------------------------
    // Interface
    //--------------------------------------------------------

    uart_rx_if vif(clk);

    //--------------------------------------------------------
    // DUT
    //--------------------------------------------------------

    uart_rx_phy #(
        .CLK_FREQ_HZ (lab12_pkg::UART_CLK_FREQ_HZ),
        .BAUD        (lab12_pkg::UART_BAUD_RATE),
        .PARITY_EN   (lab12_pkg::UART_PARITY_EN),
        .EVEN_PARITY (lab12_pkg::UART_EVEN_PARITY)
    ) DUT (
        .clk           (clk),
        .rst_n         (vif.rst_n),
        .rx            (vif.rx),
        .rx_byte       (vif.rx_byte),
        .rx_byte_valid (vif.rx_byte_valid),
        .framing_err   (vif.framing_err),
        .parity_err    (vif.parity_err),
        .rx_busy       (vif.rx_busy)
    );

    //--------------------------------------------------------
    // Reset
    //--------------------------------------------------------

    initial begin

        vif.rst_n = 0;
        vif.rx    = 1'b1;

        repeat(10)
            @(posedge clk);

        vif.rst_n = 1;

    end

    //--------------------------------------------------------
    // Config DB
    //--------------------------------------------------------

    initial begin

        uvm_config_db#(virtual uart_rx_if)::set
        (
            null,
            "*",
            "vif",
            vif
        );

        run_test();
    end

    //--------------------------------------------------------
    // Waveform dump
    //--------------------------------------------------------
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end

endmodule