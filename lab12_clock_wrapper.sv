`timescale 1ns / 1ps

module lab12_clock_wrapper (
    input  logic clk_100mhz,
    input  logic arst_n,

    // Kept temporarily for board_top interface compatibility.
    // Lab 12 clock switching no longer depends on the RGF.
    input  logic clk_fast_req,

    // In Lab 12 all three outputs carry the selected system clock.
    output logic clk_ctrl,
    output logic clk_selected,
    output logic clk_uart,

    // In Lab 12 all three resets belong to the selected clock domain.
    output logic rst_ctrl_n,
    output logic rst_selected_n,
    output logic rst_uart_n,

    output logic pll_locked,
    output logic clk_mux_sel_dbg
);

    logic clk_fast;
    logic pll_reset;

    logic pll_locked_meta;
    logic pll_locked_sync;

    logic rst_system_n;

    // Suppress unused-input warnings until board_top is updated.
    logic unused_clk_fast_req;

    assign unused_clk_fast_req = clk_fast_req;

    assign pll_reset = ~arst_n;

    // =========================================================
    // PLL / Clock Wizard
    // clk_fast = PLL output clock
    // =========================================================
    lab12_clk_wiz u_lab12_clk_wiz (
        .clk_in1  (clk_100mhz),
        .reset    (pll_reset),
        .clk_out1 (clk_fast),
        .locked   (pll_locked)
    );

    // =========================================================
    // Synchronize PLL lock into the stable 100 MHz domain
    // =========================================================
    always_ff @(posedge clk_100mhz or negedge arst_n) begin
        if (!arst_n) begin
            pll_locked_meta <= 1'b0;
            pll_locked_sync <= 1'b0;
        end
        else begin
            pll_locked_meta <= pll_locked;
            pll_locked_sync <= pll_locked_meta;
        end
    end

    // =========================================================
    // Automatic clock selection
    //
    // PLL unlocked -> use board clock, 100 MHz
    // PLL locked   -> use PLL clock
    // =========================================================
    assign clk_mux_sel_dbg = pll_locked_sync;

    glitchless_clk_mux u_glitchless_clk_mux (
        .clk0    (clk_100mhz),
        .clk1    (clk_fast),
        .sel     (pll_locked_sync),
        .rst_n   (arst_n),
        .clk_out (clk_selected)
    );

    // =========================================================
    // Lab 12 uses one selected system clock for all logic
    // =========================================================
    assign clk_ctrl = clk_selected;
    assign clk_uart = clk_selected;

    // =========================================================
    // One reset synchronizer for the common clock domain
    //
    // Reset is not held until PLL lock:
    // the system can operate from 100 MHz during PLL startup.
    // =========================================================
    reset_sync u_reset_system (
        .clk    (clk_selected),
        .arst_n (arst_n),
        .rst_n  (rst_system_n)
    );

    assign rst_ctrl_n     = rst_system_n;
    assign rst_selected_n = rst_system_n;
    assign rst_uart_n     = rst_system_n;

endmodule