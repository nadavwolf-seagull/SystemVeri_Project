class dma_response_model extends uvm_component;

    `uvm_component_utils(dma_response_model)

    virtual dma_sequencer_if vif;

    function new(
        string name = "dma_response_model",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(
                virtual dma_sequencer_if
            )::get(
                this,
                "",
                "vif",
                vif
            )) begin

            `uvm_fatal(
                "DMA_RSP_MODEL",
                "Failed to get virtual dma_sequencer_if"
            )

        end
    endfunction


    task run_phase(uvm_phase phase);

        logic [23:0] captured_addr;

        // Default behavior of the modeled environment
        vif.seq_cmd_ready = 1'b1;
        vif.tx_fifo_ready = 3'b111;

        vif.seq_rsp_valid = 1'b0;
        vif.seq_rsp_error = 1'b0;
        vif.seq_rsp_rdata = '0;

        forever begin
            @(posedge vif.clk);

            // These signals are owned by the response model.
            // Keep them asserted so the DUT can always issue commands
            // and drain READ data into the modeled TX FIFOs.
            vif.seq_cmd_ready = 1'b1;
            vif.tx_fifo_ready = 3'b111;

            if (vif.rst_n !== 1'b1) begin
                vif.seq_rsp_valid = 1'b0;
                vif.seq_rsp_error = 1'b0;
                vif.seq_rsp_rdata = '0;
            end
            else if (
                (vif.seq_cmd_valid === 1'b1) &&
                (vif.seq_cmd_ready === 1'b1)
            ) begin

                captured_addr = vif.seq_cmd_addr;

                `uvm_info(
                    "DMA_RSP_MODEL",
                    $sformatf(
                        "Accepted DMA command: write=%0b addr=0x%06h",
                        vif.seq_cmd_write,
                        captured_addr
                    ),
                    UVM_MEDIUM
                )

                // The current model supports READ responses.
                if (vif.seq_cmd_write === 1'b0) begin

                    // Return a deterministic response one cycle later.
                    @(negedge vif.clk);

                    vif.seq_rsp_error = 1'b0;

                    vif.seq_rsp_rdata = {
                        8'hD3, captured_addr,
                        8'hC2, captured_addr,
                        8'hB1, captured_addr,
                        8'hA0, captured_addr
                    };

                    vif.seq_rsp_valid = 1'b1;

                    // Keep valid asserted until the DUT accepts the response.
                    do begin
                        @(negedge vif.clk);
                    end
                    while (vif.seq_rsp_ready !== 1'b1);

                    vif.seq_rsp_valid = 1'b0;
                    vif.seq_rsp_error = 1'b0;
                    vif.seq_rsp_rdata = '0;

                    `uvm_info(
                        "DMA_RSP_MODEL",
                        $sformatf(
                            "Returned READ response for addr=0x%06h",
                            captured_addr
                        ),
                        UVM_MEDIUM
                    )

                end
                else begin
                    `uvm_warning(
                        "DMA_RSP_MODEL",
                        "WRITE command received by READ-only response model"
                    )
                end
            end
        end

    endtask

endclass