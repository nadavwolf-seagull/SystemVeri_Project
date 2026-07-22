class dma_control_item extends uvm_sequence_item;

    typedef enum bit {
        DMA_READ  = 1'b0,
        DMA_WRITE = 1'b1
    } dma_direction_e;

    rand dma_direction_e direction;
    rand logic [23:0]    img_base;
    rand logic [15:0]    img_width;
    rand logic [15:0]    img_height;

    constraint c_width {
        img_width inside {[16:256]};
        img_width % 16 == 0;
    }

    constraint c_height {
        img_height inside {[1:256]};
    }

    constraint c_base_alignment {
        img_base[1:0] == 2'b00;
    }

    `uvm_object_utils(dma_control_item)

    function new(string name = "dma_control_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf(
            "direction=%s base=0x%06h width=%0d height=%0d",
            (direction == DMA_WRITE) ? "WRITE" : "READ",
            img_base,
            img_width,
            img_height
        );
    endfunction

endclass