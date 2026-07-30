`ifndef INTEGRATION_DMA_BURST_SEQUENCE_SV
`define INTEGRATION_DMA_BURST_SEQUENCE_SV

class integration_dma_burst_sequence
    extends uvm_sequence #(integration_cmd_item);

    `uvm_object_utils(integration_dma_burst_sequence)

    function new(
        string name = "integration_dma_burst_sequence"
    );
        super.new(name);
    endfunction

    task body();
        integration_cmd_item cmd;

        cmd =
            integration_cmd_item::type_id::create(
                "dma_image_read_cmd"
            );

        start_item(cmd);

        // IMAGE_READ activates the real DMA read path:
        //
        // UART RX
        // → parser/classifier
        // → DMA configuration
        // → DMA sequencer
        // → AHB master
        // → RGB SRAM
        cmd.kind =
            INT_CMD_IMAGE_READ;

        // Global base address of the red SRAM channel.
        cmd.addr =
            lab12_pkg::R_SRAM_BASE_ADDR[
                lab12_pkg::CMD_ADDR_WIDTH-1:0
            ];

        cmd.data =
            '0;

        // Sixteen pixels correspond to four packed SRAM words:
        //
        // 16 pixels / 4 pixels per SRAM word = 4 AHB beats.
        //
        // The DMA should therefore generate one INCR4 burst for
        // each R/G/B SRAM channel.
        cmd.img_width =
            16'd16;

        cmd.img_height =
            16'd1;

        cmd.inject_parity_error =
            1'b0;

        cmd.inject_framing_error =
            1'b0;

        cmd.idle_bits =
            4;

        finish_item(cmd);

        `uvm_info(
            "INT_DMA_BURST_SEQ",
            $sformatf(
                "DMA burst command completed: %s",
                cmd.convert2string()
            ),
            UVM_LOW
        )
    endtask

endclass

`endif