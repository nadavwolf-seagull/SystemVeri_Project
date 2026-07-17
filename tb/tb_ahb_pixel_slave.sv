`timescale 1ns / 1ps

module tb_ahb_pixel_slave;

    localparam int SRAM_ADDR_W = 14;

    logic clk;
    logic rst_n;

    // =========================================================
    // AHB-Lite
    // =========================================================
    logic [31:0] haddr;
    logic [1:0]  htrans;
    logic        hwrite;
    logic [2:0]  hsize;
    logic [31:0] hwdata;

    logic [31:0] hrdata;
    logic        hready;
    logic        hresp;

    // =========================================================
    // SRAM Port-B
    // =========================================================
    logic                   sram_bus_en;
    logic                   sram_bus_write;
    logic [SRAM_ADDR_W-1:0] sram_bus_addr;

    logic [31:0] sram_r_wdata;
    logic [31:0] sram_g_wdata;
    logic [31:0] sram_b_wdata;

    logic [3:0] sram_byte_en;

    logic [31:0] sram_r_rdata;
    logic [31:0] sram_g_rdata;
    logic [31:0] sram_b_rdata;

    // Unused Sequencer port
    logic [31:0] seq_r_data;
    logic [31:0] seq_g_data;
    logic [31:0] seq_b_data;

    logic [31:0] read_data;

    // =========================================================
    // Clock
    // =========================================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // =========================================================
    // AHB Pixel Slave
    // =========================================================
    ahb_pixel_slave #(
        .HADDR_WIDTH (32),
        .HDATA_WIDTH (32),
        .SRAM_ADDR_W (SRAM_ADDR_W)
    ) u_ahb_pixel_slave (
        .HCLK           (clk),
        .HRESETn        (rst_n),

        // Master -> Slave
        .HADDR          (haddr),
        .HTRANS         (htrans),
        .HWRITE         (hwrite),
        .HSIZE          (hsize),
        .HWDATA         (hwdata),

        // Slave -> Master
        .HRDATA         (hrdata),
        .HREADY         (hready),
        .HRESP          (hresp),

        // RGB SRAM Port B
        .sram_bus_en    (sram_bus_en),
        .sram_bus_write (sram_bus_write),
        .sram_bus_addr  (sram_bus_addr),

        .sram_r_wdata   (sram_r_wdata),
        .sram_g_wdata   (sram_g_wdata),
        .sram_b_wdata   (sram_b_wdata),

        .sram_byte_en   (sram_byte_en),

        .sram_r_rdata   (sram_r_rdata),
        .sram_g_rdata   (sram_g_rdata),
        .sram_b_rdata   (sram_b_rdata)
    );

    // =========================================================
    // RGB SRAM Subsystem
    // =========================================================
    rgb_sram_subsystem #(
        .SRAM_DEPTH      (16384),
        .WORD_WIDTH      (32),
        .ADDR_WIDTH      (SRAM_ADDR_W),

        .RED_INIT_FILE   ("red_hex.mem"),
        .GREEN_INIT_FILE ("green_hex.mem"),
        .BLUE_INIT_FILE  ("blue_hex.mem")
    ) u_rgb_sram_subsystem (
        .clk_i            (clk),

        // Unused Sequencer read port
        .seq_addr_i       ('0),
        .seq_r_data_o     (seq_r_data),
        .seq_g_data_o     (seq_g_data),
        .seq_b_data_o     (seq_b_data),

        // AHB-side SRAM port
        .bus_en_i         (sram_bus_en),
        .bus_write_i      (sram_bus_write),
        .bus_addr_i       (sram_bus_addr),

        .bus_r_wdata_i    (sram_r_wdata),
        .bus_g_wdata_i    (sram_g_wdata),
        .bus_b_wdata_i    (sram_b_wdata),

        .bus_byte_en_i    (sram_byte_en),

        .bus_r_rdata_o    (sram_r_rdata),
        .bus_g_rdata_o    (sram_g_rdata),
        .bus_b_rdata_o    (sram_b_rdata)
    );

    // =========================================================
    // AHB Write Task
    // =========================================================
    task automatic ahb_write_pixel(
        input logic [31:0] address,
        input logic [7:0]  red,
        input logic [7:0]  green,
        input logic [7:0]  blue
    );
        begin
            // Wait until slave is ready
            wait (hready == 1'b1);

            @(negedge clk);

            haddr  = address;
            htrans = 2'b10; // NONSEQ
            hwrite = 1'b1;
            hsize  = 3'b010; // 32-bit word
            hwdata = {8'h00, red, green, blue};

            // Address phase captured by slave
            @(posedge clk);
            #1;

            assert (hready == 1'b0)
                else $fatal(
                    1,
                    "Expected HREADY low during write wait state"
                );

            assert (sram_bus_en == 1'b1)
                else $fatal(
                    1,
                    "SRAM bus enable not asserted during write"
                );

            assert (sram_bus_write == 1'b1)
                else $fatal(
                    1,
                    "SRAM write enable not asserted"
                );

            // Write completes at this rising edge
            @(posedge clk);
            #1;

            assert (hready == 1'b1)
                else $fatal(
                    1,
                    "Write transfer did not complete"
                );

            assert (hresp == 1'b0)
                else $fatal(
                    1,
                    "Unexpected HRESP during valid write"
                );

            // Return bus to IDLE
            @(negedge clk);

            haddr  = 32'd0;
            htrans = 2'b00;
            hwrite = 1'b0;
            hwdata = 32'd0;

            // Allow slave to return to ST_IDLE
            @(posedge clk);
            #1;
        end
    endtask

    // =========================================================
    // AHB Read Task
    // =========================================================
    task automatic ahb_read_pixel(
        input  logic [31:0] address,
        output logic [31:0] data
    );
        begin
            // Wait until slave is ready
            wait (hready == 1'b1);

            @(negedge clk);

            haddr  = address;
            htrans = 2'b10; // NONSEQ
            hwrite = 1'b0;
            hsize  = 3'b010; // 32-bit word
            hwdata = 32'd0;

            // Address phase captured by slave
            @(posedge clk);
            #1;

            assert (hready == 1'b0)
                else $fatal(
                    1,
                    "Expected HREADY low during read wait state"
                );

            assert (sram_bus_en == 1'b1)
                else $fatal(
                    1,
                    "SRAM bus enable not asserted during read"
                );

            assert (sram_bus_write == 1'b0)
                else $fatal(
                    1,
                    "SRAM write unexpectedly asserted during read"
                );

            // SRAM synchronous read completes
            @(posedge clk);
            #1;

            assert (hready == 1'b1)
                else $fatal(
                    1,
                    "Read transfer did not complete"
                );

            assert (hresp == 1'b0)
                else $fatal(
                    1,
                    "Unexpected HRESP during valid read"
                );

            data = hrdata;

            // Return bus to IDLE
            @(negedge clk);

            haddr  = 32'd0;
            htrans = 2'b00;
            hwrite = 1'b0;

            // Allow slave to return to ST_IDLE
            @(posedge clk);
            #1;
        end
    endtask

    // =========================================================
    // Main Test
    // =========================================================
    initial begin
        rst_n  = 1'b0;

        haddr  = 32'd0;
        htrans = 2'b00;
        hwrite = 1'b0;
        hsize  = 3'b010;
        hwdata = 32'd0;

        repeat (4) @(posedge clk);

        @(negedge clk);
        rst_n = 1'b1;

        repeat (2) @(posedge clk);

        assert (hready == 1'b1)
            else $fatal(
                1,
                "Slave not ready after reset"
            );

        // -----------------------------------------------------
        // Pixel 0 -> word 0, bits [31:24]
        // -----------------------------------------------------
        ahb_write_pixel(
            32'h0000_0000,
            8'h11,
            8'h22,
            8'h33
        );

        // -----------------------------------------------------
        // Pixel 1 -> word 0, bits [23:16]
        // -----------------------------------------------------
        ahb_write_pixel(
            32'h0000_0004,
            8'h44,
            8'h55,
            8'h66
        );

        // -----------------------------------------------------
        // Pixel 2 -> word 0, bits [15:8]
        // -----------------------------------------------------
        ahb_write_pixel(
            32'h0000_0008,
            8'h77,
            8'h88,
            8'h99
        );

        // -----------------------------------------------------
        // Pixel 3 -> word 0, bits [7:0]
        // -----------------------------------------------------
        ahb_write_pixel(
            32'h0000_000C,
            8'hAA,
            8'hBB,
            8'hCC
        );

        // =====================================================
        // Verify physical SRAM packing
        // =====================================================
        assert (
            u_rgb_sram_subsystem.red_sram[0] ==
            32'h114477AA
        )
        else $fatal(
            1,
            "Red SRAM word mismatch: %08h",
            u_rgb_sram_subsystem.red_sram[0]
        );

        assert (
            u_rgb_sram_subsystem.green_sram[0] ==
            32'h225588BB
        )
        else $fatal(
            1,
            "Green SRAM word mismatch: %08h",
            u_rgb_sram_subsystem.green_sram[0]
        );

        assert (
            u_rgb_sram_subsystem.blue_sram[0] ==
            32'h336699CC
        )
        else $fatal(
            1,
            "Blue SRAM word mismatch: %08h",
            u_rgb_sram_subsystem.blue_sram[0]
        );

        $display("AHB write mapping PASSED");

        // =====================================================
        // Read Pixel 0
        // =====================================================
        ahb_read_pixel(
            32'h0000_0000,
            read_data
        );

        assert (read_data == 32'h00112233)
            else $fatal(
                1,
                "Pixel 0 read mismatch: %08h",
                read_data
            );

        // =====================================================
        // Read Pixel 1
        // =====================================================
        ahb_read_pixel(
            32'h0000_0004,
            read_data
        );

        assert (read_data == 32'h00445566)
            else $fatal(
                1,
                "Pixel 1 read mismatch: %08h",
                read_data
            );

        // =====================================================
        // Read Pixel 2
        // =====================================================
        ahb_read_pixel(
            32'h0000_0008,
            read_data
        );

        assert (read_data == 32'h00778899)
            else $fatal(
                1,
                "Pixel 2 read mismatch: %08h",
                read_data
            );

        // =====================================================
        // Read Pixel 3
        // =====================================================
        ahb_read_pixel(
            32'h0000_000C,
            read_data
        );

        assert (read_data == 32'h00AABBCC)
            else $fatal(
                1,
                "Pixel 3 read mismatch: %08h",
                read_data
            );

        $display("AHB pixel readback PASSED");
        $display("========================================");
        $display("AHB Pixel Slave test PASSED");
        $display("========================================");

        $finish;
    end

    // =========================================================
    // Timeout
    // =========================================================
    initial begin
        #10000;
        $fatal(
            1,
            "Simulation timeout"
        );
    end

endmodule