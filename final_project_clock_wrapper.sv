`timescale 1ns / 1ps

// Final-project clock/reset wrapper.
//
// clk_sys is always the 100 MHz board clock.
// clk_fast uses the 100 MHz board clock while the PLL is acquiring lock,
// then switches glitchlessly to the 280 MHz Clock Wizard output.
module final_project_clock_wrapper (
    input  logic clk_100mhz,
    input  logic arst_n,

    output logic clk_sys,
    output logic clk_fast,

    output logic rst_sys_n,
    output logic rst_fast_n,

    output logic pll_locked
);

    logic clk_pll_280;
    logic pll_locked_raw;
    logic pll_locked_meta;
    logic pll_locked_sync;

    assign clk_sys = clk_100mhz;

    // Vivado Clocking Wizard configuration:
    // input  = 100 MHz
    // output = 280 MHz
    lab12_clk_wiz u_lab12_clk_wiz (
        .clk_in1  (clk_100mhz),
        .reset    (~arst_n),
        .clk_out1 (clk_pll_280),
        .locked   (pll_locked_raw)
    );

    // The mux select is generated in the stable 100 MHz domain.
    always_ff @(posedge clk_100mhz or negedge arst_n) begin
        if (!arst_n) begin
            pll_locked_meta <= 1'b0;
            pll_locked_sync <= 1'b0;
        end
        else begin
            pll_locked_meta <= pll_locked_raw;
            pll_locked_sync <= pll_locked_meta;
        end
    end

    assign pll_locked = pll_locked_sync;

    // Before PLL lock: clk_fast = 100 MHz.
    // After  PLL lock: clk_fast = 280 MHz.
    glitchless_clk_mux u_glitchless_clk_mux (
        .clk0    (clk_100mhz),
        .clk1    (clk_pll_280),
        .sel     (pll_locked_sync),
        .rst_n   (arst_n),
        .clk_out (clk_fast)
    );

    // Asynchronous assertion, synchronous release in each clock domain.
    // rst_fast_n is intentionally not held until PLL lock: the fast domain
    // is allowed to operate from the 100 MHz fallback clock during startup.
    reset_sync u_reset_sys (
        .clk    (clk_sys),
        .arst_n (arst_n),
        .rst_n  (rst_sys_n)
    );

    reset_sync u_reset_fast (
        .clk    (clk_fast),
        .arst_n (arst_n),
        .rst_n  (rst_fast_n)
    );

endmodule
