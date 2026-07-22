`timescale 1ns / 1ps

// Transfers an event pulse between unrelated clock domains by toggling a bit.
// Source events must be separated long enough for the toggle to cross.
module cdc_pulse_sync (
    input  logic src_clk,
    input  logic src_rst_n,
    input  logic src_pulse,

    input  logic dst_clk,
    input  logic dst_rst_n,
    output logic dst_pulse
);

    logic src_toggle;
    logic dst_sync;
    logic dst_sync_q;

    always_ff @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n)
            src_toggle <= 1'b0;
        else if (src_pulse)
            src_toggle <= ~src_toggle;
    end

    cdc_2ff_sync u_toggle_2ff (
        .clk      (dst_clk),
        .rst_n    (dst_rst_n),
        .async_in (src_toggle),
        .sync_out (dst_sync)
    );

    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            dst_sync_q <= 1'b0;
        end
        else begin
            dst_sync_q <= dst_sync;
        end
    end

    assign dst_pulse = dst_sync ^ dst_sync_q;

endmodule
