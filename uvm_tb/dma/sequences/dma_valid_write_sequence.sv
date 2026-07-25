class dma_valid_write_sequence extends uvm_sequence #(dma_control_item);

    `uvm_object_utils(dma_valid_write_sequence)

    function new(
        string name = "dma_valid_write_sequence"
    );
        super.new(name);
    endfunction

    virtual task body();

        dma_control_item req;

        req = dma_control_item::type_id::create("req");

        start_item(req);

        req.direction  = dma_control_item::DMA_WRITE;

        req.img_base   = lab12_pkg::R_SRAM_BASE_ADDR[23:0];
        req.img_width  = 16'd16;
        req.img_height = 16'd1;

        finish_item(req);

    endtask

endclass