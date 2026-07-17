`timescale 1ns / 1ps

module pulse_sync (
    input  logic src_clk,
    input  logic src_rst_n,
    input  logic src_pulse,

    input  logic dst_clk,
    input  logic dst_rst_n,
    output logic dst_pulse
);

    logic src_toggle;
    logic dst_meta;
    logic dst_sync;
    logic dst_sync_d;

    // Source domain: pulse -> toggle
    always_ff @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n)
            src_toggle <= 1'b0;
        else if (src_pulse)
            src_toggle <= ~src_toggle;
    end

    // Destination domain: synchronize toggle and detect transition
    always_ff @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            dst_meta   <= 1'b0;
            dst_sync   <= 1'b0;
            dst_sync_d <= 1'b0;
        end
        else begin
            dst_meta   <= src_toggle;
            dst_sync   <= dst_meta;
            dst_sync_d <= dst_sync;
        end
    end

    assign dst_pulse = dst_sync ^ dst_sync_d;

endmodule