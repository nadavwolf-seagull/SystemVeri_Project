`timescale 1ns / 1ps

module tb_control_path;

    localparam int unsigned MAX_FRAME_BYTES =
        lab12_pkg::RX_MAX_FRAME_BYTES;

    localparam int unsigned FRAME_WIDTH =
        MAX_FRAME_BYTES * 8;

    localparam int unsigned MAX_TRANSACTIONS = 8;

    logic clk;
    logic rst_n;

    // ========================================================
    // Frame input
    // ========================================================

    logic [FRAME_WIDTH-1:0] frame_data;

    logic [lab12_pkg::RX_FRAME_LEN_WIDTH-1:0]
        frame_len;

    logic frame_valid;
    logic frame_error;

    // ========================================================
    // Parser -> Classifier
    // ========================================================

    logic parsed_valid;

    lab12_pkg::rx_cmd_opcode_t
        parsed_opcode;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        parsed_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        parsed_data;

    logic parse_error;

    // ========================================================
    // Classifier -> BAR
    // ========================================================

    logic cmd_valid;
    logic cmd_ready;

    lab12_pkg::rx_cmd_opcode_t
        cmd_opcode;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        cmd_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        cmd_data;

    logic classifier_error;

    // ========================================================
    // BAR -> APB master
    // ========================================================

    logic apb_cmd_valid;
    logic apb_cmd_ready;

    lab12_pkg::rx_cmd_opcode_t
        apb_cmd_opcode;

    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]
        apb_cmd_addr;

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        apb_cmd_data;

    // ========================================================
    // APB master -> BAR response
    // ========================================================

    logic apb_rsp_valid;
    logic apb_rsp_ready;

    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]
        apb_rsp_addr;

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        apb_rsp_data;

    logic apb_rsp_error;
    logic apb_error_pulse;

    // ========================================================
    // Unused AHB side
    // ========================================================

    logic ahb_cmd_valid;
    logic ahb_cmd_ready;
    logic ahb_cmd_write;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        ahb_cmd_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        ahb_cmd_data;

    logic ahb_rsp_valid;
    logic ahb_rsp_ready;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        ahb_rsp_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        ahb_rsp_data;

    logic ahb_rsp_error;

    // ========================================================
    // Unified BAR response
    // ========================================================

    logic rsp_valid;
    logic rsp_ready;

    lab12_pkg::bar_target_t
        rsp_source;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]
        rsp_addr;

    logic [lab12_pkg::CMD_DATA_WIDTH-1:0]
        rsp_data;

    logic rsp_error;

    // ========================================================
    // APB interface
    // ========================================================

    apb_if #(
        .ADDR_WIDTH (lab12_pkg::RGF_ADDR_WIDTH),
        .DATA_WIDTH (lab12_pkg::RGF_DATA_WIDTH)
    ) apb (
        .PCLK    (clk),
        .PRESETn (rst_n)
    );

    // ========================================================
    // Simple APB register model
    // ========================================================

    logic [31:0] ctrl_reg;
    logic [31:0] img_width_reg;
    logic [31:0] img_height_reg;
    logic [31:0] img_base_reg;

    // ========================================================
    // Transaction log
    // ========================================================

    logic txn_write [0:MAX_TRANSACTIONS-1];

    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]
        txn_addr [0:MAX_TRANSACTIONS-1];

    logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
        txn_data [0:MAX_TRANSACTIONS-1];

    int unsigned txn_count;

    // ========================================================
    // DUT instances
    // ========================================================

    rx_parser #(
        .MAX_FRAME_BYTES (MAX_FRAME_BYTES)
    ) u_rx_parser (
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

    rx_classifier u_rx_classifier (
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

    bar u_bar (
        .clk             (clk),
        .rst_n           (rst_n),

        .cmd_valid       (cmd_valid),
        .cmd_ready       (cmd_ready),
        .cmd_opcode      (cmd_opcode),
        .cmd_addr        (cmd_addr),
        .cmd_data        (cmd_data),

        .apb_cmd_valid   (apb_cmd_valid),
        .apb_cmd_ready   (apb_cmd_ready),
        .apb_cmd_opcode  (apb_cmd_opcode),
        .apb_cmd_addr    (apb_cmd_addr),
        .apb_cmd_data    (apb_cmd_data),

        .apb_rsp_valid   (apb_rsp_valid),
        .apb_rsp_ready   (apb_rsp_ready),
        .apb_rsp_addr    (apb_rsp_addr),
        .apb_rsp_data    (apb_rsp_data),
        .apb_rsp_error   (apb_rsp_error),

        .ahb_cmd_valid   (ahb_cmd_valid),
        .ahb_cmd_ready   (ahb_cmd_ready),
        .ahb_cmd_write   (ahb_cmd_write),
        .ahb_cmd_addr    (ahb_cmd_addr),
        .ahb_cmd_data    (ahb_cmd_data),

        .ahb_rsp_valid   (ahb_rsp_valid),
        .ahb_rsp_ready   (ahb_rsp_ready),
        .ahb_rsp_addr    (ahb_rsp_addr),
        .ahb_rsp_data    (ahb_rsp_data),
        .ahb_rsp_error   (ahb_rsp_error),

        .rsp_valid       (rsp_valid),
        .rsp_ready       (rsp_ready),
        .rsp_source      (rsp_source),
        .rsp_addr        (rsp_addr),
        .rsp_data        (rsp_data),
        .rsp_error       (rsp_error)
    );

    apb_master_fsm u_apb_master_fsm (
        .clk             (clk),
        .rst_n           (rst_n),

        .cmd_valid       (apb_cmd_valid),
        .cmd_ready       (apb_cmd_ready),
        .cmd_opcode      (apb_cmd_opcode),
        .cmd_addr        (apb_cmd_addr),
        .cmd_data        (apb_cmd_data),

        .rsp_valid       (apb_rsp_valid),
        .rsp_ready       (apb_rsp_ready),
        .rsp_addr        (apb_rsp_addr),
        .rsp_data        (apb_rsp_data),
        .rsp_error       (apb_rsp_error),

        .apb_error_pulse (apb_error_pulse),

        .apb             (apb)
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
        $dumpfile("tb/tb_control_path.vcd");
        $dumpvars(0, tb_control_path);
    end

    // ========================================================
    // APB slave combinational outputs
    // ========================================================

    always_comb begin
        apb.PREADY  = 1'b1;
        apb.PSLVERR = 1'b0;
        apb.PRDATA  = '0;

        unique case (apb.PADDR)

            lab12_pkg::RGF_ADDR_CTRL: begin
                apb.PRDATA = ctrl_reg;
            end

            lab12_pkg::RGF_ADDR_IMG_WIDTH: begin
                apb.PRDATA = img_width_reg;
            end

            lab12_pkg::RGF_ADDR_IMG_HEIGHT: begin
                apb.PRDATA = img_height_reg;
            end

            lab12_pkg::RGF_ADDR_IMG_BASE: begin
                apb.PRDATA = img_base_reg;
            end

            default: begin
                apb.PRDATA = '0;
            end

        endcase
    end

    // ========================================================
    // APB register model and transaction monitor
    // ========================================================

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            /*
             * Bits 1 and 2 are intentionally preset.
             * The CTRL read-modify-write must preserve them.
             */
            ctrl_reg       <= 32'h0000_0006;
            img_width_reg  <= '0;
            img_height_reg <= '0;
            img_base_reg   <= '0;

            txn_count <= 0;
        end
        else if (
            apb.PSEL &&
            apb.PENABLE &&
            apb.PREADY
        ) begin
            if (txn_count >= MAX_TRANSACTIONS) begin
                $fatal(
                    1,
                    "APB transaction log overflow"
                );
            end

            txn_write[txn_count] <= apb.PWRITE;
            txn_addr[txn_count]  <= apb.PADDR;

            if (apb.PWRITE) begin
                txn_data[txn_count] <= apb.PWDATA;

                unique case (apb.PADDR)

                    lab12_pkg::RGF_ADDR_CTRL: begin
                        ctrl_reg <= apb.PWDATA;
                    end

                    lab12_pkg::RGF_ADDR_IMG_WIDTH: begin
                        img_width_reg <= apb.PWDATA;
                    end

                    lab12_pkg::RGF_ADDR_IMG_HEIGHT: begin
                        img_height_reg <= apb.PWDATA;
                    end

                    lab12_pkg::RGF_ADDR_IMG_BASE: begin
                        img_base_reg <= apb.PWDATA;
                    end

                    default: begin
                        // No modeled register update.
                    end

                endcase
            end
            else begin
                txn_data[txn_count] <= apb.PRDATA;
            end

            txn_count <= txn_count + 1;
        end
    end

    // ========================================================
    // Reset
    // ========================================================

    task automatic apply_reset;
        begin
            rst_n       = 1'b0;
            frame_data  = '0;
            frame_len   = '0;
            frame_valid = 1'b0;
            frame_error = 1'b0;

            ahb_cmd_ready = 1'b1;
            ahb_rsp_valid = 1'b0;
            ahb_rsp_addr  = '0;
            ahb_rsp_data  = '0;
            ahb_rsp_error = 1'b0;

            rsp_ready = 1'b1;

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
    // Send one ASCII frame
    // ========================================================

    task automatic send_frame(
        input string text
    );
        int unsigned i;
        int unsigned timeout;

        begin
            if (text.len() > MAX_FRAME_BYTES) begin
                $fatal(
                    1,
                    "Frame is longer than MAX_FRAME_BYTES"
                );
            end

            @(negedge clk);

            frame_data = '0;
            frame_len  =
                lab12_pkg::RX_FRAME_LEN_WIDTH'(text.len());

            for (i = 0; i < text.len(); i++) begin
                frame_data[i*8 +: 8] = text.getc(i);
            end

            frame_valid = 1'b1;
            frame_error = 1'b0;

            @(negedge clk);

            frame_valid = 1'b0;
            frame_data  = '0;
            frame_len   = '0;

            timeout = 0;
            while (
                (parsed_valid !== 1'b1) &&
                (parse_error !== 1'b1) &&
                (timeout < 12)
            ) begin
                @(posedge clk);
                #1;
                timeout++;
            end

            if (parse_error === 1'b1) begin
                $fatal(
                    1,
                    "Parser rejected frame: %s",
                    text
                );
            end

            if (parsed_valid !== 1'b1) begin
                $fatal(
                    1,
                    "Pipelined parser response timed out"
                );
            end
        end
    endtask

    // ========================================================
    // Check one recorded APB transaction
    // ========================================================

    task automatic check_transaction(
        input int unsigned index,
        input logic expected_write,
        input logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]
            expected_addr,
        input logic [lab12_pkg::RGF_DATA_WIDTH-1:0]
            expected_data
    );
        begin
            if (txn_write[index] !== expected_write) begin
                $fatal(
                    1,
                    "Transaction %0d write mismatch: expected=%0b actual=%0b",
                    index,
                    expected_write,
                    txn_write[index]
                );
            end

            if (txn_addr[index] !== expected_addr) begin
                $fatal(
                    1,
                    "Transaction %0d address mismatch: expected=%0h actual=%0h",
                    index,
                    expected_addr,
                    txn_addr[index]
                );
            end

            if (txn_data[index] !== expected_data) begin
                $fatal(
                    1,
                    "Transaction %0d data mismatch: expected=%08h actual=%08h",
                    index,
                    expected_data,
                    txn_data[index]
                );
            end

            $display(
                "APB[%0d]: %s addr=%0h data=%08h",
                index,
                expected_write ? "WRITE" : "READ ",
                txn_addr[index],
                txn_data[index]
            );
        end
    endtask

    // ========================================================
    // Wait for one complete image command
    // ========================================================

    task automatic wait_for_image_command;
        begin
            wait (txn_count == 5);

            repeat (4) begin
                @(posedge clk);
            end

            if (cmd_valid !== 1'b0) begin
                $fatal(
                    1,
                    "Classifier still holds cmd_valid after command"
                );
            end

            if (apb_cmd_ready !== 1'b1) begin
                $fatal(
                    1,
                    "APB master did not return to idle"
                );
            end

            if (parse_error || classifier_error) begin
                $fatal(
                    1,
                    "Unexpected parser/classifier error"
                );
            end

            if (apb_error_pulse) begin
                $fatal(
                    1,
                    "Unexpected APB error pulse"
                );
            end
        end
    endtask

    // ========================================================
    // Main test
    // ========================================================

    initial begin
        apply_reset();

        // ====================================================
        // TEST 1: Full-image write command
        // ====================================================

        $display("");
        $display("========================================");
        $display("TEST 1: Full-image write command");
        $display("========================================");

        send_frame(
            "{I<20,00,00>,H<00,01,00>,W<00,01,00>}"
        );

        wait_for_image_command();

        check_transaction(
            0,
            1'b1,
            lab12_pkg::RGF_ADDR_IMG_BASE,
            32'h0020_0000
        );

        check_transaction(
            1,
            1'b1,
            lab12_pkg::RGF_ADDR_IMG_WIDTH,
            32'h0000_0100
        );

        check_transaction(
            2,
            1'b1,
            lab12_pkg::RGF_ADDR_IMG_HEIGHT,
            32'h0000_0100
        );

        check_transaction(
            3,
            1'b0,
            lab12_pkg::RGF_ADDR_CTRL,
            32'h0000_0006
        );

        check_transaction(
            4,
            1'b1,
            lab12_pkg::RGF_ADDR_CTRL,
            32'h0000_000E
        );

        if (ctrl_reg !== 32'h0000_000E) begin
            $fatal(
                1,
                "Write command produced wrong CTRL value: %08h",
                ctrl_reg
            );
        end

        if (img_base_reg !== 32'h0020_0000) begin
            $fatal(
                1,
                "Wrong image base register value"
            );
        end

        if (img_width_reg !== 32'h0000_0100) begin
            $fatal(
                1,
                "Wrong image width register value"
            );
        end

        if (img_height_reg !== 32'h0000_0100) begin
            $fatal(
                1,
                "Wrong image height register value"
            );
        end

        // ====================================================
        // TEST 2: Full-image read command
        // Reset first so CTRL returns to 0x6.
        // ====================================================

        apply_reset();

        $display("");
        $display("========================================");
        $display("TEST 2: Full-image read command");
        $display("========================================");

        send_frame(
            "{R<20,00,00>,H<00,01,00>,W<00,01,00>}"
        );

        wait_for_image_command();

        check_transaction(
            0,
            1'b1,
            lab12_pkg::RGF_ADDR_IMG_BASE,
            32'h0020_0000
        );

        check_transaction(
            1,
            1'b1,
            lab12_pkg::RGF_ADDR_IMG_WIDTH,
            32'h0000_0100
        );

        check_transaction(
            2,
            1'b1,
            lab12_pkg::RGF_ADDR_IMG_HEIGHT,
            32'h0000_0100
        );

        check_transaction(
            3,
            1'b0,
            lab12_pkg::RGF_ADDR_CTRL,
            32'h0000_0006
        );

        check_transaction(
            4,
            1'b1,
            lab12_pkg::RGF_ADDR_CTRL,
            32'h0000_0007
        );

        if (ctrl_reg !== 32'h0000_0007) begin
            $fatal(
                1,
                "Read command produced wrong CTRL value: %08h",
                ctrl_reg
            );
        end

        $display("");
        $display("========================================");
        $display("All basic control-path tests PASSED");
        $display("========================================");

        $finish;
    end

    // ========================================================
    // Timeout
    // ========================================================

    initial begin
        #500000;

        $fatal(
            1,
            "Simulation timeout"
        );
    end

endmodule
