class uart_tx_smoke_sequence
    extends uvm_sequence #(uart_tx_packet_item);

    `uvm_object_utils(uart_tx_smoke_sequence)

    function new(string name = "uart_tx_smoke_sequence");
        super.new(name);
    endfunction

    task send_packet(
        logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0] data,
        logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0] length
    );
        uart_tx_packet_item req;

        req = uart_tx_packet_item::type_id::create("req");

        start_item(req);

        req.packet_data = data;
        req.packet_len  = length;

        finish_item(req);
    endtask

    task body();
        logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0] data;

        // One-byte packet.
        data = '0;
        data[95 -: 8] = 8'hA5;
        send_packet(data, 1);

        // Four-byte packet.
        data = '0;
        data[95 -: 8] = 8'hDE;
        data[87 -: 8] = 8'hAD;
        data[79 -: 8] = 8'hBE;
        data[71 -: 8] = 8'hEF;
        send_packet(data, 4);

        // Maximum-size 12-byte packet.
        data = 96'h00_11_22_33_44_55_66_77_88_99_AA_BB;
        send_packet(data, 12);

        `uvm_info(
            "TX_SMOKE_SEQ",
            "UART TX smoke sequence completed",
            UVM_LOW
        )
    endtask

endclass
