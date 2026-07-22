`timescale 1ns / 1ps

module tb_rx_command_frontend;

    localparam int unsigned MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES;

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

    logic parsed_valid;
    lab12_pkg::rx_cmd_opcode_t parsed_opcode;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] parsed_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] parsed_data;
    logic parse_error;

    logic cmd_ready;
    logic cmd_valid;
    lab12_pkg::rx_cmd_opcode_t cmd_opcode;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] cmd_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] cmd_data;
    logic classifier_error;

    rx_frame_collector #(
        .MAX_FRAME_BYTES (MAX_FRAME_BYTES)
    ) u_collector (
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

    rx_parser #(
        .MAX_FRAME_BYTES (MAX_FRAME_BYTES)
    ) u_parser (
        .clk           (clk),
        .rst_n         (rst_n),
        .frame_data    (frame_data),
        .frame_len     (frame_len),
        .frame_valid   (frame_valid),
        .frame_error   (frame_error),
        .parsed_valid  (parsed_valid),
        .parsed_opcode (parsed_opcode),
        .parsed_addr   (parsed_addr),
        .parsed_data   (parsed_data),
        .parse_error   (parse_error)
    );

    rx_classifier u_classifier (
        .clk              (clk),
        .rst_n            (rst_n),
        .parsed_valid     (parsed_valid),
        .parsed_opcode    (parsed_opcode),
        .parsed_addr      (parsed_addr),
        .parsed_data      (parsed_data),
        .parse_error      (parse_error),
        .cmd_ready        (cmd_ready),
        .cmd_valid        (cmd_valid),
        .cmd_opcode       (cmd_opcode),
        .cmd_addr         (cmd_addr),
        .cmd_data         (cmd_data),
        .classifier_error (classifier_error)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task automatic apply_reset;
        begin
            rst_n         = 1'b0;
            rx_byte       = '0;
            rx_byte_valid = 1'b0;
            framing_err   = 1'b0;
            soft_reset    = 1'b0;
            cmd_ready     = 1'b1;

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

            // The hardware UART leaves many fast-clock cycles between bytes.
            repeat (2) @(posedge clk);
        end
    endtask

    task automatic send_ascii_frame(input string text);
        int unsigned index;
        begin
            for (index = 0; index < text.len(); index++) begin
                send_uart_byte(text.getc(index));
            end
        end
    endtask

    task automatic expect_command(
        input lab12_pkg::rx_cmd_opcode_t expected_opcode,
        input logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] expected_addr,
        input logic [lab12_pkg::CMD_DATA_WIDTH-1:0] expected_data
    );
        int unsigned timeout;
        begin
            timeout = 0;

            while ((cmd_valid !== 1'b1) && (timeout < 30)) begin
                @(posedge clk);
                #1;
                timeout++;
            end

            if (cmd_valid !== 1'b1) begin
                $fatal(1, "Command response timed out");
            end

            if (cmd_opcode !== expected_opcode) begin
                $fatal(1, "Wrong command opcode");
            end

            if (cmd_addr !== expected_addr) begin
                $fatal(
                    1,
                    "Wrong address: expected=%06h actual=%06h",
                    expected_addr,
                    cmd_addr
                );
            end

            if (cmd_data !== expected_data) begin
                $fatal(
                    1,
                    "Wrong data: expected=%08h actual=%08h",
                    expected_data,
                    cmd_data
                );
            end

            if (classifier_error || parse_error || frame_error) begin
                $fatal(1, "Unexpected RX frontend error");
            end

            @(posedge clk);
        end
    endtask

    initial begin
        apply_reset();

        send_ascii_frame("{R<00,00,04>}");

        expect_command(
            lab12_pkg::RX_CMD_RGF_READ,
            24'h000004,
            32'h00000000
        );

        apply_reset();

        send_ascii_frame(
            "{I<20,00,00>,H<00,00,01>,W<00,00,10>}"
        );

        expect_command(
            lab12_pkg::RX_CMD_IMAGE_WRITE,
            24'h200000,
            32'h00010010
        );

        $display("tb_rx_command_frontend: PASS");
        $finish;
    end

    initial begin
        #50000;
        $fatal(1, "Simulation timeout");
    end

endmodule
