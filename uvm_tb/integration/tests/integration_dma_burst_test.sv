`ifndef INTEGRATION_DMA_BURST_TEST_SV
`define INTEGRATION_DMA_BURST_TEST_SV

class integration_dma_burst_test extends uvm_test;

    `uvm_component_utils(integration_dma_burst_test)

    // Only the active UART RX agent is required.
    //
    // We intentionally do not instantiate the complete integration
    // environment because an IMAGE_READ produces image packets on
    // UART TX, while the existing TX monitor is intended for 9-byte
    // control responses.
    integration_uart_rx_agent rx_agent;

    virtual integration_if vif;

    int unsigned burst_count;
    int unsigned beat_count;
    int unsigned error_count;

    logic [lab12_pkg::AHB_ADDR_WIDTH-1:0]
        expected_addr;

    function new(
        string name = "integration_dma_burst_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        rx_agent =
            integration_uart_rx_agent::type_id::create(
                "rx_agent",
                this
            );

        if (!uvm_config_db#(virtual integration_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin
            `uvm_fatal(
                "INT_DMA_BURST_TEST",
                "Failed to get integration_if"
            )
        end
    endfunction

    // =========================================================
    // Wait for one accepted AHB address phase
    // =========================================================
    task automatic wait_for_accepted_transfer(
        input int unsigned timeout_limit
    );
        int unsigned timeout_cycles;

        timeout_cycles = 0;

        while (
            !(
                (vif.ahb_hready === 1'b1) &&
                (vif.ahb_htrans[1] === 1'b1)
            ) &&
            (timeout_cycles < timeout_limit)
        ) begin
            @(posedge vif.clk_ctrl);
            timeout_cycles++;
        end

        if (timeout_cycles >= timeout_limit) begin
            `uvm_fatal(
                "INT_DMA_AHB_TIMEOUT",
                "Timed out waiting for an accepted AHB transfer"
            )
        end
    endtask

    // =========================================================
    // Check three RGB INCR4 bursts
    //
    // Expected for each burst:
    //
    // beat 0: NONSEQ
    // beat 1: SEQ
    // beat 2: SEQ
    // beat 3: SEQ
    //
    // Address increment: +4 bytes per beat.
    // =========================================================
    task automatic check_dma_bursts();
        logic [lab12_pkg::AHB_ADDR_WIDTH-1:0]
            first_addr;

        burst_count = 0;
        beat_count  = 0;
        error_count = 0;

        while (burst_count < 3) begin

            // -----------------------------
            // First beat: NONSEQ
            // -----------------------------
            wait_for_accepted_transfer(500000);

            first_addr =
                vif.ahb_haddr;

            expected_addr =
                first_addr;

            if (vif.ahb_hburst !==
                lab12_pkg::AHB_HBURST_INCR4) begin

                `uvm_error(
                    "INT_DMA_HBURST",
                    $sformatf(
                        "Burst %0d: expected INCR4, got HBURST=%03b",
                        burst_count,
                        vif.ahb_hburst
                    )
                )

                error_count++;
            end

            if (vif.ahb_htrans !==
                lab12_pkg::AHB_HTRANS_NONSEQ) begin

                `uvm_error(
                    "INT_DMA_NONSEQ",
                    $sformatf(
                        {
                            "Burst %0d beat 0: expected NONSEQ, ",
                            "got HTRANS=%02b"
                        },
                        burst_count,
                        vif.ahb_htrans
                    )
                )

                error_count++;
            end

            if (vif.ahb_hwrite !== 1'b0) begin
                `uvm_error(
                    "INT_DMA_DIRECTION",
                    $sformatf(
                        "Burst %0d: expected READ, but HWRITE=1",
                        burst_count
                    )
                )

                error_count++;
            end

            if (vif.ahb_hsize !==
                lab12_pkg::AHB_HSIZE_WORD) begin

                `uvm_error(
                    "INT_DMA_HSIZE",
                    $sformatf(
                        {
                            "Burst %0d: expected word transfer, ",
                            "got HSIZE=%03b"
                        },
                        burst_count,
                        vif.ahb_hsize
                    )
                )

                error_count++;
            end

            `uvm_info(
                "INT_DMA_BURST",
                $sformatf(
                    {
                        "Burst %0d beat 0: NONSEQ ",
                        "addr=0x%08h HRDATA=0x%08h"
                    },
                    burst_count,
                    vif.ahb_haddr,
                    vif.ahb_hrdata
                ),
                UVM_LOW
            )

            // Move beyond the already-observed address phase.
            @(posedge vif.clk_ctrl);

            // -----------------------------
            // Following three beats: SEQ
            // -----------------------------
            for (beat_count = 1;
                 beat_count < 4;
                 beat_count++) begin

                wait_for_accepted_transfer(10000);

                expected_addr =
                    first_addr + (beat_count * 4);

                if (vif.ahb_hburst !==
                    lab12_pkg::AHB_HBURST_INCR4) begin

                    `uvm_error(
                        "INT_DMA_HBURST",
                        $sformatf(
                            {
                                "Burst %0d beat %0d: ",
                                "expected INCR4, got HBURST=%03b"
                            },
                            burst_count,
                            beat_count,
                            vif.ahb_hburst
                        )
                    )

                    error_count++;
                end

                if (vif.ahb_htrans !==
                    lab12_pkg::AHB_HTRANS_SEQ) begin

                    `uvm_error(
                        "INT_DMA_SEQ",
                        $sformatf(
                            {
                                "Burst %0d beat %0d: ",
                                "expected SEQ, got HTRANS=%02b"
                            },
                            burst_count,
                            beat_count,
                            vif.ahb_htrans
                        )
                    )

                    error_count++;
                end

                if (vif.ahb_haddr !== expected_addr) begin

                    `uvm_error(
                        "INT_DMA_ADDR",
                        $sformatf(
                            {
                                "Burst %0d beat %0d: ",
                                "expected address=0x%08h, ",
                                "actual address=0x%08h"
                            },
                            burst_count,
                            beat_count,
                            expected_addr,
                            vif.ahb_haddr
                        )
                    )

                    error_count++;
                end

                if (vif.ahb_hresp !== 1'b0) begin
                    `uvm_error(
                        "INT_DMA_HRESP",
                        $sformatf(
                            "Burst %0d beat %0d returned HRESP=1",
                            burst_count,
                            beat_count
                        )
                    )

                    error_count++;
                end

                `uvm_info(
                    "INT_DMA_BURST",
                    $sformatf(
                        {
                            "Burst %0d beat %0d: SEQ ",
                            "addr=0x%08h HRDATA=0x%08h"
                        },
                        burst_count,
                        beat_count,
                        vif.ahb_haddr,
                        vif.ahb_hrdata
                    ),
                    UVM_LOW
                )

                // Move beyond the already-observed address phase.
                @(posedge vif.clk_ctrl);
            end

            `uvm_info(
                "INT_DMA_BURST_DONE",
                $sformatf(
                    {
                        "Burst %0d passed: base=0x%08h, ",
                        "last address=0x%08h"
                    },
                    burst_count,
                    first_addr,
                    first_addr + 32'd12
                ),
                UVM_LOW
            )

            burst_count++;
        end
    endtask

    task run_phase(uvm_phase phase);
        integration_dma_burst_sequence seq;
        int unsigned done_timeout;

        phase.raise_objection(this);

        wait (
            (vif.rst_ctrl_n === 1'b1) &&
            (vif.rst_img_n  === 1'b1) &&
            (vif.rst_uart_n === 1'b1)
        );

        repeat (20)
            @(posedge vif.clk_uart);

        seq =
            integration_dma_burst_sequence::type_id::create(
                "seq"
            );

        // The AHB checker must start before the UART command has
        // completed, because the DMA may begin shortly after the
        // parser accepts the frame.
        fork
            begin
                seq.start(rx_agent.sequencer);
            end

            begin
                check_dma_bursts();
            end
        join

        // Wait for complete DMA operation.
        done_timeout = 0;

        while (
            (vif.seq_transfer_done !== 1'b1) &&
            (done_timeout < 500000)
        ) begin
            @(posedge vif.clk_ctrl);
            done_timeout++;
        end

        if (done_timeout >= 500000) begin
            `uvm_error(
                "INT_DMA_DONE_TIMEOUT",
                "Timed out waiting for DMA completion"
            )

            error_count++;
        end

        if (vif.fifo_error) begin
            `uvm_error(
                "INT_DMA_FIFO_ERROR",
                "FIFO error observed during DMA burst test"
            )

            error_count++;
        end

        if (vif.rgf_error) begin
            `uvm_error(
                "INT_DMA_RGF_ERROR",
                "RGF/system error observed during DMA burst test"
            )

            error_count++;
        end

        if (error_count == 0) begin
            `uvm_info(
                "INT_DMA_BURST_PASS",
                $sformatf(
                    {
                        "DMA AHB INCR4 burst test passed: ",
                        "bursts=%0d beats=%0d"
                    },
                    burst_count,
                    burst_count * 4
                ),
                UVM_LOW
            )
        end
        else begin
            `uvm_error(
                "INT_DMA_BURST_TEST",
                $sformatf(
                    "DMA burst test completed with %0d errors",
                    error_count
                )
            )
        end

        repeat (50)
            @(posedge vif.clk_ctrl);

        phase.drop_objection(this);
    endtask

endclass

`endif