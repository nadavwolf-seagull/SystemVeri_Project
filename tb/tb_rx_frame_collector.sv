`timescale 1ns / 1ps

module tb_rx_frame_collector;

    localparam int unsigned MAX_FRAME_BYTES = 8;

    logic clk;
    logic rst_n;

    logic [7:0] rx_byte;
    logic       rx_byte_valid;
    logic       framing_err;
    logic       soft_reset;

    logic [MAX_FRAME_BYTES*8-1:0] frame_data;
    logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] frame_len;
    logic frame_valid;
    logic frame_error;

    logic frame_seen;
    logic error_seen;
    logic [MAX_FRAME_BYTES*8-1:0] captured_frame_data;
    logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0] captured_frame_len;

    rx_frame_collector #(
        .MAX_FRAME_BYTES (MAX_FRAME_BYTES)
    ) dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .rx_byte       (rx_byte),
        .rx_byte_valid (rx_byte_valid),
        .framing_err   (framing_err),
        .soft_reset    (soft_reset),
        .frame_data    (frame_data),
        .frame_len     (frame_len),
        .frame_valid   (frame_valid),
        .frame_error   (frame_error)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_seen          <= 1'b0;
            error_seen          <= 1'b0;
            captured_frame_data <= '0;
            captured_frame_len  <= '0;
        end
        else begin
            if (frame_valid) begin
                frame_seen          <= 1'b1;
                captured_frame_data <= frame_data;
                captured_frame_len  <= frame_len;
            end

            if (frame_error) begin
                error_seen <= 1'b1;
            end
        end
    end

    task automatic apply_reset;
        begin
            rst_n         = 1'b0;
            rx_byte       = '0;
            rx_byte_valid = 1'b0;
            framing_err   = 1'b0;
            soft_reset    = 1'b0;

            repeat (4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            repeat (2) @(posedge clk);
        end
    endtask

    task automatic send_uart_byte(input logic [7:0] value);
        begin
            @(negedge clk);
            rx_byte       = value;
            rx_byte_valid = 1'b1;

            @(negedge clk);
            rx_byte_valid = 1'b0;
            rx_byte       = '0;

            // The collector commits the captured byte on the next clock.
            // A real UART provides a much larger inter-byte interval.
            repeat (2) @(posedge clk);
        end
    endtask

    task automatic check_byte(
        input int unsigned index,
        input logic [7:0] expected
    );
        begin
            if (captured_frame_data[index*8 +: 8] !== expected) begin
                $fatal(
                    1,
                    "Byte %0d mismatch: expected=%02h actual=%02h",
                    index,
                    expected,
                    captured_frame_data[index*8 +: 8]
                );
            end
        end
    endtask

    initial begin
        apply_reset();

        // Valid five-byte frame: {ABC}
        send_uart_byte("{");
        send_uart_byte("A");
        send_uart_byte("B");
        send_uart_byte("C");
        send_uart_byte("}");

        wait (frame_seen === 1'b1);
        #1;

        if (captured_frame_len !==
            lab12_pkg::RX_FRAME_LEN_WIDTH'(5)) begin
            $fatal(1, "Wrong length for first frame");
        end

        check_byte(0, "{");
        check_byte(1, "A");
        check_byte(2, "B");
        check_byte(3, "C");
        check_byte(4, "}");

        apply_reset();

        // A shorter following frame verifies that only frame_len matters.
        send_uart_byte("{");
        send_uart_byte("Z");
        send_uart_byte("}");

        wait (frame_seen === 1'b1);
        #1;

        if (captured_frame_len !==
            lab12_pkg::RX_FRAME_LEN_WIDTH'(3)) begin
            $fatal(1, "Wrong length for second frame");
        end

        check_byte(0, "{");
        check_byte(1, "Z");
        check_byte(2, "}");

        apply_reset();

        // Framing error aborts collection and produces one error pulse.
        @(negedge clk);
        framing_err = 1'b1;
        @(negedge clk);
        framing_err = 1'b0;

        repeat (2) @(posedge clk);

        if (!error_seen) begin
            $fatal(1, "Framing error was not reported");
        end

        apply_reset();

        // Nine bytes without a closing brace exceed the eight-byte limit.
        send_uart_byte("{");
        send_uart_byte("A");
        send_uart_byte("B");
        send_uart_byte("C");
        send_uart_byte("D");
        send_uart_byte("E");
        send_uart_byte("F");
        send_uart_byte("G");
        send_uart_byte("H");

        repeat (2) @(posedge clk);

        if (!error_seen) begin
            $fatal(1, "Oversized frame was not rejected");
        end

        $display("tb_rx_frame_collector: PASS");
        $finish;
    end

    initial begin
        #10000;
        $fatal(1, "Simulation timeout");
    end

endmodule
