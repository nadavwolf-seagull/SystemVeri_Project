`ifndef INTEGRATION_CONTROL_SEQUENCE_SV
`define INTEGRATION_CONTROL_SEQUENCE_SV

class integration_control_sequence
    extends uvm_sequence #(integration_cmd_item);

    `uvm_object_utils(integration_control_sequence)

    function new(
        string name = "integration_control_sequence"
    );
        super.new(name);
    endfunction

    task automatic send_command(
        input integration_cmd_kind_e kind,
        input logic [23:0] addr,
        input logic [31:0] data
    );
        integration_cmd_item cmd;

        cmd = integration_cmd_item::type_id::create(
            "cmd"
        );

        start_item(cmd);

        cmd.kind                 = kind;
        cmd.addr                 = addr;
        cmd.data                 = data;
        cmd.img_width            = 16'd0;
        cmd.img_height           = 16'd0;
        cmd.inject_parity_error  = 1'b0;
        cmd.inject_framing_error = 1'b0;
        cmd.idle_bits            = 8;

        finish_item(cmd);

        `uvm_info(
            "INT_CTRL_SEQ",
            $sformatf(
                "Completed command: %s",
                cmd.convert2string()
            ),
            UVM_LOW
        )
    endtask

    task body();
        // Fixed read-only register.
        send_command(
            INT_CMD_RGF_READ,
            {20'h00000, lab12_pkg::RGF_ADDR_VERSION},
            32'h0000_0000
        );

        // Writable width register.
        send_command(
            INT_CMD_RGF_WRITE,
            {20'h00000, lab12_pkg::RGF_ADDR_IMG_WIDTH},
            32'd16
        );

        send_command(
            INT_CMD_RGF_READ,
            {20'h00000, lab12_pkg::RGF_ADDR_IMG_WIDTH},
            32'h0000_0000
        );

        // Writable height register.
        send_command(
            INT_CMD_RGF_WRITE,
            {20'h00000, lab12_pkg::RGF_ADDR_IMG_HEIGHT},
            32'd2
        );

        send_command(
            INT_CMD_RGF_READ,
            {20'h00000, lab12_pkg::RGF_ADDR_IMG_HEIGHT},
            32'h0000_0000
        );

        `uvm_info(
            "INT_CTRL_SEQ",
            "Control sequence completed",
            UVM_LOW
        )
    endtask

endclass

`endif
