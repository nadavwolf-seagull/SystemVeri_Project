class dma_env extends uvm_env;

    `uvm_component_utils(dma_env)

    dma_control_agent control_agent;

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
    endfunction

endclass