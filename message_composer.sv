timeunit 1ns;
timeprecision 1ps;

module message_composer #(
    parameter int unsigned IMG_WIDTH =
        lab12_pkg::IMG_WIDTH,

    parameter int unsigned IMG_HEIGHT =
        lab12_pkg::IMG_HEIGHT,

    parameter int unsigned ROW_WIDTH =
        lab12_pkg::ROW_WIDTH,

    parameter int unsigned COL_WIDTH =
        lab12_pkg::COL_WIDTH,

    parameter int unsigned PIXEL_WIDTH =
        lab12_pkg::PIXEL_WIDTH,

    parameter int unsigned COORD_FIELD_WIDTH =
        lab12_pkg::COORD_FIELD_WIDTH,

    parameter int unsigned PACKET_WIDTH =
        lab12_pkg::TX_PACKET_WIDTH
) (
    input  logic                          sys_clk,
    input  logic                          rst_n,

    // Pulse that starts one complete image transmission.
    input  logic                          start,

    // ---------------------------------------------------------
    // FIFO interface
    // ---------------------------------------------------------
    input  logic                          fifo_empty,
    input  logic [PIXEL_WIDTH-1:0]        fifo_data_out,
    output logic                          fifo_pop_req,

    // ---------------------------------------------------------
    // Packet interface toward UART TX top
    // ---------------------------------------------------------
    input  logic                          packet_ready,
    input  logic                          packet_done,

    output logic                          packet_valid,
    output logic [PACKET_WIDTH-1:0]       packet_data,

    // ---------------------------------------------------------
    // Image TX monitor
    // ---------------------------------------------------------
    output logic [ROW_WIDTH-1:0]          tx_row_cnt,
    output logic [COL_WIDTH-1:0]          tx_col_cnt,

    output logic                          composer_busy,
    output logic                          image_tx_done
);

    localparam int unsigned ROW_PAD_WIDTH =
        COORD_FIELD_WIDTH - ROW_WIDTH;

    localparam int unsigned COL_PAD_WIDTH =
        COORD_FIELD_WIDTH - COL_WIDTH;

    typedef enum logic [3:0] {
        IDLE,
        WAIT_PIXEL,
        POP_FIFO,
        CAPTURE_PIXEL,
        WAIT_MAC_READY,
        SEND_PACKET,
        WAIT_PACKET_DONE,
        UPDATE_COUNTERS,
        DONE
    } state_t;

    state_t state;
    state_t next_state;

    logic [PIXEL_WIDTH-1:0]       pixel_reg;

    logic [COORD_FIELD_WIDTH-1:0] row_field;
    logic [COORD_FIELD_WIDTH-1:0] col_field;

    logic last_col;
    logic last_row;
    logic last_pixel;

    // =========================================================
    // STATUS
    // =========================================================
    assign composer_busy = (state != IDLE);
    assign image_tx_done = (state == DONE);

    assign last_col   = (tx_col_cnt == IMG_WIDTH  - 1);
    assign last_row   = (tx_row_cnt == IMG_HEIGHT - 1);
    assign last_pixel = last_col && last_row;

    // =========================================================
    // PACKET COMPOSITION
    // =========================================================
    // Row and column are transmitted as 24-bit fields.
    // Their actual values are limited to 10 bits according
    // to the Lab 8 requirements.
    assign row_field = {
        {ROW_PAD_WIDTH{1'b0}},
        tx_row_cnt
    };

    assign col_field = {
        {COL_PAD_WIDTH{1'b0}},
        tx_col_cnt
    };

    // Packet format:
    // { Row[23:0], Column[23:0], Pixel[23:0] }
    //
    // Pixel format:
    // { Red[7:0], Green[7:0], Blue[7:0] }
    assign packet_data = {
        row_field,
        col_field,
        pixel_reg
    };

    // =========================================================
    // OUTPUT PULSES
    // =========================================================
    // fifo_pop_req is asserted for one cycle.
    // packet_valid is asserted for one cycle.
    always_comb begin
        fifo_pop_req = 1'b0;
        packet_valid = 1'b0;

        if (state == POP_FIFO)
            fifo_pop_req = 1'b1;

        if (state == SEND_PACKET)
            packet_valid = 1'b1;
    end

    // =========================================================
    // STATE REGISTER
    // =========================================================
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
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
                if (start)
                    next_state = WAIT_PIXEL;
            end

            // Wait until the FIFO contains at least one pixel.
            WAIT_PIXEL: begin
                if (!fifo_empty)
                    next_state = POP_FIFO;
            end

            // Generate a one-cycle FIFO pop request.
            POP_FIFO: begin
                next_state = CAPTURE_PIXEL;
            end

            // The FIFO RAM is synchronous.
            // Its output is valid after the pop clock edge.
            CAPTURE_PIXEL: begin
                next_state = WAIT_MAC_READY;
            end

            // Do not overwrite a packet that is still being sent.
            WAIT_MAC_READY: begin
                if (packet_ready)
                    next_state = SEND_PACKET;
            end

            // Pulse packet_valid for one cycle.
            SEND_PACKET: begin
                next_state = WAIT_PACKET_DONE;
            end

            // Wait until the MAC finishes all packet bytes.
            WAIT_PACKET_DONE: begin
                if (packet_done)
                    next_state = UPDATE_COUNTERS;
            end

            // Advance TX-side coordinates only after the packet
            // was transmitted successfully.
            UPDATE_COUNTERS: begin
                if (last_pixel)
                    next_state = DONE;
                else
                    next_state = WAIT_PIXEL;
            end

            // image_tx_done is asserted for one cycle.
            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

    // =========================================================
    // PIXEL REGISTER
    // =========================================================
    // Capture the FIFO output after the synchronous RAM read.
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n)
            pixel_reg <= '0;

        else if (state == CAPTURE_PIXEL)
            pixel_reg <= fifo_data_out;
    end

    // =========================================================
    // TX ROW / COLUMN COUNTERS
    // =========================================================
    always_ff @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_row_cnt <= '0;
            tx_col_cnt <= '0;
        end

        else if (state == IDLE && start) begin
            tx_row_cnt <= '0;
            tx_col_cnt <= '0;
        end

        else if (state == UPDATE_COUNTERS) begin
            if (last_col) begin
                tx_col_cnt <= '0;

                if (!last_row)
                    tx_row_cnt <= tx_row_cnt + 1'b1;
            end

            else begin
                tx_col_cnt <= tx_col_cnt + 1'b1;
            end
        end
    end

endmodule