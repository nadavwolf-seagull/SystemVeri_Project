`timescale 1ns / 1ps

// AHB-Lite subordinate for the RGB image SRAM.
//
// Address regions:
//   PIXEL_ALIAS_BASE_ADDR : one packed RGB pixel per 32-bit address
//   R/G/B_SRAM_BASE_ADDR  : channel words used by the DMA INCR4 bursts
//
// The subordinate inserts one access wait state for the synchronous SRAM.
module ahb_rgb_sram_slave #(
    parameter int unsigned HADDR_WIDTH = lab12_pkg::AHB_ADDR_WIDTH,
    parameter int unsigned HDATA_WIDTH = lab12_pkg::AHB_DATA_WIDTH,
    parameter int unsigned SRAM_ADDR_W = lab12_pkg::ROM_ADDR_WIDTH,

    parameter logic [HADDR_WIDTH-1:0] PIXEL_BASE = lab12_pkg::PIXEL_ALIAS_BASE_ADDR,
    parameter logic [HADDR_WIDTH-1:0] PIXEL_SIZE = lab12_pkg::PIXEL_ALIAS_SIZE_BYTES,
    parameter logic [HADDR_WIDTH-1:0] R_BASE = lab12_pkg::R_SRAM_BASE_ADDR,
    parameter logic [HADDR_WIDTH-1:0] G_BASE = lab12_pkg::G_SRAM_BASE_ADDR,
    parameter logic [HADDR_WIDTH-1:0] B_BASE = lab12_pkg::B_SRAM_BASE_ADDR,
    parameter logic [HADDR_WIDTH-1:0] CHANNEL_SIZE = lab12_pkg::CHANNEL_SRAM_SIZE_BYTES
) (
    input  logic                    HCLK,
    input  logic                    HRESETn,

    input  logic [HADDR_WIDTH-1:0]  HADDR,
    input  logic [1:0]              HTRANS,
    input  logic                    HWRITE,
    input  logic [2:0]              HSIZE,
    input  logic [2:0]              HBURST,
    input  logic [HDATA_WIDTH-1:0]  HWDATA,

    output logic [HDATA_WIDTH-1:0]  HRDATA,
    output logic                    HREADY,
    output logic                    HRESP,

    output logic                    sram_en,
    output logic                    sram_write,
    output logic [2:0]              sram_bank_en,
    output logic [SRAM_ADDR_W-1:0]  sram_addr,
    output logic [3:0]              sram_byte_en,
    output logic [31:0]             sram_r_wdata,
    output logic [31:0]             sram_g_wdata,
    output logic [31:0]             sram_b_wdata,

    input  logic [31:0]             sram_r_rdata,
    input  logic [31:0]             sram_g_rdata,
    input  logic [31:0]             sram_b_rdata
);

    typedef enum logic [1:0] {
        ST_IDLE,
        ST_ACCESS,
        ST_RESPONSE
    } state_t;

    typedef enum logic [2:0] {
        REGION_NONE,
        REGION_PIXEL,
        REGION_R,
        REGION_G,
        REGION_B
    } region_t;

    state_t state_q;
    region_t region_q;

    logic write_q;
    logic error_q;
    logic [SRAM_ADDR_W-1:0] word_addr_q;
    logic [1:0] pixel_lane_q;

    region_t decode_region;
    logic [HADDR_WIDTH-1:0] decode_offset;
    logic [SRAM_ADDR_W-1:0] decode_word_addr;
    logic [1:0] decode_pixel_lane;
    logic decode_error;

    logic valid_transfer;
    logic supported_burst;

    logic [7:0] pixel_r_read;
    logic [7:0] pixel_g_read;
    logic [7:0] pixel_b_read;

    assign valid_transfer = HTRANS[1];
    assign supported_burst =
        (HBURST == lab12_pkg::AHB_HBURST_SINGLE) ||
        (HBURST == lab12_pkg::AHB_HBURST_INCR4);

    always_comb begin
        decode_region     = REGION_NONE;
        decode_offset     = '0;
        decode_word_addr  = '0;
        decode_pixel_lane = '0;

        if ((HADDR >= PIXEL_BASE) && (HADDR < (PIXEL_BASE + PIXEL_SIZE))) begin
            decode_region     = REGION_PIXEL;
            decode_offset     = HADDR - PIXEL_BASE;
            decode_word_addr  = decode_offset[SRAM_ADDR_W+3:4];
            decode_pixel_lane = decode_offset[3:2];
        end
        else if ((HADDR >= R_BASE) && (HADDR < (R_BASE + CHANNEL_SIZE))) begin
            decode_region    = REGION_R;
            decode_offset    = HADDR - R_BASE;
            decode_word_addr = decode_offset[SRAM_ADDR_W+1:2];
        end
        else if ((HADDR >= G_BASE) && (HADDR < (G_BASE + CHANNEL_SIZE))) begin
            decode_region    = REGION_G;
            decode_offset    = HADDR - G_BASE;
            decode_word_addr = decode_offset[SRAM_ADDR_W+1:2];
        end
        else if ((HADDR >= B_BASE) && (HADDR < (B_BASE + CHANNEL_SIZE))) begin
            decode_region    = REGION_B;
            decode_offset    = HADDR - B_BASE;
            decode_word_addr = decode_offset[SRAM_ADDR_W+1:2];
        end
    end

    assign decode_error =
        (decode_region == REGION_NONE) ||
        (HSIZE != lab12_pkg::AHB_HSIZE_WORD) ||
        (HADDR[1:0] != 2'b00) ||
        !supported_burst ||
        ((decode_region == REGION_PIXEL) &&
         (HBURST != lab12_pkg::AHB_HBURST_SINGLE));

`ifndef SYNTHESIS
    initial begin
        if (HDATA_WIDTH != 32)
            $fatal(1, "ahb_rgb_sram_slave: HDATA_WIDTH must be 32");
    end
`endif

    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            state_q       <= ST_IDLE;
            region_q      <= REGION_NONE;
            write_q       <= 1'b0;
            error_q       <= 1'b0;
            word_addr_q   <= '0;
            pixel_lane_q  <= '0;
        end
        else begin
            case (state_q)
                ST_IDLE: begin
                    error_q <= 1'b0;
                    if (valid_transfer) begin
                        region_q     <= decode_region;
                        write_q      <= HWRITE;
                        error_q      <= decode_error;
                        word_addr_q  <= decode_word_addr;
                        pixel_lane_q <= decode_pixel_lane;
                        if (decode_error)
                            state_q <= ST_RESPONSE;
                        else
                            state_q <= ST_ACCESS;
                    end
                end

                ST_ACCESS:
                    state_q <= ST_RESPONSE;

                ST_RESPONSE: begin
                    // The current data phase completes with HREADY=1. AHB-Lite
                    // may present the next burst address in the same cycle, so
                    // capture it here instead of forcing an idle bubble.
                    if (valid_transfer) begin
                        region_q     <= decode_region;
                        write_q      <= HWRITE;
                        error_q      <= decode_error;
                        word_addr_q  <= decode_word_addr;
                        pixel_lane_q <= decode_pixel_lane;
                        if (decode_error)
                            state_q <= ST_RESPONSE;
                        else
                            state_q <= ST_ACCESS;
                    end
                    else begin
                        error_q <= 1'b0;
                        state_q <= ST_IDLE;
                    end
                end

                default:
                    state_q <= ST_IDLE;
            endcase
        end
    end

    always_comb begin
        sram_en       = 1'b0;
        sram_write    = 1'b0;
        sram_bank_en  = 3'b000;
        sram_addr     = word_addr_q;
        sram_byte_en  = 4'b0000;
        sram_r_wdata  = 32'h0000_0000;
        sram_g_wdata  = 32'h0000_0000;
        sram_b_wdata  = 32'h0000_0000;

        if ((state_q == ST_ACCESS) && !error_q) begin
            sram_en    = 1'b1;
            sram_write = write_q;

            case (region_q)
                REGION_PIXEL: begin
                    sram_bank_en = 3'b111;
                    case (pixel_lane_q)
                        2'd0: begin
                            sram_byte_en = 4'b1000;
                            sram_r_wdata[31:24] = HWDATA[23:16];
                            sram_g_wdata[31:24] = HWDATA[15:8];
                            sram_b_wdata[31:24] = HWDATA[7:0];
                        end
                        2'd1: begin
                            sram_byte_en = 4'b0100;
                            sram_r_wdata[23:16] = HWDATA[23:16];
                            sram_g_wdata[23:16] = HWDATA[15:8];
                            sram_b_wdata[23:16] = HWDATA[7:0];
                        end
                        2'd2: begin
                            sram_byte_en = 4'b0010;
                            sram_r_wdata[15:8] = HWDATA[23:16];
                            sram_g_wdata[15:8] = HWDATA[15:8];
                            sram_b_wdata[15:8] = HWDATA[7:0];
                        end
                        default: begin
                            sram_byte_en = 4'b0001;
                            sram_r_wdata[7:0] = HWDATA[23:16];
                            sram_g_wdata[7:0] = HWDATA[15:8];
                            sram_b_wdata[7:0] = HWDATA[7:0];
                        end
                    endcase
                end

                REGION_R: begin
                    sram_bank_en = 3'b001;
                    sram_byte_en = 4'b1111;
                    sram_r_wdata = HWDATA;
                end

                REGION_G: begin
                    sram_bank_en = 3'b010;
                    sram_byte_en = 4'b1111;
                    sram_g_wdata = HWDATA;
                end

                REGION_B: begin
                    sram_bank_en = 3'b100;
                    sram_byte_en = 4'b1111;
                    sram_b_wdata = HWDATA;
                end

                default: begin
                    sram_bank_en = 3'b000;
                    sram_byte_en = 4'b0000;
                end
            endcase
        end
    end

    always_comb begin
        case (pixel_lane_q)
            2'd0: begin
                pixel_r_read = sram_r_rdata[31:24];
                pixel_g_read = sram_g_rdata[31:24];
                pixel_b_read = sram_b_rdata[31:24];
            end
            2'd1: begin
                pixel_r_read = sram_r_rdata[23:16];
                pixel_g_read = sram_g_rdata[23:16];
                pixel_b_read = sram_b_rdata[23:16];
            end
            2'd2: begin
                pixel_r_read = sram_r_rdata[15:8];
                pixel_g_read = sram_g_rdata[15:8];
                pixel_b_read = sram_b_rdata[15:8];
            end
            default: begin
                pixel_r_read = sram_r_rdata[7:0];
                pixel_g_read = sram_g_rdata[7:0];
                pixel_b_read = sram_b_rdata[7:0];
            end
        endcase
    end

    always_comb begin
        HRDATA = '0;
        case (region_q)
            REGION_PIXEL: HRDATA = {8'h00, pixel_r_read, pixel_g_read, pixel_b_read};
            REGION_R:     HRDATA = sram_r_rdata;
            REGION_G:     HRDATA = sram_g_rdata;
            REGION_B:     HRDATA = sram_b_rdata;
            default:      HRDATA = '0;
        endcase
    end

    always_comb begin
        HREADY = 1'b0;
        HRESP  = 1'b0;

        case (state_q)
            ST_IDLE: begin
                HREADY = 1'b1;
            end
            ST_ACCESS: begin
                HREADY = 1'b0;
            end
            ST_RESPONSE: begin
                HREADY = 1'b1;
                HRESP  = error_q;
            end
            default: begin
                HREADY = 1'b1;
                HRESP  = 1'b1;
            end
        endcase
    end

endmodule
