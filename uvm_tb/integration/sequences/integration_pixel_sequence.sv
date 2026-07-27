`ifndef INTEGRATION_PIXEL_SEQUENCE_SV
`define INTEGRATION_PIXEL_SEQUENCE_SV

class integration_pixel_sequence
    extends uvm_sequence #(integration_cmd_item);

    `uvm_object_utils(integration_pixel_sequence)

    function new(
        string name = "integration_pixel_sequence"
    );
        super.new(name);
    endfunction

    function automatic logic [23:0] make_pixel_addr(
        input int unsigned row,
        input int unsigned col
    );
        int unsigned pixel_index;
        logic [31:0] byte_address;

        pixel_index =
            (row * lab12_pkg::IMG_WIDTH) + col;

        byte_address =
            lab12_pkg::PIXEL_ALIAS_BASE_ADDR +
            (pixel_index << lab12_pkg::AHB_PIXEL_ADDR_SHIFT);

        return byte_address[23:0];
    endfunction

    task automatic send_pixel_command(
        input integration_cmd_kind_e kind,
        input logic [23:0] addr,
        input logic [23:0] pixel
    );
        integration_cmd_item cmd;

        cmd =
            integration_cmd_item::type_id::create(
                "cmd"
            );

        start_item(cmd);

        cmd.kind =
            kind;

        cmd.addr =
            addr;

        cmd.data =
            {8'h00, pixel};

        cmd.img_width =
            16'd0;

        cmd.img_height =
            16'd0;

        cmd.inject_parity_error =
            1'b0;

        cmd.inject_framing_error =
            1'b0;

        cmd.idle_bits =
            8;

        finish_item(cmd);

        `uvm_info(
            "INT_PIXEL_SEQ",
            $sformatf(
                "Completed pixel command: %s",
                cmd.convert2string()
            ),
            UVM_LOW
        )
    endtask

    task body();

        // Pixel row=3, column=5.
        send_pixel_command(
            INT_CMD_PIXEL_WRITE,
            make_pixel_addr(3, 5),
            24'hFF0000
        );

        send_pixel_command(
            INT_CMD_PIXEL_READ,
            make_pixel_addr(3, 5),
            24'h000000
        );

        // Pixel row=7, column=9.
        send_pixel_command(
            INT_CMD_PIXEL_WRITE,
            make_pixel_addr(7, 9),
            24'h12ABEF
        );

        send_pixel_command(
            INT_CMD_PIXEL_READ,
            make_pixel_addr(7, 9),
            24'h000000
        );

        // Verify that another address remains at reset value.
        send_pixel_command(
            INT_CMD_PIXEL_READ,
            make_pixel_addr(1, 2),
            24'h000000
        );

        `uvm_info(
            "INT_PIXEL_SEQ",
            "Pixel sequence completed",
            UVM_LOW
        )
    endtask

endclass

`endif
