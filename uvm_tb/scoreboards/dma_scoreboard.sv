class dma_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(dma_scoreboard)

    uvm_analysis_imp #(dma_control_item, dma_scoreboard) analysis_export;

    int unsigned pass_count;
    int unsigned fail_count;

    function new(
        string name = "dma_scoreboard",
        uvm_component parent = null
    );
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void write(dma_control_item item);

        logic [15:0] effective_width;
        logic [15:0] effective_height;
        logic [23:0] effective_base;

        logic [31:0] total_words;
        logic [31:0] base_offset;
        logic [31:0] image_size_bytes;

        bit expected_error;

        effective_width =
            (item.img_width != 0)
            ? item.img_width
            : lab12_pkg::IMG_WIDTH[15:0];

        effective_height =
            (item.img_height != 0)
            ? item.img_height
            : lab12_pkg::IMG_HEIGHT[15:0];

        effective_base =
            (item.img_base != 0)
            ? item.img_base
            : lab12_pkg::R_SRAM_BASE_ADDR[23:0];

        total_words =
            ({16'd0, effective_width} >> 2) *
            {16'd0, effective_height};

        base_offset =
            {8'd0, effective_base} -
            {8'd0, lab12_pkg::R_SRAM_BASE_ADDR[23:0]};

        image_size_bytes = total_words << 2;

        expected_error =
            (effective_width[3:0] != 4'b0000) ||
            (effective_base[1:0] != 2'b00) ||
            (effective_base <
                lab12_pkg::R_SRAM_BASE_ADDR[23:0]) ||
            (total_words == 0) ||
            (total_words > lab12_pkg::ROM_DEPTH) ||
            (base_offset >=
                lab12_pkg::CHANNEL_SRAM_SIZE_BYTES) ||
            ((base_offset + image_size_bytes) >
                lab12_pkg::CHANNEL_SRAM_SIZE_BYTES);

        if (expected_error) begin

            if (item.observed_error === 1'b1) begin
                pass_count++;

                `uvm_info(
                    "DMA_SCB_PASS",
                    $sformatf(
                        "PASS invalid command: direction=%s base=0x%06h width=%0d height=%0d expected_error=1 observed_error=%0b",
                        (item.direction == dma_control_item::DMA_WRITE)
                            ? "WRITE"
                            : "READ",
                        item.img_base,
                        item.img_width,
                        item.img_height,
                        item.observed_error
                    ),
                    UVM_LOW
                )
            end
            else begin
                fail_count++;

                `uvm_error(
                    "DMA_SCB_FAIL",
                    $sformatf(
                        "FAIL invalid command: direction=%s base=0x%06h width=%0d height=%0d expected_error=1 observed_error=%0b",
                        (item.direction == dma_control_item::DMA_WRITE)
                            ? "WRITE"
                            : "READ",
                        item.img_base,
                        item.img_width,
                        item.img_height,
                        item.observed_error
                    )
                )
            end

        end
        else begin

            if ((item.observed_error === 1'b0) &&
                (item.observed_done  === 1'b1)) begin

                pass_count++;

                `uvm_info(
                    "DMA_SCB_PASS",
                    $sformatf(
                        "PASS legal command: direction=%s base=0x%06h width=%0d height=%0d done=%0b error=%0b",
                        (item.direction == dma_control_item::DMA_WRITE)
                            ? "WRITE"
                            : "READ",
                        item.img_base,
                        item.img_width,
                        item.img_height,
                        item.observed_done,
                        item.observed_error
                    ),
                    UVM_LOW
                )

            end
            else begin

                fail_count++;

                `uvm_error(
                    "DMA_SCB_FAIL",
                    $sformatf(
                        "FAIL legal command: direction=%s base=0x%06h width=%0d height=%0d expected_done=1 observed_done=%0b expected_error=0 observed_error=%0b",
                        (item.direction == dma_control_item::DMA_WRITE)
                            ? "WRITE"
                            : "READ",
                        item.img_base,
                        item.img_width,
                        item.img_height,
                        item.observed_done,
                        item.observed_error
                    )
                )

            end

        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "DMA_SCB_SUMMARY",
            $sformatf(
                "Scoreboard summary: PASS=%0d FAIL=%0d",
                pass_count,
                fail_count
            ),
            UVM_LOW
        )
    endfunction

endclass