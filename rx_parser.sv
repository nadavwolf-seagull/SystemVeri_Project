timeunit 1ns;
timeprecision 1ps;

module rx_parser #(
    parameter int unsigned MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES
) (
    input  logic clk,
    input  logic rst_n,

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

    localparam logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        PIXEL_ALIAS_BASE =
            lab12_pkg::PIXEL_ALIAS_BASE_ADDR[
                lab12_pkg::CMD_ADDR_WIDTH-1:0
            ];

    localparam logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        PIXEL_ALIAS_END =
            PIXEL_ALIAS_BASE +
            lab12_pkg::CMD_ADDR_WIDTH'(
                lab12_pkg::PIXEL_ALIAS_SIZE_BYTES
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
            hex_to_nibble = c[3:0];
        end
        else if ((c >= "A") && (c <= "F")) begin
            hex_to_nibble = c[3:0] + 4'd9;
        end
        else if ((c >= "a") && (c <= "f")) begin
            hex_to_nibble = c[3:0] + 4'd9;
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

    // ========================================================
    // PIPELINE STAGE 1
    // Register small, local comparisons and decoded byte fields.
    // No result in this stage depends on a wide priority decision.
    // ========================================================

    logic s1_frame_valid;
    logic s1_frame_error;

    logic s1_len_13;
    logic s1_len_25;
    logic s1_len_37;

    logic s1_braces_13;
    logic s1_braces_25;
    logic s1_braces_37;

    logic s1_addr_delimiters;
    logic s1_middle_delimiters;
    logic s1_last_delimiters;

    logic s1_char1_w;
    logic s1_char1_r;
    logic s1_char1_i;
    logic s1_char13_v;
    logic s1_char13_p;
    logic s1_char13_h;
    logic s1_char25_v;
    logic s1_char25_w;

    // Address, middle field and last field each contain six hex chars.
    logic [17:0] s1_hex_ok;

    logic [23:0] s1_decoded_addr;
    logic [31:0] s1_decoded_rgf_data;
    logic [23:0] s1_decoded_pixel;
    logic [15:0] s1_decoded_height;
    logic [15:0] s1_decoded_width;
    logic [7:0]  s1_height_high_byte;
    logic [7:0]  s1_width_high_byte;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_frame_valid        <= 1'b0;
            s1_frame_error        <= 1'b0;

            s1_len_13             <= 1'b0;
            s1_len_25             <= 1'b0;
            s1_len_37             <= 1'b0;

            s1_braces_13          <= 1'b0;
            s1_braces_25          <= 1'b0;
            s1_braces_37          <= 1'b0;

            s1_addr_delimiters    <= 1'b0;
            s1_middle_delimiters  <= 1'b0;
            s1_last_delimiters    <= 1'b0;

            s1_char1_w            <= 1'b0;
            s1_char1_r            <= 1'b0;
            s1_char1_i            <= 1'b0;
            s1_char13_v           <= 1'b0;
            s1_char13_p           <= 1'b0;
            s1_char13_h           <= 1'b0;
            s1_char25_v           <= 1'b0;
            s1_char25_w           <= 1'b0;

            s1_hex_ok             <= '0;

            s1_decoded_addr       <= '0;
            s1_decoded_rgf_data   <= '0;
            s1_decoded_pixel      <= '0;
            s1_decoded_height     <= '0;
            s1_decoded_width      <= '0;
            s1_height_high_byte   <= '0;
            s1_width_high_byte    <= '0;
        end
        else begin
            s1_frame_valid <= frame_valid;
            s1_frame_error <= frame_error;

            s1_len_13 <=
                frame_len == lab12_pkg::RX_FRAME_LEN_WIDTH'(13);
            s1_len_25 <=
                frame_len == lab12_pkg::RX_FRAME_LEN_WIDTH'(25);
            s1_len_37 <=
                frame_len == lab12_pkg::RX_FRAME_LEN_WIDTH'(37);

            s1_braces_13 <=
                (ch[0]  == lab12_pkg::ASCII_LBRACE) &&
                (ch[12] == lab12_pkg::ASCII_RBRACE);

            s1_braces_25 <=
                (ch[0]  == lab12_pkg::ASCII_LBRACE) &&
                (ch[24] == lab12_pkg::ASCII_RBRACE);

            s1_braces_37 <=
                (ch[0]  == lab12_pkg::ASCII_LBRACE) &&
                (ch[36] == lab12_pkg::ASCII_RBRACE);

            s1_addr_delimiters <=
                (ch[2]  == lab12_pkg::ASCII_LANGLE) &&
                (ch[5]  == lab12_pkg::ASCII_COMMA)  &&
                (ch[8]  == lab12_pkg::ASCII_COMMA)  &&
                (ch[11] == lab12_pkg::ASCII_RANGLE);

            s1_middle_delimiters <=
                (ch[12] == lab12_pkg::ASCII_COMMA)  &&
                (ch[14] == lab12_pkg::ASCII_LANGLE) &&
                (ch[17] == lab12_pkg::ASCII_COMMA)  &&
                (ch[20] == lab12_pkg::ASCII_COMMA)  &&
                (ch[23] == lab12_pkg::ASCII_RANGLE);

            s1_last_delimiters <=
                (ch[24] == lab12_pkg::ASCII_COMMA)  &&
                (ch[26] == lab12_pkg::ASCII_LANGLE) &&
                (ch[29] == lab12_pkg::ASCII_COMMA)  &&
                (ch[32] == lab12_pkg::ASCII_COMMA)  &&
                (ch[35] == lab12_pkg::ASCII_RANGLE);

            s1_char1_w  <= ch[1]  == lab12_pkg::ASCII_W;
            s1_char1_r  <= ch[1]  == lab12_pkg::ASCII_R;
            s1_char1_i  <= ch[1]  == lab12_pkg::ASCII_I;
            s1_char13_v <= ch[13] == lab12_pkg::ASCII_V;
            s1_char13_p <= ch[13] == lab12_pkg::ASCII_P;
            s1_char13_h <= ch[13] == "H";
            s1_char25_v <= ch[25] == lab12_pkg::ASCII_V;
            s1_char25_w <= ch[25] == lab12_pkg::ASCII_W;

            s1_hex_ok[0]  <= is_hex(ch[3]);
            s1_hex_ok[1]  <= is_hex(ch[4]);
            s1_hex_ok[2]  <= is_hex(ch[6]);
            s1_hex_ok[3]  <= is_hex(ch[7]);
            s1_hex_ok[4]  <= is_hex(ch[9]);
            s1_hex_ok[5]  <= is_hex(ch[10]);

            s1_hex_ok[6]  <= is_hex(ch[15]);
            s1_hex_ok[7]  <= is_hex(ch[16]);
            s1_hex_ok[8]  <= is_hex(ch[18]);
            s1_hex_ok[9]  <= is_hex(ch[19]);
            s1_hex_ok[10] <= is_hex(ch[21]);
            s1_hex_ok[11] <= is_hex(ch[22]);

            s1_hex_ok[12] <= is_hex(ch[27]);
            s1_hex_ok[13] <= is_hex(ch[28]);
            s1_hex_ok[14] <= is_hex(ch[30]);
            s1_hex_ok[15] <= is_hex(ch[31]);
            s1_hex_ok[16] <= is_hex(ch[33]);
            s1_hex_ok[17] <= is_hex(ch[34]);

            s1_decoded_addr <= {
                ascii_hex_byte(ch[3], ch[4]),
                ascii_hex_byte(ch[6], ch[7]),
                ascii_hex_byte(ch[9], ch[10])
            };

            s1_decoded_rgf_data <= {
                ascii_hex_byte(ch[18], ch[19]),
                ascii_hex_byte(ch[21], ch[22]),
                ascii_hex_byte(ch[30], ch[31]),
                ascii_hex_byte(ch[33], ch[34])
            };

            s1_decoded_pixel <= {
                ascii_hex_byte(ch[15], ch[16]),
                ascii_hex_byte(ch[18], ch[19]),
                ascii_hex_byte(ch[21], ch[22])
            };

            s1_decoded_height <= {
                ascii_hex_byte(ch[18], ch[19]),
                ascii_hex_byte(ch[21], ch[22])
            };

            s1_decoded_width <= {
                ascii_hex_byte(ch[30], ch[31]),
                ascii_hex_byte(ch[33], ch[34])
            };

            s1_height_high_byte <=
                ascii_hex_byte(ch[15], ch[16]);

            s1_width_high_byte <=
                ascii_hex_byte(ch[27], ch[28]);
        end
    end

    // ========================================================
    // PIPELINE STAGE 2
    // Reduce the Stage-1 checks into small independent groups. Keeping the
    // field checks separate from the command-type checks prevents a wide
    // format-and-dimensions expression from occupying one 280 MHz cycle.
    // ========================================================

    logic s2_frame_valid;
    logic s2_frame_error;

    logic s2_frame_13_ok;
    logic s2_frame_25_ok;
    logic s2_frame_37_ok;

    logic s2_addr_field_ok;
    logic s2_middle_field_ok;
    logic s2_last_field_ok;

    logic s2_rgf_type_ok;
    logic s2_read_type_ok;
    logic s2_pixel_write_type_ok;
    logic s2_image_write_type_ok;
    logic s2_image_read_type_ok;
    logic s2_image_dimensions_ok;
    logic s2_addr_is_pixel;

    logic [23:0] s2_decoded_addr;
    logic [31:0] s2_decoded_rgf_data;
    logic [23:0] s2_decoded_pixel;
    logic [15:0] s2_decoded_height;
    logic [15:0] s2_decoded_width;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s2_frame_valid       <= 1'b0;
            s2_frame_error       <= 1'b0;

            s2_frame_13_ok       <= 1'b0;
            s2_frame_25_ok       <= 1'b0;
            s2_frame_37_ok       <= 1'b0;

            s2_addr_field_ok     <= 1'b0;
            s2_middle_field_ok   <= 1'b0;
            s2_last_field_ok     <= 1'b0;

            s2_rgf_type_ok       <= 1'b0;
            s2_read_type_ok      <= 1'b0;
            s2_pixel_write_type_ok <= 1'b0;
            s2_image_write_type_ok <= 1'b0;
            s2_image_read_type_ok <= 1'b0;
            s2_image_dimensions_ok <= 1'b0;
            s2_addr_is_pixel     <= 1'b0;

            s2_decoded_addr      <= '0;
            s2_decoded_rgf_data  <= '0;
            s2_decoded_pixel     <= '0;
            s2_decoded_height    <= '0;
            s2_decoded_width     <= '0;
        end
        else begin
            s2_frame_valid <= s1_frame_valid;
            s2_frame_error <= s1_frame_error;

            s2_frame_13_ok <= s1_len_13 && s1_braces_13;
            s2_frame_25_ok <= s1_len_25 && s1_braces_25;
            s2_frame_37_ok <= s1_len_37 && s1_braces_37;

            s2_addr_field_ok <=
                s1_addr_delimiters &&
                (&s1_hex_ok[5:0]);

            s2_middle_field_ok <=
                s1_middle_delimiters &&
                (&s1_hex_ok[11:6]);

            s2_last_field_ok <=
                s1_last_delimiters &&
                (&s1_hex_ok[17:12]);

            s2_rgf_type_ok <=
                s1_char1_w && s1_char13_v && s1_char25_v;

            s2_read_type_ok <= s1_char1_r;

            s2_pixel_write_type_ok <=
                s1_char1_w && s1_char13_p;

            s2_image_write_type_ok <=
                s1_char1_i && s1_char13_h && s1_char25_w;

            s2_image_read_type_ok <=
                s1_char1_r && s1_char13_h && s1_char25_w;

            s2_image_dimensions_ok <=
                (s1_height_high_byte == 8'h00) &&
                (s1_width_high_byte  == 8'h00) &&
                (s1_decoded_height != 16'h0000) &&
                (s1_decoded_width  != 16'h0000);

            s2_addr_is_pixel <=
                (s1_decoded_addr >= PIXEL_ALIAS_BASE) &&
                (s1_decoded_addr <  PIXEL_ALIAS_END);

            s2_decoded_addr     <= s1_decoded_addr;
            s2_decoded_rgf_data <= s1_decoded_rgf_data;
            s2_decoded_pixel    <= s1_decoded_pixel;
            s2_decoded_height   <= s1_decoded_height;
            s2_decoded_width    <= s1_decoded_width;
        end
    end

    // ========================================================
    // PIPELINE STAGE 3
    // Form complete command candidates from the registered field groups.
    // Each candidate now contains at most one small LUT-level combination.
    // ========================================================

    logic s3_frame_valid;
    logic s3_frame_error;

    logic s3_rgf_write_ok;
    logic s3_read_ok;
    logic s3_pixel_write_ok;
    logic s3_image_write_ok;
    logic s3_image_read_ok;
    logic s3_addr_is_pixel;

    logic [23:0] s3_decoded_addr;
    logic [31:0] s3_decoded_rgf_data;
    logic [23:0] s3_decoded_pixel;
    logic [15:0] s3_decoded_height;
    logic [15:0] s3_decoded_width;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s3_frame_valid       <= 1'b0;
            s3_frame_error       <= 1'b0;

            s3_rgf_write_ok      <= 1'b0;
            s3_read_ok           <= 1'b0;
            s3_pixel_write_ok    <= 1'b0;
            s3_image_write_ok    <= 1'b0;
            s3_image_read_ok     <= 1'b0;
            s3_addr_is_pixel     <= 1'b0;

            s3_decoded_addr      <= '0;
            s3_decoded_rgf_data  <= '0;
            s3_decoded_pixel     <= '0;
            s3_decoded_height    <= '0;
            s3_decoded_width     <= '0;
        end
        else begin
            s3_frame_valid <= s2_frame_valid;
            s3_frame_error <= s2_frame_error;

            s3_rgf_write_ok <=
                s2_frame_37_ok &&
                s2_addr_field_ok &&
                s2_middle_field_ok &&
                s2_last_field_ok &&
                s2_rgf_type_ok;

            s3_read_ok <=
                s2_frame_13_ok &&
                s2_addr_field_ok &&
                s2_read_type_ok;

            s3_pixel_write_ok <=
                s2_frame_25_ok &&
                s2_addr_field_ok &&
                s2_middle_field_ok &&
                s2_pixel_write_type_ok;

            s3_image_write_ok <=
                s2_frame_37_ok &&
                s2_addr_field_ok &&
                s2_middle_field_ok &&
                s2_last_field_ok &&
                s2_image_write_type_ok &&
                s2_image_dimensions_ok;

            s3_image_read_ok <=
                s2_frame_37_ok &&
                s2_addr_field_ok &&
                s2_middle_field_ok &&
                s2_last_field_ok &&
                s2_image_read_type_ok &&
                s2_image_dimensions_ok;

            s3_addr_is_pixel <= s2_addr_is_pixel;

            s3_decoded_addr     <= s2_decoded_addr;
            s3_decoded_rgf_data <= s2_decoded_rgf_data;
            s3_decoded_pixel    <= s2_decoded_pixel;
            s3_decoded_height   <= s2_decoded_height;
            s3_decoded_width    <= s2_decoded_width;
        end
    end

    // ========================================================
    // PIPELINE STAGE 4
    // Priority selection and registered one-cycle parser response.
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            parsed_valid  <= 1'b0;
            parsed_opcode <= lab12_pkg::RX_CMD_NOP;
            parsed_addr   <= '0;
            parsed_data   <= '0;
            parse_error   <= 1'b0;
        end
        else begin
            parsed_valid  <= 1'b0;
            parsed_opcode <= lab12_pkg::RX_CMD_NOP;
            parsed_addr   <= '0;
            parsed_data   <= '0;
            parse_error   <= 1'b0;

            if (s3_frame_error) begin
                parse_error <= 1'b1;
            end
            else if (s3_frame_valid) begin
                if (s3_rgf_write_ok) begin
                    parsed_valid  <= 1'b1;
                    parsed_opcode <= lab12_pkg::RX_CMD_RGF_WRITE;
                    parsed_addr   <= s3_decoded_addr;
                    parsed_data   <= s3_decoded_rgf_data;
                end
                else if (s3_image_write_ok) begin
                    parsed_valid  <= 1'b1;
                    parsed_opcode <= lab12_pkg::RX_CMD_IMAGE_WRITE;
                    parsed_addr   <= s3_decoded_addr;
                    parsed_data   <= {
                        s3_decoded_height,
                        s3_decoded_width
                    };
                end
                else if (s3_image_read_ok) begin
                    parsed_valid  <= 1'b1;
                    parsed_opcode <= lab12_pkg::RX_CMD_IMAGE_READ;
                    parsed_addr   <= s3_decoded_addr;
                    parsed_data   <= {
                        s3_decoded_height,
                        s3_decoded_width
                    };
                end
                else if (s3_pixel_write_ok) begin
                    if (s3_addr_is_pixel) begin
                        parsed_valid  <= 1'b1;
                        parsed_opcode <= lab12_pkg::RX_CMD_PIXEL_WRITE;
                        parsed_addr   <= s3_decoded_addr;
                        parsed_data   <= {8'h00, s3_decoded_pixel};
                    end
                    else begin
                        parse_error <= 1'b1;
                    end
                end
                else if (s3_read_ok) begin
                    parsed_valid <= 1'b1;
                    parsed_addr  <= s3_decoded_addr;
                    parsed_data  <= '0;

                    if (s3_addr_is_pixel) begin
                        parsed_opcode <= lab12_pkg::RX_CMD_PIXEL_READ;
                    end
                    else begin
                        parsed_opcode <= lab12_pkg::RX_CMD_RGF_READ;
                    end
                end
                else begin
                    parse_error <= 1'b1;
                end
            end
        end
    end

endmodule
