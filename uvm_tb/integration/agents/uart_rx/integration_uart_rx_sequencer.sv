`ifndef INTEGRATION_UART_RX_SEQUENCER_SV
`define INTEGRATION_UART_RX_SEQUENCER_SV

class integration_uart_rx_sequencer
    extends uvm_sequencer #(integration_cmd_item);

    `uvm_component_utils(integration_uart_rx_sequencer)

    function new(
        string name = "integration_uart_rx_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass

`endif
