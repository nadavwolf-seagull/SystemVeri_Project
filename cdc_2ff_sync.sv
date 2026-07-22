`timescale 1ns / 1ps

// Two-flop synchronizer for one asynchronous level signal.
// Use only for a single-bit level. Do not use it for a multi-bit data bus.
module cdc_2ff_sync #(
    parameter logic RESET_VALUE = 1'b0
) (
    input  logic clk,
    input  logic rst_n,
    input  logic async_in,
    output logic sync_out
);

    (* ASYNC_REG = "TRUE" *) logic sync_meta;
    (* ASYNC_REG = "TRUE" *) logic sync_ff;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_meta <= RESET_VALUE;
            sync_ff   <= RESET_VALUE;
        end
        else begin
            sync_meta <= async_in;
            sync_ff   <= sync_meta;
        end
    end

    assign sync_out = sync_ff;

endmodule
