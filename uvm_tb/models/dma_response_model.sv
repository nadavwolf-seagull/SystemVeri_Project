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

        logic [23:0] pending_addr;
        logic        pending_write;
        logic        command_pending;
        logic        response_consumed;

        vif.seq_cmd_ready = 1'b1;
        vif.tx_fifo_ready = 3'b111;

        vif.seq_rsp_valid = 1'b0;
        vif.seq_rsp_error = 1'b0;
        vif.seq_rsp_rdata = '0;

        pending_addr      = '0;
        pending_write     = 1'b0;
        command_pending   = 1'b0;
        response_consumed = 1'b0;

        forever begin
            /*
            * Sample DUT handshakes at the active clock edge.
            * Do not drive response signals here.
            */
            @(posedge vif.clk);

            if (vif.rst_n !== 1'b1) begin
                command_pending   = 1'b0;
                response_consumed = 1'b0;
            end
            else begin
                /*
                * Capture a command exactly when the DUT and model
                * complete the valid-ready handshake.
                */
                if ((vif.seq_cmd_valid === 1'b1) &&
                    (vif.seq_cmd_ready === 1'b1)) begin

                    pending_addr    = vif.seq_cmd_addr;
                    pending_write   = vif.seq_cmd_write;
                    command_pending = 1'b1;

                    `uvm_info(
                        "DMA_RSP_MODEL",
                        $sformatf(
                            "Accepted DMA command: write=%0b addr=0x%06h",
                            vif.seq_cmd_write,
                            vif.seq_cmd_addr
                        ),
                        UVM_MEDIUM
                    )
                end

                /*
                * Remember that the DUT consumed the outstanding response.
                * It will be deasserted at the following negedge.
                */
                if ((vif.seq_rsp_valid === 1'b1) &&
                    (vif.seq_rsp_ready === 1'b1)) begin

                    response_consumed = 1'b1;

                    `uvm_info(
                        "DMA_RSP_MODEL",
                        $sformatf(
                            "DUT consumed DMA response for addr=0x%06h",
                            pending_addr
                        ),
                        UVM_MEDIUM
                    )
                end
            end

            /*
            * Drive response signals away from the DUT sampling edge.
            */
            @(negedge vif.clk);

            if (vif.rst_n !== 1'b1) begin
                vif.seq_rsp_valid = 1'b0;
                vif.seq_rsp_error = 1'b0;
                vif.seq_rsp_rdata = '0;

                command_pending   = 1'b0;
                response_consumed = 1'b0;
            end
            else begin
                /*
                * Remove a response only after its handshake was sampled
                * at a posedge.
                */
                if (response_consumed) begin
                    vif.seq_rsp_valid = 1'b0;
                    vif.seq_rsp_error = 1'b0;
                    vif.seq_rsp_rdata = '0;

                    response_consumed = 1'b0;
                end

                /*
                * Generate the response for the command captured at the
                * preceding posedge. It will be stable before the next
                * DUT sampling edge.
                */
                if (command_pending) begin
                    vif.seq_rsp_error = 1'b0;

                    if (pending_write === 1'b0) begin
                        vif.seq_rsp_rdata = {
                            8'hD3, pending_addr,
                            8'hC2, pending_addr,
                            8'hB1, pending_addr,
                            8'hA0, pending_addr
                        };
                    end
                    else begin
                        vif.seq_rsp_rdata = '0;
                    end

                    vif.seq_rsp_valid = 1'b1;
                    command_pending   = 1'b0;
                end
            end
        end

    endtask

endclass