`ifndef UART_RX_BASE_TEST_SV
`define UART_RX_BASE_TEST_SV

class uart_rx_base_test extends uvm_test;

    `uvm_component_utils(uart_rx_base_test)

    uart_rx_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uart_rx_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uart_rx_random_seq seq;
        phase.raise_objection(this);        // "אל תסיים, אני עסוק"
        seq = uart_rx_random_seq::type_id::create("seq");
        seq.start(env.agt.sqr);              // הרץ על ה-sequencer
        #1us;
        phase.drop_objection(this);          // "סיימתי"
    endtask

endclass

`endif