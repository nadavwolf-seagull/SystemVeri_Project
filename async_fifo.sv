`timescale 1ns / 1ps

// Generic asynchronous FIFO with Gray-coded pointers.
// Status outputs are local to the clock domain named in each signal.
module async_fifo #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned DEPTH = 32
) (
    input  logic                         wr_clk,
    input  logic                         wr_rst_n,
    input  logic                         wr_push,
    input  logic [DATA_WIDTH-1:0]        wr_data,
    input  logic [$clog2(DEPTH+1)-1:0]  wr_af_free_level,
    output logic                         wr_full,
    output logic                         wr_almost_full,
    output logic [$clog2(DEPTH+1)-1:0]  wr_level,
    output logic                         wr_overflow,

    input  logic                         rd_clk,
    input  logic                         rd_rst_n,
    input  logic                         rd_pop,
    input  logic [$clog2(DEPTH+1)-1:0]  rd_ae_level,
    output logic [DATA_WIDTH-1:0]        rd_data,
    output logic                         rd_data_valid,
    output logic                         rd_empty,
    output logic                         rd_almost_empty,
    output logic [$clog2(DEPTH+1)-1:0]  rd_level,
    output logic                         rd_underflow
);

    localparam int unsigned ADDR_W = $clog2(DEPTH);
    localparam int unsigned PTR_W = ADDR_W + 1;
    localparam int unsigned LEVEL_W = $clog2(DEPTH + 1);
    localparam int unsigned STATUS_PIPE_MARGIN = 2;

    logic [PTR_W-1:0] wbin_q, wbin_next;
    logic [PTR_W-1:0] rbin_q, rbin_next;
    logic [PTR_W-1:0] wgray_q, wgray_next;
    logic [PTR_W-1:0] rgray_q, rgray_next;

    (* ASYNC_REG = "TRUE" *) logic [PTR_W-1:0] rgray_wq1, rgray_wq2;
    (* ASYNC_REG = "TRUE" *) logic [PTR_W-1:0] wgray_rq1, wgray_rq2;

    logic [PTR_W-1:0] rbin_sync_w;
    logic [PTR_W-1:0] wbin_sync_r;
    logic [PTR_W-1:0] wr_level_cur_ext;
    logic [PTR_W-1:0] rd_level_cur_ext;

    // Registered thresholds keep the status comparison out of the
    // pointer arithmetic path. Exact full/empty protection is unchanged.
    logic [LEVEL_W-1:0] wr_used_threshold_q;
    logic [LEVEL_W-1:0] rd_empty_threshold_q;

    logic wr_accept;
    logic rd_accept;
    logic wr_full_next;
    logic rd_empty_next;

    logic [ADDR_W-1:0] wr_addr;
    logic [ADDR_W-1:0] rd_addr;

    function automatic logic [PTR_W-1:0] bin2gray(
        input logic [PTR_W-1:0] value
    );
        bin2gray = (value >> 1) ^ value;
    endfunction

    function automatic logic [PTR_W-1:0] gray2bin(
        input logic [PTR_W-1:0] value
    );
        logic [PTR_W-1:0] result;
        int i;
        begin
            result[PTR_W-1] = value[PTR_W-1];
            for (i = PTR_W-2; i >= 0; i = i - 1)
                result[i] = result[i+1] ^ value[i];
            gray2bin = result;
        end
    endfunction

`ifndef SYNTHESIS
    initial begin
        if ((DEPTH < 4) || ((DEPTH & (DEPTH - 1)) != 0))
            $fatal(1, "async_fifo: DEPTH must be a power of two and at least 4");
    end
`endif

    assign wr_accept = wr_push && !wr_full;
    assign rd_accept = rd_pop && !rd_empty;

    assign wr_addr = wbin_q[ADDR_W-1:0];
    assign rd_addr = rbin_q[ADDR_W-1:0];

    assign wbin_next = wbin_q + wr_accept;
    assign rbin_next = rbin_q + rd_accept;
    assign wgray_next = bin2gray(wbin_next);
    assign rgray_next = bin2gray(rbin_next);

    assign rbin_sync_w = gray2bin(rgray_wq2);
    assign wbin_sync_r = gray2bin(wgray_rq2);

    assign wr_level_cur_ext = wbin_q - rbin_sync_w;
    assign rd_level_cur_ext = wbin_sync_r - rbin_q;

    assign wr_full_next =
        (wgray_next == {~rgray_wq2[PTR_W-1:PTR_W-2], rgray_wq2[PTR_W-3:0]});
    assign rd_empty_next = (rgray_next == wgray_rq2);

    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rgray_wq1 <= '0;
            rgray_wq2 <= '0;
        end
        else begin
            rgray_wq1 <= rgray_q;
            rgray_wq2 <= rgray_wq1;
        end
    end

    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wgray_rq1 <= '0;
            wgray_rq2 <= '0;
        end
        else begin
            wgray_rq1 <= wgray_q;
            wgray_rq2 <= wgray_rq1;
        end
    end

    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wbin_q         <= '0;
            wgray_q        <= '0;
            wr_full        <= 1'b0;
            wr_almost_full <= 1'b0;
            wr_level       <= '0;
            wr_used_threshold_q <= LEVEL_W'(DEPTH);
            wr_overflow    <= 1'b0;
        end
        else begin
            wbin_q         <= wbin_next;
            wgray_q        <= wgray_next;
            wr_full        <= wr_full_next;

            // Level is status only; full remains the exact write guard.
            // Registering it breaks the long Gray-to-binary/arithmetic/
            // threshold chain that otherwise limits the fast clock.
            wr_level <= wr_level_cur_ext[LEVEL_W-1:0];

            // The status comparison is two registers behind the exact
            // pointer. Move the warning point earlier by two entries so
            // continuous writes still assert at the requested free level.
            if (
                wr_af_free_level >=
                LEVEL_W'(DEPTH - STATUS_PIPE_MARGIN)
            ) begin
                wr_used_threshold_q <= '0;
            end
            else begin
                wr_used_threshold_q <=
                    LEVEL_W'(DEPTH - STATUS_PIPE_MARGIN) -
                    wr_af_free_level;
            end

            wr_almost_full <=
                (wr_level >= wr_used_threshold_q);

            wr_overflow    <= wr_push && wr_full;
        end
    end

    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rbin_q          <= '0;
            rgray_q         <= '0;
            rd_empty        <= 1'b1;
            rd_almost_empty <= 1'b1;
            rd_level        <= '0;
            rd_empty_threshold_q <= '0;
            rd_data_valid   <= 1'b0;
            rd_underflow    <= 1'b0;
        end
        else begin
            rbin_q          <= rbin_next;
            rgray_q         <= rgray_next;
            rd_empty        <= rd_empty_next;

            rd_level <= rd_level_cur_ext[LEVEL_W-1:0];
            // Assert early by the matching two-entry pipeline margin.
            if (
                rd_ae_level >=
                LEVEL_W'(DEPTH - STATUS_PIPE_MARGIN)
            ) begin
                rd_empty_threshold_q <= LEVEL_W'(DEPTH);
            end
            else begin
                rd_empty_threshold_q <=
                    rd_ae_level + LEVEL_W'(STATUS_PIPE_MARGIN);
            end
            rd_almost_empty <=
                (rd_level <= rd_empty_threshold_q);

            rd_data_valid   <= rd_accept;
            rd_underflow    <= rd_pop && rd_empty;
        end
    end

    ram_1r1w #(
        .RAM_WIDTH (DATA_WIDTH),
        .RAM_DEPTH (DEPTH)
    ) u_storage (
        .wr_clk   (wr_clk),
        .wr_en    (wr_accept),
        .wr_addr  (wr_addr),
        .data_in  (wr_data),
        .rd_clk   (rd_clk),
        .rd_rst_n (rd_rst_n),
        .rd_en    (rd_accept),
        .rd_addr  (rd_addr),
        .data_out (rd_data)
    );

endmodule
