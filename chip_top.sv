timeunit 1ns;
timeprecision 1ps;

module chip_top #(
    // =========================================================
    // IMAGE
    // =========================================================
    parameter int unsigned IMG_WIDTH =
        lab12_pkg::IMG_WIDTH,

    parameter int unsigned IMG_HEIGHT =
        lab12_pkg::IMG_HEIGHT,

    // =========================================================
    // RGB MEMORIES
    // =========================================================
    parameter int unsigned ROM_DEPTH =
        lab12_pkg::ROM_DEPTH,

    parameter int unsigned ROM_WIDTH =
        lab12_pkg::ROM_WORD_WIDTH,

    parameter int unsigned ROM_ADDR_W =
        lab12_pkg::ROM_ADDR_WIDTH,

    parameter string RED_INIT_FILE =
        lab12_pkg::RED_INIT_FILE,

    parameter string GREEN_INIT_FILE =
        lab12_pkg::GREEN_INIT_FILE,

    parameter string BLUE_INIT_FILE =
        lab12_pkg::BLUE_INIT_FILE,

    // =========================================================
    // FIFO
    // =========================================================
    parameter int unsigned FIFO_WIDTH =
        lab12_pkg::FIFO_WIDTH,

    parameter int unsigned FIFO_DEPTH =
        lab12_pkg::FIFO_DEPTH,

    parameter int unsigned FIFO_AE_LEVEL =
        lab12_pkg::FIFO_AE_LEVEL,

    parameter int unsigned FIFO_AF_LEVEL =
        lab12_pkg::FIFO_AF_LEVEL,

    // =========================================================
    // UART TX
    // =========================================================
    parameter int unsigned PACKET_BYTES =
        lab12_pkg::TX_PACKET_BYTES,

    parameter int unsigned PACKET_WIDTH =
        lab12_pkg::TX_PACKET_WIDTH,

    parameter int unsigned CLKS_PER_BIT =
        lab12_pkg::UART_CLKS_PER_BIT,

    // =========================================================
    // UART RX
    // =========================================================
    parameter int unsigned RX_MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES
) (
    // Control path clock/reset
    input logic clk_ctrl,
    input logic rst_ctrl_n,

    // Image path clock/reset
    input logic clk_img,
    input logic rst_img_n,

    // UART, APB and AHB clock/reset
    input logic clk_uart,
    input logic rst_uart_n,

    // Manual image-start input
    input logic start,

    // UART
    input  logic RX,
    input  logic tx_en,
    input  logic cts_n,
    output logic TX,

    // Sequencer status
    output logic rts,

    // Legacy RGF output retained temporarily.
    // Lab 12 clock selection is controlled by PLL lock.
    output logic clk_sel,

    // =========================================================
    // DEBUG / MONITOR OUTPUTS
    // =========================================================
    output logic seq_transfer_done,
    output logic image_tx_done,

    output logic seq_busy,
    output logic composer_busy,
    output logic packet_busy,

    output logic [$clog2(FIFO_DEPTH+1)-1:0] fifo_level,
    output logic fifo_empty,
    output logic fifo_almost_empty,
    output logic fifo_half_full,
    output logic fifo_almost_full,
    output logic fifo_full,
    output logic fifo_error,

    output logic [9:0] seq_row_cnt,
    output logic [9:0] seq_col_cnt,

    output logic [lab12_pkg::ROW_WIDTH-1:0] tx_row_cnt,
    output logic [lab12_pkg::COL_WIDTH-1:0] tx_col_cnt,

    output logic rx_frame_valid,
    output logic rx_parse_error,
    output logic rx_classifier_error,
    output logic rgf_error,
    output logic rx_parity_error_dbg,
    output logic rx_framing_error_dbg,
    output logic parity_enable_dbg,

    output logic uart_rx_busy,
    output logic uart_tx_busy
);

    // =========================================================
    // LOCAL CONSTANTS
    // =========================================================
    localparam int unsigned FIFO_LEVEL_W =
        $clog2(FIFO_DEPTH + 1);

    // =========================================================
    // RX TOP -> PARSER
    // =========================================================
    logic [RX_MAX_FRAME_BYTES*8-1:0] rx_frame_data;

    logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0]
        rx_frame_len;

    logic rx_frame_error;
    logic rx_framing_err;
    logic rx_parity_err;
    logic [7:0] uart_rx_byte;
    logic       uart_rx_byte_valid;

    // =========================================================
    // PARSER -> CLASSIFIER
    // =========================================================
    logic parsed_valid;

    lab12_pkg::rx_cmd_opcode_t parsed_opcode;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        parsed_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        parsed_data;

    logic parse_error;

    // =========================================================
    // CLASSIFIER -> BAR
    // =========================================================
    logic cmd_valid;
    logic cmd_ready;

    lab12_pkg::rx_cmd_opcode_t cmd_opcode;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        cmd_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        cmd_data;

    logic classifier_error;

    // =========================================================
    // BAR -> APB MASTER
    // =========================================================
    logic apb_cmd_valid;
    logic apb_cmd_ready;

    lab12_pkg::rx_cmd_opcode_t apb_cmd_opcode;

    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]
        apb_cmd_addr;

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        apb_cmd_data;

    // =========================================================
    // APB MASTER -> BAR
    // =========================================================
    logic apb_rsp_valid;
    logic apb_rsp_ready;

    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]
        apb_rsp_addr;

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        apb_rsp_data;

    logic apb_rsp_error;
    logic apb_error_pulse;

    // =========================================================
    // BAR -> AHB MASTER
    // =========================================================
    logic ahb_cmd_valid;
    logic ahb_cmd_ready;
    logic ahb_cmd_write;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        ahb_cmd_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        ahb_cmd_data;

    // =========================================================
    // AHB MASTER -> BAR
    // =========================================================
    logic ahb_rsp_valid;
    logic ahb_rsp_ready;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        ahb_rsp_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        ahb_rsp_data;

    logic ahb_rsp_error;
    logic ahb_error_pulse;

    // =========================================================
    // BAR -> CONTROL RESPONSE COMPOSER
    // =========================================================
    logic bar_rsp_valid;
    logic bar_rsp_ready;

    lab12_pkg::bar_target_t bar_rsp_source;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        bar_rsp_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        bar_rsp_data;

    logic bar_rsp_error;

    // =========================================================
    // APB INTERFACE
    // =========================================================
    apb_if #(
        .ADDR_WIDTH (lab12_pkg::APB_ADDR_WIDTH),
        .DATA_WIDTH (lab12_pkg::APB_DATA_WIDTH)
    ) rgf_apb_if (
        .PCLK    (clk_uart),
        .PRESETn (rst_uart_n)
    );


    // =========================================================
    // RGF CONTROL / STATUS
    // =========================================================
    logic rgf_error_int;
    logic rgf_image_start_pulse;

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        rgf_fifo_ae_level;

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        rgf_fifo_af_level;

    logic mac_soft_reset_pulse;
    logic        rgf_dma_wr_start;
    logic        rgf_dma_rd_start;
    logic [23:0] rgf_img_base;
    logic [15:0] rgf_img_width;
    logic [15:0] rgf_img_height;
    logic        dma_busy;
    logic        dma_done;
    logic        dma_error;

    logic [15:0] dma_wr_row_cnt;
    logic [15:0] dma_wr_col_cnt;
    logic [15:0] dma_rd_row_cnt;
    logic [15:0] dma_rd_col_cnt;

    logic        dma_rx_push_fast;
    logic [31:0] dma_rx_r_data_fast;
    logic [31:0] dma_rx_g_data_fast;
    logic [31:0] dma_rx_b_data_fast;
    logic        dma_rx_ready_fast;

    logic [31:0] dma_tx_r_data_fast;
    logic [31:0] dma_tx_g_data_fast;
    logic [31:0] dma_tx_b_data_fast;

    logic        dma_tx_pop_fast;
    logic        dma_tx_data_valid_fast;
    logic        dma_tx_empty_fast;
    logic        dma_tx_underflow_fast;

    logic        dma_rx_almost_full_fast;
    logic        dma_rx_overflow_fast;
    logic        dma_rx_underflow_sys;
    logic        dma_tx_overflow_sys;

    logic [FIFO_LEVEL_W-1:0] dma_rx_af_free_level_fast;
    logic [FIFO_LEVEL_W-1:0] dma_tx_ae_level_fast;
    logic [FIFO_LEVEL_W-1:0] dma_rx_ae_level_sys;
    logic [FIFO_LEVEL_W-1:0] dma_tx_af_free_level_sys;

    logic        image_payload_active;
    logic        image_payload_ready;
    logic        image_payload_done;
    logic        image_payload_error;

    assign uart_tx_busy = packet_busy;


    // =========================================================
    // FIFO THRESHOLDS
    // =========================================================
    logic [FIFO_LEVEL_W-1:0] ae_level;
    logic [FIFO_LEVEL_W-1:0] af_level;

    assign ae_level =
        rgf_fifo_ae_level[FIFO_LEVEL_W-1:0];

    assign af_level =
        rgf_fifo_af_level[FIFO_LEVEL_W-1:0];

    assign dma_rx_af_free_level_fast = af_level;
    assign dma_tx_ae_level_fast      = ae_level;
    assign dma_rx_ae_level_sys       = ae_level;
    assign dma_tx_af_free_level_sys  = af_level;


    // =========================================================
    // DMA IMAGE BURST PACKET INTERFACE
    // =========================================================
    logic burst_packet_valid;

    logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0]
        burst_packet_data;

    logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0]
        burst_packet_len;

    logic burst_packet_ready;
    logic burst_packet_done;

    logic burst_tx_active;
    logic burst_tx_done;
    logic burst_tx_error;

    // =========================================================
    // CONTROL RESPONSE PACKET INTERFACE
    // =========================================================
    logic control_packet_valid;

    logic [PACKET_WIDTH-1:0]
        control_packet_data;

    logic control_packet_ready;
    logic control_packet_done;

    logic control_response_busy;
    logic control_response_error;

    // =========================================================
    // UART PACKET INTERFACE
    // =========================================================
    logic uart_packet_valid;

    logic [lab12_pkg::UART_TX_MAX_PACKET_WIDTH-1:0]
        uart_packet_data;

    logic [lab12_pkg::UART_TX_PACKET_LEN_WIDTH-1:0]
        uart_packet_len;

    logic packet_ready;
    logic packet_done;

    logic uart_owner_control;

    /*
     * Control responses have priority over DMA image bursts.
     * The legacy image composer is disconnected from UART and will
     * be removed together with the old image path.
     */
    assign uart_packet_valid =
        control_packet_valid ||
        burst_packet_valid;

    assign uart_packet_data =
        control_packet_valid ?
        {control_packet_data, 24'h000000} :
        burst_packet_data;

    assign uart_packet_len =
        control_packet_valid ?
        lab12_pkg::UART_TX_PACKET_LEN_WIDTH'(
            lab12_pkg::TX_PACKET_BYTES
        ) :
        burst_packet_len;

    assign control_packet_ready =
        packet_ready;

    assign burst_packet_ready =
        packet_ready &&
        !control_packet_valid;

    assign control_packet_done =
        packet_done &&
        uart_owner_control;

    assign burst_packet_done =
        packet_done &&
        !uart_owner_control;

    /*
     * Remember which producer won the UART handshake. The producer
     * may lower packet_valid before packet_done is asserted.
     */
    always_ff @(posedge clk_uart or negedge rst_uart_n) begin
        if (!rst_uart_n) begin
            uart_owner_control <= 1'b0;
        end
        else if (uart_packet_valid && packet_ready) begin
            uart_owner_control <= control_packet_valid;
        end
    end

    // =========================================================
    // UART RX TOP
    // =========================================================
    uart_rx_top #(
        .CLK_FREQ_HZ     (lab12_pkg::UART_CLK_FREQ_HZ),
        .BAUD            (lab12_pkg::UART_BAUD_RATE),
        .MAX_FRAME_BYTES (RX_MAX_FRAME_BYTES)
    ) u_uart_rx_top (
        .clk             (clk_uart),
        .rst_n           (rst_uart_n),

        .rx              (RX),
        .soft_reset      (mac_soft_reset_pulse),

        .rx_byte         (uart_rx_byte),
        .rx_byte_valid   (uart_rx_byte_valid),

        .frame_data      (rx_frame_data),
        .frame_len       (rx_frame_len),
        .frame_valid     (rx_frame_valid),

        .rx_framing_err  (rx_framing_err),
        .rx_parity_err   (rx_parity_err),
        .rx_frame_error  (rx_frame_error),
        .rx_busy         (uart_rx_busy)
    );

    // =========================================================
    // IMAGE BURST RX DEINTERLEAVER
    // =========================================================
    image_burst_rx_deinterleaver u_image_burst_rx_deinterleaver (
        .clk            (clk_uart),
        .rst_n          (rst_uart_n),

        .start          (rgf_dma_wr_start),
        .img_width      (rgf_img_width),
        .img_height     (rgf_img_height),

        .rx_byte        (uart_rx_byte),
        .rx_byte_valid  (
            uart_rx_byte_valid &&
            image_payload_active
        ),

        .fifo_ready     (dma_rx_ready_fast),

        .fifo_push      (dma_rx_push_fast),
        .fifo_r_data    (dma_rx_r_data_fast),
        .fifo_g_data    (dma_rx_g_data_fast),
        .fifo_b_data    (dma_rx_b_data_fast),

        .payload_active (image_payload_active),
        .payload_ready  (image_payload_ready),
        .payload_done   (image_payload_done),
        .payload_error  (image_payload_error)
    );

    // =========================================================
    // IMAGE BURST TX PACKER
    // =========================================================
    image_burst_tx_packer u_image_burst_tx_packer (
        .clk             (clk_uart),
        .rst_n           (rst_uart_n),

        .start           (rgf_dma_rd_start),
        .img_width       (rgf_img_width),
        .img_height      (rgf_img_height),

        .fifo_pop        (dma_tx_pop_fast),
        .fifo_r_data     (dma_tx_r_data_fast),
        .fifo_g_data     (dma_tx_g_data_fast),
        .fifo_b_data     (dma_tx_b_data_fast),
        .fifo_data_valid (dma_tx_data_valid_fast),
        .fifo_empty      (dma_tx_empty_fast),

        .packet_valid    (burst_packet_valid),
        .packet_data     (burst_packet_data),
        .packet_len      (burst_packet_len),
        .packet_ready    (burst_packet_ready),
        .packet_done     (burst_packet_done),

        .active          (burst_tx_active),
        .done            (burst_tx_done),
        .error           (burst_tx_error)
    );

    // =========================================================
    // RX PARSER
    // =========================================================
    rx_parser #(
        .MAX_FRAME_BYTES (RX_MAX_FRAME_BYTES)
    ) u_rx_parser (
        .frame_data    (rx_frame_data),
        .frame_len     (rx_frame_len),
        .frame_valid   (rx_frame_valid),
        .frame_error   (rx_frame_error),

        .parsed_valid  (parsed_valid),
        .parsed_opcode (parsed_opcode),
        .parsed_addr   (parsed_addr),
        .parsed_data   (parsed_data),
        .parse_error   (parse_error)
    );

    // =========================================================
    // RX CLASSIFIER
    // =========================================================
    rx_classifier u_rx_classifier (
        .clk              (clk_uart),
        .rst_n            (rst_uart_n),

        .parsed_valid     (parsed_valid),
        .parsed_opcode    (parsed_opcode),
        .parsed_addr      (parsed_addr),
        .parsed_data      (parsed_data),
        .parse_error      (parse_error),

        .cmd_ready        (cmd_ready),

        .cmd_valid        (cmd_valid),
        .cmd_opcode       (cmd_opcode),
        .cmd_addr         (cmd_addr),
        .cmd_data         (cmd_data),

        .classifier_error (classifier_error)
    );

    // =========================================================
    // BUS ACCESS ROUTER
    // =========================================================
    bar u_bar (
        .clk             (clk_uart),
        .rst_n           (rst_uart_n),

        .cmd_valid       (cmd_valid),
        .cmd_ready       (cmd_ready),
        .cmd_opcode      (cmd_opcode),
        .cmd_addr        (cmd_addr),
        .cmd_data        (cmd_data),

        .apb_cmd_valid   (apb_cmd_valid),
        .apb_cmd_ready   (apb_cmd_ready),
        .apb_cmd_opcode  (apb_cmd_opcode),
        .apb_cmd_addr    (apb_cmd_addr),
        .apb_cmd_data    (apb_cmd_data),

        .apb_rsp_valid   (apb_rsp_valid),
        .apb_rsp_ready   (apb_rsp_ready),
        .apb_rsp_addr    (apb_rsp_addr),
        .apb_rsp_data    (apb_rsp_data),
        .apb_rsp_error   (apb_rsp_error),

        .ahb_cmd_valid   (ahb_cmd_valid),
        .ahb_cmd_ready   (ahb_cmd_ready),
        .ahb_cmd_write   (ahb_cmd_write),
        .ahb_cmd_addr    (ahb_cmd_addr),
        .ahb_cmd_data    (ahb_cmd_data),

        .ahb_rsp_valid   (ahb_rsp_valid),
        .ahb_rsp_ready   (ahb_rsp_ready),
        .ahb_rsp_addr    (ahb_rsp_addr),
        .ahb_rsp_data    (ahb_rsp_data),
        .ahb_rsp_error   (ahb_rsp_error),

        .rsp_valid       (bar_rsp_valid),
        .rsp_ready       (bar_rsp_ready),
        .rsp_source      (bar_rsp_source),
        .rsp_addr        (bar_rsp_addr),
        .rsp_data        (bar_rsp_data),
        .rsp_error       (bar_rsp_error)
    );

    // =========================================================
    // APB MASTER
    // =========================================================
    apb_master_fsm u_apb_master_fsm (
        .clk             (clk_uart),
        .rst_n           (rst_uart_n),

        .cmd_valid       (apb_cmd_valid),
        .cmd_ready       (apb_cmd_ready),
        .cmd_opcode      (apb_cmd_opcode),
        .cmd_addr        (apb_cmd_addr),
        .cmd_data        (apb_cmd_data),

        .rsp_valid       (apb_rsp_valid),
        .rsp_ready       (apb_rsp_ready),
        .rsp_addr        (apb_rsp_addr),
        .rsp_data        (apb_rsp_data),
        .rsp_error       (apb_rsp_error),

        .apb_error_pulse (apb_error_pulse),

        .apb             (rgf_apb_if)
    );

    // =========================================================
    // FINAL-PROJECT DMA / MEMORY CLUSTER
    // =========================================================
    final_project_dma_cluster #(
        .FIFO_DEPTH (FIFO_DEPTH)
    ) u_final_project_dma_cluster (
        .clk_fast              (clk_uart),
        .rst_fast_n            (rst_uart_n),
        .clk_sys               (clk_ctrl),
        .rst_sys_n             (rst_ctrl_n),

        .dma_wr_start          (rgf_dma_wr_start),
        .dma_rd_start          (rgf_dma_rd_start),
        .img_base              (rgf_img_base),
        .img_width             (rgf_img_width),
        .img_height            (rgf_img_height),
        .dma_busy              (dma_busy),
        .dma_done              (dma_done),
        .dma_error             (dma_error),
        .wr_row_cnt            (dma_wr_row_cnt),
        .wr_col_cnt            (dma_wr_col_cnt),
        .rd_row_cnt            (dma_rd_row_cnt),
        .rd_col_cnt            (dma_rd_col_cnt),

        .bar_cmd_valid         (ahb_cmd_valid),
        .bar_cmd_ready         (ahb_cmd_ready),
        .bar_cmd_write         (ahb_cmd_write),
        .bar_cmd_addr          (ahb_cmd_addr),
        .bar_cmd_data          (ahb_cmd_data),
        .bar_rsp_valid         (ahb_rsp_valid),
        .bar_rsp_ready         (ahb_rsp_ready),
        .bar_rsp_addr          (ahb_rsp_addr),
        .bar_rsp_data          (ahb_rsp_data),
        .bar_rsp_error         (ahb_rsp_error),
        .ahb_error_pulse       (ahb_error_pulse),

        .rx_push_fast          (dma_rx_push_fast),
        .rx_r_data_fast        (dma_rx_r_data_fast),
        .rx_g_data_fast        (dma_rx_g_data_fast),
        .rx_b_data_fast        (dma_rx_b_data_fast),
        .rx_af_free_level_fast (dma_rx_af_free_level_fast),
        .rx_ready_fast         (dma_rx_ready_fast),
        .rx_almost_full_fast   (dma_rx_almost_full_fast),
        .rx_overflow_fast      (dma_rx_overflow_fast),

        .tx_pop_fast           (dma_tx_pop_fast),
        .tx_ae_level_fast      (dma_tx_ae_level_fast),
        .tx_r_data_fast        (dma_tx_r_data_fast),
        .tx_g_data_fast        (dma_tx_g_data_fast),
        .tx_b_data_fast        (dma_tx_b_data_fast),
        .tx_data_valid_fast    (dma_tx_data_valid_fast),
        .tx_empty_fast         (dma_tx_empty_fast),
        .tx_underflow_fast     (dma_tx_underflow_fast),

        .rx_ae_level_sys       (dma_rx_ae_level_sys),
        .tx_af_free_level_sys  (dma_tx_af_free_level_sys),
        .rx_underflow_sys      (dma_rx_underflow_sys),
        .tx_overflow_sys       (dma_tx_overflow_sys)
    );


    // =========================================================
    // APB RGF SLAVE
    // =========================================================
    apb_rgf_slave #(
        .ADDR_WIDTH (lab12_pkg::APB_ADDR_WIDTH),
        .DATA_WIDTH (lab12_pkg::APB_DATA_WIDTH),
        .FIFO_DEPTH (FIFO_DEPTH)
    ) u_apb_rgf_slave (
        .clk                  (clk_uart),
        .rst_n                (rst_uart_n),

        .apb                  (rgf_apb_if),

        .image_start_pulse    (rgf_image_start_pulse),
        .dma_wr_start         (rgf_dma_wr_start),
        .dma_rd_start         (rgf_dma_rd_start),
        .img_base             (rgf_img_base),
        .img_width            (rgf_img_width),
        .img_height           (rgf_img_height),
        .fifo_ae_level        (rgf_fifo_ae_level),
        .fifo_af_level        (rgf_fifo_af_level),

        .dma_busy             (dma_busy),
        .dma_done             (dma_done),
        .dma_error            (dma_error),

        .wr_row_cnt           (dma_wr_row_cnt),
        .wr_col_cnt           (dma_wr_col_cnt),
        .rd_row_cnt           (dma_rd_row_cnt),
        .rd_col_cnt           (dma_rd_col_cnt),
        .fifo_empty           (fifo_empty),
        .fifo_full            (fifo_full),
        .fifo_error           (fifo_error),

        .uart_parity_err      (rx_parity_err),
        .uart_framing_err     (rx_framing_err),

        .clk_sel              (clk_sel),
        .parity_enable        (parity_enable_dbg),
        .mac_soft_reset_pulse (mac_soft_reset_pulse),

        .rgf_error            (rgf_error_int)
    );

    // =========================================================
    // CONTROL RESPONSE COMPOSER
    // =========================================================
    control_response_composer #(
        .PACKET_WIDTH   (PACKET_WIDTH),
        .CMD_ADDR_WIDTH (lab12_pkg::CMD_ADDR_WIDTH),
        .CMD_DATA_WIDTH (lab12_pkg::CMD_DATA_WIDTH)
    ) u_control_response_composer (
        .clk            (clk_uart),
        .rst_n          (rst_uart_n),

        .rsp_valid      (bar_rsp_valid),
        .rsp_ready      (bar_rsp_ready),
        .rsp_source     (bar_rsp_source),
        .rsp_addr       (bar_rsp_addr),
        .rsp_data       (bar_rsp_data),
        .rsp_error      (bar_rsp_error),

        .packet_valid   (control_packet_valid),
        .packet_data    (control_packet_data),
        .packet_ready   (control_packet_ready),
        .packet_done    (control_packet_done),

        .response_busy  (control_response_busy),
        .response_error (control_response_error)
    );


    // =========================================================
    // UART TX
    // =========================================================
    uart_tx_top #(
        .MAX_PACKET_BYTES (
            lab12_pkg::UART_TX_MAX_PACKET_BYTES
        ),
        .MAX_PACKET_WIDTH (
            lab12_pkg::UART_TX_MAX_PACKET_WIDTH
        ),
        .PACKET_LEN_WIDTH (
            lab12_pkg::UART_TX_PACKET_LEN_WIDTH
        ),
        .CLKS_PER_BIT (CLKS_PER_BIT)
    ) u_uart_tx_top (
        .sys_clk      (clk_uart),
        .rst_n        (rst_uart_n),
        .tx_en        (tx_en),

        .cts_n        (cts_n),

        .packet_valid (uart_packet_valid),
        .packet_data  (uart_packet_data),
        .packet_len   (uart_packet_len),
        .packet_ready (packet_ready),

        .packet_busy  (packet_busy),
        .packet_done  (packet_done),

        .TX           (TX)
    );

    // =========================================================
    // DEBUG ASSIGNMENTS
    // =========================================================
    // Legacy top-level debug ports are mapped to the final-project
    // DMA and FIFO-bank status signals.
    assign seq_transfer_done = dma_done;
    assign image_tx_done     = burst_tx_done;
    assign seq_busy          = dma_busy;
    assign composer_busy     = burst_tx_active;

    assign fifo_level        = '0;
    assign fifo_empty        = dma_tx_empty_fast;
    assign fifo_almost_empty = dma_tx_empty_fast;
    assign fifo_half_full    = 1'b0;
    assign fifo_almost_full  = dma_rx_almost_full_fast;
    assign fifo_full         = !dma_rx_ready_fast;
    assign fifo_error        =
        dma_rx_overflow_fast  |
        dma_rx_underflow_sys  |
        dma_tx_overflow_sys   |
        dma_tx_underflow_fast |
        image_payload_error   |
        burst_tx_error;

    assign seq_row_cnt = dma_wr_row_cnt[9:0];
    assign seq_col_cnt = dma_wr_col_cnt[9:0];
    assign tx_row_cnt  = dma_rd_row_cnt[lab12_pkg::ROW_WIDTH-1:0];
    assign tx_col_cnt  = dma_rd_col_cnt[lab12_pkg::COL_WIDTH-1:0];

    // RTS is active-low at board level: 0 means the FPGA can receive.
    assign rts = image_payload_active && !image_payload_ready;
    assign rx_parse_error =
        parse_error;

    assign rx_classifier_error =
        classifier_error;

    assign rgf_error =
        rgf_error_int |
        apb_error_pulse |
        ahb_error_pulse |
        control_response_error |
        fifo_error;

    assign rx_parity_error_dbg =
        rx_parity_err;

    assign rx_framing_error_dbg =
        rx_framing_err;

endmodule : chip_top
