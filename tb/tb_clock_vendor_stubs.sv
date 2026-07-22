`timescale 1ns / 1ps

// Lint and simulation only.
// Do not add this file to the Vivado Design Sources.
module lab12_clk_wiz (
    input  logic clk_in1,
    input  logic reset,
    output logic clk_out1,
    output logic locked
);
    assign clk_out1 = clk_in1;
    assign locked   = ~reset;
endmodule

// Behavioral substitute for the Xilinx global clock primitive.
module BUFGMUX (
    input  logic I0,
    input  logic I1,
    input  logic S,
    output logic O
);
    assign O = S ? I1 : I0;
endmodule
