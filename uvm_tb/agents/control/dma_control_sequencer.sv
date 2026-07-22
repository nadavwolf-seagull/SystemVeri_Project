class dma_control_sequencer
    extends uvm_sequencer #(dma_control_item);

    `uvm_component_utils(dma_control_sequencer)

    function new(
        string name = "dma_control_sequencer",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction

endclass