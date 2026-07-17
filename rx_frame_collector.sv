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

    typedef enum logic {
        IDLE,
        COLLECT
    } state_t;

    state_t state;

    logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] byte_count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            frame_data  <= '0;
            frame_len   <= '0;
            frame_valid <= 1'b0;
            frame_error <= 1'b0;
            byte_count  <= '0;
        end
        else begin
            // One-cycle output pulses
            frame_valid <= 1'b0;
            frame_error <= 1'b0;

            if (framing_err || soft_reset) begin
                state       <= IDLE;
                frame_data  <= '0;
                frame_len   <= '0;
                byte_count  <= '0;
                frame_error <= framing_err;
            end
            else begin
                unique case (state)

                    IDLE: begin
                        frame_len  <= '0;
                        byte_count <= '0;

                        if (rx_byte_valid &&
                            rx_byte == lab12_pkg::ASCII_LBRACE) begin

                            frame_data          <= '0;
                            frame_data[7:0]     <= rx_byte;
                            frame_len           <= 1;
                            byte_count          <= 1;
                            state               <= COLLECT;
                        end
                    end

                    COLLECT: begin
                        if (rx_byte_valid) begin
                            if (byte_count < MAX_FRAME_BYTES) begin
                                frame_data[byte_count*8 +: 8] <= rx_byte;
                                frame_len <= byte_count + 1'b1;

                                if (rx_byte ==
                                    lab12_pkg::ASCII_RBRACE) begin

                                    frame_valid <= 1'b1;
                                    byte_count  <= '0;
                                    state       <= IDLE;
                                end
                                else begin
                                    byte_count <= byte_count + 1'b1;
                                end
                            end
                            else begin
                                // Frame exceeded the configured limit
                                state       <= IDLE;
                                frame_data  <= '0;
                                frame_len   <= '0;
                                byte_count  <= '0;
                                frame_error <= 1'b1;
                            end
                        end
                    end

                    default: begin
                        state       <= IDLE;
                        frame_data  <= '0;
                        frame_len   <= '0;
                        frame_valid <= 1'b0;
                        frame_error <= 1'b0;
                        byte_count  <= '0;
                    end

                endcase
            end
        end
    end

endmodule