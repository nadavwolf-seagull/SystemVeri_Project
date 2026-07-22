timeunit 1ns;
timeprecision 1ps;

module tb_bar_pixel_write_then_read;

    logic clk;
    logic rst_n;

    logic                              cmd_valid;
    logic                              cmd_ready;
    lab12_pkg::rx_cmd_opcode_t         cmd_opcode;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] cmd_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] cmd_data;

    logic                              apb_cmd_valid;
    logic                              apb_cmd_ready;
    lab12_pkg::rx_cmd_opcode_t         apb_cmd_opcode;
    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0] apb_cmd_addr;
    logic [lab12_pkg::RGF_DATA_WIDTH-1:0] apb_cmd_data;
    logic                              apb_rsp_valid;
    logic                              apb_rsp_ready;
    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0] apb_rsp_addr;
    logic [lab12_pkg::RGF_DATA_WIDTH-1:0] apb_rsp_data;
    logic                              apb_rsp_error;

    logic                              ahb_cmd_valid;
    logic                              ahb_cmd_ready;
    logic                              ahb_cmd_write;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] ahb_cmd_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] ahb_cmd_data;
    logic                              ahb_rsp_valid;
    logic                              ahb_rsp_ready;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] ahb_rsp_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] ahb_rsp_data;
    logic                              ahb_rsp_error;

    logic                              rsp_valid;
    logic                              rsp_ready;
    lab12_pkg::bar_target_t            rsp_source;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] rsp_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] rsp_data;
    logic                              rsp_error;

    localparam logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        PIXEL_ADDR = 24'h10_0000;

    bar dut (
        .clk            (clk),
        .rst_n          (rst_n),
        .cmd_valid      (cmd_valid),
        .cmd_ready      (cmd_ready),
        .cmd_opcode     (cmd_opcode),
        .cmd_addr       (cmd_addr),
        .cmd_data       (cmd_data),
        .apb_cmd_valid  (apb_cmd_valid),
        .apb_cmd_ready  (apb_cmd_ready),
        .apb_cmd_opcode (apb_cmd_opcode),
        .apb_cmd_addr   (apb_cmd_addr),
        .apb_cmd_data   (apb_cmd_data),
        .apb_rsp_valid  (apb_rsp_valid),
        .apb_rsp_ready  (apb_rsp_ready),
        .apb_rsp_addr   (apb_rsp_addr),
        .apb_rsp_data   (apb_rsp_data),
        .apb_rsp_error  (apb_rsp_error),
        .ahb_cmd_valid  (ahb_cmd_valid),
        .ahb_cmd_ready  (ahb_cmd_ready),
        .ahb_cmd_write  (ahb_cmd_write),
        .ahb_cmd_addr   (ahb_cmd_addr),
        .ahb_cmd_data   (ahb_cmd_data),
        .ahb_rsp_valid  (ahb_rsp_valid),
        .ahb_rsp_ready  (ahb_rsp_ready),
        .ahb_rsp_addr   (ahb_rsp_addr),
        .ahb_rsp_data   (ahb_rsp_data),
        .ahb_rsp_error  (ahb_rsp_error),
        .rsp_valid      (rsp_valid),
        .rsp_ready      (rsp_ready),
        .rsp_source     (rsp_source),
        .rsp_addr       (rsp_addr),
        .rsp_data       (rsp_data),
        .rsp_error      (rsp_error)
    );

    always #5 clk = ~clk;

    task automatic send_command(
        input lab12_pkg::rx_cmd_opcode_t opcode,
        input logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] address,
        input logic [lab12_pkg::CMD_DATA_WIDTH-1:0] data
    );
        int timeout;
        begin
            @(negedge clk);
            cmd_opcode = opcode;
            cmd_addr   = address;
            cmd_data   = data;
            cmd_valid  = 1'b1;

            timeout = 0;
            while (!cmd_ready) begin
                @(negedge clk);
                timeout++;
                if (timeout > 20)
                    $fatal(1, "BAR command handshake timed out");
            end

            #1;
            if ((opcode == lab12_pkg::RX_CMD_PIXEL_WRITE) &&
                (!ahb_cmd_valid || !ahb_cmd_write)) begin
                $fatal(1, "Pixel write was not routed as an AHB write");
            end

            if ((opcode == lab12_pkg::RX_CMD_PIXEL_READ) &&
                (!ahb_cmd_valid || ahb_cmd_write)) begin
                $fatal(1, "Pixel read was not routed as an AHB read");
            end

            @(posedge clk);
            @(negedge clk);
            cmd_valid  = 1'b0;
            cmd_opcode = lab12_pkg::RX_CMD_NOP;
            cmd_addr   = '0;
            cmd_data   = '0;
        end
    endtask

    task automatic return_ahb_response(
        input logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] address,
        input logic [lab12_pkg::CMD_DATA_WIDTH-1:0] data
    );
        begin
            @(negedge clk);
            ahb_rsp_addr  = address;
            ahb_rsp_data  = data;
            ahb_rsp_error = 1'b0;
            ahb_rsp_valid = 1'b1;

            #1;
            if (!ahb_rsp_ready)
                $fatal(1, "BAR did not accept the AHB completion response");

            @(posedge clk);
            @(negedge clk);
            ahb_rsp_valid = 1'b0;
            ahb_rsp_addr  = '0;
            ahb_rsp_data  = '0;
        end
    endtask

    initial begin
        clk           = 1'b0;
        rst_n         = 1'b0;
        cmd_valid     = 1'b0;
        cmd_opcode    = lab12_pkg::RX_CMD_NOP;
        cmd_addr      = '0;
        cmd_data      = '0;
        apb_cmd_ready = 1'b1;
        apb_rsp_valid = 1'b0;
        apb_rsp_addr  = '0;
        apb_rsp_data  = '0;
        apb_rsp_error = 1'b0;
        ahb_cmd_ready = 1'b1;
        ahb_rsp_valid = 1'b0;
        ahb_rsp_addr  = '0;
        ahb_rsp_data  = '0;
        ahb_rsp_error = 1'b0;
        rsp_ready     = 1'b0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;
        repeat (2) @(posedge clk);

        // --------------------------------------------------------
        // Pixel write: the BAR must consume the AHB completion
        // locally and return to IDLE without a UART response.
        // --------------------------------------------------------
        send_command(
            lab12_pkg::RX_CMD_PIXEL_WRITE,
            PIXEL_ADDR,
            32'h00_A5_5A_C3
        );

        ahb_cmd_ready = 1'b0;
        return_ahb_response(PIXEL_ADDR, 32'h0000_0000);
        ahb_cmd_ready = 1'b1;

        repeat (2) @(posedge clk);
        if (!cmd_ready)
            $fatal(1, "BAR remained blocked after pixel-write completion");
        if (rsp_valid)
            $fatal(1, "Pixel write unexpectedly produced a UART response");

        // --------------------------------------------------------
        // A following pixel read must be accepted and forwarded.
        // --------------------------------------------------------
        send_command(
            lab12_pkg::RX_CMD_PIXEL_READ,
            PIXEL_ADDR,
            32'h0000_0000
        );

        ahb_cmd_ready = 1'b0;
        return_ahb_response(PIXEL_ADDR, 32'h00_12_34_56);

        #1;
        if (!rsp_valid)
            $fatal(1, "BAR did not forward the pixel-read response");
        if (rsp_source != lab12_pkg::BAR_TARGET_AHB)
            $fatal(1, "Pixel-read response has the wrong source");
        if (rsp_addr != PIXEL_ADDR)
            $fatal(1, "Pixel-read response address mismatch");
        if (rsp_data != 32'h00_12_34_56)
            $fatal(1, "Pixel-read response data mismatch");
        if (rsp_error)
            $fatal(1, "Pixel-read response unexpectedly reports an error");

        rsp_ready = 1'b1;
        @(posedge clk);
        @(negedge clk);
        rsp_ready     = 1'b0;
        ahb_cmd_ready = 1'b1;

        repeat (2) @(posedge clk);
        if (!cmd_ready)
            $fatal(1, "BAR did not return to IDLE after pixel read");

        $display("tb_bar_pixel_write_then_read: PASS");
        $finish;
    end

endmodule
