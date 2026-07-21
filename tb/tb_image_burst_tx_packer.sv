`timescale 1ns / 1ps

module tb_image_burst_tx_packer;

    localparam int unsigned MAX_PACKET_BYTES =
        lab12_pkg::UART_TX_MAX_PACKET_BYTES;

    localparam int unsigned MAX_PACKET_WIDTH =
        lab12_pkg::UART_TX_MAX_PACKET_WIDTH;

    localparam int unsigned PACKET_LEN_WIDTH =
        lab12_pkg::UART_TX_PACKET_LEN_WIDTH;

    logic clk;
    logic rst_n;

    logic        start;
    logic [15:0] img_width;
    logic [15:0] img_height;

    logic        fifo_pop;
    logic [31:0] fifo_r_data;
    logic [31:0] fifo_g_data;
    logic [31:0] fifo_b_data;
    logic        fifo_data_valid;
    logic        fifo_empty;

    logic                        packet_valid;
    logic [MAX_PACKET_WIDTH-1:0] packet_data;
    logic [PACKET_LEN_WIDTH-1:0] packet_len;
    logic                        packet_ready;
    logic                        packet_done;

    logic active;
    logic done;
    logic error;

    int unsigned observed_pop_count;
    int unsigned observed_packet_count;

    // ========================================================
    // DUT
    // ========================================================

    image_burst_tx_packer dut (
        .clk             (clk),
        .rst_n           (rst_n),

        .start           (start),
        .img_width       (img_width),
        .img_height      (img_height),

        .fifo_pop        (fifo_pop),
        .fifo_r_data     (fifo_r_data),
        .fifo_g_data     (fifo_g_data),
        .fifo_b_data     (fifo_b_data),
        .fifo_data_valid (fifo_data_valid),
        .fifo_empty      (fifo_empty),

        .packet_valid    (packet_valid),
        .packet_data     (packet_data),
        .packet_len      (packet_len),
        .packet_ready    (packet_ready),
        .packet_done     (packet_done),

        .active          (active),
        .done            (done),
        .error           (error)
    );

    // ========================================================
    // Clock
    // ========================================================

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end

    // ========================================================
    // Waveform
    // ========================================================

    initial begin
        $dumpfile("tb/tb_image_burst_tx_packer.vcd");
        $dumpvars(0, tb_image_burst_tx_packer);
    end

    // ========================================================
    // Counters
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            observed_pop_count    <= 0;
            observed_packet_count <= 0;
        end
        else begin
            if (fifo_pop) begin
                observed_pop_count <= observed_pop_count + 1;
            end

            if (packet_valid && packet_ready) begin
                observed_packet_count <=
                    observed_packet_count + 1;
            end
        end
    end

    // ========================================================
    // Reset
    // ========================================================

    task automatic apply_reset;
        begin
            rst_n = 1'b0;

            start      = 1'b0;
            img_width  = '0;
            img_height = '0;

            fifo_r_data     = '0;
            fifo_g_data     = '0;
            fifo_b_data     = '0;
            fifo_data_valid = 1'b0;
            fifo_empty      = 1'b1;

            packet_ready = 1'b0;
            packet_done  = 1'b0;

            repeat (4) begin
                @(posedge clk);
            end

            @(negedge clk);
            rst_n = 1'b1;

            repeat (2) begin
                @(posedge clk);
            end
        end
    endtask

    // ========================================================
    // Start image transmission
    // ========================================================

    task automatic start_image(
        input logic [15:0] width,
        input logic [15:0] height
    );
        begin
            @(negedge clk);

            img_width  = width;
            img_height = height;
            start      = 1'b1;

            @(negedge clk);

            start = 1'b0;
        end
    endtask

    // ========================================================
    // Supply one planar RGB FIFO word
    // ========================================================

    task automatic supply_fifo_word(
        input logic [31:0] red_word,
        input logic [31:0] green_word,
        input logic [31:0] blue_word,
        input int unsigned valid_delay_cycles
    );
        begin
            fifo_empty = 1'b0;

            wait (fifo_pop === 1'b1);

            @(negedge clk);
            fifo_empty = 1'b1;

            repeat (valid_delay_cycles) begin
                @(posedge clk);
            end

            @(negedge clk);

            fifo_r_data     = red_word;
            fifo_g_data     = green_word;
            fifo_b_data     = blue_word;
            fifo_data_valid = 1'b1;

            @(negedge clk);

            fifo_data_valid = 1'b0;
        end
    endtask

    // ========================================================
    // Check and accept one UART packet
    // ========================================================

    task automatic expect_packet(
        input logic [MAX_PACKET_WIDTH-1:0] expected_data,
        input int unsigned                 expected_len,
        input int unsigned                 ready_delay_cycles
    );
        logic [MAX_PACKET_WIDTH-1:0] held_data;
        logic [PACKET_LEN_WIDTH-1:0] held_len;

        begin
            packet_ready = 1'b0;

            wait (packet_valid === 1'b1);
            #1;

            held_data = packet_data;
            held_len  = packet_len;

            if (packet_data !== expected_data) begin
                $fatal(
                    1,
                    "Packet data mismatch: expected=%024h actual=%024h",
                    expected_data,
                    packet_data
                );
            end

            if (packet_len !== PACKET_LEN_WIDTH'(expected_len)) begin
                $fatal(
                    1,
                    "Packet length mismatch: expected=%0d actual=%0d",
                    expected_len,
                    packet_len
                );
            end

            repeat (ready_delay_cycles) begin
                @(posedge clk);
                #1;

                if (packet_valid !== 1'b1) begin
                    $fatal(
                        1,
                        "packet_valid dropped before packet_ready"
                    );
                end

                if (packet_data !== held_data) begin
                    $fatal(
                        1,
                        "packet_data changed while waiting for ready"
                    );
                end

                if (packet_len !== held_len) begin
                    $fatal(
                        1,
                        "packet_len changed while waiting for ready"
                    );
                end
            end

            $display(
                "[%0t] Packet accepted: len=%0d data=%024h",
                $time,
                packet_len,
                packet_data
            );

            @(negedge clk);
            packet_ready = 1'b1;

            @(posedge clk);
            #1;

            @(negedge clk);
            packet_ready = 1'b0;
        end
    endtask

    // ========================================================
    // Signal UART packet completion
    // ========================================================

    task automatic complete_packet(
        input logic expect_final_done
    );
        begin
            repeat (2) begin
                @(posedge clk);

                if (done !== 1'b0) begin
                    $fatal(
                        1,
                        "done asserted before packet_done"
                    );
                end
            end

            @(negedge clk);
            packet_done = 1'b1;

            @(posedge clk);
            #1;

            if (done !== expect_final_done) begin
                $fatal(
                    1,
                    "done mismatch: expected=%0b actual=%0b",
                    expect_final_done,
                    done
                );
            end

            @(negedge clk);
            packet_done = 1'b0;
        end
    endtask

    // ========================================================
    // Main test
    // ========================================================

    initial begin
        apply_reset();

        // ====================================================
        // TEST 1
        // Complete packet of four pixels
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 1: Complete four-pixel packet");
        $display("========================================");

        start_image(16'd4, 16'd1);

        wait (active === 1'b1);

        supply_fifo_word(
            32'h11121314,
            32'h21222324,
            32'h31323334,
            1
        );

        expect_packet(
            96'h112131_122232_132333_142434,
            12,
            2
        );

        complete_packet(1'b1);

        if (active !== 1'b0) begin
            $fatal(
                1,
                "active did not clear after final packet"
            );
        end

        if (error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected error in TEST 1"
            );
        end

        // ====================================================
        // TEST 2
        // Partial packet of three pixels
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 2: Partial three-pixel packet");
        $display("========================================");

        start_image(16'd3, 16'd1);

        wait (active === 1'b1);

        supply_fifo_word(
            32'hA1A2A300,
            32'hB1B2B300,
            32'hC1C2C300,
            0
        );

        expect_packet(
            96'hA1B1C1_A2B2C2_A3B3C3_000000,
            9,
            0
        );

        complete_packet(1'b1);

        if (error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected error in TEST 2"
            );
        end

        // ====================================================
        // TEST 3
        // Five pixels require two FIFO words and two packets
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 3: Five pixels across two packets");
        $display("========================================");

        start_image(16'd5, 16'd1);

        wait (active === 1'b1);

        /*
         * Keep FIFO empty for several cycles and verify that
         * the DUT does not request unavailable data.
         */
        fifo_empty = 1'b1;

        repeat (3) begin
            @(posedge clk);
            #1;

            if (fifo_pop !== 1'b0) begin
                $fatal(
                    1,
                    "fifo_pop asserted while fifo_empty was high"
                );
            end
        end

        supply_fifo_word(
            32'h41424344,
            32'h51525354,
            32'h61626364,
            2
        );

        expect_packet(
            96'h415161_425262_435363_445464,
            12,
            1
        );

        complete_packet(1'b0);

        if (active !== 1'b1) begin
            $fatal(
                1,
                "active cleared before the second packet"
            );
        end

        supply_fifo_word(
            32'h45000000,
            32'h55000000,
            32'h65000000,
            1
        );

        expect_packet(
            96'h455565_000000_000000_000000,
            3,
            2
        );

        complete_packet(1'b1);

        if (active !== 1'b0) begin
            $fatal(
                1,
                "active did not clear after second packet"
            );
        end

        if (error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected error in TEST 3"
            );
        end

        // ====================================================
        // TEST 4
        // Invalid zero-height image
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 4: Invalid zero-height image");
        $display("========================================");

        start_image(16'd4, 16'd0);

        if (error !== 1'b1) begin
            $fatal(
                1,
                "Expected error for zero-height image"
            );
        end

        if (active !== 1'b0) begin
            $fatal(
                1,
                "Invalid image entered active state"
            );
        end

        // ====================================================
        // Final checks
        // ====================================================

        if (observed_pop_count !== 4) begin
            $fatal(
                1,
                "Expected 4 FIFO pops, observed %0d",
                observed_pop_count
            );
        end

        if (observed_packet_count !== 4) begin
            $fatal(
                1,
                "Expected 4 accepted packets, observed %0d",
                observed_packet_count
            );
        end

        $display("");
        $display("========================================");
        $display("All TX packer tests PASSED");
        $display("========================================");

        $finish;
    end

    // ========================================================
    // Timeout
    // ========================================================

    initial begin
        #300000;

        $fatal(
            1,
            "Simulation timeout"
        );
    end

endmodule