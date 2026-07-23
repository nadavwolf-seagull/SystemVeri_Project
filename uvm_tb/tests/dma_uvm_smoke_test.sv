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

        dma_validation_sequence validation_seq;
        dma_valid_read_sequence valid_read_seq;

        phase.raise_objection(
            this,
            "Starting DMA smoke test"
        );

        validation_seq = dma_validation_sequence::type_id::create(
            "validation_seq"
        );

        valid_read_seq = dma_valid_read_sequence::type_id::create(
            "valid_read_seq"
        );

        validation_seq.start(
            env.control_agent.sequencer
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "DMA validation sequence completed",
            UVM_LOW
        )

        valid_read_seq.start(
            env.control_agent.sequencer
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "Legal DMA READ sequence completed",
            UVM_LOW
        )

        #100ns;

        phase.drop_objection(
            this,
            "DMA smoke test completed"
        );

    endtask

endclass