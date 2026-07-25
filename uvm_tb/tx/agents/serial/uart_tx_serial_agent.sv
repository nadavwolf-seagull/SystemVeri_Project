class uart_tx_serial_agent extends uvm_agent;

    `uvm_component_utils(uart_tx_serial_agent)

    uart_tx_serial_monitor monitor;

    function new(
        string name = "uart_tx_serial_agent",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor =
            uart_tx_serial_monitor::type_id::create(
                "monitor", this
            );
    endfunction

endclass
