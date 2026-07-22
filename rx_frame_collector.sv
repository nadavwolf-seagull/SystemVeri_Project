timeunit 1ns;
timeprecision 1ps;

module rx_frame_collector #(
    parameter int unsigned MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES
) (
    input  logic clk,
    input  logic rst_n,

    input  logic [7:0] rx_byte,
    input  logic       rx_byte_valid,
    input  logic       framing_err,
    input  logic       soft_reset,

    output logic [MAX_FRAME_BYTES*8-1:0] frame_data,
    output logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] frame_len,
    output logic frame_valid,
    output logic frame_error
);

    typedef enum logic [1:0] {
        IDLE,
        COLLECT,
        WRITE_BYTE
    } state_t;

    state_t state;

    logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] byte_count;

    // A UART byte is first captured with a one-hot write position and is
    // committed on the following clock. Each frame byte therefore receives
    // a local one-bit enable instead of a wide decoded byte-index enable.
    logic [7:0]                 pending_byte_q;
    logic                       pending_last_q;
    logic [MAX_FRAME_BYTES-1:0] write_onehot_q;

    integer byte_index;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= IDLE;
            frame_data      <= '0;
            frame_len       <= '0;
            frame_valid     <= 1'b0;
            frame_error     <= 1'b0;
            byte_count      <= '0;
            pending_byte_q  <= '0;
            pending_last_q  <= 1'b0;
            write_onehot_q  <= '0;
        end
        else begin
            // One-cycle output pulses.
            frame_valid <= 1'b0;
            frame_error <= 1'b0;

            if (framing_err || soft_reset) begin
                state           <= IDLE;
                frame_len       <= '0;
                byte_count      <= '0;
                pending_byte_q  <= '0;
                pending_last_q  <= 1'b0;
                write_onehot_q  <= '0;
                frame_error     <= framing_err;
            end
            else begin
                unique case (state)

                    IDLE: begin
                        frame_len      <= '0;
                        byte_count     <= '0;
                        write_onehot_q <= '0;

                        if (
                            rx_byte_valid &&
                            (rx_byte == lab12_pkg::ASCII_LBRACE)
                        ) begin
                            pending_byte_q <= rx_byte;
                            pending_last_q <= 1'b0;

                            // The first frame byte always uses byte lane 0.
                            write_onehot_q <= {
                                {(MAX_FRAME_BYTES-1){1'b0}},
                                1'b1
                            };

                            state <= WRITE_BYTE;
                        end
                    end

                    COLLECT: begin
                        if (rx_byte_valid) begin
                            if (
                                byte_count <
                                lab12_pkg::RX_FRAME_LEN_WIDTH'(
                                    MAX_FRAME_BYTES
                                )
                            ) begin
                                pending_byte_q <= rx_byte;
                                pending_last_q <=
                                    rx_byte ==
                                    lab12_pkg::ASCII_RBRACE;

                                state <= WRITE_BYTE;
                            end
                            else begin
                                // Frame exceeded the configured limit.
                                state           <= IDLE;
                                frame_len       <= '0;
                                byte_count      <= '0;
                                pending_last_q  <= 1'b0;
                                write_onehot_q  <= '0;
                                frame_error     <= 1'b1;
                            end
                        end
                    end

                    WRITE_BYTE: begin
                        // Static byte lanes with local one-hot enables.
                        for (
                            byte_index = 0;
                            byte_index < MAX_FRAME_BYTES;
                            byte_index = byte_index + 1
                        ) begin
                            if (write_onehot_q[byte_index]) begin
                                frame_data[byte_index*8 +: 8] <=
                                    pending_byte_q;
                            end
                        end

                        frame_len <= byte_count + 1'b1;

                        if (pending_last_q) begin
                            frame_valid     <= 1'b1;
                            byte_count      <= '0;
                            pending_last_q  <= 1'b0;
                            write_onehot_q  <= '0;
                            state           <= IDLE;
                        end
                        else begin
                            byte_count <= byte_count + 1'b1;

                            // Shifting a one-hot vector is wiring, not a
                            // variable byte-index decoder.
                            write_onehot_q <= write_onehot_q << 1;
                            state          <= COLLECT;
                        end
                    end

                    default: begin
                        state           <= IDLE;
                        frame_len       <= '0;
                        frame_valid     <= 1'b0;
                        frame_error     <= 1'b0;
                        byte_count      <= '0;
                        pending_byte_q  <= '0;
                        pending_last_q  <= 1'b0;
                        write_onehot_q  <= '0;
                    end

                endcase
            end
        end
    end

endmodule
