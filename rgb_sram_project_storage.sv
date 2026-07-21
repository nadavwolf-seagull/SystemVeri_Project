`timescale 1ns / 1ps

// Three 32-bit SRAM banks. Every word stores four 8-bit samples from
// one color channel. Access is synchronous and shared by the AHB slave.
module rgb_sram_project_storage #(
    parameter int unsigned SRAM_DEPTH = lab12_pkg::ROM_DEPTH,
    parameter int unsigned WORD_WIDTH = lab12_pkg::ROM_WORD_WIDTH,
    parameter int unsigned ADDR_WIDTH = lab12_pkg::ROM_ADDR_WIDTH,

    parameter string RED_INIT_FILE   = lab12_pkg::RED_INIT_FILE,
    parameter string GREEN_INIT_FILE = lab12_pkg::GREEN_INIT_FILE,
    parameter string BLUE_INIT_FILE  = lab12_pkg::BLUE_INIT_FILE
) (
    input  logic                  clk_i,

    input  logic                  mem_en_i,
    input  logic                  mem_write_i,
    input  logic [2:0]            mem_bank_en_i, // [0]=R, [1]=G, [2]=B
    input  logic [ADDR_WIDTH-1:0] mem_addr_i,
    input  logic [3:0]            mem_byte_en_i,

    input  logic [WORD_WIDTH-1:0] mem_r_wdata_i,
    input  logic [WORD_WIDTH-1:0] mem_g_wdata_i,
    input  logic [WORD_WIDTH-1:0] mem_b_wdata_i,

    output logic [WORD_WIDTH-1:0] mem_r_rdata_o,
    output logic [WORD_WIDTH-1:0] mem_g_rdata_o,
    output logic [WORD_WIDTH-1:0] mem_b_rdata_o
);

    (* ram_style = "block" *)
    logic [WORD_WIDTH-1:0] red_sram [0:SRAM_DEPTH-1];

    (* ram_style = "block" *)
    logic [WORD_WIDTH-1:0] green_sram [0:SRAM_DEPTH-1];

    (* ram_style = "block" *)
    logic [WORD_WIDTH-1:0] blue_sram [0:SRAM_DEPTH-1];

`ifndef SYNTHESIS
    initial begin
        if (WORD_WIDTH != 32)
            $fatal(1, "rgb_sram_subsystem: byte enables require WORD_WIDTH=32");
        if (SRAM_DEPTH != (1 << ADDR_WIDTH))
            $fatal(1, "rgb_sram_subsystem: SRAM_DEPTH must equal 2**ADDR_WIDTH");
    end
`endif

    initial begin
        if (RED_INIT_FILE != "")
            $readmemh(RED_INIT_FILE, red_sram);
        if (GREEN_INIT_FILE != "")
            $readmemh(GREEN_INIT_FILE, green_sram);
        if (BLUE_INIT_FILE != "")
            $readmemh(BLUE_INIT_FILE, blue_sram);
    end

    // Read-first behavior is intentional. The read value observed during a
    // write is the word that existed before that write edge.
    always_ff @(posedge clk_i) begin
        if (mem_en_i && mem_bank_en_i[0]) begin
            mem_r_rdata_o <= red_sram[mem_addr_i];
            if (mem_write_i) begin
                if (mem_byte_en_i[3]) red_sram[mem_addr_i][31:24] <= mem_r_wdata_i[31:24];
                if (mem_byte_en_i[2]) red_sram[mem_addr_i][23:16] <= mem_r_wdata_i[23:16];
                if (mem_byte_en_i[1]) red_sram[mem_addr_i][15:8]  <= mem_r_wdata_i[15:8];
                if (mem_byte_en_i[0]) red_sram[mem_addr_i][7:0]   <= mem_r_wdata_i[7:0];
            end
        end

        if (mem_en_i && mem_bank_en_i[1]) begin
            mem_g_rdata_o <= green_sram[mem_addr_i];
            if (mem_write_i) begin
                if (mem_byte_en_i[3]) green_sram[mem_addr_i][31:24] <= mem_g_wdata_i[31:24];
                if (mem_byte_en_i[2]) green_sram[mem_addr_i][23:16] <= mem_g_wdata_i[23:16];
                if (mem_byte_en_i[1]) green_sram[mem_addr_i][15:8]  <= mem_g_wdata_i[15:8];
                if (mem_byte_en_i[0]) green_sram[mem_addr_i][7:0]   <= mem_g_wdata_i[7:0];
            end
        end

        if (mem_en_i && mem_bank_en_i[2]) begin
            mem_b_rdata_o <= blue_sram[mem_addr_i];
            if (mem_write_i) begin
                if (mem_byte_en_i[3]) blue_sram[mem_addr_i][31:24] <= mem_b_wdata_i[31:24];
                if (mem_byte_en_i[2]) blue_sram[mem_addr_i][23:16] <= mem_b_wdata_i[23:16];
                if (mem_byte_en_i[1]) blue_sram[mem_addr_i][15:8]  <= mem_b_wdata_i[15:8];
                if (mem_byte_en_i[0]) blue_sram[mem_addr_i][7:0]   <= mem_b_wdata_i[7:0];
            end
        end
    end

endmodule
