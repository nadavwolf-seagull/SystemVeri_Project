`timescale 1ns / 1ps

module rgb_sram_subsystem #(
    parameter int SRAM_DEPTH = 16384,
    parameter int WORD_WIDTH = 32,
    parameter int ADDR_WIDTH = 14,

    parameter string RED_INIT_FILE   = "red_hex.mem",
    parameter string GREEN_INIT_FILE = "green_hex.mem",
    parameter string BLUE_INIT_FILE  = "blue_hex.mem"
)(
    input logic clk_i,

    // =========================================================
    // Port A: Sequencer read-only port
    // =========================================================
    input  logic [ADDR_WIDTH-1:0] seq_addr_i,

    output logic [WORD_WIDTH-1:0] seq_r_data_o,
    output logic [WORD_WIDTH-1:0] seq_g_data_o,
    output logic [WORD_WIDTH-1:0] seq_b_data_o,

    // =========================================================
    // Port B: AHB Slave internal read/write port
    // =========================================================
    input logic                  bus_en_i,
    input logic                  bus_write_i,
    input logic [ADDR_WIDTH-1:0] bus_addr_i,

    input logic [WORD_WIDTH-1:0] bus_r_wdata_i,
    input logic [WORD_WIDTH-1:0] bus_g_wdata_i,
    input logic [WORD_WIDTH-1:0] bus_b_wdata_i,

    input logic [3:0] bus_byte_en_i,

    output logic [WORD_WIDTH-1:0] bus_r_rdata_o,
    output logic [WORD_WIDTH-1:0] bus_g_rdata_o,
    output logic [WORD_WIDTH-1:0] bus_b_rdata_o
);

    // =========================================================
    // Three independent color SRAM banks
    // =========================================================
    (* ram_style = "block" *)
    logic [WORD_WIDTH-1:0] red_sram [0:SRAM_DEPTH-1];

    (* ram_style = "block" *)
    logic [WORD_WIDTH-1:0] green_sram [0:SRAM_DEPTH-1];

    (* ram_style = "block" *)
    logic [WORD_WIDTH-1:0] blue_sram [0:SRAM_DEPTH-1];

    // =========================================================
    // Initial image contents
    // =========================================================
    initial begin
        $readmemh(RED_INIT_FILE,   red_sram);
        $readmemh(GREEN_INIT_FILE, green_sram);
        $readmemh(BLUE_INIT_FILE,  blue_sram);
    end

    // =========================================================
    // Port A: synchronous read for existing Sequencer
    // =========================================================
    always_ff @(posedge clk_i) begin
        seq_r_data_o <= red_sram[seq_addr_i];
        seq_g_data_o <= green_sram[seq_addr_i];
        seq_b_data_o <= blue_sram[seq_addr_i];
    end

    // =========================================================
    // Port B: synchronous AHB-side read/write
    //
    // Byte ordering:
    // byte_en[3] -> pixel 0 -> bits [31:24]
    // byte_en[2] -> pixel 1 -> bits [23:16]
    // byte_en[1] -> pixel 2 -> bits [15:8]
    // byte_en[0] -> pixel 3 -> bits [7:0]
    // =========================================================
    always_ff @(posedge clk_i) begin
        if (bus_en_i) begin

            // Synchronous read.
            // During a simultaneous write, these outputs contain
            // the old value of the selected word.
            bus_r_rdata_o <= red_sram[bus_addr_i];
            bus_g_rdata_o <= green_sram[bus_addr_i];
            bus_b_rdata_o <= blue_sram[bus_addr_i];

            if (bus_write_i) begin
                if (bus_byte_en_i[3]) begin
                    red_sram[bus_addr_i][31:24]
                        <= bus_r_wdata_i[31:24];

                    green_sram[bus_addr_i][31:24]
                        <= bus_g_wdata_i[31:24];

                    blue_sram[bus_addr_i][31:24]
                        <= bus_b_wdata_i[31:24];
                end

                if (bus_byte_en_i[2]) begin
                    red_sram[bus_addr_i][23:16]
                        <= bus_r_wdata_i[23:16];

                    green_sram[bus_addr_i][23:16]
                        <= bus_g_wdata_i[23:16];

                    blue_sram[bus_addr_i][23:16]
                        <= bus_b_wdata_i[23:16];
                end

                if (bus_byte_en_i[1]) begin
                    red_sram[bus_addr_i][15:8]
                        <= bus_r_wdata_i[15:8];

                    green_sram[bus_addr_i][15:8]
                        <= bus_g_wdata_i[15:8];

                    blue_sram[bus_addr_i][15:8]
                        <= bus_b_wdata_i[15:8];
                end

                if (bus_byte_en_i[0]) begin
                    red_sram[bus_addr_i][7:0]
                        <= bus_r_wdata_i[7:0];

                    green_sram[bus_addr_i][7:0]
                        <= bus_g_wdata_i[7:0];

                    blue_sram[bus_addr_i][7:0]
                        <= bus_b_wdata_i[7:0];
                end
            end
        end
    end

endmodule