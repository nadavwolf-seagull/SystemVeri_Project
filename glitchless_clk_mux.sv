`timescale 1ns / 1ps

module glitchless_clk_mux (
    input  logic clk0,
    input  logic clk1,
    input  logic sel,
    input  logic rst_n,
    output logic clk_out
);

    // rst_n is kept only for interface compatibility.
    // BUFGMUX performs the clock switch on the FPGA global clock network.
    BUFGMUX u_bufgmux (
        .I0 (clk0),
        .I1 (clk1),
        .S  (sel),
        .O  (clk_out)
    );

endmodule