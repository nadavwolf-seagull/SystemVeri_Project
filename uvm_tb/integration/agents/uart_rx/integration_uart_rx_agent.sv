`ifndef INTEGRATION_UART_RX_AGENT_SV
`define INTEGRATION_UART_RX_AGENT_SV

class integration_uart_rx_agent extends uvm_agent;

    `uvm_component_utils(integration_uart_rx_agent)

    integration_uart_rx_sequencer sequencer;
    integration_uart_rx_driver    driver;

    function new(
        string name = "integration_uart_rx_agent",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (get_is_active() == UVM_ACTIVE) begin
            sequencer =
                integration_uart_rx_sequencer::type_id::create(
                    "sequencer",
                    this
                );

            driver =
                integration_uart_rx_driver::type_id::create(
                    "driver",
                    this
                );
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(
                sequencer.seq_item_export
            );
        end
    endfunction

endclass

`endif
