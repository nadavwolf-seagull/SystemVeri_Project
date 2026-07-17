timeunit 1ns;
timeprecision 1ps;

module uart_tx_mac #(
    parameter int unsigned PACKET_BYTES = lab12_pkg::TX_PACKET_BYTES,
    parameter int unsigned PACKET_WIDTH = lab12_pkg::TX_PACKET_WIDTH
) (
    input  logic                    sys_clk,
    input  logic                    rst_n,
    input  logic                    tx_en,

    // CTS is active-low:
    // cts_n = 0 -> transmission is allowed
    // cts_n = 1 -> wait before starting the next byte
    input  logic                    cts_n,

    // Packet interface from Message Composer
    input  logic                    packet_valid,
    input  logic [PACKET_WIDTH-1:0] packet_data,
    output logic                    packet_ready,

    // Byte-level interface toward UART TX PHY
    input  logic                    uart_done,
    output logic                    uart_tx_en,
    output logic [7:0]              uart_tx_data,

    // Status toward Message Composer / monitor logic
    output logic                    packet_busy,
    output logic                    packet_done
);

    localparam int unsigned BYTE_IDX_W =
        (PACKET_BYTES <= 1) ? 1 : $clog2(PACKET_BYTES);

    typedef enum logic [2:0] {
        IDLE,
        WAIT_CTS,
        START_BYTE,
        WAIT_BYTE_DONE,
        DONE
    } state_t;

    state_t state;
    state_t next_state;

    logic [PACKET_WIDTH-1:0] packet_reg;
    logic [BYTE_IDX_W-1:0]   byte_idx;

    // =========================================================
    // STATUS OUTPUTS
    // =========================================================
    assign packet_ready = (state == IDLE) && tx_en;
    assign packet_busy  = (state != IDLE) && (state != DONE);
    assign packet_done  = (state == DONE);

    // One-cycle pulse toward the PHY.
    assign uart_tx_en = (state == START_BYTE);

    // =========================================================
    // BYTE SELECTION
    // =========================================================
    // Bytes are transmitted MSB first.
    //
    // For the default 72-bit packet:
    // byte 0 = packet_data[71:64]
    // byte 1 = packet_data[63:56]
    // ...
    // byte 8 = packet_data[7:0]
    // =========================================================
    assign uart_tx_data =
        packet_reg[PACKET_WIDTH - 1 - (byte_idx * 8) -: 8];

    // =========================================================
    // STATE REGISTER
    // =========================================================
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;

        else if (!tx_en)
            state <= IDLE;

        else
            state <= next_state;
    end

    // =========================================================
    // NEXT STATE LOGIC
    // =========================================================
    always_comb begin
        next_state = state;

        unique case (state)

            IDLE: begin
                if (packet_valid)
                    next_state = WAIT_CTS;
            end

            WAIT_CTS: begin
                if (!cts_n)
                    next_state = START_BYTE;
            end

            START_BYTE: begin
                next_state = WAIT_BYTE_DONE;
            end

            WAIT_BYTE_DONE: begin
                if (uart_done) begin
                    if (byte_idx == PACKET_BYTES - 1)
                        next_state = DONE;
                    else
                        next_state = WAIT_CTS;
                end
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

    // =========================================================
    // PACKET REGISTER
    // =========================================================
    // Sample the packet once, before shifting bytes toward PHY.
    // =========================================================
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            packet_reg <= '0;

        else if (!tx_en)
            packet_reg <= '0;

        else if (state == IDLE && packet_valid)
            packet_reg <= packet_data;
    end

    // =========================================================
    // BYTE INDEX
    // =========================================================
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            byte_idx <= '0;

        else if (!tx_en)
            byte_idx <= '0;

        else if (state == IDLE && packet_valid)
            byte_idx <= '0;

        else if (
            state == WAIT_BYTE_DONE &&
            uart_done &&
            byte_idx < PACKET_BYTES - 1
        )
            byte_idx <= byte_idx + 1'b1;
    end

endmodule
