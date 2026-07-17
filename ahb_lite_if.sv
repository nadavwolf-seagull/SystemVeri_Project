`timescale 1ns / 1ps

interface ahb_lite_if #(
    parameter int unsigned ADDR_WIDTH = lab12_pkg::AHB_ADDR_WIDTH,
    parameter int unsigned DATA_WIDTH = lab12_pkg::AHB_DATA_WIDTH
) (
    input logic HCLK,
    input logic HRESETn
);

    // ============================================================
    // Manager to subordinate
    // ============================================================

    logic [ADDR_WIDTH-1:0] HADDR;
    logic [DATA_WIDTH-1:0] HWDATA;

    logic                  HWRITE;
    logic [1:0]            HTRANS;
    logic [2:0]            HSIZE;
    logic [2:0]            HBURST;
    logic [3:0]            HPROT;
    logic                  HMASTLOCK;

    // ============================================================
    // Subordinate to manager
    // ============================================================

    logic [DATA_WIDTH-1:0] HRDATA;
    logic                  HREADY;
    logic                  HRESP;

    // ============================================================
    // Master modport
    // ============================================================

    modport master (
        input  HCLK,
        input  HRESETn,

        output HADDR,
        output HWDATA,
        output HWRITE,
        output HTRANS,
        output HSIZE,
        output HBURST,
        output HPROT,
        output HMASTLOCK,

        input  HRDATA,
        input  HREADY,
        input  HRESP
    );

    // ============================================================
    // Slave modport
    // ============================================================

    modport slave (
        input  HCLK,
        input  HRESETn,

        input  HADDR,
        input  HWDATA,
        input  HWRITE,
        input  HTRANS,
        input  HSIZE,
        input  HBURST,
        input  HPROT,
        input  HMASTLOCK,

        output HRDATA,
        output HREADY,
        output HRESP
    );

endinterface