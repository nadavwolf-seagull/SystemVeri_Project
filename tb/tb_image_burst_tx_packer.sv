`timescale 1ns / 1ps

module tb_image_burst_tx_packer;

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

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb/tb_image_burst_tx_packer.vcd");
        $dumpvars(0, tb_image_burst_tx_packer);
    end

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

    task automatic expect_packet(
        input logic [MAX_PACKET_WIDTH-1:0] expected_data,
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

            if (packet_len !== PACKET_LEN_WIDTH'(12)) begin
                $fatal(
                    1,
                    "Packet length mismatch: expected=12 actual=%0d",
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

    initial begin
        apply_reset();

        $display("");
        $display("========================================");
        $display("TEST 1: Valid 16-pixel image");
        $display("========================================");

        start_image(16'd16, 16'd1);
        wait (active === 1'b1);

        /*
         * Keep FIFO empty briefly and verify the DUT does not
         * request data that is not available.
         */
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
            32'h11121314,
            32'h21222324,
            32'h31323334,
            1
        );

        expect_packet(
            96'h112131_122232_132333_142434,
            2
        );

        complete_packet(1'b0);

        if (active !== 1'b1) begin
            $fatal(
                1,
                "active cleared after first packet"
            );
        end

        supply_fifo_word(
            32'h15161718,
            32'h25262728,
            32'h35363738,
            0
        );

        expect_packet(
            96'h152535_162636_172737_182838,
            0
        );

        complete_packet(1'b0);

        supply_fifo_word(
            32'h191A1B1C,
            32'h292A2B2C,
            32'h393A3B3C,
            2
        );

        expect_packet(
            96'h192939_1A2A3A_1B2B3B_1C2C3C,
            3
        );

        complete_packet(1'b0);

        supply_fifo_word(
            32'h1D1E1F20,
            32'h2D2E2F30,
            32'h3D3E3F40,
            1
        );

        expect_packet(
            96'h1D2D3D_1E2E3E_1F2F3F_203040,
            1
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
        $display("TEST 2: Invalid non-multiple-of-16 width");
        $display("========================================");

        apply_reset();

        start_image(16'd5, 16'd1);

        wait (error === 1'b1);
        #1;

        if (error !== 1'b1) begin
            $fatal(
                1,
                "Expected error for width not divisible by 16"
            );
        end

        if (active !== 1'b0) begin
            $fatal(
                1,
                "Invalid width entered active state"
            );
        end

        if (fifo_pop !== 1'b0) begin
            $fatal(
                1,
                "fifo_pop asserted for invalid width"
            );
        end

        $display("");
        $display("========================================");
        $display("TEST 3: Invalid zero-height image");
        $display("========================================");

        apply_reset();

        start_image(16'd16, 16'd0);

        wait (error === 1'b1);
        #1;

        if (error !== 1'b1) begin
            $fatal(
                1,
                "Expected error for zero-height image"
            );
        end

        if (active !== 1'b0) begin
            $fatal(
                1,
                "Zero-height image entered active state"
            );
        end

        $display("");
        $display("========================================");
        $display("All TX packer tests PASSED");
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
