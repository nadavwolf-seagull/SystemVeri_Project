`ifndef INTEGRATION_CMD_ITEM_SV
`define INTEGRATION_CMD_ITEM_SV

typedef enum logic [2:0] {
    INT_CMD_RGF_WRITE,
    INT_CMD_RGF_READ,
    INT_CMD_PIXEL_WRITE,
    INT_CMD_PIXEL_READ,
    INT_CMD_IMAGE_WRITE,
    INT_CMD_IMAGE_READ,
    INT_CMD_INVALID
} integration_cmd_kind_e;

class integration_cmd_item extends uvm_sequence_item;

    `uvm_object_utils(integration_cmd_item)

    rand integration_cmd_kind_e kind;

    // Global 24-bit command address.
    rand logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] addr;

    // RGF write data or RGB pixel data.
    rand logic [lab12_pkg::CMD_DATA_WIDTH-1:0] data;

    // Image dimensions for IMAGE_WRITE / IMAGE_READ.
    rand logic [15:0] img_width;
    rand logic [15:0] img_height;

    // UART-level error injection.
    rand bit inject_parity_error;
    rand bit inject_framing_error;

    // Idle bit-times inserted before the UART frame.
    rand int unsigned idle_bits;

    constraint c_idle_bits {
        idle_bits inside {[1:8]};
    }

    // Keep the initial integration regressions deterministic:
    // inject at most one physical-layer error per frame.
    constraint c_single_uart_error {
        !(inject_parity_error && inject_framing_error);
    }

    constraint c_image_dimensions {
        if (kind inside {INT_CMD_IMAGE_WRITE, INT_CMD_IMAGE_READ}) {
            img_width  != 0;
            img_height != 0;
            img_width[3:0] == 4'b0000;
        }
    }

    function new(string name = "integration_cmd_item");
        super.new(name);
    endfunction

    function string kind_to_string();
        case (kind)
            INT_CMD_RGF_WRITE:   return "RGF_WRITE";
            INT_CMD_RGF_READ:    return "RGF_READ";
            INT_CMD_PIXEL_WRITE: return "PIXEL_WRITE";
            INT_CMD_PIXEL_READ:  return "PIXEL_READ";
            INT_CMD_IMAGE_WRITE: return "IMAGE_WRITE";
            INT_CMD_IMAGE_READ:  return "IMAGE_READ";
            default:             return "INVALID";
        endcase
    endfunction

    function bit expects_uart_response();
        return kind inside {
            INT_CMD_RGF_READ,
            INT_CMD_PIXEL_READ
        };
    endfunction

    function string convert2string();
        return $sformatf(
            {
                "kind=%s addr=0x%06h data=0x%08h ",
                "width=%0d height=%0d ",
                "parity_error=%0b framing_error=%0b idle_bits=%0d"
            },
            kind_to_string(),
            addr,
            data,
            img_width,
            img_height,
            inject_parity_error,
            inject_framing_error,
            idle_bits
        );
    endfunction

endclass

`endif
