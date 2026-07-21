`timescale 1ns / 1ps

// Integration wrapper: one AHB-Lite subordinate plus the three RGB SRAM banks.
module ahb_rgb_sram_subsystem #(
    parameter int unsigned SRAM_DEPTH = lab12_pkg::ROM_DEPTH,
    parameter int unsigned SRAM_ADDR_W = lab12_pkg::ROM_ADDR_WIDTH,
    parameter string RED_INIT_FILE   = lab12_pkg::RED_INIT_FILE,
    parameter string GREEN_INIT_FILE = lab12_pkg::GREEN_INIT_FILE,
    parameter string BLUE_INIT_FILE  = lab12_pkg::BLUE_INIT_FILE
) (
    ahb_lite_if.slave ahb
);

    logic sram_en;
    logic sram_write;
    logic [2:0] sram_bank_en;
    logic [SRAM_ADDR_W-1:0] sram_addr;
    logic [3:0] sram_byte_en;
    logic [31:0] sram_r_wdata, sram_g_wdata, sram_b_wdata;
    logic [31:0] sram_r_rdata, sram_g_rdata, sram_b_rdata;

    ahb_rgb_sram_slave #(
        .HADDR_WIDTH (lab12_pkg::AHB_ADDR_WIDTH),
        .HDATA_WIDTH (lab12_pkg::AHB_DATA_WIDTH),
        .SRAM_ADDR_W (SRAM_ADDR_W)
    ) u_ahb_rgb_sram_slave (
        .HCLK           (ahb.HCLK),
        .HRESETn        (ahb.HRESETn),
        .HADDR          (ahb.HADDR),
        .HTRANS         (ahb.HTRANS),
        .HWRITE         (ahb.HWRITE),
        .HSIZE          (ahb.HSIZE),
        .HBURST         (ahb.HBURST),
        .HWDATA         (ahb.HWDATA),
        .HRDATA         (ahb.HRDATA),
        .HREADY         (ahb.HREADY),
        .HRESP          (ahb.HRESP),
        .sram_en        (sram_en),
        .sram_write     (sram_write),
        .sram_bank_en   (sram_bank_en),
        .sram_addr      (sram_addr),
        .sram_byte_en   (sram_byte_en),
        .sram_r_wdata   (sram_r_wdata),
        .sram_g_wdata   (sram_g_wdata),
        .sram_b_wdata   (sram_b_wdata),
        .sram_r_rdata   (sram_r_rdata),
        .sram_g_rdata   (sram_g_rdata),
        .sram_b_rdata   (sram_b_rdata)
    );

    rgb_sram_project_storage #(
        .SRAM_DEPTH     (SRAM_DEPTH),
        .WORD_WIDTH     (32),
        .ADDR_WIDTH     (SRAM_ADDR_W),
        .RED_INIT_FILE  (RED_INIT_FILE),
        .GREEN_INIT_FILE(GREEN_INIT_FILE),
        .BLUE_INIT_FILE (BLUE_INIT_FILE)
    ) u_rgb_sram_subsystem (
        .clk_i           (ahb.HCLK),
        .mem_en_i        (sram_en),
        .mem_write_i     (sram_write),
        .mem_bank_en_i   (sram_bank_en),
        .mem_addr_i      (sram_addr),
        .mem_byte_en_i   (sram_byte_en),
        .mem_r_wdata_i   (sram_r_wdata),
        .mem_g_wdata_i   (sram_g_wdata),
        .mem_b_wdata_i   (sram_b_wdata),
        .mem_r_rdata_o   (sram_r_rdata),
        .mem_g_rdata_o   (sram_g_rdata),
        .mem_b_rdata_o   (sram_b_rdata)
    );

endmodule
