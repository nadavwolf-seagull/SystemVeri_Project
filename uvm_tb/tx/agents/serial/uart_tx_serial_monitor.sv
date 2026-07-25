class uart_tx_serial_monitor extends uvm_monitor;

    `uvm_component_utils(uart_tx_serial_monitor)

    virtual uart_tx_if vif;
    localparam int unsigned CLKS_PER_BIT =
        lab12_pkg::UART_CLKS_PER_BIT;

    localparam logic PARITY_EN =
        lab12_pkg::UART_PARITY_EN;

    localparam logic EVEN_PARITY =
        lab12_pkg::UART_EVEN_PARITY;

    uvm_analysis_port #(uart_tx_packet_item) analysis_port;

    function new(
        string name = "uart_tx_serial_monitor",
        uvm_component parent = null
    );
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uart_tx_if)::get(
                this, "", "vif", vif
            )) begin
            `uvm_fatal(
                "TX_SERIAL_MON",
                "Failed to get uart_tx_if"
            )
        end
    endfunction

    task wait_clock_cycles(int unsigned count);
        repeat (count)
            @(posedge vif.sys_clk);
    endtask

    task receive_uart_byte(output logic [7:0] received_byte);
        logic expected_parity;
        int unsigned bit_index;

        @(negedge vif.TX);

        wait_clock_cycles(CLKS_PER_BIT / 2);

        if (vif.TX !== 1'b0) begin
            `uvm_error(
                "TX_SERIAL_MON",
                "Invalid UART start bit"
            )
        end

        received_byte = '0;

        for (bit_index = 0; bit_index < 8; bit_index++) begin
            wait_clock_cycles(CLKS_PER_BIT);
            received_byte[bit_index] = vif.TX;
        end

        if (PARITY_EN) begin
            wait_clock_cycles(CLKS_PER_BIT);

            if (EVEN_PARITY)
                expected_parity = ^received_byte;
            else
                expected_parity = ~(^received_byte);

            if (vif.TX !== expected_parity) begin
                `uvm_error(
                    "TX_SERIAL_MON",
                    $sformatf(
                        "Parity mismatch for byte 0x%02h",
                        received_byte
                    )
                )
            end
        end

        wait_clock_cycles(CLKS_PER_BIT);

        if (vif.TX !== 1'b1) begin
            `uvm_error(
                "TX_SERIAL_MON",
                "Invalid UART stop bit"
            )
        end
    endtask

    task run_phase(uvm_phase phase);
        uart_tx_packet_item observed_item;
        logic [7:0] received_byte;
        int unsigned byte_index;
        logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0]
            captured_len;

        forever begin
            do begin
                @(posedge vif.sys_clk);
            end
            while (!(
                (vif.rst_n === 1'b1) &&
                (vif.packet_valid === 1'b1) &&
                (vif.packet_ready === 1'b1)
            ));

            captured_len = vif.packet_len;

            observed_item =
                uart_tx_packet_item::type_id::create(
                    "observed_item"
                );

            observed_item.packet_data = '0;
            observed_item.packet_len  = captured_len;

            for (byte_index = 0;
                 byte_index < captured_len;
                 byte_index++) begin

                receive_uart_byte(received_byte);

                observed_item.packet_data[
                    lab12_pkg::UART_TX_MAX_PACKET_WIDTH -
                    1 - (byte_index * 8) -: 8
                ] = received_byte;

                `uvm_info(
                    "TX_SERIAL_MON",
                    $sformatf(
                        "Decoded UART byte[%0d] = 0x%02h",
                        byte_index,
                        received_byte
                    ),
                    UVM_MEDIUM
                )
            end

            analysis_port.write(observed_item);
        end
    endtask

endclass
