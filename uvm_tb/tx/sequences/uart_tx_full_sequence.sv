class uart_tx_full_sequence
    extends uvm_sequence #(uart_tx_packet_item);

    `uvm_object_utils(uart_tx_full_sequence)

    function new(string name = "uart_tx_full_sequence");
        super.new(name);
    endfunction

    task send_legal_packet(
        logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0] data,
        logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0] length,
        bit hold_cts = 1'b0,
        int unsigned cts_cycles = 0,
        bit start_disabled = 1'b0,
        int unsigned disabled_cycles = 0
    );
        uart_tx_packet_item req;

        req = uart_tx_packet_item::type_id::create(
            "legal_req"
        );

        start_item(req);

        req.packet_data            = data;
        req.packet_len             = length;
        req.expect_accept          = 1'b1;
        req.hold_cts_before_start  = hold_cts;
        req.cts_hold_cycles        = cts_cycles;
        req.start_with_tx_disabled = start_disabled;
        req.tx_disable_cycles      = disabled_cycles;

        finish_item(req);
    endtask

    task send_illegal_length(
        logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0] length
    );
        uart_tx_packet_item req;

        req = uart_tx_packet_item::type_id::create(
            "illegal_req"
        );

        start_item(req);

        req.packet_data            = 96'hDEAD_BEEF_0123_4567_89AB_CDEF;
        req.packet_len             = length;
        req.expect_accept          = 1'b0;
        req.hold_cts_before_start  = 1'b0;
        req.cts_hold_cycles        = 0;
        req.start_with_tx_disabled = 1'b0;
        req.tx_disable_cycles      = 0;

        finish_item(req);
    endtask

    task send_random_packets(int unsigned count);
        uart_tx_packet_item req;
        int unsigned packet_index;

        for (packet_index = 0;
             packet_index < count;
             packet_index++) begin

            req = uart_tx_packet_item::type_id::create(
                $sformatf(
                    "random_req_%0d",
                    packet_index
                )
            );

            start_item(req);

            if (!req.randomize() with {
                    packet_len inside {
                        [1:lab12_pkg::UART_TX_MAX_PACKET_BYTES]
                    };
                }) begin
                `uvm_fatal(
                    "TX_RANDOM_SEQ",
                    "Failed to randomize UART TX packet"
                )
            end

            req.expect_accept          = 1'b1;
            req.hold_cts_before_start  = 1'b0;
            req.cts_hold_cycles        = 0;
            req.start_with_tx_disabled = 1'b0;
            req.tx_disable_cycles      = 0;

            finish_item(req);

            `uvm_info(
                "TX_RANDOM_SEQ",
                $sformatf(
                    "Completed random packet %0d/%0d: %s",
                    packet_index + 1,
                    count,
                    req.convert2string()
                ),
                UVM_MEDIUM
            )
        end
    endtask

    task body();
        logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0] data;

        // -----------------------------------------------------
        // Original directed smoke cases
        // -----------------------------------------------------

        data = '0;
        data[95 -: 8] = 8'hA5;
        send_legal_packet(data, 4'd1);

        data = '0;
        data[95 -: 8] = 8'hDE;
        data[87 -: 8] = 8'hAD;
        data[79 -: 8] = 8'hBE;
        data[71 -: 8] = 8'hEF;
        send_legal_packet(data, 4'd4);

        data = 96'h00_11_22_33_44_55_66_77_88_99_AA_BB;
        send_legal_packet(data, 4'd12);

        // -----------------------------------------------------
        // CTS pause and resume
        // -----------------------------------------------------

        data = '0;
        data[95 -: 8] = 8'hC1;
        data[87 -: 8] = 8'hC2;
        data[79 -: 8] = 8'hC3;

        send_legal_packet(
            data,
            4'd3,
            1'b1,
            40,
            1'b0,
            0
        );

        // -----------------------------------------------------
        // tx_en disable and enable
        // -----------------------------------------------------

        data = '0;
        data[95 -: 8] = 8'hE1;
        data[87 -: 8] = 8'hE2;

        send_legal_packet(
            data,
            4'd2,
            1'b0,
            0,
            1'b1,
            20
        );

        // -----------------------------------------------------
        // Invalid packet lengths
        // -----------------------------------------------------

        send_illegal_length(4'd0);
        send_illegal_length(4'd15);

        // -----------------------------------------------------
        // Constrained-random legal packets
        // -----------------------------------------------------

        send_random_packets(20);

        `uvm_info(
            "TX_FULL_SEQ",
            "UART TX full verification sequence completed",
            UVM_LOW
        )
    endtask

endclass
