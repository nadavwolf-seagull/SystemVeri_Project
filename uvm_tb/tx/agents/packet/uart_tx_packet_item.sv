class uart_tx_packet_item extends uvm_sequence_item;

    rand logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0]
        packet_data;

    rand logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0]
        packet_len;

    // Verification controls. These fields do not belong to the DUT packet;
    // they tell the driver how to exercise the surrounding control signals.
    bit          hold_cts_before_start;
    int unsigned cts_hold_cycles;

    bit          start_with_tx_disabled;
    int unsigned tx_disable_cycles;

    // Legal packets are expected to be accepted and transmitted.
    // Illegal packet lengths are expected to remain unaccepted.
    bit expect_accept;

    constraint legal_length_c {
        packet_len inside {
            [1:lab12_pkg::UART_TX_MAX_PACKET_BYTES]
        };
    }

    `uvm_object_utils(uart_tx_packet_item)

    function new(string name = "uart_tx_packet_item");
        super.new(name);

        hold_cts_before_start  = 1'b0;
        cts_hold_cycles       = 0;
        start_with_tx_disabled = 1'b0;
        tx_disable_cycles      = 0;
        expect_accept          = 1'b1;
    endfunction

    function string convert2string();
        return $sformatf(
            {
                "packet_len=%0d packet_data=0x%024h ",
                "expect_accept=%0b cts_hold=%0b/%0d ",
                "tx_disabled=%0b/%0d"
            },
            packet_len,
            packet_data,
            expect_accept,
            hold_cts_before_start,
            cts_hold_cycles,
            start_with_tx_disabled,
            tx_disable_cycles
        );
    endfunction

endclass
