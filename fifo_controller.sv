`timescale 1ns / 1ps

module fifo_controller #(
    parameter int unsigned FIFO_DEPTH = 32
) (
    input  logic                             wr_clk,
    input  logic                             wr_rst_n,
    input  logic                             push_req,

    input  logic                             rd_clk,
    input  logic                             rd_rst_n,
    input  logic                             pop_req,

    input  logic [$clog2(FIFO_DEPTH+1)-1:0] ae_level,
    input  logic [$clog2(FIFO_DEPTH+1)-1:0] af_level,

    output logic                             wr_en,
    output logic                             rd_en,
    output logic [$clog2(FIFO_DEPTH)-1:0]   wr_addr,
    output logic [$clog2(FIFO_DEPTH)-1:0]   rd_addr,

    output logic [$clog2(FIFO_DEPTH+1)-1:0] fifo_level,
    output logic                             empty,
    output logic                             almost_empty,
    output logic                             half_full,
    output logic                             almost_full,
    output logic                             full,

    output logic                             rom_pause,
    output logic                             error
);

    // ============================================================
    // Local parameters
    // ============================================================
    localparam int unsigned ADDR_W  = $clog2(FIFO_DEPTH);
    localparam int unsigned PTR_W   = ADDR_W + 1;
    localparam int unsigned LEVEL_W = $clog2(FIFO_DEPTH + 1);

    // FIFO_DEPTH is power of two.
    // For depth 32 and PTR_W=6:
    // FIFO_DEPTH_PTR = 6'b100000 = 32
    localparam logic [PTR_W-1:0] FIFO_DEPTH_PTR =
        {1'b1, {ADDR_W{1'b0}}};

    localparam logic [PTR_W-1:0] HALF_LEVEL_PTR =
        FIFO_DEPTH_PTR >> 1;

    // ============================================================
    // Binary and Gray-coded pointers
    // ============================================================
    logic [PTR_W-1:0] wbin;
    logic [PTR_W-1:0] wbin_next;
    logic [PTR_W-1:0] rbin;
    logic [PTR_W-1:0] rbin_next;

    logic [PTR_W-1:0] wgray;
    logic [PTR_W-1:0] wgray_next;
    logic [PTR_W-1:0] rgray;
    logic [PTR_W-1:0] rgray_next;

    // ============================================================
    // Two-flop synchronizers for remote Gray pointers
    // ============================================================
    logic [PTR_W-1:0] rgray_wq1;
    logic [PTR_W-1:0] rgray_wq2;

    logic [PTR_W-1:0] wgray_rq1;
    logic [PTR_W-1:0] wgray_rq2;

    // ============================================================
    // Binary versions of synchronized remote pointers
    // ============================================================
    logic [PTR_W-1:0] rbin_sync_w;
    logic [PTR_W-1:0] wbin_sync_r;

    // ============================================================
    // Occupancy estimates
    // ============================================================
    logic [PTR_W-1:0] w_level_cur;
    logic [PTR_W-1:0] w_level_next;
    logic [PTR_W-1:0] r_level_next;
    logic [PTR_W-1:0] w_free_next;

    // ============================================================
    // Next-state flags
    // ============================================================
    logic wfull_next;
    logic rempty_next;
    logic walmost_full_next;
    logic ralmost_empty_next;
    logic whalf_full_next;

    // ============================================================
    // Helper functions
    // ============================================================
    function automatic logic [PTR_W-1:0] bin2gray(
        input logic [PTR_W-1:0] bin
    );
        bin2gray = (bin >> 1) ^ bin;
    endfunction


    function automatic logic [PTR_W-1:0] gray2bin(
        input logic [PTR_W-1:0] gray
    );
        logic [PTR_W-1:0] bin;
        int i;

        begin
            bin[PTR_W-1] = gray[PTR_W-1];

            for (i = PTR_W - 2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end

            gray2bin = bin;
        end
    endfunction

`ifndef SYNTHESIS
    initial begin
        if ((FIFO_DEPTH < 4) ||
            ((FIFO_DEPTH & (FIFO_DEPTH - 1)) != 0)) begin

            $fatal(
                1,
                "fifo_controller: FIFO_DEPTH must be power of two and >= 4"
            );
        end
    end
`endif

    // ============================================================
    // RAM addresses
    // ============================================================
    assign wr_addr = wbin[ADDR_W-1:0];
    assign rd_addr = rbin[ADDR_W-1:0];

    // ============================================================
    // Accept push/pop only when legal
    // ============================================================
    assign wr_en = push_req && !full;
    assign rd_en = pop_req  && !empty;

    // ============================================================
    // Pointer next-state logic
    // ============================================================
    assign wbin_next = wbin + wr_en;
    assign rbin_next = rbin + rd_en;

    assign wgray_next = bin2gray(wbin_next);
    assign rgray_next = bin2gray(rbin_next);

    // ============================================================
    // Convert synchronized Gray pointers to binary
    // ============================================================
    assign rbin_sync_w = gray2bin(rgray_wq2);
    assign wbin_sync_r = gray2bin(wgray_rq2);

    // ============================================================
    // Occupancy estimates
    // ============================================================
    assign w_level_cur  = wbin      - rbin_sync_w;
    assign w_level_next = wbin_next - rbin_sync_w;

    assign r_level_next = wbin_sync_r - rbin_next;

    assign fifo_level = w_level_cur[LEVEL_W-1:0];

    // ============================================================
    // Full detection
    //
    // The next write Gray pointer equals the synchronized read Gray
    // pointer with its two MSBs inverted.
    // ============================================================
    assign wfull_next =
        (wgray_next ==
            {~rgray_wq2[PTR_W-1:PTR_W-2],
              rgray_wq2[PTR_W-3:0]});

    // ============================================================
    // Empty detection
    //
    // The FIFO is empty when the next read Gray pointer reaches the
    // synchronized write Gray pointer.
    // ============================================================
    assign rempty_next = (rgray_next == wgray_rq2);

    // ============================================================
    // Threshold flags
    // ============================================================
    assign w_free_next        = FIFO_DEPTH_PTR - w_level_next;
    assign walmost_full_next  = (w_free_next <= af_level);
    assign ralmost_empty_next = (r_level_next <= ae_level);
    assign whalf_full_next    = (w_level_next >= HALF_LEVEL_PTR);

    // ============================================================
    // Synchronize read pointer into write clock domain
    // ============================================================
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rgray_wq1 <= '0;
            rgray_wq2 <= '0;
        end
        else begin
            rgray_wq1 <= rgray;
            rgray_wq2 <= rgray_wq1;
        end
    end

    // ============================================================
    // Synchronize write pointer into read clock domain
    // ============================================================
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wgray_rq1 <= '0;
            wgray_rq2 <= '0;
        end
        else begin
            wgray_rq1 <= wgray;
            wgray_rq2 <= wgray_rq1;
        end
    end

    // ============================================================
    // Write-side pointer, flags, and ROM pause hysteresis
    // ============================================================
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wbin        <= '0;
            wgray       <= '0;
            full        <= 1'b0;
            almost_full <= 1'b0;
            half_full   <= 1'b0;
            rom_pause   <= 1'b0;
        end
        else begin
            wbin        <= wbin_next;
            wgray       <= wgray_next;
            full        <= wfull_next;
            almost_full <= walmost_full_next;
            half_full   <= whalf_full_next;

            // Stop ROM/pixel generation when the FIFO is almost full.
            // Resume only after the FIFO drains back to ae_level.
            if (walmost_full_next) begin
                rom_pause <= 1'b1;
            end
            else if (w_level_next <= ae_level) begin
                rom_pause <= 1'b0;
            end
        end
    end

    // ============================================================
    // Read-side pointer and flags
    // ============================================================
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rbin         <= '0;
            rgray        <= '0;
            empty        <= 1'b1;
            almost_empty <= 1'b1;
        end
        else begin
            rbin         <= rbin_next;
            rgray        <= rgray_next;
            empty        <= rempty_next;
            almost_empty <= ralmost_empty_next;
        end
    end

    // ============================================================
    // Debug indication only.
    // Do not use this as real CDC control logic.
    // ============================================================
    assign error = (push_req && full) || (pop_req && empty);

endmodule

