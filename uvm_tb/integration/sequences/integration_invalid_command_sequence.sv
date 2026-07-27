`ifndef INTEGRATION_INVALID_COMMAND_SEQUENCE_SV
`define INTEGRATION_INVALID_COMMAND_SEQUENCE_SV

class integration_invalid_command_sequence
    extends uvm_sequence #(integration_cmd_item);

    `uvm_object_utils(integration_invalid_command_sequence)

    function new(
        string name = "integration_invalid_command_sequence"
    );
        super.new(name);
    endfunction

    task body();
        integration_cmd_item cmd;

        cmd = integration_cmd_item::type_id::create("cmd");

        start_item(cmd);

        cmd.kind                  = INT_CMD_INVALID;
        cmd.addr                  = 24'h000002;
        cmd.data                  = '0;
        cmd.img_width             = '0;
        cmd.img_height            = '0;
        cmd.inject_parity_error   = 1'b0;
        cmd.inject_framing_error  = 1'b0;
        cmd.idle_bits             = 4;

        finish_item(cmd);

        `uvm_info(
            "INT_INVALID_SEQ",
            $sformatf(
                "Completed invalid command: %s",
                cmd.convert2string()
            ),
            UVM_LOW
        )
    endtask

endclass

`endif
