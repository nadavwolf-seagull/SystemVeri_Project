`ifndef UART_RX_MONITOR_SV
`define UART_RX_MONITOR_SV

class uart_rx_monitor extends uvm_monitor;

    `uvm_component_utils(uart_rx_monitor)

    virtual uart_rx_if vif;

    // הפורט שדרכו ה-monitor משדר transactions ל-scoreboard/coverage
    uvm_analysis_port #(uart_rx_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual uart_rx_if)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "no vif")
    endfunction

    task run_phase(uvm_phase phase);
        // ערכים קודמים כדי לזהות rising edge
        logic prev_valid   = 0;
        logic prev_parity  = 0;
        logic prev_framing = 0;

        forever begin
            @(posedge vif.clk);
            if ((vif.rx_byte_valid && !prev_valid) ||
                (vif.parity_err    && !prev_parity) ||
                (vif.framing_err   && !prev_framing)) begin
                    uart_rx_item tr = uart_rx_item::type_id::create("tr");
                    tr.data            = vif.rx_byte;
                    tr.dut_parity_err  = vif.parity_err;
                    tr.dut_framing_err = vif.framing_err;
                    ap.write(tr);
            end

            prev_valid   = vif.rx_byte_valid;
            prev_parity  = vif.parity_err;
            prev_framing = vif.framing_err;
        end
    endtask

endclass

`endif