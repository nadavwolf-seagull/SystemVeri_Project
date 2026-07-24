class dma_rx_fifo_model extends uvm_component;

    `uvm_component_utils(dma_rx_fifo_model)

    virtual dma_sequencer_if vif;

    logic [31:0] next_r_data;
    logic [31:0] next_g_data;
    logic [31:0] next_b_data;

    function new(
        string name = "dma_rx_fifo_model",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(
            virtual dma_sequencer_if
        )::get(this, "", "vif", vif)) begin
            `uvm_fatal(
                "DMA_RX_FIFO_CFG",
                "Failed to get dma_sequencer_if"
            )
        end
    endfunction

    task run_phase(uvm_phase phase);

        vif.rx_fifo_empty      <= 3'b000;
        vif.rx_fifo_data_valid <= 3'b000;

        vif.rx_fifo_r_data <= '0;
        vif.rx_fifo_g_data <= '0;
        vif.rx_fifo_b_data <= '0;

        next_r_data = 32'h1000_0000;
        next_g_data = 32'h2000_0000;
        next_b_data = 32'h3000_0000;

        forever begin
            @(posedge vif.clk);

            vif.rx_fifo_data_valid <= 3'b000;

            if (!vif.rst_n) begin
                vif.rx_fifo_empty      <= 3'b000;
                vif.rx_fifo_data_valid <= 3'b000;

                vif.rx_fifo_r_data <= '0;
                vif.rx_fifo_g_data <= '0;
                vif.rx_fifo_b_data <= '0;

                next_r_data = 32'h1000_0000;
                next_g_data = 32'h2000_0000;
                next_b_data = 32'h3000_0000;
            end
            else begin
                if (vif.rx_fifo_pop[0]) begin
                    vif.rx_fifo_r_data     <= next_r_data;
                    vif.rx_fifo_data_valid[0] <= 1'b1;

                    `uvm_info(
                        "DMA_RX_FIFO",
                        $sformatf(
                            "Providing R FIFO data: 0x%08h",
                            next_r_data
                        ),
                        UVM_MEDIUM
                    )

                    next_r_data = next_r_data + 1'b1;
                end

                if (vif.rx_fifo_pop[1]) begin
                    vif.rx_fifo_g_data     <= next_g_data;
                    vif.rx_fifo_data_valid[1] <= 1'b1;

                    `uvm_info(
                        "DMA_RX_FIFO",
                        $sformatf(
                            "Providing G FIFO data: 0x%08h",
                            next_g_data
                        ),
                        UVM_MEDIUM
                    )

                    next_g_data = next_g_data + 1'b1;
                end

                if (vif.rx_fifo_pop[2]) begin
                    vif.rx_fifo_b_data     <= next_b_data;
                    vif.rx_fifo_data_valid[2] <= 1'b1;

                    `uvm_info(
                        "DMA_RX_FIFO",
                        $sformatf(
                            "Providing B FIFO data: 0x%08h",
                            next_b_data
                        ),
                        UVM_MEDIUM
                    )

                    next_b_data = next_b_data + 1'b1;
                end
            end
        end
    endtask

endclass