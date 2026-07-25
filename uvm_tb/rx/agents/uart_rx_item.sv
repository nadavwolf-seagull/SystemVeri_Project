`ifndef UART_RX_ITEM_SV
`define UART_RX_ITEM_SV

class uart_rx_item extends uvm_sequence_item;

    //------------------------------------------------------------
    // UART Frame Fields
    //------------------------------------------------------------

    rand bit [7:0] data;
    rand bit inject_parity_error;
    rand bit inject_frame_error;
    rand int unsigned idle_cycles;
    bit dut_parity_err;
    bit dut_framing_err; 
    //------------------------------------------------------------
    // Constraints
    //------------------------------------------------------------

    constraint c_idle
    {
        idle_cycles inside {[2:20]};
    }
    constraint c_single_error {
        !(inject_parity_error && inject_frame_error);
    }

    //------------------------------------------------------------
    // Factory
    //------------------------------------------------------------

    `uvm_object_utils_begin(uart_rx_item)

        `uvm_field_int(data,                 UVM_ALL_ON)
        `uvm_field_int(inject_parity_error,  UVM_ALL_ON)
        `uvm_field_int(inject_frame_error,   UVM_ALL_ON)
        `uvm_field_int(idle_cycles,          UVM_ALL_ON)
        `uvm_field_int(dut_parity_err,       UVM_ALL_ON)
        `uvm_field_int(dut_framing_err,      UVM_ALL_ON)
    `uvm_object_utils_end

    //------------------------------------------------------------
    // Constructor
    //------------------------------------------------------------

    function new(string name="uart_rx_item");
        super.new(name);
    endfunction

endclass

`endif