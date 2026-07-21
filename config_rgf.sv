`timescale 1ns / 1ps

module config_rgf #(
    parameter int unsigned ADDR_WIDTH = lab12_pkg::RGF_ADDR_WIDTH,
    parameter int unsigned DATA_WIDTH = lab12_pkg::RGF_DATA_WIDTH,
    parameter int unsigned FIFO_DEPTH = lab12_pkg::FIFO_DEPTH
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // RGF access interface from Sequencer / command controller
    input  logic                  wr_en,
    input  logic                  rd_en,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wr_data,

    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  rd_valid,
    output logic                  error,

    // DMA configuration and control outputs
    output logic                  image_start_pulse,
    output logic                  dma_wr_start,
    output logic                  dma_rd_start,
    output logic [23:0]           img_base,
    output logic [15:0]           img_width,
    output logic [15:0]           img_height,

    output logic [DATA_WIDTH-1:0] fifo_ae_level,
    output logic [DATA_WIDTH-1:0] fifo_af_level,

    // Status inputs from the system
    input logic                   dma_busy,
    input logic                   dma_done,
    input logic                   dma_error,

    input logic [15:0]            wr_row_cnt,
    input logic [15:0]            wr_col_cnt,
    input logic [15:0]            rd_row_cnt,
    input logic [15:0]            rd_col_cnt,
    input  logic                  fifo_empty,
    input  logic                  fifo_full,
    input  logic                  fifo_error,

    // LAB11 UART PHY error inputs
    input  logic                  uart_parity_err,
    input  logic                  uart_framing_err,

    // LAB11 control outputs
    output logic                  clk_sel,
    output logic                  parity_enable,
    output logic                  mac_soft_reset_pulse
);

    // ============================================================
    // Internal registers
    // ============================================================
    logic [DATA_WIDTH-1:0] ctrl_reg;
    logic [DATA_WIDTH-1:0] img_base_reg;
    logic [DATA_WIDTH-1:0] img_width_reg;
    logic [DATA_WIDTH-1:0] img_height_reg;
    logic [DATA_WIDTH-1:0] fifo_ae_level_reg;
    logic [DATA_WIDTH-1:0] fifo_af_level_reg;
    logic [DATA_WIDTH-1:0] error_status_reg;
    logic [DATA_WIDTH-1:0] uart_error_cnt_reg;
    logic                  uart_phy_error;

    logic illegal_addr;
    logic illegal_write;
    logic threshold_error;

    logic access_error;

    // ============================================================
    // Dynamic STATUS register value
    // ============================================================
    logic [DATA_WIDTH-1:0] status_value;

    assign uart_phy_error = uart_parity_err | uart_framing_err;

    always_comb begin
        status_value = '0;

        status_value[lab12_pkg::RGF_STATUS_SEQ_BUSY_BIT] =
            dma_busy;

        status_value[lab12_pkg::RGF_STATUS_IMAGE_DONE_BIT] =
            dma_done;
        status_value[lab12_pkg::RGF_STATUS_FIFO_EMPTY_BIT] = fifo_empty;
        status_value[lab12_pkg::RGF_STATUS_FIFO_FULL_BIT]  = fifo_full;
        status_value[lab12_pkg::RGF_STATUS_FIFO_ERROR_BIT] = fifo_error;
        status_value[lab12_pkg::RGF_STATUS_UART_PARITY_ERR_BIT]  = error_status_reg[lab12_pkg::RGF_ERROR_UART_PARITY_BIT];
        status_value[lab12_pkg::RGF_STATUS_UART_FRAMING_ERR_BIT] = error_status_reg[lab12_pkg::RGF_ERROR_UART_FRAMING_BIT];
    end

    // ============================================================
    // Address decode
    // ============================================================
    always_comb begin
        illegal_addr = 1'b0;

        unique case (addr)

            lab12_pkg::RGF_ADDR_CTRL,
            lab12_pkg::RGF_ADDR_STATUS,
            lab12_pkg::RGF_ADDR_IMG_WIDTH,
            lab12_pkg::RGF_ADDR_IMG_HEIGHT,
            lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL,
            lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL,
            lab12_pkg::RGF_ADDR_ERROR_STATUS,
            lab12_pkg::RGF_ADDR_VERSION,
            lab12_pkg::RGF_ADDR_IMG_BASE,
            lab12_pkg::RGF_ADDR_WR_ROW_CNT,
            lab12_pkg::RGF_ADDR_WR_COL_CNT,
            lab12_pkg::RGF_ADDR_RD_ROW_CNT,
            lab12_pkg::RGF_ADDR_RD_COL_CNT,
            lab12_pkg::RGF_ADDR_UART_ERROR_CNT: begin
                illegal_addr = 1'b0;
            end

            default: begin
                illegal_addr = 1'b1;
            end

        endcase
    end

    // ============================================================
    // Write permission decode
    // ============================================================
    always_comb begin
        illegal_write = 1'b0;

        if (wr_en) begin
            unique case (addr)

                lab12_pkg::RGF_ADDR_CTRL,
                lab12_pkg::RGF_ADDR_IMG_BASE,
                lab12_pkg::RGF_ADDR_IMG_WIDTH,
                lab12_pkg::RGF_ADDR_IMG_HEIGHT,
                lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL,
                lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL: begin
                    illegal_write = 1'b0;
                end

                default: begin
                    illegal_write = 1'b1;
                end

            endcase
        end
    end

    // ============================================================
    // Threshold validation
    // For now, only checks that written FIFO thresholds are not
    // larger than FIFO_DEPTH.
    // ============================================================
    always_comb begin
        threshold_error = 1'b0;

        if (wr_en &&
            (
                addr == lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL ||
                addr == lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL
            )
        ) begin
            if (wr_data > DATA_WIDTH'(FIFO_DEPTH)) begin
                threshold_error = 1'b1;
            end
        end
    end

    assign access_error = illegal_addr || illegal_write || threshold_error;

    // ============================================================
    // Write logic
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg           <= '0;

            img_base_reg       <= DATA_WIDTH'(lab12_pkg::R_SRAM_BASE_ADDR);
            img_width_reg      <= DATA_WIDTH'(lab12_pkg::IMG_WIDTH);
            img_height_reg     <= DATA_WIDTH'(lab12_pkg::IMG_HEIGHT);

            fifo_ae_level_reg  <= DATA_WIDTH'(lab12_pkg::FIFO_AE_LEVEL);
            fifo_af_level_reg  <= DATA_WIDTH'(lab12_pkg::FIFO_AF_LEVEL);
            error_status_reg   <= '0;
            uart_error_cnt_reg <= '0;

            dma_wr_start       <= 1'b0;
            dma_rd_start       <= 1'b0;
            image_start_pulse  <= 1'b0;

            mac_soft_reset_pulse <= 1'b0;
        end
        else begin
            // Default: start pulse is one clock only
            dma_wr_start      <= 1'b0;
            dma_rd_start      <= 1'b0;
            image_start_pulse <= 1'b0;
            mac_soft_reset_pulse <= 1'b0;

            // Latch external FIFO error into ERROR_STATUS
            if (fifo_error) begin
                error_status_reg[lab12_pkg::RGF_ERROR_FIFO_ERROR_BIT] <= 1'b1;
            end

            // Latch DMA error into ERROR_STATUS
            if (dma_error) begin
                error_status_reg[lab12_pkg::RGF_ERROR_DMA_ERROR_BIT] <= 1'b1;
            end

            // LAB11: latch UART PHY errors and count faulty frames
            if (uart_parity_err) begin
                error_status_reg[lab12_pkg::RGF_ERROR_UART_PARITY_BIT] <= 1'b1;
            end

            if (uart_framing_err) begin
                error_status_reg[lab12_pkg::RGF_ERROR_UART_FRAMING_BIT] <= 1'b1;
            end

            if (uart_phy_error) begin
                uart_error_cnt_reg   <= uart_error_cnt_reg + DATA_WIDTH'(1);
                mac_soft_reset_pulse <= 1'b1;
            end

            if (wr_en) begin

                if (illegal_addr) begin
                    error_status_reg[lab12_pkg::RGF_ERROR_INVALID_ADDR_BIT] <= 1'b1;
                end

                else if (illegal_write || threshold_error) begin
                    error_status_reg[lab12_pkg::RGF_ERROR_ILLEGAL_WRITE_BIT] <= 1'b1;
                end

                else begin
                    unique case (addr)

                        lab12_pkg::RGF_ADDR_CTRL: begin
                            ctrl_reg <= wr_data;

                            if (wr_data[lab12_pkg::RGF_CTRL_DMA_RD_START_BIT]) begin
                                dma_rd_start      <= 1'b1;
                                image_start_pulse <= 1'b1;
                            end

                            if (wr_data[lab12_pkg::RGF_CTRL_DMA_WR_START_BIT]) begin
                                dma_wr_start <= 1'b1;
                            end
                        end

                        lab12_pkg::RGF_ADDR_IMG_BASE: begin
                            img_base_reg <= wr_data;
                        end

                        lab12_pkg::RGF_ADDR_IMG_WIDTH: begin
                            img_width_reg <= wr_data;
                        end

                        lab12_pkg::RGF_ADDR_IMG_HEIGHT: begin
                            img_height_reg <= wr_data;
                        end

                        lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL: begin
                            fifo_ae_level_reg <= wr_data;
                        end

                        lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL: begin
                            fifo_af_level_reg <= wr_data;
                        end

                        default: begin
                            // Protected by illegal_write.
                        end

                    endcase
                end
            end
        end
    end

    // ============================================================
    // Read logic
    //
    // rd_valid is a one-cycle pulse for a legal read.
    // rd_data is registered.
    // error is asserted for one clock when an illegal read/write
    // access is detected.
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_data  <= '0;
            rd_valid <= 1'b0;
            error    <= 1'b0;
        end
        else begin
            rd_valid <= 1'b0;
            error    <= 1'b0;

            // Report write access errors as well
            if (wr_en && access_error) begin
                error <= 1'b1;
            end

            if (rd_en) begin
                if (illegal_addr) begin
                    rd_data  <= '0;
                    rd_valid <= 1'b0;
                    error    <= 1'b1;
                end
                else begin
                    rd_valid <= 1'b1;

                    unique case (addr)

                        lab12_pkg::RGF_ADDR_CTRL: begin
                            rd_data <= ctrl_reg;
                        end

                        lab12_pkg::RGF_ADDR_STATUS: begin
                            rd_data <= status_value;
                        end

                        lab12_pkg::RGF_ADDR_IMG_BASE: begin
                            rd_data <= img_base_reg;
                        end

                        lab12_pkg::RGF_ADDR_IMG_WIDTH: begin
                            rd_data <= img_width_reg;
                        end

                        lab12_pkg::RGF_ADDR_IMG_HEIGHT: begin
                            rd_data <= img_height_reg;
                        end

                        lab12_pkg::RGF_ADDR_WR_ROW_CNT: begin
                            rd_data <= DATA_WIDTH'(wr_row_cnt);
                        end

                        lab12_pkg::RGF_ADDR_WR_COL_CNT: begin
                            rd_data <= DATA_WIDTH'(wr_col_cnt);
                        end

                        lab12_pkg::RGF_ADDR_RD_ROW_CNT: begin
                            rd_data <= DATA_WIDTH'(rd_row_cnt);
                        end

                        lab12_pkg::RGF_ADDR_RD_COL_CNT: begin
                            rd_data <= DATA_WIDTH'(rd_col_cnt);
                        end

                        lab12_pkg::RGF_ADDR_FIFO_AE_LEVEL: begin
                            rd_data <= fifo_ae_level_reg;
                        end

                        lab12_pkg::RGF_ADDR_FIFO_AF_LEVEL: begin
                            rd_data <= fifo_af_level_reg;
                        end

                        lab12_pkg::RGF_ADDR_ERROR_STATUS: begin
                            rd_data <= error_status_reg;
                        end

                        lab12_pkg::RGF_ADDR_VERSION: begin
                            rd_data <= lab12_pkg::RGF_VERSION_VALUE;
                        end

                        lab12_pkg::RGF_ADDR_UART_ERROR_CNT: begin
                            rd_data <= uart_error_cnt_reg;
                        end

                        default: begin
                            rd_data  <= '0;
                            rd_valid <= 1'b0;
                            error    <= 1'b1;
                        end

                    endcase
                end
            end
        end
    end

    // ============================================================
    // Output assignments
    // ============================================================
    assign fifo_ae_level = fifo_ae_level_reg;
    assign fifo_af_level = fifo_af_level_reg;
    assign clk_sel       = ctrl_reg[lab12_pkg::RGF_CTRL_CLK_SEL_BIT];
    assign parity_enable = ctrl_reg[lab12_pkg::RGF_CTRL_PARITY_ENABLE_BIT];
    assign img_base   = img_base_reg[23:0];
    assign img_width  = img_width_reg[15:0];
    assign img_height = img_height_reg[15:0];

endmodule
