`ifndef UART_RX_SEQUENCER_SV
`define UART_RX_SEQUENCER_SV

class uart_rx_sequencer extends uvm_sequencer #(uart_rx_item);

    `uvm_component_utils(uart_rx_sequencer)

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------
    function new(string name = "uart_rx_sequencer",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass

`endif