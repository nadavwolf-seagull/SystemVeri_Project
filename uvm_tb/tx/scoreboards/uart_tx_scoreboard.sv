class uart_tx_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(uart_tx_scoreboard)

    uvm_tlm_analysis_fifo #(uart_tx_packet_item)
        expected_fifo;

    uvm_tlm_analysis_fifo #(uart_tx_packet_item)
        observed_fifo;

    int unsigned pass_count;
    int unsigned fail_count;

    function new(
        string name = "uart_tx_scoreboard",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        expected_fifo = new("expected_fifo", this);
        observed_fifo = new("observed_fifo", this);

        pass_count = 0;
        fail_count = 0;
    endfunction

    function bit packets_match(
        uart_tx_packet_item expected_item,
        uart_tx_packet_item observed_item
    );
        int unsigned byte_index;
        logic [7:0] expected_byte;
        logic [7:0] observed_byte;

        packets_match = 1'b1;

        if (expected_item.packet_len != observed_item.packet_len) begin
            packets_match = 1'b0;
            return packets_match;
        end

        for (byte_index = 0;
             byte_index < expected_item.packet_len;
             byte_index++) begin

            expected_byte =
                expected_item.packet_data[
                    lab12_pkg::UART_TX_MAX_PACKET_WIDTH -
                    1 - (byte_index * 8) -: 8
                ];

            observed_byte =
                observed_item.packet_data[
                    lab12_pkg::UART_TX_MAX_PACKET_WIDTH -
                    1 - (byte_index * 8) -: 8
                ];

            if (expected_byte !== observed_byte) begin
                packets_match = 1'b0;
                return packets_match;
            end
        end
    endfunction

    task run_phase(uvm_phase phase);
        uart_tx_packet_item expected_item;
        uart_tx_packet_item observed_item;

        forever begin
            expected_fifo.get(expected_item);
            observed_fifo.get(observed_item);

            if (packets_match(
                    expected_item,
                    observed_item
                )) begin

                pass_count++;

                `uvm_info(
                    "TX_SCB_PASS",
                    $sformatf(
                        "PASS: expected=%s observed=%s",
                        expected_item.convert2string(),
                        observed_item.convert2string()
                    ),
                    UVM_LOW
                )
            end
            else begin
                fail_count++;

                `uvm_error(
                    "TX_SCB_FAIL",
                    $sformatf(
                        "FAIL: expected=%s observed=%s",
                        expected_item.convert2string(),
                        observed_item.convert2string()
                    )
                )
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "TX_SCB_SUMMARY",
            $sformatf(
                "TX scoreboard summary: PASS=%0d FAIL=%0d",
                pass_count,
                fail_count
            ),
            UVM_NONE
        )
    endfunction

endclass