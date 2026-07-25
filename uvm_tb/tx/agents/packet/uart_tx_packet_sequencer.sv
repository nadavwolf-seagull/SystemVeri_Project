class uart_tx_packet_sequencer
    extends uvm_sequencer #(uart_tx_packet_item);

    `uvm_component_utils(uart_tx_packet_sequencer)

    function new(
        string name = "uart_tx_packet_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass
