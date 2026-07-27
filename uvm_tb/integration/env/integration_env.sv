`ifndef INTEGRATION_ENV_SV
`define INTEGRATION_ENV_SV

class integration_env extends uvm_env;

    `uvm_component_utils(integration_env)

    integration_uart_rx_agent    rx_agent;
    integration_uart_tx_agent    tx_agent;
    integration_reference_model  reference_model;
    integration_scoreboard       scoreboard;

    function new(
        string name = "integration_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#(uvm_active_passive_enum)::set(
            this,
            "rx_agent",
            "is_active",
            UVM_ACTIVE
        );

        rx_agent =
            integration_uart_rx_agent::type_id::create(
                "rx_agent",
                this
            );

        tx_agent =
            integration_uart_tx_agent::type_id::create(
                "tx_agent",
                this
            );

        reference_model =
            integration_reference_model::type_id::create(
                "reference_model",
                this
            );

        scoreboard =
            integration_scoreboard::type_id::create(
                "scoreboard",
                this
            );
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        rx_agent.driver.command_ap.connect(
            reference_model.command_imp
        );

        reference_model.expected_ap.connect(
            scoreboard.expected_imp
        );

        tx_agent.monitor.response_ap.connect(
            scoreboard.actual_imp
        );
    endfunction

endclass

`endif
