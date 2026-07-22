`timescale 1ns / 1ps

// RGB DMA sequencer.
//
// One FIFO word contains four 8-bit samples from one color channel. The DMA
// prefetches four FIFO words, performs one INCR4 burst, and advances through
// R, G and B. A complete RGB round therefore advances by 16 pixels.
module rgb_dma_sequencer #(
    parameter int unsigned IMG_WIDTH  = lab12_pkg::IMG_WIDTH,
    parameter int unsigned IMG_HEIGHT = lab12_pkg::IMG_HEIGHT,
    parameter int unsigned ROM_DEPTH  = lab12_pkg::ROM_DEPTH
) (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        dma_wr_start,
    input  logic        dma_rd_start,
    // Global byte address in the R SRAM window. Zero selects R_SRAM_BASE_ADDR.
    input  logic [23:0] img_base,
    input  logic [15:0] img_width,
    input  logic [15:0] img_height,

    output logic        busy,
    output logic        done,
    output logic        error,

    output logic [15:0] wr_row_cnt,
    output logic [15:0] wr_col_cnt,
    output logic [15:0] rd_row_cnt,
    output logic [15:0] rd_col_cnt,

    output logic        seq_cmd_valid,
    input  logic        seq_cmd_ready,
    output logic        seq_cmd_write,
    output logic [23:0] seq_cmd_addr,
    output logic [127:0] seq_cmd_wdata,

    input  logic        seq_rsp_valid,
    output logic        seq_rsp_ready,
    input  logic        seq_rsp_error,
    input  logic [127:0] seq_rsp_rdata,

    // RX FIFO read side: independent pops are required because AHB bursts
    // visit one color channel at a time.
    input  logic [2:0]  rx_fifo_empty,
    input  logic [2:0]  rx_fifo_data_valid,
    input  logic [31:0] rx_fifo_r_data,
    input  logic [31:0] rx_fifo_g_data,
    input  logic [31:0] rx_fifo_b_data,
    output logic [2:0]  rx_fifo_pop,

    // TX FIFO write side: the DMA pushes the channel currently being read.
    input  logic [2:0]  tx_fifo_ready,
    output logic [2:0]  tx_fifo_push,
    output logic [31:0] tx_fifo_r_data,
    output logic [31:0] tx_fifo_g_data,
    output logic [31:0] tx_fifo_b_data
);

    localparam logic [23:0] R_BASE = lab12_pkg::R_SRAM_BASE_ADDR[23:0];
    localparam logic [23:0] G_BASE = lab12_pkg::G_SRAM_BASE_ADDR[23:0];
    localparam logic [23:0] B_BASE = lab12_pkg::B_SRAM_BASE_ADDR[23:0];
    localparam logic [23:0] CHANNEL_BYTES =
        lab12_pkg::CHANNEL_SRAM_SIZE_BYTES[23:0];

    typedef enum logic [3:0] {
        ST_IDLE,
        ST_CFG_MULTIPLY,
        ST_CFG_VALIDATE,
        ST_RX_POP,
        ST_RX_WAIT,
        ST_ISSUE,
        ST_WAIT_RSP,
        ST_TX_DRAIN,
        ST_ADVANCE
    } state_t;

    state_t state_q;

    logic is_write_q;
    logic [1:0] color_q; // 0=R, 1=G, 2=B
    logic [1:0] word_index_q;

    logic [23:0] active_r_base_q;
    logic [15:0] active_height_q;
    logic [15:0] words_per_row_q;
    logic [31:0] total_words_q;
    logic [31:0] active_base_offset_q;
    logic [31:0] image_word_index_q;
    logic [15:0] row_q;
    logic [15:0] word_col_q;

    logic [127:0] burst_wdata_q;
    logic [127:0] burst_rdata_q;

    logic [15:0] cfg_width;
    logic [15:0] cfg_height;
    logic [23:0] cfg_r_base;
    logic        cfg_basic_valid;

    logic selected_rx_empty;
    logic selected_rx_valid;
    logic selected_tx_ready;
    logic [31:0] selected_rx_data;
    logic [31:0] selected_tx_data;

    logic [23:0] channel_base;
    logic [31:0] current_byte_offset;

    assign cfg_width  = (img_width  != 0) ? img_width  : IMG_WIDTH[15:0];
    assign cfg_height = (img_height != 0) ? img_height : IMG_HEIGHT[15:0];
    assign cfg_r_base = (img_base   != 0) ? img_base   : R_BASE;

    // First-stage validation deliberately excludes the image-size multiply.
    // The multiply is registered in ST_CFG_MULTIPLY so it is not part of the
    // command-accept and counter-control timing paths.
    assign cfg_basic_valid =
        (dma_wr_start ^ dma_rd_start) &&
        (cfg_width  != 0) &&
        (cfg_height != 0) &&
        (cfg_width[3:0] == 4'b0000) &&
        (cfg_r_base[1:0] == 2'b00) &&
        (cfg_r_base >= R_BASE);

    assign busy = (state_q != ST_IDLE);

    always_comb begin
        selected_rx_empty = 1'b1;
        selected_rx_valid = 1'b0;
        selected_tx_ready = 1'b0;
        selected_rx_data  = '0;

        unique case (color_q)
            2'd0: begin
                selected_rx_empty = rx_fifo_empty[0];
                selected_rx_valid = rx_fifo_data_valid[0];
                selected_tx_ready = tx_fifo_ready[0];
                selected_rx_data  = rx_fifo_r_data;
            end
            2'd1: begin
                selected_rx_empty = rx_fifo_empty[1];
                selected_rx_valid = rx_fifo_data_valid[1];
                selected_tx_ready = tx_fifo_ready[1];
                selected_rx_data  = rx_fifo_g_data;
            end
            default: begin
                selected_rx_empty = rx_fifo_empty[2];
                selected_rx_valid = rx_fifo_data_valid[2];
                selected_tx_ready = tx_fifo_ready[2];
                selected_rx_data  = rx_fifo_b_data;
            end
        endcase

        unique case (word_index_q)
            2'd0: selected_tx_data = burst_rdata_q[31:0];
            2'd1: selected_tx_data = burst_rdata_q[63:32];
            2'd2: selected_tx_data = burst_rdata_q[95:64];
            default: selected_tx_data = burst_rdata_q[127:96];
        endcase
    end

    always_comb begin
        channel_base = active_r_base_q;
        unique case (color_q)
            2'd0: channel_base = R_BASE + (active_r_base_q - R_BASE);
            2'd1: channel_base = G_BASE + (active_r_base_q - R_BASE);
            default: channel_base = B_BASE + (active_r_base_q - R_BASE);
        endcase
    end

    // The image is traversed linearly. Each completed R/G/B round advances
    // by one INCR4 burst, namely four 32-bit words in every color channel.
    // Keeping this registered index removes row*words_per_row from the active
    // DMA address path.
    assign current_byte_offset = image_word_index_q << 2;

    assign seq_cmd_valid = (state_q == ST_ISSUE);
    assign seq_cmd_write = is_write_q;
    assign seq_cmd_addr  = channel_base + current_byte_offset[23:0];
    assign seq_cmd_wdata = burst_wdata_q;
    assign seq_rsp_ready = (state_q == ST_WAIT_RSP);

    always_comb begin
        rx_fifo_pop = 3'b000;
        tx_fifo_push = 3'b000;
        tx_fifo_r_data = '0;
        tx_fifo_g_data = '0;
        tx_fifo_b_data = '0;

        if ((state_q == ST_RX_POP) && !selected_rx_empty)
            rx_fifo_pop[color_q] = 1'b1;

        if ((state_q == ST_TX_DRAIN) && selected_tx_ready) begin
            tx_fifo_push[color_q] = 1'b1;
            unique case (color_q)
                2'd0: tx_fifo_r_data = selected_tx_data;
                2'd1: tx_fifo_g_data = selected_tx_data;
                default: tx_fifo_b_data = selected_tx_data;
            endcase
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q         <= ST_IDLE;
            is_write_q      <= 1'b0;
            color_q         <= 2'd0;
            word_index_q    <= 2'd0;
            active_r_base_q <= R_BASE;
            active_height_q <= IMG_HEIGHT[15:0];
            words_per_row_q <= IMG_WIDTH[15:0] >> 2;
            total_words_q   <= (IMG_WIDTH * IMG_HEIGHT) >> 2;
            active_base_offset_q <= '0;
            image_word_index_q   <= '0;
            row_q           <= '0;
            word_col_q      <= '0;
            burst_wdata_q   <= '0;
            burst_rdata_q   <= '0;
            done            <= 1'b0;
            error           <= 1'b0;
            wr_row_cnt      <= '0;
            wr_col_cnt      <= '0;
            rd_row_cnt      <= '0;
            rd_col_cnt      <= '0;
        end
        else begin
            done <= 1'b0;

            unique case (state_q)
                ST_IDLE: begin
                    if (dma_wr_start || dma_rd_start) begin
                        error <= 1'b0;
                        if (!cfg_basic_valid) begin
                            error <= 1'b1;
                        end
                        else begin
                            is_write_q      <= dma_wr_start;
                            active_r_base_q <= cfg_r_base;
                            active_height_q <= cfg_height;
                            words_per_row_q <= cfg_width >> 2;
                            active_base_offset_q <=
                                {8'd0, cfg_r_base} - {8'd0, R_BASE};
                            image_word_index_q <= '0;
                            row_q           <= '0;
                            word_col_q      <= '0;
                            color_q         <= 2'd0;
                            word_index_q    <= 2'd0;
                            burst_wdata_q   <= '0;
                            burst_rdata_q   <= '0;
                            state_q         <= ST_CFG_MULTIPLY;
                        end
                    end
                end

                ST_CFG_MULTIPLY: begin
                    // Registered multiply: operands were captured in IDLE,
                    // and the result is consumed only in the following state.
                    total_words_q <=
                        {16'd0, words_per_row_q} *
                        {16'd0, active_height_q};
                    state_q <= ST_CFG_VALIDATE;
                end

                ST_CFG_VALIDATE: begin
                    if ((total_words_q == 0) ||
                        (total_words_q > ROM_DEPTH) ||
                        (active_base_offset_q >= CHANNEL_BYTES) ||
                        ((active_base_offset_q +
                          (total_words_q << 2)) > CHANNEL_BYTES)) begin
                        error   <= 1'b1;
                        state_q <= ST_IDLE;
                    end
                    else if (is_write_q) begin
                        wr_row_cnt <= '0;
                        wr_col_cnt <= '0;
                        state_q    <= ST_RX_POP;
                    end
                    else begin
                        rd_row_cnt <= '0;
                        rd_col_cnt <= '0;
                        state_q    <= ST_ISSUE;
                    end
                end

                ST_RX_POP: begin
                    if (!selected_rx_empty)
                        state_q <= ST_RX_WAIT;
                end

                ST_RX_WAIT: begin
                    if (selected_rx_valid) begin
                        case (word_index_q)
                            2'd0: burst_wdata_q[31:0]   <= selected_rx_data;
                            2'd1: burst_wdata_q[63:32]  <= selected_rx_data;
                            2'd2: burst_wdata_q[95:64]  <= selected_rx_data;
                            default: burst_wdata_q[127:96] <= selected_rx_data;
                        endcase

                        if (word_index_q == 2'd3) begin
                            word_index_q <= 2'd0;
                            state_q      <= ST_ISSUE;
                        end
                        else begin
                            word_index_q <= word_index_q + 1'b1;
                            state_q      <= ST_RX_POP;
                        end
                    end
                end

                ST_ISSUE: begin
                    if (seq_cmd_ready)
                        state_q <= ST_WAIT_RSP;
                end

                ST_WAIT_RSP: begin
                    if (seq_rsp_valid) begin
                        if (seq_rsp_error) begin
                            error   <= 1'b1;
                            state_q <= ST_IDLE;
                        end
                        else if (is_write_q) begin
                            state_q <= ST_ADVANCE;
                        end
                        else begin
                            burst_rdata_q <= seq_rsp_rdata;
                            word_index_q  <= 2'd0;
                            state_q       <= ST_TX_DRAIN;
                        end
                    end
                end

                ST_TX_DRAIN: begin
                    if (selected_tx_ready) begin
                        if (word_index_q == 2'd3) begin
                            word_index_q <= 2'd0;
                            state_q      <= ST_ADVANCE;
                        end
                        else begin
                            word_index_q <= word_index_q + 1'b1;
                        end
                    end
                end

                ST_ADVANCE: begin
                    if (color_q != 2'd2) begin
                        color_q      <= color_q + 1'b1;
                        word_index_q <= 2'd0;
                        state_q      <= is_write_q ? ST_RX_POP : ST_ISSUE;
                    end
                    else begin
                        color_q <= 2'd0;

                        if ((word_col_q + 16'd4) >= words_per_row_q) begin
                            if ((row_q + 16'd1) >= active_height_q) begin
                                done    <= 1'b1;
                                state_q <= ST_IDLE;
                            end
                            else begin
                                image_word_index_q <=
                                    image_word_index_q + 32'd4;
                                row_q      <= row_q + 1'b1;
                                word_col_q <= '0;
                                if (is_write_q) begin
                                    wr_row_cnt <= row_q + 1'b1;
                                    wr_col_cnt <= '0;
                                    state_q    <= ST_RX_POP;
                                end
                                else begin
                                    rd_row_cnt <= row_q + 1'b1;
                                    rd_col_cnt <= '0;
                                    state_q    <= ST_ISSUE;
                                end
                            end
                        end
                        else begin
                            image_word_index_q <=
                                image_word_index_q + 32'd4;
                            word_col_q <= word_col_q + 16'd4;
                            if (is_write_q) begin
                                wr_col_cnt <= wr_col_cnt + 16'd16;
                                state_q    <= ST_RX_POP;
                            end
                            else begin
                                rd_col_cnt <= rd_col_cnt + 16'd16;
                                state_q    <= ST_ISSUE;
                            end
                        end
                    end
                end

                default: state_q <= ST_IDLE;
            endcase
        end
    end

endmodule
