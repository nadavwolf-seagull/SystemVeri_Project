`ifndef INTEGRATION_RSP_ITEM_SV
`define INTEGRATION_RSP_ITEM_SV

typedef enum logic [1:0] {
    INT_RSP_NONE,
    INT_RSP_RGF_READ,
    INT_RSP_PIXEL_READ,
    INT_RSP_ERROR
} integration_rsp_kind_e;

class integration_rsp_item extends uvm_sequence_item;

    `uvm_object_utils(integration_rsp_item)

    integration_rsp_kind_e kind;

    // Raw UART packet, first transmitted byte stored at the MSB side.
    logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0] raw_packet;

    logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0] packet_len;

    // Decoded RGF response fields.
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] data;

    // Pixel-response metadata. The RTL returns the low 16 bits of the
    // byte offset inside the pixel-alias region, not decoded row/column.
    logic [15:0] pixel_offset;
    logic [31:0] pixel_index;

    // Row/column are retained only as derived debug information.
    logic [7:0] pixel_row;
    logic [7:0] pixel_col;
    logic [lab12_pkg::CMD_PIXEL_WIDTH-1:0] pixel;

    bit response_error;
    bit parity_error;
    bit framing_error;

    function new(string name = "integration_rsp_item");
        super.new(name);

        kind           = INT_RSP_NONE;
        raw_packet     = '0;
        packet_len     = '0;
        addr           = '0;
        data           = '0;
        pixel_offset   = '0;
        pixel_index    = '0;
        pixel_row      = '0;
        pixel_col      = '0;
        pixel          = '0;
        response_error = 1'b0;
        parity_error   = 1'b0;
        framing_error  = 1'b0;
    endfunction

    function string kind_to_string();
        case (kind)
            INT_RSP_RGF_READ:   return "RGF_READ_RESPONSE";
            INT_RSP_PIXEL_READ: return "PIXEL_READ_RESPONSE";
            INT_RSP_ERROR:      return "ERROR_RESPONSE";
            default:            return "NONE";
        endcase
    endfunction

    function string convert2string();
        return $sformatf(
            {
                "kind=%s packet_len=%0d raw_packet=0x%024h ",
                "addr=0x%06h data=0x%08h ",
                "pixel_offset=0x%04h pixel_index=%0d ",
                "row=%0d col=%0d pixel=0x%06h ",
                "response_error=%0b parity_error=%0b framing_error=%0b"
            },
            kind_to_string(),
            packet_len,
            raw_packet,
            addr,
            data,
            pixel_offset,
            pixel_index,
            pixel_row,
            pixel_col,
            pixel,
            response_error,
            parity_error,
            framing_error
        );
    endfunction

endclass

`endif
