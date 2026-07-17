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


    // ============================================================
    // AHB Pixel Slave <-> RGB SRAM subsystem
    // ============================================================
    logic                       sram_bus_en;
    logic                       sram_bus_write;
    logic [ROM_ADDR_W-1:0]      sram_bus_addr;

    logic [ROM_WIDTH-1:0]       sram_r_wdata;
    logic [ROM_WIDTH-1:0]       sram_g_wdata;
    logic [ROM_WIDTH-1:0]       sram_b_wdata;

    logic [3:0]                 sram_byte_en;

    logic [ROM_WIDTH-1:0]       sram_r_rdata;
    logic [ROM_WIDTH-1:0]       sram_g_rdata;
    logic [ROM_WIDTH-1:0]       sram_b_rdata;

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

    // =========================================================
    // IMAGE START
    // =========================================================
    logic image_start_uart;
    logic image_start_img;

    assign uart_tx_busy     = packet_busy;
    assign image_start_uart = start | rgf_image_start_pulse;

    pulse_sync u_image_start_pulse_sync (
        .src_clk   (clk_uart),
        .src_rst_n (rst_uart_n),
        .src_pulse (image_start_uart),

        .dst_clk   (clk_img),
        .dst_rst_n (rst_img_n),
        .dst_pulse (image_start_img)
    );

    // =========================================================
    // FIFO THRESHOLDS
    // =========================================================
    logic [FIFO_LEVEL_W-1:0] ae_level;
    logic [FIFO_LEVEL_W-1:0] af_level;

    assign ae_level =
        rgf_fifo_ae_level[FIFO_LEVEL_W-1:0];

    assign af_level =
        rgf_fifo_af_level[FIFO_LEVEL_W-1:0];

    // =========================================================
    // IMAGE CLUSTER -> IMAGE COMPOSER
    // =========================================================
    logic fifo_pop_req;

    logic [FIFO_WIDTH-1:0]
        fifo_data_out;

    // =========================================================
    // IMAGE COMPOSER PACKET INTERFACE
    // =========================================================
    logic image_packet_valid;

    logic [PACKET_WIDTH-1:0]
        image_packet_data;

    logic image_packet_ready;
    logic image_packet_done;

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

    logic [PACKET_WIDTH-1:0]
        uart_packet_data;

    logic packet_ready;
    logic packet_done;

    /*
     * Control responses have priority over full-image packets.
     * Only the selected producer receives ready/done.
     */
    assign uart_packet_valid =
        control_packet_valid ?
        control_packet_valid :
        image_packet_valid;

    assign uart_packet_data =
        control_packet_valid ?
        control_packet_data :
        image_packet_data;

    assign control_packet_ready =
        packet_ready;

    assign image_packet_ready =
        packet_ready && !control_packet_valid;

    assign control_packet_done =
        packet_done && control_packet_valid;

    assign image_packet_done =
        packet_done && !control_packet_valid;

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

        .rx_byte         (),
        .rx_byte_valid   (),

        .frame_data      (rx_frame_data),
        .frame_len       (rx_frame_len),
        .frame_valid     (rx_frame_valid),

        .rx_framing_err  (rx_framing_err),
        .rx_parity_err   (rx_parity_err),
        .rx_frame_error  (rx_frame_error),
        .rx_busy         (uart_rx_busy)
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
    // INTERNAL AHB-LITE INTERFACE
    // =========================================================
    ahb_lite_if #(
        .ADDR_WIDTH (lab12_pkg::AHB_ADDR_WIDTH),
        .DATA_WIDTH (lab12_pkg::AHB_DATA_WIDTH)
    ) image_ahb (
        .HCLK    (clk_uart),
        .HRESETn (rst_uart_n)
    );

    // =========================================================
    // AHB-LITE MASTER
    // =========================================================
    ahb_master_fsm u_ahb_master_fsm (
        .clk             (clk_uart),
        .rst_n           (rst_uart_n),

        .cmd_valid       (ahb_cmd_valid),
        .cmd_ready       (ahb_cmd_ready),
        .cmd_write       (ahb_cmd_write),
        .cmd_addr        (ahb_cmd_addr),
        .cmd_data        (ahb_cmd_data),

        .rsp_valid       (ahb_rsp_valid),
        .rsp_ready       (ahb_rsp_ready),
        .rsp_addr        (ahb_rsp_addr),
        .rsp_data        (ahb_rsp_data),
        .rsp_error       (ahb_rsp_error),

        .ahb_error_pulse (ahb_error_pulse),

        .ahb             (image_ahb)
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
        .fifo_ae_level        (rgf_fifo_ae_level),
        .fifo_af_level        (rgf_fifo_af_level),

        .seq_busy             (seq_busy),
        .image_done           (image_tx_done),
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
    // AHB-LITE PIXEL SLAVE
    // =========================================================
    ahb_pixel_slave #(
        .HADDR_WIDTH (lab12_pkg::AHB_ADDR_WIDTH),
        .HDATA_WIDTH (lab12_pkg::AHB_DATA_WIDTH),
        .SRAM_ADDR_W (ROM_ADDR_W)
    ) u_ahb_pixel_slave (
        .HCLK           (clk_uart),
        .HRESETn        (rst_uart_n),

        // AHB Master -> Pixel Slave
        .HADDR          (image_ahb.HADDR),
        .HTRANS         (image_ahb.HTRANS),
        .HWRITE         (image_ahb.HWRITE),
        .HSIZE          (image_ahb.HSIZE),
        .HWDATA         (image_ahb.HWDATA),

        // Pixel Slave -> AHB Master
        .HRDATA         (image_ahb.HRDATA),
        .HREADY         (image_ahb.HREADY),
        .HRESP          (image_ahb.HRESP),

        // Pixel Slave -> RGB SRAM Port B
        .sram_bus_en    (sram_bus_en),
        .sram_bus_write (sram_bus_write),
        .sram_bus_addr  (sram_bus_addr),

        .sram_r_wdata   (sram_r_wdata),
        .sram_g_wdata   (sram_g_wdata),
        .sram_b_wdata   (sram_b_wdata),

        .sram_byte_en   (sram_byte_en),

        // RGB SRAM Port B -> Pixel Slave
        .sram_r_rdata   (sram_r_rdata),
        .sram_g_rdata   (sram_g_rdata),
        .sram_b_rdata   (sram_b_rdata)
    );
    // =========================================================
    // IMAGE CLUSTER
    // =========================================================
    seq_img_cluster #(
        .IMG_WIDTH       (IMG_WIDTH),
        .IMG_HEIGHT      (IMG_HEIGHT),

        .ROM_DEPTH       (ROM_DEPTH),
        .ROM_WIDTH       (ROM_WIDTH),
        .ROM_ADDR_W      (ROM_ADDR_W),

        .FIFO_WIDTH      (FIFO_WIDTH),
        .FIFO_DEPTH      (FIFO_DEPTH),

        .RED_INIT_FILE   (RED_INIT_FILE),
        .GREEN_INIT_FILE (GREEN_INIT_FILE),
        .BLUE_INIT_FILE  (BLUE_INIT_FILE)
    ) u_seq_img_cluster (
        .wr_clk   (clk_img),
        .wr_rst_n (rst_img_n),

        .rd_clk   (clk_uart),
        .rd_rst_n (rst_uart_n),

        .start    (image_start_img),

        .fifo_pop_req      (fifo_pop_req),

        .ae_level          (ae_level),
        .af_level          (af_level),

        .fifo_data_out     (fifo_data_out),

        .fifo_level        (fifo_level),
        .fifo_empty        (fifo_empty),
        .fifo_almost_empty (fifo_almost_empty),
        .fifo_half_full    (fifo_half_full),
        .fifo_almost_full  (fifo_almost_full),
        .fifo_full         (fifo_full),
        .fifo_error        (fifo_error),

        // AHB Pixel Slave -> SRAM Port B
        .sram_bus_en       (sram_bus_en),
        .sram_bus_write    (sram_bus_write),
        .sram_bus_addr     (sram_bus_addr),

        .sram_r_wdata      (sram_r_wdata),
        .sram_g_wdata      (sram_g_wdata),
        .sram_b_wdata      (sram_b_wdata),

        .sram_byte_en      (sram_byte_en),

        .sram_r_rdata      (sram_r_rdata),
        .sram_g_rdata      (sram_g_rdata),
        .sram_b_rdata      (sram_b_rdata),

        .row_cnt           (seq_row_cnt),
        .col_cnt           (seq_col_cnt),
        .transfer_done     (seq_transfer_done),
        .busy              (seq_busy),
        .rts               (rts)
    );

    // =========================================================
    // FULL-IMAGE MESSAGE COMPOSER
    // =========================================================
    message_composer #(
        .IMG_WIDTH         (IMG_WIDTH),
        .IMG_HEIGHT        (IMG_HEIGHT),

        .ROW_WIDTH         (lab12_pkg::ROW_WIDTH),
        .COL_WIDTH         (lab12_pkg::COL_WIDTH),

        .PIXEL_WIDTH       (FIFO_WIDTH),

        .COORD_FIELD_WIDTH (lab12_pkg::COORD_FIELD_WIDTH),
        .PACKET_WIDTH      (PACKET_WIDTH)
    ) u_message_composer (
        .sys_clk       (clk_uart),
        .rst_n         (rst_uart_n),

        .start         (image_start_uart),

        .fifo_empty    (fifo_empty),
        .fifo_data_out (fifo_data_out),
        .fifo_pop_req  (fifo_pop_req),

        .packet_ready  (image_packet_ready),
        .packet_done   (image_packet_done),

        .packet_valid  (image_packet_valid),
        .packet_data   (image_packet_data),

        .tx_row_cnt    (tx_row_cnt),
        .tx_col_cnt    (tx_col_cnt),

        .composer_busy (composer_busy),
        .image_tx_done (image_tx_done)
    );

    // =========================================================
    // UART TX
    // =========================================================
    uart_tx_top #(
        .PACKET_BYTES (PACKET_BYTES),
        .PACKET_WIDTH (PACKET_WIDTH),
        .CLKS_PER_BIT (CLKS_PER_BIT)
    ) u_uart_tx_top (
        .sys_clk      (clk_uart),
        .rst_n        (rst_uart_n),
        .tx_en        (tx_en),

        .cts_n        (cts_n),

        .packet_valid (uart_packet_valid),
        .packet_data  (uart_packet_data),
        .packet_ready (packet_ready),

        .packet_busy  (packet_busy),
        .packet_done  (packet_done),

        .TX           (TX)
    );

    // =========================================================
    // DEBUG ASSIGNMENTS
    // =========================================================
    assign rx_parse_error =
        parse_error;

    assign rx_classifier_error =
        classifier_error;

    assign rgf_error =
        rgf_error_int |
        apb_error_pulse |
        ahb_error_pulse |
        control_response_error;

    assign rx_parity_error_dbg =
        rx_parity_err;

    assign rx_framing_error_dbg =
        rx_framing_err;

endmodule : chip_top