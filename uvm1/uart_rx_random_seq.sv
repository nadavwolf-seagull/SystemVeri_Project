`ifndef UART_RX_RANDOM_SEQ_SV
`define UART_RX_RANDOM_SEQ_SV

class uart_rx_random_seq extends uvm_sequence #(uart_rx_item);

    `uvm_object_utils(uart_rx_random_seq)

    function new(string name = "uart_rx_random_seq");
        super.new(name);
    endfunction

    task body();
        repeat (10) begin
            uart_rx_item tr = uart_rx_item::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize()) `uvm_fatal("SEQ", "randomize failed")
            finish_item(tr);
        end
    endtask

endclass

`endif