timeunit 1ns;
timeprecision 1ps;

module rx_parser #(
    parameter int unsigned MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES
) (
    input  logic [MAX_FRAME_BYTES*8-1:0] frame_data,
    input  logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] frame_len,
    input  logic                         frame_valid,
    input  logic                         frame_error,

    output logic                         parsed_valid,
    output lab12_pkg::rx_cmd_opcode_t    parsed_opcode,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] parsed_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0] parsed_data,
    output logic                         parse_error
);

    logic [7:0] ch [0:MAX_FRAME_BYTES-1];

    genvar i;
    generate
        for (i = 0; i < MAX_FRAME_BYTES; i++) begin : gen_chars
            assign ch[i] = frame_data[i*8 +: 8];
        end
    endgenerate

    function automatic logic is_hex(input logic [7:0] c);
        is_hex =
            ((c >= "0") && (c <= "9")) ||
            ((c >= "A") && (c <= "F")) ||
            ((c >= "a") && (c <= "f"));
    endfunction

    function automatic logic [3:0] hex_to_nibble(
        input logic [7:0] c
    );
        if ((c >= "0") && (c <= "9")) begin
            hex_to_nibble = c - "0";
        end
        else if ((c >= "A") && (c <= "F")) begin
            hex_to_nibble = c - "A" + 4'd10;
        end
        else if ((c >= "a") && (c <= "f")) begin
            hex_to_nibble = c - "a" + 4'd10;
        end
        else begin
            hex_to_nibble = 4'h0;
        end
    endfunction

    function automatic logic [7:0] ascii_hex_byte(
        input logic [7:0] high_char,
        input logic [7:0] low_char
    );
        ascii_hex_byte = {
            hex_to_nibble(high_char),
            hex_to_nibble(low_char)
        };
    endfunction

    logic rgf_write_format_ok;
    logic rgf_read_format_ok;
    logic pixel_write_format_ok;
    logic image_format_ok;

    logic rgf_write_hex_ok;
    logic rgf_read_hex_ok;
    logic pixel_write_hex_ok;

    logic [23:0] decoded_addr;
    logic [31:0] decoded_rgf_data;
    logic [23:0] decoded_pixel;

    always_comb begin
        rgf_write_format_ok   = 1'b0;
        rgf_read_format_ok    = 1'b0;
        pixel_write_format_ok = 1'b0;
        image_format_ok       = 1'b0;

        rgf_write_hex_ok   = 1'b0;
        rgf_read_hex_ok    = 1'b0;
        pixel_write_hex_ok = 1'b0;

        decoded_addr     = '0;
        decoded_rgf_data = '0;
        decoded_pixel    = '0;

        // --------------------------------------------------------
        // Register Write
        // {W<00,00,04>,V<00,12,34>,V<00,56,78>}
        // Length = 37
        // --------------------------------------------------------
        rgf_write_format_ok =
            (frame_len == 37) &&
            (ch[0]  == lab12_pkg::ASCII_LBRACE) &&
            (ch[1]  == lab12_pkg::ASCII_W)      &&
            (ch[2]  == lab12_pkg::ASCII_LANGLE) &&
            (ch[5]  == lab12_pkg::ASCII_COMMA)  &&
            (ch[8]  == lab12_pkg::ASCII_COMMA)  &&
            (ch[11] == lab12_pkg::ASCII_RANGLE) &&
            (ch[12] == lab12_pkg::ASCII_COMMA)  &&
            (ch[13] == lab12_pkg::ASCII_V)      &&
            (ch[14] == lab12_pkg::ASCII_LANGLE) &&
            (ch[17] == lab12_pkg::ASCII_COMMA)  &&
            (ch[20] == lab12_pkg::ASCII_COMMA)  &&
            (ch[23] == lab12_pkg::ASCII_RANGLE) &&
            (ch[24] == lab12_pkg::ASCII_COMMA)  &&
            (ch[25] == lab12_pkg::ASCII_V)      &&
            (ch[26] == lab12_pkg::ASCII_LANGLE) &&
            (ch[29] == lab12_pkg::ASCII_COMMA)  &&
            (ch[32] == lab12_pkg::ASCII_COMMA)  &&
            (ch[35] == lab12_pkg::ASCII_RANGLE) &&
            (ch[36] == lab12_pkg::ASCII_RBRACE);

        rgf_write_hex_ok =
            is_hex(ch[3])  && is_hex(ch[4])  &&
            is_hex(ch[6])  && is_hex(ch[7])  &&
            is_hex(ch[9])  && is_hex(ch[10]) &&

            is_hex(ch[15]) && is_hex(ch[16]) &&
            is_hex(ch[18]) && is_hex(ch[19]) &&
            is_hex(ch[21]) && is_hex(ch[22]) &&

            is_hex(ch[27]) && is_hex(ch[28]) &&
            is_hex(ch[30]) && is_hex(ch[31]) &&
            is_hex(ch[33]) && is_hex(ch[34]);

        // --------------------------------------------------------
        // Register Read
        // {R<00,00,04>}
        // Length = 13
        // --------------------------------------------------------
        rgf_read_format_ok =
            (frame_len == 13) &&
            (ch[0]  == lab12_pkg::ASCII_LBRACE) &&
            (ch[1]  == lab12_pkg::ASCII_R)      &&
            (ch[2]  == lab12_pkg::ASCII_LANGLE) &&
            (ch[5]  == lab12_pkg::ASCII_COMMA)  &&
            (ch[8]  == lab12_pkg::ASCII_COMMA)  &&
            (ch[11] == lab12_pkg::ASCII_RANGLE) &&
            (ch[12] == lab12_pkg::ASCII_RBRACE);

        rgf_read_hex_ok =
            is_hex(ch[3])  && is_hex(ch[4])  &&
            is_hex(ch[6])  && is_hex(ch[7])  &&
            is_hex(ch[9])  && is_hex(ch[10]);

        // --------------------------------------------------------
        // Pixel Write
        // {W<00,03,05>,P<FF,00,00>}
        // Length = 25
        // --------------------------------------------------------
        pixel_write_format_ok =
            (frame_len == 25) &&
            (ch[0]  == lab12_pkg::ASCII_LBRACE) &&
            (ch[1]  == lab12_pkg::ASCII_W)      &&
            (ch[2]  == lab12_pkg::ASCII_LANGLE) &&
            (ch[5]  == lab12_pkg::ASCII_COMMA)  &&
            (ch[8]  == lab12_pkg::ASCII_COMMA)  &&
            (ch[11] == lab12_pkg::ASCII_RANGLE) &&
            (ch[12] == lab12_pkg::ASCII_COMMA)  &&
            (ch[13] == lab12_pkg::ASCII_P)      &&
            (ch[14] == lab12_pkg::ASCII_LANGLE) &&
            (ch[17] == lab12_pkg::ASCII_COMMA)  &&
            (ch[20] == lab12_pkg::ASCII_COMMA)  &&
            (ch[23] == lab12_pkg::ASCII_RANGLE) &&
            (ch[24] == lab12_pkg::ASCII_RBRACE);

        pixel_write_hex_ok =
            is_hex(ch[3])  && is_hex(ch[4])  &&
            is_hex(ch[6])  && is_hex(ch[7])  &&
            is_hex(ch[9])  && is_hex(ch[10]) &&

            is_hex(ch[15]) && is_hex(ch[16]) &&
            is_hex(ch[18]) && is_hex(ch[19]) &&
            is_hex(ch[21]) && is_hex(ch[22]);

        // --------------------------------------------------------
        // Full image command
        // {I}
        // --------------------------------------------------------
        image_format_ok =
            (frame_len == 3) &&
            (ch[0] == lab12_pkg::ASCII_LBRACE) &&
            (ch[1] == lab12_pkg::ASCII_I)      &&
            (ch[2] == lab12_pkg::ASCII_RBRACE);

        decoded_addr = {
            ascii_hex_byte(ch[3], ch[4]),
            ascii_hex_byte(ch[6], ch[7]),
            ascii_hex_byte(ch[9], ch[10])
        };

        /*
         * Register value format:
         * V<00,DH1,DH0>,V<00,DL1,DL0>
         *
         * Leading 00 fields are currently ignored.
         */
        decoded_rgf_data = {
            ascii_hex_byte(ch[18], ch[19]),
            ascii_hex_byte(ch[21], ch[22]),
            ascii_hex_byte(ch[30], ch[31]),
            ascii_hex_byte(ch[33], ch[34])
        };

        decoded_pixel = {
            ascii_hex_byte(ch[15], ch[16]),
            ascii_hex_byte(ch[18], ch[19]),
            ascii_hex_byte(ch[21], ch[22])
        };
    end

    always_comb begin
        parsed_valid  = 1'b0;
        parsed_opcode = lab12_pkg::RX_CMD_NOP;
        parsed_addr   = '0;
        parsed_data   = '0;
        parse_error   = 1'b0;

        if (frame_error) begin
            parse_error = 1'b1;
        end
        else if (frame_valid) begin
            if (rgf_write_format_ok && rgf_write_hex_ok) begin
                parsed_valid  = 1'b1;
                parsed_opcode = lab12_pkg::RX_CMD_RGF_WRITE;
                parsed_addr   = decoded_addr;
                parsed_data   = decoded_rgf_data;
            end
            else if (rgf_read_format_ok && rgf_read_hex_ok) begin
                parsed_valid  = 1'b1;
                parsed_opcode = lab12_pkg::RX_CMD_RGF_READ;
                parsed_addr   = decoded_addr;
                parsed_data   = '0;
            end
            else if (pixel_write_format_ok && pixel_write_hex_ok) begin
                parsed_valid  = 1'b1;
                parsed_opcode = lab12_pkg::RX_CMD_PIXEL_WRITE;
                parsed_addr   = decoded_addr;
                parsed_data   = {
                    8'h00,
                    decoded_pixel
                };
            end
            else if (image_format_ok) begin
                parsed_valid  = 1'b1;
                parsed_opcode = lab12_pkg::RX_CMD_IMAGE_READ;
                parsed_addr   = {
                    {(lab12_pkg::CMD_ADDR_WIDTH-
                       lab12_pkg::RGF_ADDR_WIDTH){1'b0}},
                    lab12_pkg::RGF_ADDR_CTRL
                };
                parsed_data = 32'h0000_0001;
            end
            else begin
                parse_error = 1'b1;
            end
        end
    end

endmodule