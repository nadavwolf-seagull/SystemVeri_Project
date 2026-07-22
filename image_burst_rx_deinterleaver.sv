timeunit 1ns;
timeprecision 1ps;

module image_burst_rx_deinterleaver (
    input  logic        clk,
    input  logic        rst_n,

    // Starts reception of one image payload.
    input  logic        start,
    input  logic [15:0] img_width,
    input  logic [15:0] img_height,

    // Byte stream from the UART RX PHY.
    // Expected payload order:
    // R0,G0,B0,R1,G1,B1,R2,G2,B2,R3,G3,B3,...
    input  logic [7:0]  rx_byte,
    input  logic        rx_byte_valid,

    // Interface toward the DMA RX FIFO bank.
    input  logic        fifo_ready,

    output logic        fifo_push,
    output logic [31:0] fifo_r_data,
    output logic [31:0] fifo_g_data,
    output logic [31:0] fifo_b_data,

    // Status and flow-control information.
    output logic        payload_active,
    output logic        payload_ready,
    output logic        payload_done,
    output logic        payload_error
);

    typedef enum logic [2:0] {
        RX_IDLE,
        RX_CONFIG_CHECK,
        RX_CONFIG_APPLY,
        RX_WAIT_BYTE,
        RX_PROCESS_BYTE,
        RX_WAIT_FIFO
    } rx_state_t;

    typedef enum logic [1:0] {
        BYTE_R,
        BYTE_G,
        BYTE_B
    } byte_phase_t;

    rx_state_t   state;
    byte_phase_t byte_phase;

    logic [7:0] rx_byte_q;
    logic [1:0] pixel_in_group;

    // One FIFO group contains four pixels. A legal row contains a multiple
    // of four groups because the DMA works with complete 16-pixel rows.
    logic [15:0] penultimate_row;
    logic [13:0] penultimate_group_col;
    logic [15:0] row_count;
    logic [13:0] group_col;

    logic [15:0] config_width;
    logic [15:0] config_height;
    logic        config_ok;
    logic        row_is_last_q;
    logic        group_is_last_q;

    logic [31:0] r_word;
    logic [31:0] g_word;
    logic [31:0] b_word;

    logic final_group_pending;

    assign fifo_r_data = r_word;
    assign fifo_g_data = g_word;
    assign fifo_b_data = b_word;

    // RGB data is already registered and stable throughout RX_WAIT_FIFO.
    // The asynchronous FIFO samples push and all three words together.
    assign fifo_push =
        (state == RX_WAIT_FIFO) && fifo_ready;

    // A byte is accepted only in RX_WAIT_BYTE. RX_PROCESS_BYTE forms a
    // one-cycle timing pipeline between the UART byte and the RGB words.
    assign payload_ready =
        payload_active && (state == RX_WAIT_BYTE);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state                    <= RX_IDLE;
            byte_phase               <= BYTE_R;
            rx_byte_q                 <= '0;
            pixel_in_group           <= '0;

            penultimate_row          <= '0;
            penultimate_group_col    <= '0;
            row_count                <= '0;
            group_col                <= '0;

            config_width             <= '0;
            config_height            <= '0;
            config_ok                <= 1'b0;
            row_is_last_q            <= 1'b0;
            group_is_last_q          <= 1'b0;

            r_word                   <= '0;
            g_word                   <= '0;
            b_word                   <= '0;

            final_group_pending      <= 1'b0;

            payload_active           <= 1'b0;
            payload_done             <= 1'b0;
            payload_error            <= 1'b0;
        end
        else begin
            // One-cycle status pulses.
            payload_done  <= 1'b0;
            payload_error <= 1'b0;

            // Start has priority so a new descriptor returns all receive
            // state to a known boundary before its geometry is checked.
            if (start) begin
                state                    <= RX_CONFIG_CHECK;
                byte_phase               <= BYTE_R;
                rx_byte_q                 <= '0;
                pixel_in_group           <= '0;

                config_width             <= img_width;
                config_height            <= img_height;
                config_ok                <= 1'b0;

                penultimate_row          <= '0;
                penultimate_group_col    <= '0;
                row_count                <= '0;
                group_col                <= '0;
                row_is_last_q            <= 1'b0;
                group_is_last_q          <= 1'b0;

                r_word                   <= '0;
                g_word                   <= '0;
                b_word                   <= '0;

                final_group_pending      <= 1'b0;
                payload_active           <= 1'b0;
            end
            else begin
                unique case (state)

                    RX_IDLE: begin
                        payload_active <= 1'b0;
                    end

                    RX_CONFIG_CHECK: begin
                        config_ok <=
                            (config_width != 16'd0) &&
                            (config_height != 16'd0) &&
                            (config_width[3:0] == 4'b0000);

                        if (config_height > 16'd1) begin
                            penultimate_row <=
                                config_height - 16'd2;
                        end
                        else begin
                            penultimate_row <= '0;
                        end

                        if (config_width[15:2] > 14'd1) begin
                            penultimate_group_col <=
                                config_width[15:2] - 14'd2;
                        end
                        else begin
                            penultimate_group_col <= '0;
                        end

                        row_is_last_q <=
                            config_height == 16'd1;

                        // Every accepted width is at least 16, hence the
                        // first group of a row is never its final group.
                        group_is_last_q <= 1'b0;

                        state <= RX_CONFIG_APPLY;
                    end

                    RX_CONFIG_APPLY: begin
                        if (config_ok) begin
                            payload_active <= 1'b1;
                            state          <= RX_WAIT_BYTE;
                        end
                        else begin
                            payload_active <= 1'b0;
                            payload_error  <= 1'b1;
                            state          <= RX_IDLE;
                        end
                    end

                    RX_WAIT_BYTE: begin
                        if (rx_byte_valid) begin
                            rx_byte_q <= rx_byte;
                            state     <= RX_PROCESS_BYTE;
                        end
                    end

                    RX_PROCESS_BYTE: begin
                        // A new byte while payload_ready is low violates the
                        // source-side ready/valid contract.
                        if (rx_byte_valid) begin
                            payload_error <= 1'b1;
                        end

                        unique case (byte_phase)

                            BYTE_R: begin
                                unique case (pixel_in_group)
                                    2'd0: r_word[31:24] <= rx_byte_q;
                                    2'd1: r_word[23:16] <= rx_byte_q;
                                    2'd2: r_word[15:8]  <= rx_byte_q;
                                    default: r_word[7:0] <= rx_byte_q;
                                endcase

                                byte_phase <= BYTE_G;
                                state      <= RX_WAIT_BYTE;
                            end

                            BYTE_G: begin
                                unique case (pixel_in_group)
                                    2'd0: g_word[31:24] <= rx_byte_q;
                                    2'd1: g_word[23:16] <= rx_byte_q;
                                    2'd2: g_word[15:8]  <= rx_byte_q;
                                    default: g_word[7:0] <= rx_byte_q;
                                endcase

                                byte_phase <= BYTE_B;
                                state      <= RX_WAIT_BYTE;
                            end

                            BYTE_B: begin
                                unique case (pixel_in_group)
                                    2'd0: b_word[31:24] <= rx_byte_q;
                                    2'd1: b_word[23:16] <= rx_byte_q;
                                    2'd2: b_word[15:8]  <= rx_byte_q;
                                    default: b_word[7:0] <= rx_byte_q;
                                endcase

                                byte_phase <= BYTE_R;

                                if (pixel_in_group == 2'd3) begin
                                    pixel_in_group <= '0;
                                    state          <= RX_WAIT_FIFO;

                                    if (group_is_last_q) begin
                                        group_col       <= '0;
                                        group_is_last_q <= 1'b0;

                                        if (row_is_last_q) begin
                                            final_group_pending <= 1'b1;
                                        end
                                        else begin
                                            row_count <=
                                                row_count + 16'd1;

                                            row_is_last_q <=
                                                row_count ==
                                                penultimate_row;
                                        end
                                    end
                                    else begin
                                        group_col <=
                                            group_col + 14'd1;

                                        group_is_last_q <=
                                            group_col ==
                                            penultimate_group_col;
                                    end
                                end
                                else begin
                                    pixel_in_group <=
                                        pixel_in_group + 2'd1;

                                    state <= RX_WAIT_BYTE;
                                end
                            end

                            default: begin
                                byte_phase    <= BYTE_R;
                                payload_error <= 1'b1;
                                state         <= RX_IDLE;
                            end

                        endcase
                    end

                    RX_WAIT_FIFO: begin
                        // The PC must stop while payload_ready is low.
                        if (rx_byte_valid) begin
                            payload_error <= 1'b1;
                        end

                        if (fifo_ready) begin
                            if (final_group_pending) begin
                                final_group_pending <= 1'b0;
                                payload_active      <= 1'b0;
                                payload_done        <= 1'b1;
                                state               <= RX_IDLE;
                            end
                            else begin
                                state <= RX_WAIT_BYTE;
                            end
                        end
                    end

                    default: begin
                        state               <= RX_IDLE;
                        byte_phase          <= BYTE_R;
                        payload_active      <= 1'b0;
                        final_group_pending <= 1'b0;
                        payload_error       <= 1'b1;
                    end

                endcase
            end
        end
    end

endmodule
