class dma_control_driver
    extends uvm_driver #(dma_control_item);

    `uvm_component_utils(dma_control_driver)

    virtual dma_sequencer_if vif;

    function new(
        string name = "dma_control_driver",
        uvm_component parent = null
    );
        super.new(name, parent);
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
                "DMA_CTRL_DRV",
                "Failed to get dma_sequencer_if from uvm_config_db"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);
        dma_control_item req;

        drive_idle();

        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info(
                "DMA_CTRL_DRV",
                $sformatf("Driving transaction: %s",
                          req.convert2string()),
                UVM_MEDIUM
            )

            drive_transfer(req);

            seq_item_port.item_done();
        end
    endtask

    task automatic drive_idle();
        vif.dma_wr_start = 1'b0;
        vif.dma_rd_start = 1'b0;
        vif.img_base     = '0;
        vif.img_width    = '0;
        vif.img_height   = '0;
    endtask

    task automatic drive_transfer(dma_control_item req);
        int unsigned timeout_cycles;

        // Wait for reset release, but never wait forever.
        timeout_cycles = 0;

        while (vif.rst_n !== 1'b1) begin
            @(posedge vif.clk);
            timeout_cycles++;

            if (timeout_cycles >= 20) begin
                `uvm_error(
                    "DMA_CTRL_DRV",
                    "Timeout waiting for reset deassertion"
                )
                return;
            end
        end

        // Wait until DUT is idle.
        timeout_cycles = 0;

        while (vif.busy === 1'b1) begin
            @(posedge vif.clk);
            timeout_cycles++;

            if (timeout_cycles >= 100) begin
                `uvm_error(
                    "DMA_CTRL_DRV",
                    "Timeout waiting for DUT to become idle"
                )
                return;
            end
        end

        // Drive inputs away from the active clock edge to avoid races.
        @(negedge vif.clk);

        vif.img_base   = req.img_base;
        vif.img_width  = req.img_width;
        vif.img_height = req.img_height;

        if (req.direction == dma_control_item::DMA_WRITE) begin
            vif.dma_wr_start = 1'b1;
            vif.dma_rd_start = 1'b0;
        end
        else begin
            vif.dma_wr_start = 1'b0;
            vif.dma_rd_start = 1'b1;
        end

        // Keep start asserted across one complete rising edge.
        @(negedge vif.clk);

        vif.dma_wr_start = 1'b0;
        vif.dma_rd_start = 1'b0;

        // Wait for either rejection or entry into an active operation.
        timeout_cycles = 0;

        while ((vif.error !== 1'b1) &&
            (vif.busy  !== 1'b1)) begin
            @(posedge vif.clk);
            timeout_cycles++;

            if (timeout_cycles >= 20) begin
                `uvm_error(
                    "DMA_CTRL_DRV",
                    "Timeout: DUT neither accepted nor rejected DMA command"
                )
                return;
            end
        end

        if (vif.error === 1'b1) begin
            `uvm_info(
                "DMA_CTRL_DRV",
                "DMA command was rejected by the DUT as expected",
                UVM_LOW
            )
            return;
        end

        // Legal transfers may take longer, so use a larger timeout.
        timeout_cycles = 0;

        while (vif.busy === 1'b1) begin
            @(posedge vif.clk);
            timeout_cycles++;

            if (timeout_cycles >= 1000) begin
                `uvm_error(
                    "DMA_CTRL_DRV",
                    "Timeout waiting for DMA operation to complete"
                )
                return;
            end
        end

        if (vif.error === 1'b1) begin
            `uvm_warning(
                "DMA_CTRL_DRV",
                "DMA operation ended with error"
            )
        end
        else if (vif.done !== 1'b1) begin
            `uvm_error(
                "DMA_CTRL_DRV",
                "DMA returned to idle without asserting done"
            )
        end
    endtask

endclass