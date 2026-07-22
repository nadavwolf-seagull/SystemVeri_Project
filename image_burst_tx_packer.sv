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
        CHECK_CONFIG,
        APPLY_CONFIG,
        REQUEST_WORD,
        WAIT_WORD,
        PRESENT_PACKET,
        WAIT_PACKET_DONE
    } state_t;

    state_t state;

    // One FIFO word always represents four pixels. Row/group counters avoid
    // a width*height multiplier and a 32-bit compare on every packet_done.
    logic [15:0] last_row;
    logic [15:0] last_group_col;
    logic [15:0] row_count;
    logic [15:0] group_col;

    logic [15:0] config_width;
    logic [15:0] config_height;
    logic        config_ok;

    // The row/group counters do not change while a packet is being sent.
    // Register their terminal comparisons before entering the packet path.
    logic        row_is_last_q;
    logic        group_is_last_q;

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

            last_row          <= '0;
            last_group_col    <= '0;
            row_count         <= '0;
            group_col         <= '0;

            config_width      <= '0;
            config_height     <= '0;
            config_ok         <= 1'b0;

            row_is_last_q     <= 1'b0;
            group_is_last_q   <= 1'b0;

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
                        // Capture the descriptor first. The descriptor bus
                        // does not directly drive a wide FSM decision.
                        config_width  <= img_width;
                        config_height <= img_height;
                        row_count     <= '0;
                        group_col     <= '0;
                        state         <= CHECK_CONFIG;
                    end
                end

                CHECK_CONFIG: begin
                    // Register both the arithmetic and the validation.
                    // The following state uses only config_ok.
                    last_row <= config_height - 16'd1;
                    last_group_col <=
                        (config_width >> 2) - 16'd1;

                    config_ok <=
                        (config_width != 0) &&
                        (config_height != 0) &&
                        (config_width[3:0] == 4'b0000);

                    state <= APPLY_CONFIG;
                end

                APPLY_CONFIG: begin
                    if (config_ok) begin
                        active <= 1'b1;
                        state  <= REQUEST_WORD;
                    end
                    else begin
                        error <= 1'b1;
                        state <= IDLE;
                    end
                end

                REQUEST_WORD: begin
                    row_is_last_q <=
                        (row_count == last_row);

                    group_is_last_q <=
                        (group_col == last_group_col);

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
                        if (group_is_last_q) begin
                            group_col <= '0;

                            if (row_is_last_q) begin
                                active <= 1'b0;
                                done   <= 1'b1;
                                state  <= IDLE;
                            end
                            else begin
                                row_count <= row_count + 16'd1;
                                state     <= REQUEST_WORD;
                            end
                        end
                        else begin
                            group_col <= group_col + 16'd1;
                            state     <= REQUEST_WORD;
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
