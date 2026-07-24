class dma_env extends uvm_env;

    `uvm_component_utils(dma_env)

    dma_control_agent  control_agent;
    dma_scoreboard     scoreboard;
    dma_response_model response_model;
    dma_rx_fifo_model  rx_fifo_model;

    function new(
        string name = "dma_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#(uvm_active_passive_enum)::set(
            this,
            "control_agent",
            "is_active",
            UVM_ACTIVE
        );

        control_agent = dma_control_agent::type_id::create(
            "control_agent",
            this
        );

        scoreboard = dma_scoreboard::type_id::create(
            "scoreboard",
            this
        );

        response_model = dma_response_model::type_id::create(
            "response_model",
            this
        );

        rx_fifo_model = dma_rx_fifo_model::type_id::create(
            "rx_fifo_model",
            this
        );
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        control_agent.monitor.analysis_port.connect(
            scoreboard.analysis_export
        );
    endfunction

endclass