timeunit 1ns;
timeprecision 1ps;

module tx_uvm_top;

    import uvm_pkg::*;
    import tx_uvm_pkg::*;

    logic sys_clk;

    uart_tx_if tx_if (
        .sys_clk(sys_clk)
    );

    uart_tx_top dut (
        .sys_clk      (sys_clk),
        .rst_n        (tx_if.rst_n),
        .tx_en        (tx_if.tx_en),
        .cts_n        (tx_if.cts_n),

        .packet_valid (tx_if.packet_valid),
        .packet_data  (tx_if.packet_data),
        .packet_len   (tx_if.packet_len),
        .packet_ready (tx_if.packet_ready),

        .packet_busy  (tx_if.packet_busy),
        .packet_done  (tx_if.packet_done),

        .TX           (tx_if.TX)
    );

    initial begin
        sys_clk = 1'b0;

        forever #5ns
            sys_clk = ~sys_clk;
    end

    initial begin
        tx_if.rst_n = 1'b0;

        repeat (5)
            @(posedge sys_clk);

        tx_if.rst_n = 1'b1;
    end

    initial begin
        uvm_config_db#(virtual uart_tx_if)::set(
            null,
            "*",
            "vif",
            tx_if
        );

        //run_test("uart_tx_smoke_test");
        run_test("uart_tx_full_test");
    end

endmodule
