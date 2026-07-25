class uart_tx_env extends uvm_env;

    `uvm_component_utils(uart_tx_env)

    uart_tx_packet_agent packet_agent;
    uart_tx_serial_agent serial_agent;
    uart_tx_scoreboard   scoreboard;

    function new(
        string name = "uart_tx_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        packet_agent =
            uart_tx_packet_agent::type_id::create(
                "packet_agent", this
            );

        serial_agent =
            uart_tx_serial_agent::type_id::create(
                "serial_agent", this
            );

        scoreboard =
            uart_tx_scoreboard::type_id::create(
                "scoreboard", this
            );
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        packet_agent.monitor.analysis_port.connect(
            scoreboard.expected_fifo.analysis_export
        );

        serial_agent.monitor.analysis_port.connect(
            scoreboard.observed_fifo.analysis_export
        );
    endfunction

endclass
