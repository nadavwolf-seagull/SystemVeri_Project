timeunit 1ns;
timeprecision 1ps;

module uart_tx_mac #(
    parameter int unsigned MAX_PACKET_BYTES =
        lab12_pkg::UART_TX_MAX_PACKET_BYTES,

    parameter int unsigned MAX_PACKET_WIDTH =
        lab12_pkg::UART_TX_MAX_PACKET_WIDTH,

    parameter int unsigned PACKET_LEN_WIDTH =
        lab12_pkg::UART_TX_PACKET_LEN_WIDTH
) (
    input  logic                    sys_clk,
    input  logic                    rst_n,
    input  logic                    tx_en,

    // CTS is active-low:
    // cts_n = 0 -> transmission is allowed
    // cts_n = 1 -> wait before starting the next byte
    input  logic                    cts_n,

    // Packet interface from Message Composer
    input  logic                        packet_valid,
    input  logic [MAX_PACKET_WIDTH-1:0] packet_data,
    input  logic [PACKET_LEN_WIDTH-1:0] packet_len,
    output logic                        packet_ready,

    // Byte-level interface toward UART TX PHY
    input  logic                    uart_done,
    output logic                    uart_tx_en,
    output logic [7:0]              uart_tx_data,

    // Status toward Message Composer / monitor logic
    output logic                    packet_busy,
    output logic                    packet_done
);

    localparam int unsigned BYTE_IDX_W =
        (MAX_PACKET_BYTES <= 1) ? 1 : $clog2(MAX_PACKET_BYTES);

    typedef enum logic [2:0] {
        IDLE,
        WAIT_CTS,
        START_BYTE,
        WAIT_BYTE_DONE,
        DONE
    } state_t;

    state_t state;
    state_t next_state;

    logic [MAX_PACKET_WIDTH-1:0] packet_reg;
    logic [PACKET_LEN_WIDTH-1:0] packet_len_reg;
    logic [BYTE_IDX_W-1:0]       byte_idx;
    logic packet_len_valid;

    // =========================================================
    // STATUS OUTPUTS
    // =========================================================
    assign packet_len_valid =
        (packet_len != '0) &&
        (packet_len <= PACKET_LEN_WIDTH'(MAX_PACKET_BYTES));

    assign packet_ready =
        (state == IDLE) &&
        tx_en &&
        (!packet_valid || packet_len_valid);
    assign packet_busy  = (state != IDLE) && (state != DONE);
    assign packet_done  = (state == DONE);

    // One-cycle pulse toward the PHY.
    assign uart_tx_en = (state == START_BYTE);

    // =========================================================
    // BYTE SELECTION
    // =========================================================
    // Bytes are transmitted MSB first from the maximum-width packet.
    // packet_len determines how many leading bytes are transmitted.
    // =========================================================
    assign uart_tx_data =
        packet_reg[MAX_PACKET_WIDTH - 1 - (byte_idx * 8) -: 8];

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
                if (packet_valid && packet_ready)
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
                    if (byte_idx == packet_len_reg - 1'b1)
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
        if (!rst_n) begin
            packet_reg     <= '0;
            packet_len_reg <= '0;
        end
        else if (!tx_en) begin
            packet_reg     <= '0;
            packet_len_reg <= '0;
        end
        else if (state == IDLE && packet_valid && packet_ready) begin
            packet_reg     <= packet_data;
            packet_len_reg <= packet_len;
        end
    end

    // =========================================================
    // BYTE INDEX
    // =========================================================
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            byte_idx <= '0;

        else if (!tx_en)
            byte_idx <= '0;

        else if (state == IDLE && packet_valid && packet_ready)
            byte_idx <= '0;

        else if (
            state == WAIT_BYTE_DONE &&
            uart_done &&
            byte_idx < packet_len_reg - 1'b1
        )
            byte_idx <= byte_idx + 1'b1;
    end

endmodule
