`ifndef UART_RX_AGENT_SV
`define UART_RX_AGENT_SV

class uart_rx_agent extends uvm_agent;

    `uvm_component_utils(uart_rx_agent)

    uart_rx_driver    drv;
    uart_rx_monitor   mon;
    uart_rx_sequencer sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = uart_rx_monitor::type_id::create("mon", this);

        if (get_is_active() == UVM_ACTIVE) begin
            drv = uart_rx_driver   ::type_id::create("drv", this);
            sqr = uart_rx_sequencer::type_id::create("sqr", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if (get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction

endclass

`endif