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

    typedef enum logic [1:0] {
        BYTE_R,
        BYTE_G,
        BYTE_B
    } byte_phase_t;

    byte_phase_t byte_phase;

    logic [1:0] pixel_in_group;

    logic [31:0] total_pixels;
    logic [31:0] received_pixels;

    logic [31:0] r_word;
    logic [31:0] g_word;
    logic [31:0] b_word;

    logic pending_push;
    logic final_group_pending;

    assign fifo_r_data = r_word;
    assign fifo_g_data = g_word;
    assign fifo_b_data = b_word;

    /*
     * A new UART byte may be accepted while an image payload is active
     * and no completed four-pixel group is waiting for the FIFO.
     */
    assign payload_ready =
        payload_active &&
        !pending_push &&
        !fifo_push;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            byte_phase          <= BYTE_R;
            pixel_in_group      <= '0;

            total_pixels        <= '0;
            received_pixels     <= '0;

            r_word              <= '0;
            g_word              <= '0;
            b_word              <= '0;

            pending_push        <= 1'b0;
            final_group_pending <= 1'b0;

            fifo_push           <= 1'b0;
            payload_active      <= 1'b0;
            payload_done        <= 1'b0;
            payload_error       <= 1'b0;
        end
        else begin
            // One-cycle output pulses.
            fifo_push     <= 1'b0;
            payload_done  <= 1'b0;
            payload_error <= 1'b0;

            // Start a new image payload.
            if (start) begin
                byte_phase          <= BYTE_R;
                pixel_in_group      <= '0;

                total_pixels        <= img_width * img_height;
                received_pixels     <= '0;

                r_word              <= '0;
                g_word              <= '0;
                b_word              <= '0;

                pending_push        <= 1'b0;
                final_group_pending <= 1'b0;

                if ((img_width == 0) || (img_height == 0)) begin
                    payload_active <= 1'b0;
                    payload_error  <= 1'b1;
                end
                else begin
                    payload_active <= 1'b1;
                end
            end

            /*
             * Keep the completed RGB words stable throughout the fifo_push
             * cycle. Clear them only on the following clock.
             */
            else if (fifo_push) begin
                r_word <= '0;
                g_word <= '0;
                b_word <= '0;
            end

            /*
             * A completed group is held until all three RX FIFOs
             * can accept it together.
             */
            else if (pending_push) begin
                if (fifo_ready) begin
                    fifo_push    <= 1'b1;
                    pending_push <= 1'b0;
                    if (final_group_pending) begin
                        final_group_pending <= 1'b0;
                        payload_active      <= 1'b0;
                        payload_done        <= 1'b1;
                    end
                end

                /*
                 * The PC should stop sending when payload_ready is low.
                 * Receiving another byte here means flow control was
                 * violated and the byte cannot be stored safely.
                 */
                if (rx_byte_valid) begin
                    payload_error <= 1'b1;
                end
            end

            // Consume raw RGB payload bytes.
            else if (payload_active && rx_byte_valid) begin
                unique case (byte_phase)

                    BYTE_R: begin
                        r_word[
                            31 - (pixel_in_group * 8) -: 8
                        ] <= rx_byte;

                        byte_phase <= BYTE_G;
                    end

                    BYTE_G: begin
                        g_word[
                            31 - (pixel_in_group * 8) -: 8
                        ] <= rx_byte;

                        byte_phase <= BYTE_B;
                    end

                    BYTE_B: begin
                        b_word[
                            31 - (pixel_in_group * 8) -: 8
                        ] <= rx_byte;

                        received_pixels <= received_pixels + 1'b1;
                        byte_phase      <= BYTE_R;

                        /*
                         * Push after four pixels, or after the final
                         * partial group. Unused bytes in a partial group
                         * remain zero.
                         */
                        if (
                            (pixel_in_group == 2'd3) ||
                            ((received_pixels + 1'b1) == total_pixels)
                        ) begin
                            pending_push   <= 1'b1;
                            pixel_in_group <= '0;

                            if (
                                (received_pixels + 1'b1) ==
                                total_pixels
                            ) begin
                                final_group_pending <= 1'b1;
                            end
                        end
                        else begin
                            pixel_in_group <= pixel_in_group + 1'b1;
                        end
                    end

                    default: begin
                        byte_phase    <= BYTE_R;
                        payload_error <= 1'b1;
                    end

                endcase
            end
        end
    end

endmodule