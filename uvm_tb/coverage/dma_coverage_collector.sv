class dma_coverage_collector extends uvm_subscriber #(dma_control_item);

    `uvm_component_utils(dma_coverage_collector)

    // Sampled transaction fields
    bit        sampled_direction;
    logic [23:0] sampled_base;
    logic [15:0] sampled_width;
    logic [15:0] sampled_height;

    bit sampled_done;
    bit sampled_error;
    bit sampled_timeout;

    covergroup dma_cg;

        option.per_instance = 1;

        cp_direction: coverpoint sampled_direction {
            bins read  = {dma_control_item::DMA_READ};
            bins write = {dma_control_item::DMA_WRITE};
        }

        cp_result: coverpoint {
            sampled_done,
            sampled_error,
            sampled_timeout
        } {
            bins success = {3'b100};
            bins error   = {3'b010};
            bins timeout = {3'b001};

            illegal_bins conflicting_results = {
                3'b110,
                3'b101,
                3'b011,
                3'b111
            };
        }

        cp_alignment: coverpoint sampled_base[1:0] {
            bins aligned    = {2'b00};
            bins misaligned = {[2'b01:2'b11]};
        }

        cp_address_region: coverpoint sampled_base {
            bins below_dma_range = {[24'h000000:24'h1FFFFF]};
            bins dma_range       = {[24'h200000:24'h20FFFF]};
            bins above_dma_range = {[24'h210000:24'hFFFFFF]};
        }

        cp_width: coverpoint sampled_width {
            bins below_min  = {[0:15]};
            bins minimum    = {16};
            bins middle[]   = {[17:255]};
            bins maximum    = {256};
            bins above_max  = {[257:65535]};
        }

        cp_height: coverpoint sampled_height {
            bins zero       = {0};
            bins minimum    = {1};
            bins middle[]   = {[2:255]};
            bins maximum    = {256};
            bins above_max  = {[257:65535]};
        }

        direction_x_result: cross cp_direction, cp_result;

        direction_x_alignment: cross cp_direction, cp_alignment;

        direction_x_address: cross cp_direction, cp_address_region;

    endgroup

    function new(
        string name = "dma_coverage_collector",
        uvm_component parent = null
    );
        super.new(name, parent);
        dma_cg = new();
    endfunction

    function void write(dma_control_item item);

        sampled_direction = item.direction;
        sampled_base      = item.img_base;
        sampled_width     = item.img_width;
        sampled_height    = item.img_height;

        sampled_done    = item.observed_done;
        sampled_error   = item.observed_error;
        sampled_timeout =
            !item.observed_done && !item.observed_error;

        dma_cg.sample();

        `uvm_info(
            "DMA_COV",
            $sformatf(
                "Sampled coverage: %s | instance coverage=%0.2f%%",
                item.convert2string(),
                dma_cg.get_inst_coverage()
            ),
            UVM_MEDIUM
        )

    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info(
            "DMA_COV_SUMMARY",
            $sformatf(
                "Final DMA functional coverage: %0.2f%%",
                dma_cg.get_inst_coverage()
            ),
            UVM_NONE
        )
    endfunction

endclass