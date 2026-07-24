`timescale 1ns / 1ps

// ============================================================
// APB RGF Slave
//
// APB wrapper around the existing config_rgf module.
// This keeps the proven RGF logic unchanged and only replaces
// the external access mechanism with APB.
//
// The wrapper inserts wait states because config_rgf has a
// registered read response: rd_valid/rd_data return after rd_en.
// ============================================================
module apb_rgf_slave #(
    parameter int unsigned ADDR_WIDTH = lab12_pkg::RGF_ADDR_WIDTH,
    parameter int unsigned DATA_WIDTH = lab12_pkg::RGF_DATA_WIDTH,
    parameter int unsigned FIFO_DEPTH = lab12_pkg::FIFO_DEPTH
)(
    input logic clk,
    input logic rst_n,

    // APB slave bus
    apb_if.slave apb,

    // DMA configuration and control outputs
    output logic                  image_start_pulse,
    output logic                  dma_wr_start,
    output logic                  dma_rd_start,
    output logic [23:0]           img_base,
    output logic [15:0]           img_width,
    output logic [15:0]           img_height,

    output logic [DATA_WIDTH-1:0] fifo_ae_level,
    output logic [DATA_WIDTH-1:0] fifo_af_level,

    // DMA status and progress inputs
    input  logic                  dma_busy,
    input  logic                  dma_done,
    input  logic                  dma_error,

    input  logic [15:0]           wr_row_cnt,
    input  logic [15:0]           wr_col_cnt,
    input  logic [15:0]           rd_row_cnt,
    input  logic [15:0]           rd_col_cnt,

    input  logic                  fifo_empty,
    input  logic                  fifo_full,
    input  logic                  fifo_error,
    input  logic                  image_payload_corrupt,

    // UART PHY error inputs
    input  logic                  uart_parity_err,
    input  logic                  uart_framing_err,

    // Control outputs
    output logic                  clk_sel,
    output logic                  parity_enable,
    output logic                  mac_soft_reset_pulse,

    // Debug/error output from the underlying RGF
    output logic                  rgf_error
);

    typedef enum logic [0:0] {
        SLV_IDLE,
        SLV_WAIT_RESPONSE
    } state_t;

    state_t state;

    logic pending_write;
    logic pending_read;

    logic                  rgf_wr_en;
    logic                  rgf_rd_en;
    logic [ADDR_WIDTH-1:0] rgf_addr;
    logic [DATA_WIDTH-1:0] rgf_wr_data;
    logic [DATA_WIDTH-1:0] rgf_rd_data;
    logic                  rgf_rd_valid;
    logic                  rgf_error_int;

    logic access_phase;
    logic access_launch;
    logic read_done;
    logic write_done;
    logic transfer_done;

    assign access_phase  = apb.PSEL && apb.PENABLE;
    assign access_launch = (state == SLV_IDLE) && access_phase;

    assign rgf_wr_en   = access_launch && apb.PWRITE;
    assign rgf_rd_en   = access_launch && !apb.PWRITE;
    assign rgf_addr    = apb.PADDR[ADDR_WIDTH-1:0];
    assign rgf_wr_data = apb.PWDATA;

    assign read_done     = pending_read  && (rgf_rd_valid || rgf_error_int);
    assign write_done    = pending_write;
    assign transfer_done = (state == SLV_WAIT_RESPONSE) && (read_done || write_done);

    // PREADY is asserted only when the wrapper has a valid response.
    // This creates legal APB wait states while config_rgf prepares rd_data.
    assign apb.PREADY  = transfer_done;
    assign apb.PRDATA  = (pending_read) ? rgf_rd_data : '0;
    assign apb.PSLVERR = (transfer_done) ? rgf_error_int : 1'b0;

    assign rgf_error = rgf_error_int;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= SLV_IDLE;
            pending_write <= 1'b0;
            pending_read  <= 1'b0;
        end
        else begin
            unique case (state)

                SLV_IDLE: begin
                    pending_write <= 1'b0;
                    pending_read  <= 1'b0;

                    if (access_launch) begin
                        pending_write <= apb.PWRITE;
                        pending_read  <= !apb.PWRITE;
                        state         <= SLV_WAIT_RESPONSE;
                    end
                end

                SLV_WAIT_RESPONSE: begin
                    if (transfer_done) begin
                        pending_write <= 1'b0;
                        pending_read  <= 1'b0;
                        state         <= SLV_IDLE;
                    end
                end

                default: begin
                    state         <= SLV_IDLE;
                    pending_write <= 1'b0;
                    pending_read  <= 1'b0;
                end

            endcase
        end
    end

    // Existing RGF is kept unchanged under the APB wrapper.
    config_rgf #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .FIFO_DEPTH (FIFO_DEPTH)
    ) u_config_rgf (
        .clk                  (clk),
        .rst_n                (rst_n),

        .wr_en                (rgf_wr_en),
        .rd_en                (rgf_rd_en),
        .addr                 (rgf_addr),
        .wr_data              (rgf_wr_data),

        .rd_data              (rgf_rd_data),
        .rd_valid             (rgf_rd_valid),
        .error                (rgf_error_int),

        .image_start_pulse    (image_start_pulse),
        .dma_wr_start         (dma_wr_start),
        .dma_rd_start         (dma_rd_start),
        .img_base             (img_base),
        .img_width            (img_width),
        .img_height           (img_height),
        .fifo_ae_level        (fifo_ae_level),
        .fifo_af_level        (fifo_af_level),

        .dma_busy             (dma_busy),
        .dma_done             (dma_done),
        .dma_error            (dma_error),

        .wr_row_cnt           (wr_row_cnt),
        .wr_col_cnt           (wr_col_cnt),
        .rd_row_cnt           (rd_row_cnt),
        .rd_col_cnt           (rd_col_cnt),
        .fifo_empty           (fifo_empty),
        .fifo_full            (fifo_full),
        .fifo_error           (fifo_error),
        .image_payload_corrupt(image_payload_corrupt),

        .uart_parity_err      (uart_parity_err),
        .uart_framing_err     (uart_framing_err),

        .clk_sel              (clk_sel),
        .parity_enable        (parity_enable),
        .mac_soft_reset_pulse (mac_soft_reset_pulse)
    );

endmodule
