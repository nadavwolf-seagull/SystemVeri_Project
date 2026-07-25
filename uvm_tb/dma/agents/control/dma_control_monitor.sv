class dma_control_monitor extends uvm_monitor;

    `uvm_component_utils(dma_control_monitor)

    virtual dma_sequencer_if vif;

    uvm_analysis_port #(dma_control_item) analysis_port;

    function new(
        string name = "dma_control_monitor",
        uvm_component parent = null
    );
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual dma_sequencer_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin
            `uvm_fatal(
                "DMA_CTRL_MON",
                "Failed to get dma_sequencer_if from uvm_config_db"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        dma_control_item observed_item;
        bit saw_busy;
        bit outcome_seen;
        int unsigned timeout_cycles;

        forever begin
            @(posedge vif.clk);

            if (vif.rst_n !== 1'b1)
                continue;

            if ((vif.dma_wr_start === 1'b1) ||
                (vif.dma_rd_start === 1'b1)) begin

                observed_item =
                    dma_control_item::type_id::create("observed_item");

                observed_item.direction =
                    (vif.dma_wr_start === 1'b1)
                    ? dma_control_item::DMA_WRITE
                    : dma_control_item::DMA_READ;

                observed_item.img_base   = vif.img_base;
                observed_item.img_width  = vif.img_width;
                observed_item.img_height = vif.img_height;

                saw_busy       = 1'b0;
                outcome_seen   = 1'b0;
                timeout_cycles = 0;

                // Wait for an actual result:
                // immediate validation error,
                // delayed validation error,
                // or successful completion.
                while (!outcome_seen && timeout_cycles < 500) begin
                    @(posedge vif.clk);
                    #1ns;

                    timeout_cycles++;

                    if (vif.busy === 1'b1)
                        saw_busy = 1'b1;

                    if (vif.error === 1'b1) begin
                        outcome_seen = 1'b1;
                    end
                    else if (vif.done === 1'b1) begin
                        outcome_seen = 1'b1;
                    end
                    else if (saw_busy && (vif.busy === 1'b0)) begin
                        outcome_seen = 1'b1;
                    end
                end

                observed_item.observed_busy  = vif.busy;
                observed_item.observed_done  = vif.done;
                observed_item.observed_error = vif.error;

                if (!outcome_seen) begin
                    `uvm_warning(
                        "DMA_CTRL_MON_TIMEOUT",
                        $sformatf(
                            "No final outcome observed within %0d cycles: %s",
                            timeout_cycles,
                            observed_item.convert2string()
                        )
                    )
                end

                `uvm_info(
                    "DMA_CTRL_MON",
                    $sformatf(
                        "Observed transaction: %s",
                        observed_item.convert2string()
                    ),
                    UVM_MEDIUM
                )

                analysis_port.write(observed_item);
            end
        end
    endtask

endclass