`timescale 1ns / 1ps

module tb_seq_img_cluster;

    localparam int IMG_WIDTH  = 4;
    localparam int IMG_HEIGHT = 1;

    localparam int ROM_DEPTH  = 16384;
    localparam int ROM_WIDTH  = 32;
    localparam int ROM_ADDR_W = 14;

    localparam int FIFO_WIDTH = 24;
    localparam int FIFO_DEPTH = 8;
    localparam int LEVEL_W    = $clog2(FIFO_DEPTH + 1);

    logic wr_clk;
    logic wr_rst_n;

    logic rd_clk;
    logic rd_rst_n;

    logic start;
    logic fifo_pop_req;

    logic [LEVEL_W-1:0] ae_level;
    logic [LEVEL_W-1:0] af_level;

    logic sram_bus_en;
    logic sram_bus_write;
    logic [ROM_ADDR_W-1:0] sram_bus_addr;

    logic [ROM_WIDTH-1:0] sram_r_wdata;
    logic [ROM_WIDTH-1:0] sram_g_wdata;
    logic [ROM_WIDTH-1:0] sram_b_wdata;

    logic [3:0] sram_byte_en;

    logic [ROM_WIDTH-1:0] sram_r_rdata;
    logic [ROM_WIDTH-1:0] sram_g_rdata;
    logic [ROM_WIDTH-1:0] sram_b_rdata;

    logic [FIFO_WIDTH-1:0] fifo_data_out;

    logic [LEVEL_W-1:0] fifo_level;
    logic fifo_empty;
    logic fifo_almost_empty;
    logic fifo_half_full;
    logic fifo_almost_full;
    logic fifo_full;
    logic fifo_error;

    logic [9:0] row_cnt;
    logic [9:0] col_cnt;
    logic transfer_done;
    logic busy;
    logic rts;

    logic [23:0] observed_pixels [0:3];
    int pixel_count;

    // =========================================================
    // DUT
    // =========================================================
    seq_img_cluster #(
        .IMG_WIDTH   (IMG_WIDTH),
        .IMG_HEIGHT  (IMG_HEIGHT),

        .ROM_DEPTH   (ROM_DEPTH),
        .ROM_WIDTH   (ROM_WIDTH),
        .ROM_ADDR_W  (ROM_ADDR_W),

        .FIFO_WIDTH  (FIFO_WIDTH),
        .FIFO_DEPTH  (FIFO_DEPTH),

        .RED_INIT_FILE   ("red_hex.mem"),
        .GREEN_INIT_FILE ("green_hex.mem"),
        .BLUE_INIT_FILE  ("blue_hex.mem")
    ) dut (
        .wr_clk             (wr_clk),
        .wr_rst_n           (wr_rst_n),

        .rd_clk             (rd_clk),
        .rd_rst_n           (rd_rst_n),

        .start              (start),
        .fifo_pop_req       (fifo_pop_req),

        .ae_level           (ae_level),
        .af_level           (af_level),

        .sram_bus_en        (sram_bus_en),
        .sram_bus_write     (sram_bus_write),
        .sram_bus_addr      (sram_bus_addr),

        .sram_r_wdata       (sram_r_wdata),
        .sram_g_wdata       (sram_g_wdata),
        .sram_b_wdata       (sram_b_wdata),

        .sram_byte_en       (sram_byte_en),

        .sram_r_rdata       (sram_r_rdata),
        .sram_g_rdata       (sram_g_rdata),
        .sram_b_rdata       (sram_b_rdata),

        .fifo_data_out      (fifo_data_out),

        .fifo_level         (fifo_level),
        .fifo_empty         (fifo_empty),
        .fifo_almost_empty  (fifo_almost_empty),
        .fifo_half_full     (fifo_half_full),
        .fifo_almost_full   (fifo_almost_full),
        .fifo_full          (fifo_full),
        .fifo_error         (fifo_error),

        .row_cnt            (row_cnt),
        .col_cnt            (col_cnt),
        .transfer_done      (transfer_done),
        .busy               (busy),
        .rts                (rts)
    );

    // =========================================================
    // Clocks
    // Same clock is sufficient for this unit test
    // =========================================================
    initial begin
        wr_clk = 1'b0;
        forever #5 wr_clk = ~wr_clk;
    end

    initial begin
        rd_clk = 1'b0;
        forever #5 rd_clk = ~rd_clk;
    end

    // =========================================================
    // Port-B write
    // =========================================================
    task automatic sram_write(
        input logic [ROM_ADDR_W-1:0] addr,
        input logic [3:0] byte_en,
        input logic [31:0] r_data,
        input logic [31:0] g_data,
        input logic [31:0] b_data
    );
        begin
            @(negedge wr_clk);

            sram_bus_en    = 1'b1;
            sram_bus_write = 1'b1;
            sram_bus_addr  = addr;

            sram_byte_en   = byte_en;

            sram_r_wdata   = r_data;
            sram_g_wdata   = g_data;
            sram_b_wdata   = b_data;

            @(negedge wr_clk);

            sram_bus_en    = 1'b0;
            sram_bus_write = 1'b0;
            sram_byte_en   = 4'b0000;
        end
    endtask

    // =========================================================
    // Port-B synchronous read
    // =========================================================
    task automatic sram_read(
        input logic [ROM_ADDR_W-1:0] addr
    );
        begin
            @(negedge wr_clk);

            sram_bus_en    = 1'b1;
            sram_bus_write = 1'b0;
            sram_bus_addr  = addr;

            @(posedge wr_clk);
            #1;

            @(negedge wr_clk);
            sram_bus_en = 1'b0;
        end
    endtask

    // =========================================================
    // Observe the Sequencer output before it enters the FIFO
    // =========================================================
    always @(posedge wr_clk) begin
        if (!wr_rst_n) begin
            pixel_count <= 0;
        end
        else if (dut.fifo_wr_en) begin
            observed_pixels[pixel_count] <= dut.fifo_data_in;

            $display(
                "[%0t] Pixel %0d = R:%02h G:%02h B:%02h",
                $time,
                pixel_count,
                dut.fifo_data_in[23:16],
                dut.fifo_data_in[15:8],
                dut.fifo_data_in[7:0]
            );

            pixel_count <= pixel_count + 1;
        end
    end

    // =========================================================
    // Main test
    // =========================================================
    initial begin
        wr_rst_n       = 1'b0;
        rd_rst_n       = 1'b0;

        start          = 1'b0;
        fifo_pop_req   = 1'b0;

        ae_level       = 1;
        af_level       = FIFO_DEPTH - 1;

        sram_bus_en    = 1'b0;
        sram_bus_write = 1'b0;
        sram_bus_addr  = '0;

        sram_r_wdata   = '0;
        sram_g_wdata   = '0;
        sram_b_wdata   = '0;

        sram_byte_en   = 4'b0000;

        pixel_count    = 0;

        repeat (4) @(posedge wr_clk);

        wr_rst_n = 1'b1;
        rd_rst_n = 1'b1;

        repeat (2) @(posedge wr_clk);

        // -----------------------------------------------------
        // Create a deterministic first SRAM word:
        //
        // Pixel 0: 11 55 99
        // Pixel 1: 22 66 AA
        // Pixel 2: 33 77 BB
        // Pixel 3: 44 88 CC
        // -----------------------------------------------------
        dut.u_rgb_sram_subsystem.red_sram[0]   = 32'h11223344;
        dut.u_rgb_sram_subsystem.green_sram[0] = 32'h55667788;
        dut.u_rgb_sram_subsystem.blue_sram[0]  = 32'h99AABBCC;

        // -----------------------------------------------------
        // Replace only Pixel 1:
        //
        // Pixel 1 = R:AA G:BB B:CC
        //
        // Pixel 1 occupies bits [23:16], therefore byte_en=0100
        // -----------------------------------------------------
        sram_write(
            14'd0,
            4'b0100,
            32'h00AA0000,
            32'h00BB0000,
            32'h00CC0000
        );

        // Read the complete word back through Port B
        sram_read(14'd0);

        $display("Readback R = %08h", sram_r_rdata);
        $display("Readback G = %08h", sram_g_rdata);
        $display("Readback B = %08h", sram_b_rdata);

        assert (sram_r_rdata == 32'h11AA3344)
            else $fatal(1, "Red SRAM readback mismatch");

        assert (sram_g_rdata == 32'h55BB7788)
            else $fatal(1, "Green SRAM readback mismatch");

        assert (sram_b_rdata == 32'h99CCBBCC)
            else $fatal(1, "Blue SRAM readback mismatch");

        $display("Port-B byte-write test PASSED");

        // -----------------------------------------------------
        // Start the Sequencer
        // -----------------------------------------------------
        @(negedge wr_clk);
        start = 1'b1;

        @(negedge wr_clk);
        start = 1'b0;

        wait (transfer_done == 1'b1);
        repeat (2) @(posedge wr_clk);

        assert (pixel_count == 4)
            else $fatal(
                1,
                "Expected 4 pixels, observed %0d",
                pixel_count
            );

        // Pixel 0 remained unchanged
        assert (observed_pixels[0] == 24'h115599)
            else $fatal(
                1,
                "Pixel 0 mismatch: %06h",
                observed_pixels[0]
            );

        // Pixel 1 was modified through Port B
        assert (observed_pixels[1] == 24'hAABBCC)
            else $fatal(
                1,
                "Pixel 1 mismatch: %06h",
                observed_pixels[1]
            );

        // Pixels 2 and 3 remained unchanged
        assert (observed_pixels[2] == 24'h3377BB)
            else $fatal(
                1,
                "Pixel 2 mismatch: %06h",
                observed_pixels[2]
            );

        assert (observed_pixels[3] == 24'h4488CC)
            else $fatal(
                1,
                "Pixel 3 mismatch: %06h",
                observed_pixels[3]
            );

        assert (!fifo_error)
            else $fatal(1, "FIFO error asserted");

        $display("========================================");
        $display("seq_img_cluster SRAM test PASSED");
        $display("========================================");

        $finish;
    end

    // Timeout
    initial begin
        #10000;
        $fatal(1, "Simulation timeout");
    end

endmodule