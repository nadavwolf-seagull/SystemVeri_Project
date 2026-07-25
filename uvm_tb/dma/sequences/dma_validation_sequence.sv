class dma_validation_sequence extends uvm_sequence #(dma_control_item);

    `uvm_object_utils(dma_validation_sequence)

    function new(string name = "dma_validation_sequence");
        super.new(name);
    endfunction

    task send_write(
        logic [23:0] base,
        logic [15:0] width,
        logic [15:0] height
    );
        dma_control_item req;

        req = dma_control_item::type_id::create("req");

        start_item(req);

        req.direction  = dma_control_item::DMA_WRITE;
        req.img_base   = base;
        req.img_width  = width;
        req.img_height = height;

        finish_item(req);
    endtask

    virtual task body();

        logic [23:0] r_base;
        logic [23:0] channel_bytes;

        r_base =
            lab12_pkg::R_SRAM_BASE_ADDR[23:0];

        channel_bytes =
            lab12_pkg::CHANNEL_SRAM_SIZE_BYTES[23:0];

        // 1. Width is not divisible by 16.
        send_write(
            r_base,
            16'd18,
            16'd1
        );

        // 2. Base address is not 4-byte aligned.
        send_write(
            r_base + 24'd2,
            16'd16,
            16'd1
        );

        // 3. Base address is below the R SRAM base.
        send_write(
            r_base - 24'd4,
            16'd16,
            16'd1
        );

        // 4. Image is larger than ROM_DEPTH.
        send_write(
            r_base,
            16'd256,
            16'd257
        );

        // 5. Base address is outside the channel window.
        send_write(
            r_base + channel_bytes,
            16'd16,
            16'd1
        );

        // 6. Image starts inside the window but crosses its boundary.
        send_write(
            r_base + channel_bytes - 24'd16,
            16'd16,
            16'd2
        );

    endtask

endclass