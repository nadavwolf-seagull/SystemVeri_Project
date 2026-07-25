`ifndef UART_RX_BASE_SEQ_SV
`define UART_RX_BASE_SEQ_SV

class uart_rx_base_seq extends uvm_sequence #(uart_rx_item);

    `uvm_object_utils(uart_rx_base_seq)

    function new(string name = "uart_rx_base_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(
            "RX_BASE_SEQ",
            "UART RX base sequence started",
            UVM_LOW
        )
    endtask

endclass

`endif