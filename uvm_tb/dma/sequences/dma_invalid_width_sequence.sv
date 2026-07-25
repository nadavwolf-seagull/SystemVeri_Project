class dma_invalid_width_sequence
    extends uvm_sequence #(dma_control_item);

    `uvm_object_utils(dma_invalid_width_sequence)

    function new(string name = "dma_invalid_width_sequence");
        super.new(name);
    endfunction

    virtual task body();
        dma_control_item req;

        req = dma_control_item::type_id::create("req");

        start_item(req);

        req.direction  = dma_control_item::DMA_WRITE;
        req.img_base   = lab12_pkg::R_SRAM_BASE_ADDR[23:0];
        req.img_width  = 16'd18; // Illegal: not divisible by 16
        req.img_height = 16'd1;

        finish_item(req);
    endtask

endclass