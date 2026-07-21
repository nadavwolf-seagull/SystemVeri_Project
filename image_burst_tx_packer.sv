timeunit 1ns;
timeprecision 1ps;

module image_burst_tx_packer #(
    parameter int unsigned MAX_PACKET_BYTES =
        lab12_pkg::UART_TX_MAX_PACKET_BYTES,

    parameter int unsigned MAX_PACKET_WIDTH =
        lab12_pkg::UART_TX_MAX_PACKET_WIDTH,

    parameter int unsigned PACKET_LEN_WIDTH =
        lab12_pkg::UART_TX_PACKET_LEN_WIDTH
) (
    input  logic clk,
    input  logic rst_n,

    // Begins transmission of one complete image.
    input  logic        start,
    input  logic [15:0] img_width,
    input  logic [15:0] img_height,

    // DMA TX FIFO interface.
    output logic        fifo_pop,
    input  logic [31:0] fifo_r_data,
    input  logic [31:0] fifo_g_data,
    input  logic [31:0] fifo_b_data,
    input  logic        fifo_data_valid,
    input  logic        fifo_empty,

    // UART packet interface.
    output logic                        packet_valid,
    output logic [MAX_PACKET_WIDTH-1:0] packet_data,
    output logic [PACKET_LEN_WIDTH-1:0] packet_len,
    input  logic                        packet_ready,
    input  logic                        packet_done,

    // Status.
    output logic active,
    output logic done,
    output logic error
);

    typedef enum logic [2:0] {
        IDLE,
        REQUEST_WORD,
        WAIT_WORD,
        PRESENT_PACKET,
        WAIT_PACKET_DONE
    } state_t;

    state_t state;

    logic [31:0] total_pixels;
    logic [31:0] sent_pixels;
    logic [2:0]  pixels_in_packet;

    logic [MAX_PACKET_WIDTH-1:0] packet_data_reg;
    logic [PACKET_LEN_WIDTH-1:0] packet_len_reg;

    assign packet_data = packet_data_reg;
    assign packet_len  = packet_len_reg;

`ifndef SYNTHESIS
    initial begin
        if ((MAX_PACKET_BYTES != 12) || (MAX_PACKET_WIDTH != 96))
            $fatal(1, "image_burst_tx_packer requires one 12-byte RGB group");
    end
`endif

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state             <= IDLE;

            total_pixels      <= '0;
            sent_pixels       <= '0;
            pixels_in_packet  <= '0;

            packet_data_reg   <= '0;
            packet_len_reg    <= '0;

            fifo_pop          <= 1'b0;
            packet_valid      <= 1'b0;

            active            <= 1'b0;
            done              <= 1'b0;
            error             <= 1'b0;
        end
        else begin
            // One-cycle pulses.
            fifo_pop <= 1'b0;
            done     <= 1'b0;
            error    <= 1'b0;

            unique case (state)

                IDLE: begin
                    packet_valid <= 1'b0;
                    active       <= 1'b0;

                    if (start) begin
                        total_pixels <= img_width * img_height;
                        sent_pixels  <= '0;

                        if ((img_width == 0) ||
                            (img_height == 0) ||
                            (img_width[3:0] != 4'b0000)) begin
                            error <= 1'b1;
                        end
                        else begin
                            active <= 1'b1;
                            state  <= REQUEST_WORD;
                        end
                    end
                end

                REQUEST_WORD: begin
                    /*
                     * Wait until the DMA TX FIFO contains a complete
                     * group before requesting it.
                     */
                    if (!fifo_empty) begin
                        fifo_pop <= 1'b1;
                        state    <= WAIT_WORD;
                    end
                end

                WAIT_WORD: begin
                    if (fifo_data_valid) begin
                        /*
                         * Convert the planar FIFO words:
                         *   {R0,R1,R2,R3}
                         *   {G0,G1,G2,G3}
                         *   {B0,B1,B2,B3}
                         *
                         * into the UART byte order:
                         *   R0,G0,B0,R1,G1,B1,...
                         */
                        packet_data_reg <= {
                            fifo_r_data[31:24],
                            fifo_g_data[31:24],
                            fifo_b_data[31:24],

                            fifo_r_data[23:16],
                            fifo_g_data[23:16],
                            fifo_b_data[23:16],

                            fifo_r_data[15:8],
                            fifo_g_data[15:8],
                            fifo_b_data[15:8],

                            fifo_r_data[7:0],
                            fifo_g_data[7:0],
                            fifo_b_data[7:0]
                        };

                        // The INCR4-only DMA accepts complete 16-pixel rows,
                        // so every FIFO word always contains four pixels.
                        pixels_in_packet <= 3'd4;
                        packet_len_reg   <= PACKET_LEN_WIDTH'(12);

                        packet_valid <= 1'b1;
                        state        <= PRESENT_PACKET;
                    end
                end

                PRESENT_PACKET: begin
                    /*
                     * The UART MAC samples packet_data and packet_len
                     * on the valid/ready handshake.
                     */
                    if (packet_valid && packet_ready) begin
                        packet_valid <= 1'b0;
                        state        <= WAIT_PACKET_DONE;
                    end
                end

                WAIT_PACKET_DONE: begin
                    if (packet_done) begin
                        if (
                            (sent_pixels +
                             {{29{1'b0}}, pixels_in_packet}) >=
                            total_pixels
                        ) begin
                            sent_pixels <=
                                sent_pixels +
                                {{29{1'b0}}, pixels_in_packet};

                            active <= 1'b0;
                            done   <= 1'b1;
                            state  <= IDLE;
                        end
                        else begin
                            sent_pixels <=
                                sent_pixels +
                                {{29{1'b0}}, pixels_in_packet};

                            state <= REQUEST_WORD;
                        end
                    end
                end

                default: begin
                    state        <= IDLE;
                    packet_valid <= 1'b0;
                    active       <= 1'b0;
                    error        <= 1'b1;
                end

            endcase
        end
    end

endmodule
