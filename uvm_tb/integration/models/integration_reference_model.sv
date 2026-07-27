`ifndef INTEGRATION_REFERENCE_MODEL_SV
`define INTEGRATION_REFERENCE_MODEL_SV

`uvm_analysis_imp_decl(_cmd)

class integration_reference_model extends uvm_component;

    `uvm_component_utils(integration_reference_model)

    uvm_analysis_imp_cmd #(
        integration_cmd_item,
        integration_reference_model
    ) command_imp;

    uvm_analysis_port #(integration_rsp_item) expected_ap;

    logic [31:0] rgf_model [0:15];

    // Pixel memory model indexed by linear pixel index.
    logic [23:0] pixel_model [int unsigned];

    function new(
        string name = "integration_reference_model",
        uvm_component parent = null
    );
        super.new(name, parent);

        command_imp = new("command_imp", this);
        expected_ap = new("expected_ap", this);

        foreach (rgf_model[index])
            rgf_model[index] = 32'h0000_0000;

        rgf_model[lab12_pkg::RGF_ADDR_IMG_WIDTH] =
            lab12_pkg::IMG_WIDTH;

        rgf_model[lab12_pkg::RGF_ADDR_IMG_HEIGHT] =
            lab12_pkg::IMG_HEIGHT;

        rgf_model[lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL] =
            lab12_pkg::FIFO_AE_LEVEL;

        rgf_model[lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL] =
            lab12_pkg::FIFO_AF_LEVEL;

        rgf_model[lab12_pkg::RGF_ADDR_VERSION] =
            lab12_pkg::RGF_VERSION_VALUE;
    endfunction

    function logic [31:0] read_rgf(
        input logic [3:0] addr
    );
        case (addr)
            lab12_pkg::RGF_ADDR_VERSION:
                return lab12_pkg::RGF_VERSION_VALUE;

            default:
                return rgf_model[addr];
        endcase
    endfunction

    function logic [23:0] read_pixel(
        input int unsigned pixel_index
    );
        if (pixel_model.exists(pixel_index))
            return pixel_model[pixel_index];

        return 24'h000000;
    endfunction

    function void write_cmd(integration_cmd_item cmd);
        integration_rsp_item expected;

        logic [3:0]  rgf_addr;
        logic [31:0] pixel_offset_full;
        logic [15:0] pixel_offset_low16;
        int unsigned pixel_index;
        int unsigned pixel_row;
        int unsigned pixel_col;

        rgf_addr = cmd.addr[3:0];

        pixel_offset_full =
            {8'h00, cmd.addr} -
            lab12_pkg::PIXEL_ALIAS_BASE_ADDR;

        pixel_offset_low16 =
            pixel_offset_full[15:0];

        pixel_index =
            pixel_offset_full >>
            lab12_pkg::AHB_PIXEL_ADDR_SHIFT;

        pixel_row =
            pixel_index / lab12_pkg::IMG_WIDTH;

        pixel_col =
            pixel_index % lab12_pkg::IMG_WIDTH;

        `uvm_info(
            "INT_REF_MODEL",
            $sformatf(
                "Processing command: %s",
                cmd.convert2string()
            ),
            UVM_MEDIUM
        )

        case (cmd.kind)

            INT_CMD_RGF_WRITE: begin
                case (rgf_addr)
                    lab12_pkg::RGF_ADDR_CTRL,
                    lab12_pkg::RGF_ADDR_IMG_BASE,
                    lab12_pkg::RGF_ADDR_IMG_WIDTH,
                    lab12_pkg::RGF_ADDR_IMG_HEIGHT,
                    lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL,
                    lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL:
                        rgf_model[rgf_addr] = cmd.data;

                    default: begin
                        // Read-only or unsupported register.
                    end
                endcase
            end

            INT_CMD_RGF_READ: begin
                expected =
                    integration_rsp_item::type_id::create(
                        "expected_rgf"
                    );

                expected.kind = INT_RSP_RGF_READ;

                expected.packet_len =
                    lab12_pkg::UART_TX_PACKET_LEN_WIDTH'(
                        lab12_pkg::TX_PACKET_BYTES
                    );

                expected.addr =
                    {20'h00000, rgf_addr};

                expected.data =
                    read_rgf(rgf_addr);

                expected_ap.write(expected);
            end

            INT_CMD_PIXEL_WRITE: begin
                pixel_model[pixel_index] =
                    cmd.data[23:0];

                `uvm_info(
                    "INT_REF_PIXEL_WRITE",
                    $sformatf(
                        {
                            "Stored expected pixel index=%0d ",
                            "row=%0d col=%0d offset=0x%04h RGB=0x%06h"
                        },
                        pixel_index,
                        pixel_row,
                        pixel_col,
                        pixel_offset_low16,
                        cmd.data[23:0]
                    ),
                    UVM_MEDIUM
                )
            end

            INT_CMD_PIXEL_READ: begin
                expected =
                    integration_rsp_item::type_id::create(
                        "expected_pixel"
                    );

                expected.kind =
                    INT_RSP_PIXEL_READ;

                expected.packet_len =
                    lab12_pkg::UART_TX_PACKET_LEN_WIDTH'(
                        lab12_pkg::TX_PACKET_BYTES
                    );

                expected.pixel_offset =
                    pixel_offset_low16;

                expected.pixel_index =
                    pixel_index;

                expected.pixel_row =
                    pixel_row[7:0];

                expected.pixel_col =
                    pixel_col[7:0];

                expected.pixel =
                    read_pixel(pixel_index);

                `uvm_info(
                    "INT_REF_PIXEL_READ",
                    $sformatf(
                        {
                            "Expected pixel index=%0d row=%0d col=%0d ",
                            "offset=0x%04h RGB=0x%06h"
                        },
                        expected.pixel_index,
                        expected.pixel_row,
                        expected.pixel_col,
                        expected.pixel_offset,
                        expected.pixel
                    ),
                    UVM_MEDIUM
                )

                expected_ap.write(expected);
            end

            default: begin
                // Image support is added in the following stage.
            end

        endcase
    endfunction

endclass

`endif
