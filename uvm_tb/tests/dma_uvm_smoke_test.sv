class dma_uvm_smoke_test extends uvm_test;

    `uvm_component_utils(dma_uvm_smoke_test)

    function new(
        string name = "dma_uvm_smoke_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(
            this,
            "Starting DMA UVM smoke test"
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "UVM is running successfully with Verilator",
            UVM_LOW
        )

        #100ns;

        phase.drop_objection(
            this,
            "DMA UVM smoke test completed"
        );
    endtask

endclass