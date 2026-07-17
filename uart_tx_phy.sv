timeunit 1ns;
timeprecision 1ps;

module uart_tx_phy #(
    parameter int unsigned CLKS_PER_BIT = lab12_pkg::UART_CLKS_PER_BIT,
    parameter logic        PARITY_EN    = lab12_pkg::UART_PARITY_EN,
    parameter logic        EVEN_PARITY  = lab12_pkg::UART_EVEN_PARITY
) (
    input  logic       sys_clk,
    input  logic       rst_n,
    input  logic       tx_en,

    input  logic       uart_tx_en,
    input  logic [7:0] uart_tx_data,

    output logic       TX,
    output logic       uart_done
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        PARITY,
        STOP
    } state_t;

    state_t state;

    logic [7:0]  tx_data_reg;
    logic [2:0]  bit_idx;
    logic [$clog2(CLKS_PER_BIT)-1:0] clk_count;
    logic parity_bit;

    always_comb begin
        if (EVEN_PARITY) begin
            parity_bit = ^tx_data_reg;
        end else begin
            parity_bit = ~(^tx_data_reg);
        end
    end

    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            TX          <= 1'b1;
            uart_done   <= 1'b0;
            tx_data_reg <= 8'd0;
            bit_idx     <= 3'd0;
            clk_count   <= '0;
        end else if (!tx_en) begin
            state       <= IDLE;
            TX          <= 1'b1;
            uart_done   <= 1'b0;
            tx_data_reg <= 8'd0;
            bit_idx     <= 3'd0;
            clk_count   <= '0;
        end else begin
            uart_done <= 1'b0;

            unique case (state)

                IDLE: begin
                    TX        <= 1'b1;
                    clk_count <= '0;
                    bit_idx   <= 3'd0;

                    if (uart_tx_en) begin
                        tx_data_reg <= uart_tx_data;
                        TX          <= 1'b0;
                        state       <= START;
                    end
                end

                START: begin
                    TX <= 1'b0;

                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= '0;
                        bit_idx   <= 3'd0;
                        TX        <= tx_data_reg[0];
                        state     <= DATA;
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end

                DATA: begin
                    TX <= tx_data_reg[bit_idx];

                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= '0;
                        if (bit_idx == 3'd7) begin
                            if (PARITY_EN) begin
                                TX    <= parity_bit;
                                state <= PARITY;
                            end else begin
                                TX    <= 1'b1;
                                state <= STOP;
                            end
                        end else begin
                            bit_idx <= bit_idx + 1'b1;
                            TX      <= tx_data_reg[bit_idx + 1'b1];
                        end
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end

                PARITY: begin
                    TX <= parity_bit;

                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= '0;
                        TX        <= 1'b1;
                        state     <= STOP;
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end

                STOP: begin
                    TX <= 1'b1;

                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= '0;
                        uart_done <= 1'b1;
                        state     <= IDLE;
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end


                default: begin
                    state       <= IDLE;
                    TX          <= 1'b1;
                    uart_done   <= 1'b0;
                    tx_data_reg <= 8'd0;
                    bit_idx     <= 3'd0;
                    clk_count   <= '0;
                end

            endcase
        end
    end

endmodule