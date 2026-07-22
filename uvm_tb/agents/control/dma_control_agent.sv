class dma_control_agent extends uvm_agent;

    `uvm_component_utils(dma_control_agent)

    dma_control_sequencer sequencer;
    dma_control_driver    driver;

    function new(
        string name = "dma_control_agent",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (get_is_active() == UVM_ACTIVE) begin
            sequencer = dma_control_sequencer::type_id::create(
                "sequencer",
                this
            );

            driver = dma_control_driver::type_id::create(
                "driver",
                this
            );
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(
                sequencer.seq_item_export
            );
        end
    endfunction

endclass