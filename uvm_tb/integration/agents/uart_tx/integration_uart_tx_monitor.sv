`ifndef INTEGRATION_UART_TX_MONITOR_SV
`define INTEGRATION_UART_TX_MONITOR_SV

class integration_uart_tx_monitor extends uvm_monitor;

    `uvm_component_utils(integration_uart_tx_monitor)

    typedef logic [7:0] uart_byte_t;

    virtual integration_if vif;

    uvm_analysis_port #(integration_rsp_item) response_ap;

    localparam int unsigned CLKS_PER_BIT =
        lab12_pkg::UART_CLKS_PER_BIT;

    localparam int unsigned CONTROL_PACKET_BYTES =
        lab12_pkg::TX_PACKET_BYTES;

    localparam bit PARITY_EN =
        lab12_pkg::UART_PARITY_EN;

    localparam bit EVEN_PARITY =
        lab12_pkg::UART_EVEN_PARITY;

    function new(
        string name = "integration_uart_tx_monitor",
        uvm_component parent = null
    );
        super.new(name, parent);
        response_ap = new("response_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual integration_if)::get(
                this, "", "vif", vif
            )) begin
            `uvm_fatal(
                "INT_TX_MON",
                "Failed to get integration_if"
            )
        end
    endfunction

    task automatic wait_uart_cycles(
        input int unsigned count
    );
        repeat (count)
            @(posedge vif.clk_uart);
    endtask

    task automatic receive_uart_byte(
        output uart_byte_t data,
        output bit parity_error,
        output bit framing_error
    );
        bit expected_parity;

        parity_error  = 1'b0;
        framing_error = 1'b0;
        data          = '0;

        // Wait for start-bit falling edge.
        @(negedge vif.TX);

        // Move to the middle of the start bit.
        wait_uart_cycles(CLKS_PER_BIT / 2);

        if (vif.TX !== 1'b0) begin
            `uvm_error(
                "INT_TX_MON",
                "Invalid UART start bit"
            )
        end

        // Sample eight data bits, LSB first.
        for (int unsigned bit_index = 0;
             bit_index < 8;
             bit_index++) begin

            wait_uart_cycles(CLKS_PER_BIT);
            data[bit_index] = vif.TX;
        end

        if (PARITY_EN) begin
            wait_uart_cycles(CLKS_PER_BIT);

            if (EVEN_PARITY)
                expected_parity = ^data;
            else
                expected_parity = ~(^data);

            if (vif.TX !== expected_parity)
                parity_error = 1'b1;
        end

        wait_uart_cycles(CLKS_PER_BIT);

        if (vif.TX !== 1'b1)
            framing_error = 1'b1;
    endtask

    task run_phase(uvm_phase phase);
        integration_rsp_item rsp;
        uart_byte_t bytes[0:CONTROL_PACKET_BYTES-1];

        bit byte_parity_error;
        bit byte_framing_error;

        while (vif.rst_uart_n !== 1'b1)
            @(posedge vif.clk_uart);

        forever begin
            // packet_busy rises before the first UART start bit.
            @(posedge vif.packet_busy);

            rsp = integration_rsp_item::type_id::create(
                "rsp"
            );

            rsp.packet_len =
                lab12_pkg::UART_TX_PACKET_LEN_WIDTH'(
                    CONTROL_PACKET_BYTES
                );

            rsp.raw_packet = '0;

            for (int unsigned index = 0;
                 index < CONTROL_PACKET_BYTES;
                 index++) begin

                receive_uart_byte(
                    bytes[index],
                    byte_parity_error,
                    byte_framing_error
                );

                rsp.parity_error |= byte_parity_error;
                rsp.framing_error |= byte_framing_error;

                rsp.raw_packet[
                    lab12_pkg::UART_TX_MAX_PACKET_WIDTH -
                    1 - (index * 8) -: 8
                ] = bytes[index];

                `uvm_info(
                    "INT_TX_MON",
                    $sformatf(
                        "Decoded TX byte[%0d]=0x%02h",
                        index,
                        bytes[index]
                    ),
                    UVM_HIGH
                )
            end

            // RGF response:
            // 0: "R", 1: "D", 2: address,
            // 3-4: reserved, 5-8: data.
            if ((bytes[0] == 8'h52) &&
                (bytes[1] == 8'h44)) begin

                rsp.kind = INT_RSP_RGF_READ;
                rsp.addr = {
                    20'h00000,
                    bytes[2][3:0]
                };

                rsp.data = {
                    bytes[5],
                    bytes[6],
                    bytes[7],
                    bytes[8]
                };
            end
            else begin
                // Pixel response:
                // 00 00 offset[15:8], 00 00 offset[7:0], R G B.
                // The two metadata bytes are the low 16 bits of the
                // byte offset inside the pixel-alias range.
                rsp.kind = INT_RSP_PIXEL_READ;

                rsp.pixel_offset = {
                    bytes[2],
                    bytes[5]
                };

                rsp.pixel_index =
                    rsp.pixel_offset >>
                    lab12_pkg::AHB_PIXEL_ADDR_SHIFT;

                rsp.pixel_row =
                    (rsp.pixel_index /
                     lab12_pkg::IMG_WIDTH);

                rsp.pixel_col =
                    (rsp.pixel_index %
                     lab12_pkg::IMG_WIDTH);

                rsp.pixel = {
                    bytes[6],
                    bytes[7],
                    bytes[8]
                };
            end

            `uvm_info(
                "INT_TX_MON",
                $sformatf(
                    "Observed UART response: %s",
                    rsp.convert2string()
                ),
                UVM_LOW
            )

            response_ap.write(rsp);

            // Wait for packet completion before looking for another one.
            wait (vif.packet_busy === 1'b0);
        end
    endtask

endclass

`endif
