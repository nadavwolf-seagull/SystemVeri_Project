`timescale 1ns / 1ps

module tb_image_burst_rx_deinterleaver;

    logic clk;
    logic rst_n;

    logic        start;
    logic [15:0] img_width;
    logic [15:0] img_height;

    logic [7:0] rx_byte;
    logic       rx_byte_valid;

    logic fifo_ready;

    logic        fifo_push;
    logic [31:0] fifo_r_data;
    logic [31:0] fifo_g_data;
    logic [31:0] fifo_b_data;

    logic payload_active;
    logic payload_ready;
    logic payload_done;
    logic payload_error;

    int unsigned observed_push_count;

    // ========================================================
    // DUT
    // ========================================================

    image_burst_rx_deinterleaver dut (
        .clk            (clk),
        .rst_n          (rst_n),

        .start          (start),
        .img_width      (img_width),
        .img_height     (img_height),

        .rx_byte        (rx_byte),
        .rx_byte_valid  (rx_byte_valid),

        .fifo_ready     (fifo_ready),

        .fifo_push      (fifo_push),
        .fifo_r_data    (fifo_r_data),
        .fifo_g_data    (fifo_g_data),
        .fifo_b_data    (fifo_b_data),

        .payload_active (payload_active),
        .payload_ready  (payload_ready),
        .payload_done   (payload_done),
        .payload_error  (payload_error)
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
        $dumpfile(
            "tb/tb_image_burst_rx_deinterleaver.vcd"
        );

        $dumpvars(
            0,
            tb_image_burst_rx_deinterleaver
        );
    end

    // ========================================================
    // Push counter
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            observed_push_count <= 0;
        end
        else if (fifo_push) begin
            observed_push_count <= observed_push_count + 1;
        end
    end

    // ========================================================
    // Reset task
    // ========================================================

    task automatic apply_reset;
        begin
            rst_n         = 1'b0;
            start         = 1'b0;

            img_width     = '0;
            img_height    = '0;

            rx_byte       = '0;
            rx_byte_valid = 1'b0;

            fifo_ready    = 1'b1;

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
    // Image-start task
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
    // UART-byte task
    // ========================================================

    task automatic send_byte(
        input logic [7:0] data
    );
        begin
            wait (payload_ready === 1'b1);

            @(negedge clk);

            rx_byte       = data;
            rx_byte_valid = 1'b1;

            @(negedge clk);

            rx_byte_valid = 1'b0;
            rx_byte       = '0;
        end
    endtask

    // ========================================================
    // RGB-pixel task
    // ========================================================

    task automatic send_pixel(
        input logic [7:0] red,
        input logic [7:0] green,
        input logic [7:0] blue
    );
        begin
            send_byte(red);
            send_byte(green);
            send_byte(blue);
        end
    endtask

    // ========================================================
    // FIFO-push checker
    // ========================================================

    task automatic expect_fifo_push(
        input logic [31:0] expected_r,
        input logic [31:0] expected_g,
        input logic [31:0] expected_b,
        input logic        expected_done
    );
        begin
            wait (fifo_push === 1'b1);

            #1;

            $display(
                "[%0t] FIFO push: R=%08h G=%08h B=%08h done=%0b",
                $time,
                fifo_r_data,
                fifo_g_data,
                fifo_b_data,
                payload_done
            );

            if (fifo_r_data !== expected_r) begin
                $fatal(
                    1,
                    "R mismatch: expected=%08h actual=%08h",
                    expected_r,
                    fifo_r_data
                );
            end

            if (fifo_g_data !== expected_g) begin
                $fatal(
                    1,
                    "G mismatch: expected=%08h actual=%08h",
                    expected_g,
                    fifo_g_data
                );
            end

            if (fifo_b_data !== expected_b) begin
                $fatal(
                    1,
                    "B mismatch: expected=%08h actual=%08h",
                    expected_b,
                    fifo_b_data
                );
            end

            if (payload_done !== expected_done) begin
                $fatal(
                    1,
                    "payload_done mismatch: expected=%0b actual=%0b",
                    expected_done,
                    payload_done
                );
            end

            @(negedge clk);
        end
    endtask

    // ========================================================
    // Main test
    // ========================================================

    initial begin
        apply_reset();

        // ====================================================
        // TEST 1
        // Complete group of four pixels
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 1: Complete four-pixel group");
        $display("========================================");

        start_image(16'd4, 16'd1);

        wait (payload_active === 1'b1);

        if (payload_ready !== 1'b1) begin
            $fatal(
                1,
                "payload_ready must be high after valid start"
            );
        end

        send_pixel(8'h11, 8'h21, 8'h31);
        send_pixel(8'h12, 8'h22, 8'h32);
        send_pixel(8'h13, 8'h23, 8'h33);
        send_pixel(8'h14, 8'h24, 8'h34);

        expect_fifo_push(
            32'h11121314,
            32'h21222324,
            32'h31323334,
            1'b1
        );

        if (payload_active !== 1'b0) begin
            $fatal(
                1,
                "payload_active did not clear after final push"
            );
        end

        if (payload_error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected payload_error in TEST 1"
            );
        end

        // ====================================================
        // TEST 2
        // Partial group of three pixels
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 2: Partial three-pixel group");
        $display("========================================");

        start_image(16'd3, 16'd1);

        wait (payload_active === 1'b1);

        send_pixel(8'hA1, 8'hB1, 8'hC1);
        send_pixel(8'hA2, 8'hB2, 8'hC2);
        send_pixel(8'hA3, 8'hB3, 8'hC3);

        expect_fifo_push(
            32'hA1A2A300,
            32'hB1B2B300,
            32'hC1C2C300,
            1'b1
        );

        if (payload_active !== 1'b0) begin
            $fatal(
                1,
                "payload_active did not clear in TEST 2"
            );
        end

        if (payload_error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected payload_error in TEST 2"
            );
        end

        // ====================================================
        // TEST 3
        // FIFO backpressure
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 3: FIFO backpressure");
        $display("========================================");

        fifo_ready = 1'b0;

        start_image(16'd4, 16'd1);

        wait (payload_active === 1'b1);

        send_pixel(8'h41, 8'h51, 8'h61);
        send_pixel(8'h42, 8'h52, 8'h62);
        send_pixel(8'h43, 8'h53, 8'h63);
        send_pixel(8'h44, 8'h54, 8'h64);

        wait (payload_ready === 1'b0);

        repeat (3) begin
            @(posedge clk);

            if (fifo_push !== 1'b0) begin
                $fatal(
                    1,
                    "fifo_push asserted while fifo_ready was low"
                );
            end
        end

        @(negedge clk);
        fifo_ready = 1'b1;

        expect_fifo_push(
            32'h41424344,
            32'h51525354,
            32'h61626364,
            1'b1
        );

        if (payload_error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected payload_error during legal backpressure"
            );
        end

        // ====================================================
        // TEST 4
        // Invalid zero-width image
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 4: Invalid zero-width image");
        $display("========================================");

        start_image(16'd0, 16'd4);

        if (payload_error !== 1'b1) begin
            $fatal(
                1,
                "Expected payload_error for zero-width image"
            );
        end

        if (payload_active !== 1'b0) begin
            $fatal(
                1,
                "Invalid image entered payload-active state"
            );
        end

        // ====================================================
        // Final checks
        // ====================================================

        if (observed_push_count !== 3) begin
            $fatal(
                1,
                "Expected exactly 3 FIFO pushes, observed %0d",
                observed_push_count
            );
        end

        $display("");
        $display("========================================");
        $display("All RX deinterleaver tests PASSED");
        $display("========================================");

        $finish;
    end

    // ========================================================
    // Timeout protection
    // ========================================================

    initial begin
        #200000;

        $fatal(
            1,
            "Simulation timeout"
        );
    end

endmodule