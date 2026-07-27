`ifndef INTEGRATION_UART_TX_AGENT_SV
`define INTEGRATION_UART_TX_AGENT_SV

class integration_uart_tx_agent extends uvm_agent;

    `uvm_component_utils(integration_uart_tx_agent)

    integration_uart_tx_monitor monitor;

    function new(
        string name = "integration_uart_tx_agent",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor =
            integration_uart_tx_monitor::type_id::create(
                "monitor",
                this
            );
    endfunction

endclass

`endif
