class dma_uvm_smoke_test extends uvm_test;

    `uvm_component_utils(dma_uvm_smoke_test)

    dma_env env;

    function new(
        string name = "dma_uvm_smoke_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = dma_env::type_id::create(
            "env",
            this
        );
    endfunction

    virtual task run_phase(uvm_phase phase);
        dma_invalid_width_sequence seq;

        phase.raise_objection(
            this,
            "Starting DMA invalid-width test"
        );

        seq = dma_invalid_width_sequence::type_id::create("seq");

        seq.start(env.control_agent.sequencer);

        #20ns;

        `uvm_info(
            "DMA_UVM_SMOKE",
            "Invalid-width sequence completed",
            UVM_LOW
        )

        phase.drop_objection(
            this,
            "DMA invalid-width test completed"
        );
    endtask

endclass