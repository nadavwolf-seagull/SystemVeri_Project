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

        dma_validation_sequence  validation_seq;
        dma_valid_read_sequence  valid_read_seq;
        dma_valid_write_sequence valid_write_seq;
        dma_random_sequence      random_seq;

        phase.raise_objection(
            this,
            "Starting DMA smoke test"
        );

        validation_seq =
            dma_validation_sequence::type_id::create(
                "validation_seq"
            );

        valid_read_seq =
            dma_valid_read_sequence::type_id::create(
                "valid_read_seq"
            );

        valid_write_seq =
            dma_valid_write_sequence::type_id::create(
                "valid_write_seq"
            );

        random_seq =
            dma_random_sequence::type_id::create(
                "random_seq"
            );

        /*
         * Run directed invalid-command validation.
         */
        validation_seq.start(
            env.control_agent.sequencer
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "DMA validation sequence completed",
            UVM_LOW
        )

        /*
         * Run one legal READ command.
         */
        valid_read_seq.start(
            env.control_agent.sequencer
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "Legal DMA READ sequence completed",
            UVM_LOW
        )

        /*
         * Run one legal WRITE command.
         */
        valid_write_seq.start(
            env.control_agent.sequencer
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "Legal DMA WRITE sequence completed",
            UVM_LOW
        )

        /*
         * Run multiple constrained-random legal DMA commands.
         */
        random_seq.num_transactions = 20;

        random_seq.start(
            env.control_agent.sequencer
        );

        `uvm_info(
            "DMA_UVM_SMOKE",
            "DMA constrained-random sequence completed",
            UVM_LOW
        )

        /*
         * Allow the monitor, scoreboard and coverage collector
         * to finish processing the final transaction.
         */
        #100ns;

        phase.drop_objection(
            this,
            "DMA smoke test completed"
        );

    endtask

endclass