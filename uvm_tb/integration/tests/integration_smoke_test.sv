`ifndef INTEGRATION_SMOKE_TEST_SV
`define INTEGRATION_SMOKE_TEST_SV

class integration_smoke_test extends uvm_test;

    `uvm_component_utils(integration_smoke_test)

    virtual integration_if vif;

    function new(
        string name = "integration_smoke_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual integration_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin
            `uvm_fatal(
                "INT_SMOKE",
                "Failed to get integration_if from config_db"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info(
            "INT_SMOKE",
            "Integration smoke test started",
            UVM_LOW
        )

        // Wait until all three reset domains are released.
        wait (
            (vif.rst_ctrl_n === 1'b1) &&
            (vif.rst_img_n  === 1'b1) &&
            (vif.rst_uart_n === 1'b1)
        );

        // Allow CDC synchronizers and internal state machines to settle.
        repeat (50)
            @(posedge vif.clk_ctrl);

        // Check externally visible signals for unknown values.
        if ($isunknown(vif.TX))
            `uvm_error("INT_SMOKE", "TX contains X or Z")

        if ($isunknown(vif.rts))
            `uvm_error("INT_SMOKE", "rts contains X or Z")

        if ($isunknown(vif.uart_rx_busy))
            `uvm_error(
                "INT_SMOKE",
                "uart_rx_busy contains X or Z"
            )

        if ($isunknown(vif.uart_tx_busy))
            `uvm_error(
                "INT_SMOKE",
                "uart_tx_busy contains X or Z"
            )

        if ($isunknown(vif.fifo_error))
            `uvm_error(
                "INT_SMOKE",
                "fifo_error contains X or Z"
            )

        if ($isunknown(vif.rgf_error))
            `uvm_error(
                "INT_SMOKE",
                "rgf_error contains X or Z"
            )

        `uvm_info(
            "INT_SMOKE",
            $sformatf(
                {
                    "Smoke status: TX=%0b rts=%0b ",
                    "rx_busy=%0b tx_busy=%0b ",
                    "fifo_error=%0b rgf_error=%0b"
                },
                vif.TX,
                vif.rts,
                vif.uart_rx_busy,
                vif.uart_tx_busy,
                vif.fifo_error,
                vif.rgf_error
            ),
            UVM_LOW
        )

        repeat (20)
            @(posedge vif.clk_ctrl);

        `uvm_info(
            "INT_SMOKE",
            "Integration smoke test completed",
            UVM_LOW
        )

        phase.drop_objection(this);
    endtask

endclass

`endif
