class dma_random_sequence extends uvm_sequence #(dma_control_item);

    `uvm_object_utils(dma_random_sequence)

    rand int unsigned num_transactions;

    constraint num_transactions_c {
        num_transactions inside {[10:30]};
    }

    function new(string name = "dma_random_sequence");
        super.new(name);
        num_transactions = 20;
    endfunction

    virtual task body();

        dma_control_item req;

        int unsigned width_sel;
        int unsigned height_sel;
        int unsigned transfer_bytes;
        int unsigned max_offset;
        int unsigned random_offset;

        `uvm_info(
            "DMA_RANDOM_SEQ",
            $sformatf(
                "Starting constrained-random sequence with %0d transactions",
                num_transactions
            ),
            UVM_LOW
        )

        repeat (num_transactions) begin

            req = dma_control_item::type_id::create("req");

            start_item(req);

            /*
             * Keep transfers deliberately small so the regression remains
             * fast while still exercising different legal configurations.
             */
            width_sel  = 16 * $urandom_range(1, 4);
            height_sel = $urandom_range(1, 4);

            /*
             * Each pixel occupies four address bytes in the DMA address map.
             * Restrict the starting offset so the complete transfer remains
             * inside the 64 KiB image region.
             */
            transfer_bytes = width_sel * height_sel * 4;
            max_offset = 65536 - transfer_bytes;

            /*
             * Generate a word-aligned offset. Dividing and multiplying by
             * four guarantees that address bits [1:0] are zero.
             */
            random_offset =
                $urandom_range(0, max_offset / 4) * 4;

            if ($urandom_range(0, 1) == 0)
                req.direction = dma_control_item::DMA_READ;
            else
                req.direction = dma_control_item::DMA_WRITE;
            req.img_base  = 24'h200000 + random_offset;
            req.img_width = width_sel;
            req.img_height = height_sel;

            finish_item(req);

            `uvm_info(
                "DMA_RANDOM_SEQ",
                $sformatf(
                    "Completed randomized transaction: %s",
                    req.convert2string()
                ),
                UVM_MEDIUM
            )
        end

        `uvm_info(
            "DMA_RANDOM_SEQ",
            "Constrained-random sequence completed",
            UVM_LOW
        )

    endtask

endclass