`timescale 1ns / 1ps

module ahb_pixel_slave #(
    parameter int unsigned HADDR_WIDTH = 32,
    parameter int unsigned HDATA_WIDTH = 32,
    parameter int unsigned SRAM_ADDR_W = 14
)(
    input logic                    HCLK,
    input logic                    HRESETn,

    // =========================================================
    // AHB-Lite request
    // Point-to-point connection: no HSEL is required
    // =========================================================
    input logic [HADDR_WIDTH-1:0]  HADDR,
    input logic [1:0]              HTRANS,
    input logic                    HWRITE,
    input logic [2:0]              HSIZE,
    input logic [HDATA_WIDTH-1:0]  HWDATA,

    // =========================================================
    // AHB-Lite response
    // =========================================================
    output logic [HDATA_WIDTH-1:0] HRDATA,
    output logic                   HREADY,
    output logic                   HRESP,

    // =========================================================
    // RGB SRAM Port-B interface
    // =========================================================
    output logic                   sram_bus_en,
    output logic                   sram_bus_write,
    output logic [SRAM_ADDR_W-1:0] sram_bus_addr,

    output logic [31:0]            sram_r_wdata,
    output logic [31:0]            sram_g_wdata,
    output logic [31:0]            sram_b_wdata,

    output logic [3:0]             sram_byte_en,

    input logic [31:0]             sram_r_rdata,
    input logic [31:0]             sram_g_rdata,
    input logic [31:0]             sram_b_rdata
);

    localparam logic [2:0] HSIZE_WORD = 3'b010;

    typedef enum logic [1:0] {
        ST_IDLE,
        ST_WRITE,
        ST_READ,
        ST_COMPLETE
    } state_t;

    state_t state;

    logic [HADDR_WIDTH-1:0] addr_q;
    logic                   error_q;

    logic [1:0] pixel_sel;

    logic [7:0] red_write;
    logic [7:0] green_write;
    logic [7:0] blue_write;

    logic [7:0] red_read;
    logic [7:0] green_read;
    logic [7:0] blue_read;

    logic valid_transfer;
    logic invalid_transfer;

    // HTRANS[1] is set for NONSEQ or SEQ.
    assign valid_transfer =
        HTRANS[1];

    assign invalid_transfer =
        (HSIZE != HSIZE_WORD) ||
        (HADDR[1:0] != 2'b00);

    /*
     * Every AHB address represents one complete RGB pixel:
     *
     * Pixel 0: HADDR = 0x0000
     * Pixel 1: HADDR = 0x0004
     * Pixel 2: HADDR = 0x0008
     * Pixel 3: HADDR = 0x000C
     * Pixel 4: HADDR = 0x0010
     *
     * HADDR[3:2] selects the pixel byte inside the SRAM word.
     * HADDR[SRAM_ADDR_W+3:4] selects the SRAM word.
     */
    assign pixel_sel =
        addr_q[3:2];

    assign sram_bus_addr =
        addr_q[SRAM_ADDR_W+3:4];

    /*
     * AHB pixel representation:
     *
     * HWDATA = {8'h00, R, G, B}
     */
    assign red_write   = HWDATA[23:16];
    assign green_write = HWDATA[15:8];
    assign blue_write  = HWDATA[7:0];

    // =========================================================
    // State machine
    // =========================================================
    always_ff @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            state   <= ST_IDLE;
            addr_q  <= '0;
            error_q <= 1'b0;
        end
        else begin
            case (state)

                ST_IDLE: begin
                    error_q <= 1'b0;

                    if (valid_transfer) begin
                        addr_q  <= HADDR;
                        error_q <= invalid_transfer;

                        if (invalid_transfer)
                            state <= ST_COMPLETE;
                        else if (HWRITE)
                            state <= ST_WRITE;
                        else
                            state <= ST_READ;
                    end
                end

                ST_WRITE: begin
                    /*
                     * SRAM write occurs at the rising edge at
                     * the end of this state.
                     */
                    state <= ST_COMPLETE;
                end

                ST_READ: begin
                    /*
                     * SRAM synchronous read occurs at the rising
                     * edge at the end of this state.
                     */
                    state <= ST_COMPLETE;
                end

                ST_COMPLETE: begin
                    /*
                     * HREADY is asserted during this state.
                     * Do not accept a second transfer here.
                     * The master returns HTRANS to IDLE and the
                     * slave returns to ST_IDLE.
                     */
                    state   <= ST_IDLE;
                    error_q <= 1'b0;
                end

                default: begin
                    state   <= ST_IDLE;
                    addr_q  <= '0;
                    error_q <= 1'b0;
                end

            endcase
        end
    end

    // =========================================================
    // SRAM byte write mapping
    //
    // Sequencer ordering:
    // Pixel 0 -> bits [31:24]
    // Pixel 1 -> bits [23:16]
    // Pixel 2 -> bits [15:8]
    // Pixel 3 -> bits [7:0]
    // =========================================================
    always_comb begin
        sram_byte_en = 4'b0000;

        sram_r_wdata = 32'd0;
        sram_g_wdata = 32'd0;
        sram_b_wdata = 32'd0;

        case (pixel_sel)

            2'd0: begin
                sram_byte_en = 4'b1000;

                sram_r_wdata[31:24] = red_write;
                sram_g_wdata[31:24] = green_write;
                sram_b_wdata[31:24] = blue_write;
            end

            2'd1: begin
                sram_byte_en = 4'b0100;

                sram_r_wdata[23:16] = red_write;
                sram_g_wdata[23:16] = green_write;
                sram_b_wdata[23:16] = blue_write;
            end

            2'd2: begin
                sram_byte_en = 4'b0010;

                sram_r_wdata[15:8] = red_write;
                sram_g_wdata[15:8] = green_write;
                sram_b_wdata[15:8] = blue_write;
            end

            2'd3: begin
                sram_byte_en = 4'b0001;

                sram_r_wdata[7:0] = red_write;
                sram_g_wdata[7:0] = green_write;
                sram_b_wdata[7:0] = blue_write;
            end

            default: begin
                sram_byte_en = 4'b0000;
            end

        endcase
    end

    // =========================================================
    // SRAM read-byte selection
    // =========================================================
    always_comb begin
        red_read   = 8'd0;
        green_read = 8'd0;
        blue_read  = 8'd0;

        case (pixel_sel)

            2'd0: begin
                red_read   = sram_r_rdata[31:24];
                green_read = sram_g_rdata[31:24];
                blue_read  = sram_b_rdata[31:24];
            end

            2'd1: begin
                red_read   = sram_r_rdata[23:16];
                green_read = sram_g_rdata[23:16];
                blue_read  = sram_b_rdata[23:16];
            end

            2'd2: begin
                red_read   = sram_r_rdata[15:8];
                green_read = sram_g_rdata[15:8];
                blue_read  = sram_b_rdata[15:8];
            end

            2'd3: begin
                red_read   = sram_r_rdata[7:0];
                green_read = sram_g_rdata[7:0];
                blue_read  = sram_b_rdata[7:0];
            end

            default: begin
                red_read   = 8'd0;
                green_read = 8'd0;
                blue_read  = 8'd0;
            end

        endcase
    end

    // =========================================================
    // AHB response and SRAM controls
    // =========================================================
    always_comb begin
        HRDATA = {
            8'h00,
            red_read,
            green_read,
            blue_read
        };

        HREADY = 1'b0;
        HRESP  = 1'b0;

        sram_bus_en    = 1'b0;
        sram_bus_write = 1'b0;

        case (state)

            ST_IDLE: begin
                HREADY = 1'b1;
            end

            ST_WRITE: begin
                HREADY         = 1'b0;
                sram_bus_en    = 1'b1;
                sram_bus_write = 1'b1;
            end

            ST_READ: begin
                HREADY         = 1'b0;
                sram_bus_en    = 1'b1;
                sram_bus_write = 1'b0;
            end

            ST_COMPLETE: begin
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