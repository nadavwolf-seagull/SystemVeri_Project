class uart_tx_full_test extends uvm_test;

    `uvm_component_utils(uart_tx_full_test)

    uart_tx_env env;

    function new(
        string name = "uart_tx_full_test",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = uart_tx_env::type_id::create(
            "env", this
        );
    endfunction

    task run_phase(uvm_phase phase);
        uart_tx_full_sequence sequence_h;

        phase.raise_objection(
            this,
            "Starting UART TX full verification test"
        );

        sequence_h =
            uart_tx_full_sequence::type_id::create(
                "sequence_h"
            );

        sequence_h.start(
            env.packet_agent.sequencer
        );

        #200ns;

        phase.drop_objection(
            this,
            "UART TX full verification test completed"
        );
    endtask

endclass
