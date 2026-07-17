`timescale 1ns / 1ps

// ============================================================
// APB Interface
// Minimal APB-style interface used in Lab 11 for RGF access.
// One master is connected to one RGF slave.
// ============================================================
interface apb_if #(
    parameter int unsigned ADDR_WIDTH = lab12_pkg::RGF_ADDR_WIDTH,
    parameter int unsigned DATA_WIDTH = lab12_pkg::RGF_DATA_WIDTH
)(
    input logic PCLK,
    input logic PRESETn
);

    logic                  PSEL;
    logic                  PENABLE;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic                  PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic                  PREADY;
    logic                  PSLVERR;

    // Optional APB4-style sideband signals.
    // The current RGF does not use them, but keeping them in the
    // interface makes the bus more complete and easier to extend.
    logic [(DATA_WIDTH/8)-1:0] PSTRB;
    logic [2:0]                PPROT;

    modport master (
        input  PCLK,
        input  PRESETn,
        output PSEL,
        output PENABLE,
        output PADDR,
        output PWRITE,
        output PWDATA,
        output PSTRB,
        output PPROT,
        input  PRDATA,
        input  PREADY,
        input  PSLVERR
    );

    modport slave (
        input  PCLK,
        input  PRESETn,
        input  PSEL,
        input  PENABLE,
        input  PADDR,
        input  PWRITE,
        input  PWDATA,
        input  PSTRB,
        input  PPROT,
        output PRDATA,
        output PREADY,
        output PSLVERR
    );

endinterface
