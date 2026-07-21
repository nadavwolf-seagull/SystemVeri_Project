`timescale 1ns / 1ps

// Multi-bit CDC using the request/acknowledge handshake synchronizer taught
// in Lecture 9. The source register holds the bus stable throughout the
// transfer. Only the one-bit request and acknowledge controls pass through
// two-flop synchronizers.
module cdc_handshake_sync #(
    parameter int unsigned DATA_WIDTH = 32
) (
    input  logic                  src_clk,
    input  logic                  src_rst_n,
    input  logic                  src_valid,
    output logic                  src_ready,
    input  logic [DATA_WIDTH-1:0] src_data,

    input  logic                  dst_clk,
    input  logic                  dst_rst_n,
    output logic                  dst_valid,
    input  logic                  dst_ready,
    output logic [DATA_WIDTH-1:0] dst_data
);

    typedef enum logic [1:0] {
        SRC_IDLE,
        SRC_WAIT_ACK_HIGH,
        SRC_WAIT_ACK_LOW
    } src_state_t;

    typedef enum logic [1:0] {
        DST_WAIT_REQ_HIGH,
        DST_HAVE_DATA,
        DST_WAIT_REQ_LOW
    } dst_state_t;

    src_state_t src_state;
    dst_state_t dst_state;

    logic [DATA_WIDTH-1:0] src_data_hold;
    logic                  req_src;
    logic                  ack_dst;

    logic ack_sync_src;
    logic req_sync_dst;

    assign src_ready =
        (src_state == SRC_IDLE) && !ack_sync_src;

    // Source controller: capture data, assert request, observe acknowledge,
    // then deassert request and wait for acknowledge to return low.
    always_ff @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n) begin
            src_state     <= SRC_IDLE;
            src_data_hold <= '0;
            req_src       <= 1'b0;
        end
        else begin
            unique case (src_state)
                SRC_IDLE: begin
                    if (src_valid && !ack_sync_src) begin
                        src_data_hold <= src_data;
                        req_src       <= 1'b1;
                        src_state     <= SRC_WAIT_ACK_HIGH;
                    end
                end

                SRC_WAIT_ACK_HIGH: begin
                    if (ack_sync_src) begin
                        req_src   <= 1'b0;
                        src_state <= SRC_WAIT_ACK_LOW;
                    end
                end

                SRC_WAIT_ACK_LOW: begin
                    if (!ack_sync_src)
                        src_state <= SRC_IDLE;
                end

                default: begin
                    req_src   <= 1'b0;
                    src_state <= SRC_IDLE;
                end
            endcase
        end
    end

    // Destination controller: after the synchronized request arrives, sample
    // the held bus. Acknowledge only after the destination consumes the data.
    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            dst_state <= DST_WAIT_REQ_HIGH;
            dst_valid <= 1'b0;
            dst_data  <= '0;
            ack_dst   <= 1'b0;
        end
        else begin
            unique case (dst_state)
                DST_WAIT_REQ_HIGH: begin
                    if (req_sync_dst) begin
                        dst_data  <= src_data_hold;
                        dst_valid <= 1'b1;
                        dst_state <= DST_HAVE_DATA;
                    end
                end

                DST_HAVE_DATA: begin
                    if (dst_valid && dst_ready) begin
                        dst_valid <= 1'b0;
                        ack_dst   <= 1'b1;
                        dst_state <= DST_WAIT_REQ_LOW;
                    end
                end

                DST_WAIT_REQ_LOW: begin
                    if (!req_sync_dst) begin
                        ack_dst   <= 1'b0;
                        dst_state <= DST_WAIT_REQ_HIGH;
                    end
                end

                default: begin
                    dst_valid <= 1'b0;
                    ack_dst   <= 1'b0;
                    dst_state <= DST_WAIT_REQ_HIGH;
                end
            endcase
        end
    end

    cdc_2ff_sync u_ack_2ff (
        .clk      (src_clk),
        .rst_n    (src_rst_n),
        .async_in (ack_dst),
        .sync_out (ack_sync_src)
    );

    cdc_2ff_sync u_req_2ff (
        .clk      (dst_clk),
        .rst_n    (dst_rst_n),
        .async_in (req_src),
        .sync_out (req_sync_dst)
    );

endmodule
