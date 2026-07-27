`ifndef INTEGRATION_UART_RX_DRIVER_SV
`define INTEGRATION_UART_RX_DRIVER_SV

class integration_uart_rx_driver
    extends uvm_driver #(integration_cmd_item);

    `uvm_component_utils(integration_uart_rx_driver)

    typedef logic [7:0] uart_byte_t;

    virtual integration_if vif;

    // Publishes commands accepted for transmission.
    // The reference model will connect to this port later.
    uvm_analysis_port #(integration_cmd_item) command_ap;

    localparam int unsigned CLKS_PER_BIT =
        lab12_pkg::UART_CLKS_PER_BIT;

    localparam bit PARITY_EN =
        lab12_pkg::UART_PARITY_EN;

    localparam bit EVEN_PARITY =
        lab12_pkg::UART_EVEN_PARITY;

    function new(
        string name = "integration_uart_rx_driver",
        uvm_component parent = null
    );
        super.new(name, parent);
        command_ap = new("command_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual integration_if)::get(
                this,
                "",
                "vif",
                vif
            )) begin
            `uvm_fatal(
                "INT_RX_DRV",
                "Failed to get integration_if from config_db"
            )
        end
    endfunction

    // =========================================================
    // ASCII conversion helpers
    // =========================================================

    function automatic uart_byte_t nibble_to_ascii(
        input logic [3:0] nibble
    );
        if (nibble < 4'd10)
            return 8'h30 + nibble;
        else
            return 8'h41 + (nibble - 4'd10);
    endfunction

    function automatic bit calculate_parity(
        input uart_byte_t data
    );
        if (EVEN_PARITY)
            return ^data;
        else
            return ~(^data);
    endfunction

    task automatic append_hex_byte(
        ref uart_byte_t frame[$],
        input uart_byte_t value
    );
        frame.push_back(nibble_to_ascii(value[7:4]));
        frame.push_back(nibble_to_ascii(value[3:0]));
    endtask

    task automatic append_hex24(
        ref uart_byte_t frame[$],
        input logic [23:0] value
    );
        append_hex_byte(frame, value[23:16]);
        frame.push_back(8'h2C); // ","

        append_hex_byte(frame, value[15:8]);
        frame.push_back(8'h2C); // ","

        append_hex_byte(frame, value[7:0]);
    endtask

    task automatic append_field24(
        ref uart_byte_t frame[$],
        input uart_byte_t field_name,
        input logic [23:0] value
    );
        frame.push_back(field_name);
        frame.push_back(8'h3C); // "<"
        append_hex24(frame, value);
        frame.push_back(8'h3E); // ">"
    endtask

    // =========================================================
    // Command serialization
    // =========================================================

    task automatic build_ascii_frame(
        input integration_cmd_item cmd,
        ref uart_byte_t frame[$]
    );
        frame.delete();

        frame.push_back(8'h7B); // "{"

        case (cmd.kind)

            // Format:
            // {W<AA,AA,AA>,V<00,HH,HH>,V<00,LL,LL>}
            INT_CMD_RGF_WRITE: begin
                frame.push_back(8'h57); // "W"
                frame.push_back(8'h3C); // "<"
                append_hex24(frame, cmd.addr);
                frame.push_back(8'h3E); // ">"

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h56, // "V"
                    {8'h00, cmd.data[31:16]}
                );

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h56, // "V"
                    {8'h00, cmd.data[15:0]}
                );
            end

            // Format:
            // {R<AA,AA,AA>}
            //
            // The parser distinguishes RGF and pixel reads
            // according to the address range.
            INT_CMD_RGF_READ,
            INT_CMD_PIXEL_READ: begin
                frame.push_back(8'h52); // "R"
                frame.push_back(8'h3C); // "<"
                append_hex24(frame, cmd.addr);
                frame.push_back(8'h3E); // ">"
            end

            // Format:
            // {W<AA,AA,AA>,P<RR,GG,BB>}
            INT_CMD_PIXEL_WRITE: begin
                frame.push_back(8'h57); // "W"
                frame.push_back(8'h3C); // "<"
                append_hex24(frame, cmd.addr);
                frame.push_back(8'h3E); // ">"

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h50, // "P"
                    cmd.data[23:0]
                );
            end

            // Format:
            // {I<AA,AA,AA>,H<00,HH,HH>,W<00,WW,WW>}
            INT_CMD_IMAGE_WRITE: begin
                frame.push_back(8'h49); // "I"
                frame.push_back(8'h3C); // "<"
                append_hex24(frame, cmd.addr);
                frame.push_back(8'h3E); // ">"

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h48, // "H"
                    {8'h00, cmd.img_height}
                );

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h57, // "W"
                    {8'h00, cmd.img_width}
                );
            end

            // Format:
            // {R<AA,AA,AA>,H<00,HH,HH>,W<00,WW,WW>}
            INT_CMD_IMAGE_READ: begin
                frame.push_back(8'h52); // "R"
                frame.push_back(8'h3C); // "<"
                append_hex24(frame, cmd.addr);
                frame.push_back(8'h3E); // ">"

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h48, // "H"
                    {8'h00, cmd.img_height}
                );

                frame.push_back(8'h2C); // ","
                append_field24(
                    frame,
                    8'h57, // "W"
                    {8'h00, cmd.img_width}
                );
            end

            // Deliberately unsupported opcode.
            INT_CMD_INVALID: begin
                frame.push_back(8'h58); // "X"
                frame.push_back(8'h3C); // "<"
                append_hex24(frame, cmd.addr);
                frame.push_back(8'h3E); // ">"
            end

            default: begin
                frame.push_back(8'h58); // "X"
            end

        endcase

        frame.push_back(8'h7D); // "}"
    endtask

    // =========================================================
    // UART physical-layer driving
    // =========================================================

    task automatic send_uart_bit(input bit value);
        vif.RX <= value;

        repeat (CLKS_PER_BIT)
            @(posedge vif.clk_uart);
    endtask

    task automatic send_uart_byte(
        input uart_byte_t data,
        input bit corrupt_parity,
        input bit corrupt_stop
    );
        bit parity_bit;

        parity_bit = calculate_parity(data);

        if (corrupt_parity)
            parity_bit = ~parity_bit;

        send_uart_bit(1'b0); // Start bit

        for (int unsigned bit_index = 0;
             bit_index < 8;
             bit_index++) begin
            send_uart_bit(data[bit_index]);
        end

        if (PARITY_EN)
            send_uart_bit(parity_bit);

        if (corrupt_stop)
            send_uart_bit(1'b0);
        else
            send_uart_bit(1'b1);
    endtask

    task automatic send_command(
        input integration_cmd_item cmd
    );
        uart_byte_t frame[$];
        bit corrupt_this_parity;
        bit corrupt_this_stop;

        build_ascii_frame(cmd, frame);

        `uvm_info(
            "INT_RX_DRV",
            $sformatf(
                "Driving command: %s | ASCII bytes=%0d",
                cmd.convert2string(),
                frame.size()
            ),
            UVM_LOW
        )

        // Stable idle before the complete command frame.
        repeat (cmd.idle_bits)
            send_uart_bit(1'b1);

        foreach (frame[index]) begin
            // Error injection is applied to the first byte only.
            corrupt_this_parity =
                cmd.inject_parity_error && (index == 0);

            corrupt_this_stop =
                cmd.inject_framing_error && (index == 0);

            send_uart_byte(
                frame[index],
                corrupt_this_parity,
                corrupt_this_stop
            );
        end

        // Return to UART idle after the command.
        send_uart_bit(1'b1);
    endtask

    // =========================================================
    // Main driver loop
    // =========================================================

    task run_phase(uvm_phase phase);
        integration_cmd_item req;
        integration_cmd_item published_cmd;

        // UART input line is idle-high.
        vif.RX <= 1'b1;

        // Wait for the UART reset domain to be released.
        while (vif.rst_uart_n !== 1'b1)
            @(posedge vif.clk_uart);

        // Allow the DUT RX synchronizer to observe stable idle.
        repeat (8)
            @(posedge vif.clk_uart);

        forever begin
            seq_item_port.get_next_item(req);

            // Publish a stable copy before the DUT response can occur.
            published_cmd =
                integration_cmd_item::type_id::create(
                    "published_cmd"
                );

            published_cmd.kind =
                req.kind;

            published_cmd.addr =
                req.addr;

            published_cmd.data =
                req.data;

            published_cmd.img_width =
                req.img_width;

            published_cmd.img_height =
                req.img_height;

            published_cmd.inject_parity_error =
                req.inject_parity_error;

            published_cmd.inject_framing_error =
                req.inject_framing_error;

            published_cmd.idle_bits =
                req.idle_bits;

            command_ap.write(published_cmd);

            send_command(req);

            seq_item_port.item_done();
        end
    endtask

endclass

`endif
