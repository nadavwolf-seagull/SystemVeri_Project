`timescale 1ns / 1ps



module rgb_rom_subsystem #(
    parameter int ROM_DEPTH   = 16384,       // Number of rows in each ROM
    parameter int ROM_WIDTH   = 32,          // Word width (4 pixels of 8 bits each)
    parameter int ADDR_WIDTH  = 14,          // Address width matching the Sequencer
    
    // Hex initialization files for the ROMs
    parameter string RED_INIT_FILE   = "red_hex.mem",
    parameter string GREEN_INIT_FILE = "green_hex.mem",
    parameter string BLUE_INIT_FILE  = "blue_hex.mem"
)(
    input  logic                    clk,            // System clock (100MHz)
    input  logic [ADDR_WIDTH-1:0]   rom_addr,       // 14-bit Address from Sequencer
    
    output logic [ROM_WIDTH-1:0]    rom_r_data,     // 32-bit Red word output
    output logic [ROM_WIDTH-1:0]    rom_g_data,     // 32-bit Green word output
    output logic [ROM_WIDTH-1:0]    rom_b_data      // 32-bit Blue word output
);

    // -------------------------------------------------------------------------
    // 1. Memory Array Declarations (Inferred as Block RAMs)
    // -------------------------------------------------------------------------
    logic [ROM_WIDTH-1:0] red_rom   [0:ROM_DEPTH-1];
    logic [ROM_WIDTH-1:0] green_rom [0:ROM_DEPTH-1];
    logic [ROM_WIDTH-1:0] blue_rom  [0:ROM_DEPTH-1];

    // -------------------------------------------------------------------------
    // 2. ROM Initialization from Hex Files
    // -------------------------------------------------------------------------
    initial begin
        $readmemh(RED_INIT_FILE,   red_rom);
        $readmemh(GREEN_INIT_FILE, green_rom);
        $readmemh(BLUE_INIT_FILE,  blue_rom);
    end

    // -------------------------------------------------------------------------
    // 3. Synchronous ROM Read (BRAM Inference)
    // -------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        rom_r_data <= red_rom[rom_addr];
        rom_g_data <= green_rom[rom_addr];
        rom_b_data <= blue_rom[rom_addr];
    end

endmodule