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

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb/tb_image_burst_rx_deinterleaver.vcd");
        $dumpvars(0, tb_image_burst_rx_deinterleaver);
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            observed_push_count <= 0;
        end
        else if (fifo_push) begin
            observed_push_count <= observed_push_count + 1;
        end
    end

    task automatic apply_reset;
        begin
            rst_n         = 1'b0;
            start         = 1'b0;
            img_width     = '0;
            img_height    = '0;
            rx_byte       = '0;
            rx_byte_valid = 1'b0;
            fifo_ready    = 1'b1;

            repeat (4) @(posedge clk);

            @(negedge clk);
            rst_n = 1'b1;

            repeat (2) @(posedge clk);
        end
    endtask

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

            /*
            * fifo_push is combinational. For the final group,
            * payload_done is generated on the following rising edge,
            * after the FIFO samples the push and RGB data.
            */
            if (!expected_done) begin
                if (payload_done !== 1'b0) begin
                    $fatal(
                        1,
                        "payload_done asserted before final group"
                    );
                end

                @(negedge clk);
            end
            else begin
                if (payload_done !== 1'b0) begin
                    $fatal(
                        1,
                        "payload_done asserted too early during final push"
                    );
                end

                @(posedge clk);
                #1;

                if (payload_done !== 1'b1) begin
                    $fatal(
                        1,
                        "payload_done was not asserted after final FIFO push"
                    );
                end

                if (payload_active !== 1'b0) begin
                    $fatal(
                        1,
                        "payload_active did not clear after final FIFO push"
                    );
                end

                @(negedge clk);
            end
        end
    endtask

    initial begin
        apply_reset();

        $display("");
        $display("========================================");
        $display("TEST 1: Valid 16-pixel image");
        $display("========================================");

        start_image(16'd16, 16'd1);

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
            1'b0
        );

        send_pixel(8'h15, 8'h25, 8'h35);
        send_pixel(8'h16, 8'h26, 8'h36);
        send_pixel(8'h17, 8'h27, 8'h37);
        send_pixel(8'h18, 8'h28, 8'h38);

        expect_fifo_push(
            32'h15161718,
            32'h25262728,
            32'h35363738,
            1'b0
        );

        send_pixel(8'h19, 8'h29, 8'h39);
        send_pixel(8'h1A, 8'h2A, 8'h3A);
        send_pixel(8'h1B, 8'h2B, 8'h3B);
        send_pixel(8'h1C, 8'h2C, 8'h3C);

        expect_fifo_push(
            32'h191A1B1C,
            32'h292A2B2C,
            32'h393A3B3C,
            1'b0
        );

        send_pixel(8'h1D, 8'h2D, 8'h3D);
        send_pixel(8'h1E, 8'h2E, 8'h3E);
        send_pixel(8'h1F, 8'h2F, 8'h3F);
        send_pixel(8'h20, 8'h30, 8'h40);

        expect_fifo_push(
            32'h1D1E1F20,
            32'h2D2E2F30,
            32'h3D3E3F40,
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

        $display("");
        $display("========================================");
        $display("TEST 2: FIFO backpressure");
        $display("========================================");

        apply_reset();

        start_image(16'd16, 16'd1);
        wait (payload_active === 1'b1);

        @(negedge clk);
        fifo_ready = 1'b0;

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

            if (fifo_r_data !== 32'h41424344 ||
                fifo_g_data !== 32'h51525354 ||
                fifo_b_data !== 32'h61626364) begin
                $fatal(
                    1,
                    "FIFO data changed during backpressure"
                );
            end
        end

        @(negedge clk);
        fifo_ready = 1'b1;

        expect_fifo_push(
            32'h41424344,
            32'h51525354,
            32'h61626364,
            1'b0
        );

        send_pixel(8'h45, 8'h55, 8'h65);
        send_pixel(8'h46, 8'h56, 8'h66);
        send_pixel(8'h47, 8'h57, 8'h67);
        send_pixel(8'h48, 8'h58, 8'h68);

        expect_fifo_push(
            32'h45464748,
            32'h55565758,
            32'h65666768,
            1'b0
        );

        send_pixel(8'h49, 8'h59, 8'h69);
        send_pixel(8'h4A, 8'h5A, 8'h6A);
        send_pixel(8'h4B, 8'h5B, 8'h6B);
        send_pixel(8'h4C, 8'h5C, 8'h6C);

        expect_fifo_push(
            32'h494A4B4C,
            32'h595A5B5C,
            32'h696A6B6C,
            1'b0
        );

        send_pixel(8'h4D, 8'h5D, 8'h6D);
        send_pixel(8'h4E, 8'h5E, 8'h6E);
        send_pixel(8'h4F, 8'h5F, 8'h6F);
        send_pixel(8'h50, 8'h60, 8'h70);

        expect_fifo_push(
            32'h4D4E4F50,
            32'h5D5E5F60,
            32'h6D6E6F70,
            1'b1
        );

        if (payload_error !== 1'b0) begin
            $fatal(
                1,
                "Unexpected payload_error during legal backpressure"
            );
        end

        $display("");
        $display("========================================");
        $display("TEST 3: Invalid non-multiple-of-16 width");
        $display("========================================");

        apply_reset();

        start_image(16'd4, 16'd1);

        if (payload_error !== 1'b1) begin
            $fatal(
                1,
                "Expected payload_error for width not divisible by 16"
            );
        end

        if (payload_active !== 1'b0) begin
            $fatal(
                1,
                "Invalid width entered payload-active state"
            );
        end

        $display("");
        $display("========================================");
        $display("TEST 4: Invalid zero dimensions");
        $display("========================================");

        apply_reset();

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
                "Zero-width image entered payload-active state"
            );
        end

        if (observed_push_count !== 0) begin
            $fatal(
                1,
                "Push counter was not reset before final test"
            );
        end

        $display("");
        $display("========================================");
        $display("All RX deinterleaver tests PASSED");
        $display("========================================");

        $finish;
    end

    initial begin
        #400000;

        $fatal(
            1,
            "Simulation timeout"
        );
    end

endmodule