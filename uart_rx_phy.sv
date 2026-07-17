timeunit 1ns;
timeprecision 1ps;

module uart_rx_phy #(
    parameter int unsigned CLK_FREQ_HZ = lab12_pkg::SYS_CLK_FREQ_HZ,
    parameter int unsigned BAUD        = lab12_pkg::UART_BAUD_RATE,
    parameter logic        PARITY_EN   = lab12_pkg::UART_PARITY_EN,
    parameter logic        EVEN_PARITY = lab12_pkg::UART_EVEN_PARITY
) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx,
    output logic [7:0] rx_byte,
    output logic       rx_byte_valid,
    output logic       framing_err,
    output logic       parity_err,
    output logic       rx_busy
);

    localparam int unsigned OS_RATE  = BAUD * 16;
    localparam int unsigned OS_DIV   = (CLK_FREQ_HZ + (OS_RATE / 2)) / OS_RATE;
    localparam int unsigned OS_CNT_W = (OS_DIV <= 1) ? 1 : $clog2(OS_DIV);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        PARITY,
        STOP
    } state_t;

    state_t state;

    // RX input synchronizer
    logic rx_ff1;
    logic rx_ff2;
    logic rx_sync;
    logic rx_sync_prev;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_ff1       <= 1'b1;
            rx_ff2       <= 1'b1;
            rx_sync_prev <= 1'b1;
        end else begin
            rx_ff1       <= rx;
            rx_ff2       <= rx_ff1;
            rx_sync_prev <= rx_ff2;
        end
    end

    assign rx_sync = rx_ff2;
    assign rx_busy = (state != IDLE);

    logic [OS_CNT_W-1:0] os_div_cnt;
    logic [3:0]          os_phase;

    logic [2:0] bit_idx;
    logic [7:0] shift_reg;

    logic sampled_parity_bit;
    logic expected_parity_bit;
    logic parity_ok;

    logic s7;
    logic s8;
    logic s9;

    always_comb begin
        if (EVEN_PARITY) begin
            expected_parity_bit = ^shift_reg;
        end else begin
            expected_parity_bit = ~(^shift_reg);
        end

        parity_ok = (sampled_parity_bit == expected_parity_bit);
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            os_div_cnt    <= '0;
            os_phase      <= 4'd0;
            bit_idx       <= 3'd0;
            shift_reg     <= 8'd0;
            rx_byte       <= 8'd0;
            rx_byte_valid <= 1'b0;
            framing_err   <= 1'b0;
            parity_err         <= 1'b0;
            sampled_parity_bit <= 1'b1;
            s7            <= 1'b1;
            s8            <= 1'b1;
            s9            <= 1'b1;
        end else begin
            rx_byte_valid <= 1'b0;
            framing_err   <= 1'b0;
            parity_err <= 1'b0;

            unique case (state)

                IDLE: begin
                    os_div_cnt <= '0;
                    os_phase   <= 4'd0;
                    bit_idx    <= 3'd0;
                    shift_reg  <= 8'd0;
                    sampled_parity_bit <= 1'b1;
                    s7         <= 1'b1;
                    s8         <= 1'b1;
                    s9         <= 1'b1;

                    // Detect falling edge of start bit
                    if ((rx_sync_prev == 1'b1) && (rx_sync == 1'b0)) begin
                        state      <= START;
                        os_div_cnt <= '0;
                        os_phase   <= 4'd0;
                    end
                end

                START: begin
                    if (os_div_cnt == OS_DIV - 1) begin
                        os_div_cnt <= '0;
                        os_phase   <= os_phase + 4'd1;

                        if (os_phase == 4'd7) begin
                            s7 <= rx_sync;
                        end

                        if (os_phase == 4'd8) begin
                            s8 <= rx_sync;
                        end

                        if (os_phase == 4'd9) begin
                            s9 <= rx_sync;
                        end

                        if (os_phase == 4'd15) begin
                            // Majority vote: start bit should be low
                            if ((~s7 & ~s8) | (~s7 & ~s9) | (~s8 & ~s9)) begin
                                state     <= DATA;
                                os_phase  <= 4'd0;
                                bit_idx   <= 3'd0;
                                shift_reg <= 8'd0;
                                s7        <= 1'b1;
                                s8        <= 1'b1;
                                s9        <= 1'b1;
                            end else begin
                                state    <= IDLE;
                                os_phase <= 4'd0;
                            end
                        end
                    end else begin
                        os_div_cnt <= os_div_cnt + 1'b1;
                    end
                end

                DATA: begin
                    if (os_div_cnt == OS_DIV - 1) begin
                        os_div_cnt <= '0;
                        os_phase   <= os_phase + 4'd1;

                        if (os_phase == 4'd8) begin
                            s8 <= rx_sync;
                        end

                        if (os_phase == 4'd15) begin
                            shift_reg[bit_idx] <= s8;
                            os_phase <= 4'd0;
                            s8       <= 1'b1;
                            if (bit_idx == 3'd7) begin
                                if (PARITY_EN) begin
                                    state <= PARITY;
                                end else begin
                                    state <= STOP;
                                end
                                bit_idx <= 3'd0;
                            end else begin
                                bit_idx <= bit_idx + 3'd1;
                            end
                        end
                    end else begin
                        os_div_cnt <= os_div_cnt + 1'b1;
                    end
                end

                PARITY: begin
                    if (os_div_cnt == OS_DIV - 1) begin
                        os_div_cnt <= '0;
                        os_phase   <= os_phase + 4'd1;

                        if (os_phase == 4'd8) begin
                            sampled_parity_bit <= rx_sync;
                        end

                        if (os_phase == 4'd15) begin
                            os_phase <= 4'd0;
                            state    <= STOP;
                        end
                    end else begin
                        os_div_cnt <= os_div_cnt + 1'b1;
                    end
                end

                STOP: begin
                    if (os_div_cnt == OS_DIV - 1) begin
                        os_div_cnt <= '0;
                        os_phase   <= os_phase + 4'd1;

                        // Sample stop bit in the middle
                        if (os_phase == 4'd8) begin
                            if (rx_sync != 1'b1) begin
                                framing_err <= 1'b1;
                            end else if (PARITY_EN && !parity_ok) begin
                                parity_err <= 1'b1;
                            end else begin
                                rx_byte       <= shift_reg;
                                rx_byte_valid <= 1'b1;
                            end

                            os_phase <= 4'd0;
                            state    <= IDLE;
                        end
                    end else begin
                        os_div_cnt <= os_div_cnt + 1'b1;
                    end
                end

                default: begin
                    state              <= IDLE;
                    os_div_cnt         <= '0;
                    os_phase           <= 4'd0;
                    bit_idx            <= 3'd0;
                    shift_reg          <= 8'd0;
                    sampled_parity_bit <= 1'b1;
                    s7                 <= 1'b1;
                    s8                 <= 1'b1;
                    s9                 <= 1'b1;
                end

            endcase
        end
    end

endmodule