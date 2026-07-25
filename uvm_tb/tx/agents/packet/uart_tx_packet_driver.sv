class uart_tx_packet_driver
    extends uvm_driver #(uart_tx_packet_item);

    `uvm_component_utils(uart_tx_packet_driver)

    virtual uart_tx_if vif;

    function new(
        string name = "uart_tx_packet_driver",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uart_tx_if)::get(
                this, "", "vif", vif
            )) begin
            `uvm_fatal(
                "TX_PKT_DRV",
                "Failed to get uart_tx_if"
            )
        end
    endfunction

    task drive_idle();
        vif.tx_en        = 1'b1;
        vif.cts_n        = 1'b0;
        vif.packet_valid = 1'b0;
        vif.packet_data  = '0;
        vif.packet_len   = '0;
    endtask

    task wait_for_reset_release();
        while (vif.rst_n !== 1'b1)
            @(posedge vif.sys_clk);
    endtask

    task check_idle_state(string check_context);
        if (vif.TX !== 1'b1) begin
            `uvm_error(
                "TX_IDLE_CHECK",
                $sformatf(
                    "%s: TX is not idle-high",
                    check_context
                )
            )
        end

        if (vif.packet_busy !== 1'b0) begin
            `uvm_error(
                "TX_IDLE_CHECK",
                $sformatf(
                    "%s: packet_busy unexpectedly asserted",
                    check_context
                )
            )
        end

        if (vif.packet_done !== 1'b0) begin
            `uvm_error(
                "TX_IDLE_CHECK",
                $sformatf(
                    "%s: packet_done unexpectedly asserted",
                    check_context
                )
            )
        end
    endtask

    task drive_rejected_packet(uart_tx_packet_item req);
        int unsigned cycle_index;

        @(negedge vif.sys_clk);

        vif.tx_en        = 1'b1;
        vif.cts_n        = 1'b0;
        vif.packet_data  = req.packet_data;
        vif.packet_len   = req.packet_len;
        vif.packet_valid = 1'b1;

        for (cycle_index = 0;
             cycle_index < 20;
             cycle_index++) begin

            @(posedge vif.sys_clk);

            if (vif.packet_ready !== 1'b0) begin
                `uvm_error(
                    "TX_INVALID_LEN",
                    $sformatf(
                        "Illegal packet_len=%0d was unexpectedly accepted",
                        req.packet_len
                    )
                )
            end

            check_idle_state(
                $sformatf(
                    "Illegal packet_len=%0d",
                    req.packet_len
                )
            );
        end

        @(negedge vif.sys_clk);
        vif.packet_valid = 1'b0;
        vif.packet_data  = '0;
        vif.packet_len   = '0;

        `uvm_info(
            "TX_INVALID_LEN_PASS",
            $sformatf(
                "PASS: illegal packet_len=%0d was rejected",
                req.packet_len
            ),
            UVM_LOW
        )
    endtask

    task drive_accepted_packet(uart_tx_packet_item req);
        int unsigned timeout_cycles;
        int unsigned cycle_index;

        @(negedge vif.sys_clk);

        vif.packet_data  = req.packet_data;
        vif.packet_len   = req.packet_len;
        vif.packet_valid = 1'b1;

        // Optional tx_en disable test.
        if (req.start_with_tx_disabled) begin
            vif.tx_en = 1'b0;

            for (cycle_index = 0;
                 cycle_index < req.tx_disable_cycles;
                 cycle_index++) begin

                @(posedge vif.sys_clk);

                if (vif.packet_ready !== 1'b0) begin
                    `uvm_error(
                        "TX_EN_CHECK",
                        "packet_ready asserted while tx_en=0"
                    )
                end

                check_idle_state("tx_en=0");
            end

            @(negedge vif.sys_clk);
            vif.tx_en = 1'b1;

            `uvm_info(
                "TX_EN_PASS",
                "PASS: transmitter remained idle while tx_en=0",
                UVM_LOW
            )
        end
        else begin
            vif.tx_en = 1'b1;
        end

        // Optional CTS pause before the first byte.
        vif.cts_n =
            req.hold_cts_before_start ? 1'b1 : 1'b0;

        timeout_cycles = 0;

        while (vif.packet_ready !== 1'b1) begin
            @(posedge vif.sys_clk);
            timeout_cycles++;

            if (timeout_cycles >= 100) begin
                `uvm_error(
                    "TX_PKT_DRV",
                    "Timeout waiting for packet_ready"
                )

                @(negedge vif.sys_clk);
                drive_idle();
                return;
            end
        end

        // packet_valid && packet_ready is sampled at this rising edge.
        @(posedge vif.sys_clk);

        @(negedge vif.sys_clk);
        vif.packet_valid = 1'b0;

        if (req.hold_cts_before_start) begin
            for (cycle_index = 0;
                 cycle_index < req.cts_hold_cycles;
                 cycle_index++) begin

                @(posedge vif.sys_clk);

                if (vif.TX !== 1'b1) begin
                    `uvm_error(
                        "TX_CTS_CHECK",
                        "UART transmission started while cts_n=1"
                    )
                end

                if (vif.packet_busy !== 1'b1) begin
                    `uvm_error(
                        "TX_CTS_CHECK",
                        "packet_busy was not asserted while waiting for CTS"
                    )
                end
            end

            @(negedge vif.sys_clk);
            vif.cts_n = 1'b0;

            `uvm_info(
                "TX_CTS_PASS",
                "PASS: packet paused before first byte and resumed after CTS",
                UVM_LOW
            )
        end

        timeout_cycles = 0;

        while (vif.packet_done !== 1'b1) begin
            @(posedge vif.sys_clk);
            timeout_cycles++;

            if (timeout_cycles >= 5000) begin
                `uvm_error(
                    "TX_PKT_DRV",
                    "Timeout waiting for packet_done"
                )

                @(negedge vif.sys_clk);
                drive_idle();
                return;
            end
        end

        `uvm_info(
            "TX_PKT_DRV",
            "Packet transmission completed",
            UVM_MEDIUM
        )

        @(negedge vif.sys_clk);
        vif.cts_n = 1'b0;
        vif.tx_en = 1'b1;
    endtask

    task run_phase(uvm_phase phase);
        uart_tx_packet_item req;

        drive_idle();
        wait_for_reset_release();

        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info(
                "TX_PKT_DRV",
                $sformatf(
                    "Driving %s",
                    req.convert2string()
                ),
                UVM_MEDIUM
            )

            if (req.expect_accept)
                drive_accepted_packet(req);
            else
                drive_rejected_packet(req);

            seq_item_port.item_done();
        end
    endtask

endclass
