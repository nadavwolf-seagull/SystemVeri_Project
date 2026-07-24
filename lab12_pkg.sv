`timescale 1ns / 1ps
package lab12_pkg;

    // ============================================================
    // BOARD / SYSTEM CLOCK
    // ============================================================
    parameter int unsigned SYS_CLK_FREQ_HZ = 100_000_000;

    // ============================================================
    // SYSTEM / UART CLOCK
    // ============================================================

    parameter int unsigned UART_CLK_FREQ_HZ = 256_000_000;

    parameter int unsigned UART_BAUD_RATE    = 8_000_000;
    parameter int unsigned UART_CLKS_PER_BIT = 32;
    // ============================================================
    // IMAGE
    // ============================================================
    parameter int unsigned IMG_WIDTH  = 256;
    parameter int unsigned IMG_HEIGHT = 256;

    parameter int unsigned ROW_WIDTH  = 10;
    parameter int unsigned COL_WIDTH  = 10;

    // ============================================================
    // RGB SRAM BANKS
    // ============================================================
    parameter int unsigned ROM_WORD_WIDTH = 32;
    parameter int unsigned ROM_DEPTH      = 16_384;
    parameter int unsigned ROM_ADDR_WIDTH = 14;

    parameter string RED_INIT_FILE   = "red_hex.mem";
    parameter string GREEN_INIT_FILE = "green_hex.mem";
    parameter string BLUE_INIT_FILE  = "blue_hex.mem";

    // ============================================================
    // PIXEL FORMAT
    // ============================================================
    parameter int unsigned CHANNEL_WIDTH = 8;
    parameter int unsigned PIXEL_WIDTH   = 24;

    // ============================================================
    // UART TX IMAGE PACKET
    // ============================================================
    parameter int unsigned COORD_FIELD_WIDTH = 24;

    // Row    = 24 bits
    // Column = 24 bits
    // Pixel  = 24 bits
    parameter int unsigned TX_PACKET_WIDTH =
        (2 * COORD_FIELD_WIDTH) + PIXEL_WIDTH;

    parameter int unsigned TX_PACKET_BYTES =
        TX_PACKET_WIDTH / 8;

    // ============================================================
    // FINAL-PROJECT UART TX PACKET
    // ============================================================

    // A group of four RGB pixels contains 12 bytes:
    // R0,G0,B0 ... R3,G3,B3.
    parameter int unsigned UART_TX_MAX_PACKET_BYTES = 12;
    parameter int unsigned UART_TX_MAX_PACKET_WIDTH =
        UART_TX_MAX_PACKET_BYTES * 8;

    parameter int unsigned UART_TX_PACKET_LEN_WIDTH =
        $clog2(UART_TX_MAX_PACKET_BYTES + 1);

    // ============================================================
    // UART RX / COMMAND PARSER
    // ============================================================

    /*
     * Lab 12 messages are longer than the Lab 11 commands.
     *
     * Examples:
     * Register write:
     *   {W<AAA>,V<HHHH>,V<LLLL>}
     *
     * Register read:
     *   {R<AAA>}
     *
     * Pixel write:
     *   {W<AAA>,P<RR,GG,BB>}
     *
     * Keep some margin for delimiters and future formatting changes.
     */
    // Longest expected Lab 12 command is under 48 ASCII bytes
    parameter int unsigned RX_MAX_FRAME_BYTES = 48;

    parameter int unsigned RX_FRAME_LEN_WIDTH =
        $clog2(RX_MAX_FRAME_BYTES + 1);

    // ============================================================
    // COMMAND TYPES
    // ============================================================

    /*
     * The parser identifies the semantic operation.
     *
     * Register operations are routed by BAR to the APB master.
     * Pixel operations are routed by BAR to the AHB-Lite master.
     * IMAGE_READ preserves the existing full-image command.
     */
    typedef enum logic [2:0] {
        RX_CMD_NOP          = 3'd0,
        RX_CMD_RGF_WRITE    = 3'd1,
        RX_CMD_RGF_READ     = 3'd2,
        RX_CMD_IMAGE_READ   = 3'd3,
        RX_CMD_PIXEL_WRITE  = 3'd4,
        RX_CMD_PIXEL_READ   = 3'd5,
        RX_CMD_IMAGE_WRITE  = 3'd6
    } rx_cmd_opcode_t;

    // ============================================================
    // ASCII CONSTANTS
    // ============================================================

    parameter logic [7:0] ASCII_LBRACE = 8'h7B; // {
    parameter logic [7:0] ASCII_RBRACE = 8'h7D; // }
    parameter logic [7:0] ASCII_LANGLE = 8'h3C; // <
    parameter logic [7:0] ASCII_RANGLE = 8'h3E; // >
    parameter logic [7:0] ASCII_COMMA  = 8'h2C; // ,

    parameter logic [7:0] ASCII_W      = 8'h57; // W
    parameter logic [7:0] ASCII_R      = 8'h52; // R
    parameter logic [7:0] ASCII_I      = 8'h49; // I
    parameter logic [7:0] ASCII_V      = 8'h56; // V
    parameter logic [7:0] ASCII_P      = 8'h50; // P
    parameter logic [7:0] ASCII_C      = 8'h43; // C

    // ============================================================
    // FIFO
    // ============================================================
    // Each FIFO entry holds four samples from one color channel.
    parameter int unsigned FIFO_WIDTH = PIXEL_WIDTH;
    parameter int unsigned RGB_FIFO_WIDTH = 32;
    parameter int unsigned FIFO_DEPTH = 32;

    parameter int unsigned FIFO_AE_LEVEL = 8;
    parameter int unsigned FIFO_AF_LEVEL = 8;

    parameter int unsigned FIFO_LEVEL_WIDTH = $clog2(FIFO_DEPTH + 1);

    // ============================================================
    // RGF PARAMETERS
    // ============================================================
    parameter int unsigned RGF_ADDR_WIDTH = 4;
    parameter int unsigned RGF_DATA_WIDTH = 32;

    // ============================================================
    // APB PARAMETERS
    // ============================================================
    parameter int unsigned APB_ADDR_WIDTH = RGF_ADDR_WIDTH;
    parameter int unsigned APB_DATA_WIDTH = RGF_DATA_WIDTH;
    parameter int unsigned APB_STRB_WIDTH = APB_DATA_WIDTH / 8;

    // ============================================================
    // AHB-LITE PARAMETERS
    // ============================================================

    /*
     * The UART command contains a 12-bit address.
     * Internally, the AHB interface is kept at 32 bits to follow
     * the conventional AHB-Lite signal widths.
     */
    parameter int unsigned AHB_ADDR_WIDTH = 32;
    parameter int unsigned AHB_DATA_WIDTH = 32;

    // HTRANS encodings
    parameter logic [1:0] AHB_HTRANS_IDLE   = 2'b00;
    parameter logic [1:0] AHB_HTRANS_BUSY   = 2'b01;
    parameter logic [1:0] AHB_HTRANS_NONSEQ = 2'b10;
    parameter logic [1:0] AHB_HTRANS_SEQ    = 2'b11;

    // Single-pixel accesses use SINGLE. Image DMA uses INCR4.
    parameter logic [2:0] AHB_HBURST_SINGLE = 3'b000;
    parameter logic [2:0] AHB_HBURST_INCR4  = 3'b011;

    /*
     * 32-bit transfer size.
     */
    parameter logic [2:0] AHB_HSIZE_WORD = 3'b010;

    /*
     * Basic data access attributes.
     */
    parameter logic [3:0] AHB_HPROT_DEFAULT = 4'b0011;

    // ============================================================
    // LAB 12 COMMAND ADDRESSING
    // ============================================================

    // Global 24-bit byte address.
    // Transmitted over UART as 6 ASCII hexadecimal characters, MSB first.
    parameter int unsigned CMD_ADDR_WIDTH       = 24;
    parameter int unsigned CMD_ADDR_ASCII_CHARS = 6;

    // 256x256 image = 65,536 pixels
    parameter int unsigned PIXEL_INDEX_WIDTH = 16;

    // Four pixels are packed in each 32-bit SRAM word
    parameter int unsigned PIXELS_PER_SRAM_WORD = 4;
    parameter int unsigned PIXEL_LANE_WIDTH =
        $clog2(PIXELS_PER_SRAM_WORD);

    // 32-bit AHB transfers are 4-byte aligned
    parameter int unsigned AHB_PIXEL_ADDR_SHIFT = 2;

    // RGB pixel payload: {R, G, B}
    parameter int unsigned CMD_PIXEL_WIDTH = 24;

    // Shared command data width
    parameter int unsigned CMD_DATA_WIDTH = 32;

    // ============================================================
    // FINAL-PROJECT GLOBAL ADDRESS MAP
    // ============================================================

    // BAR/RGF control region. The APB bridge uses the low address bits.
    parameter logic [AHB_ADDR_WIDTH-1:0] RGF_BASE_ADDR = 32'h0000_0000;
    parameter logic [AHB_ADDR_WIDTH-1:0] RGF_SIZE_BYTES = 32'h0000_1000;

    // Pixel alias: one 32-bit address per RGB pixel.
    // HWDATA/HRDATA format is {8'h00, R, G, B}.
    parameter logic [AHB_ADDR_WIDTH-1:0] PIXEL_ALIAS_BASE_ADDR = 32'h0010_0000;
    parameter logic [AHB_ADDR_WIDTH-1:0] PIXEL_ALIAS_SIZE_BYTES = 32'h0004_0000;

    // DMA channel windows: one 32-bit word contains four channel samples.
    parameter logic [AHB_ADDR_WIDTH-1:0] R_SRAM_BASE_ADDR = 32'h0020_0000;
    parameter logic [AHB_ADDR_WIDTH-1:0] G_SRAM_BASE_ADDR = 32'h0021_0000;
    parameter logic [AHB_ADDR_WIDTH-1:0] B_SRAM_BASE_ADDR = 32'h0022_0000;
    parameter logic [AHB_ADDR_WIDTH-1:0] CHANNEL_SRAM_SIZE_BYTES = 32'h0001_0000;
    // ============================================================
    // BAR TARGET SELECTION
    // ============================================================

    typedef enum logic [1:0] {
        BAR_TARGET_NONE = 2'd0,
        BAR_TARGET_APB  = 2'd1,
        BAR_TARGET_AHB  = 2'd2
    } bar_target_t;

    // ============================================================
    // RGF REGISTER ADDRESSES
    // ============================================================
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_CTRL           = 4'h0;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_STATUS         = 4'h1;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_IMG_WIDTH      = 4'h2;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_IMG_HEIGHT     = 4'h3;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_FIFO_AE_LEVEL  = 4'h4;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_FIFO_AF_LEVEL  = 4'h5;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_ERROR_STATUS   = 4'h6;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_VERSION        = 4'h7;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_UART_ERROR_CNT = 4'h8;

    // Final-project DMA configuration and progress registers
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_IMG_BASE       = 4'h9;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_WR_ROW_CNT     = 4'hA;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_WR_COL_CNT     = 4'hB;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_RD_ROW_CNT     = 4'hC;
    parameter logic [RGF_ADDR_WIDTH-1:0] RGF_ADDR_RD_COL_CNT     = 4'hD;

    // ============================================================
    // CTRL REGISTER BITS
    // ============================================================

    // Bit 0 preserves the previous image-start behavior and now starts
    // a DMA read operation from SRAM toward the UART TX path.
    parameter int unsigned RGF_CTRL_DMA_RD_START_BIT = 0;

    // Existing Lab 11 controls
    parameter int unsigned RGF_CTRL_CLK_SEL_BIT       = 1;
    parameter int unsigned RGF_CTRL_PARITY_ENABLE_BIT = 2;

    // Starts a DMA write operation from the UART RX path toward SRAM.
    parameter int unsigned RGF_CTRL_DMA_WR_START_BIT = 3;

    // Backward-compatible alias for existing modules during integration.
    parameter int unsigned RGF_CTRL_IMAGE_START_BIT =
        RGF_CTRL_DMA_RD_START_BIT;

    // ============================================================
    // STATUS REGISTER BITS
    // ============================================================
    parameter int unsigned RGF_STATUS_SEQ_BUSY_BIT    = 0;
    parameter int unsigned RGF_STATUS_IMAGE_DONE_BIT  = 1;
    parameter int unsigned RGF_STATUS_FIFO_EMPTY_BIT  = 2;
    parameter int unsigned RGF_STATUS_FIFO_FULL_BIT   = 3;
    parameter int unsigned RGF_STATUS_FIFO_ERROR_BIT  = 4;
    parameter int unsigned RGF_STATUS_UART_PARITY_ERR_BIT  = 5;
    parameter int unsigned RGF_STATUS_UART_FRAMING_ERR_BIT = 6;

    // ============================================================
    // ERROR_STATUS REGISTER BITS
    // ============================================================
    parameter int unsigned RGF_ERROR_INVALID_ADDR_BIT  = 0;
    parameter int unsigned RGF_ERROR_ILLEGAL_WRITE_BIT = 1;
    parameter int unsigned RGF_ERROR_FIFO_ERROR_BIT    = 2;
    parameter int unsigned RGF_ERROR_UART_PARITY_BIT  = 3;
    parameter int unsigned RGF_ERROR_UART_FRAMING_BIT = 4;
    parameter int unsigned RGF_ERROR_DMA_ERROR_BIT     = 5;
    // Set when a burst payload byte was lost to a PHY error and
    // replaced by a fill byte. The image completed but is not faithful.
    parameter int unsigned RGF_ERROR_IMAGE_CORRUPT_BIT = 6;
    // ============================================================
    // VERSION REGISTER
    // ============================================================
    parameter logic [RGF_DATA_WIDTH-1:0] RGF_VERSION_VALUE = 32'h0011_0001;


    parameter logic UART_PARITY_EN    = 1'b1;
    parameter logic UART_EVEN_PARITY  = 1'b1;

endpackage
