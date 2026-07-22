`timescale 1ns / 1ps

module dma_uvm_top;

    import uvm_pkg::*;
    import dma_uvm_pkg::*;

    initial begin
        run_test("dma_uvm_smoke_test");
    end

endmodule