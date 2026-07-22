timeunit 1ns;
timeprecision 1ps;

module rx_classifier (
    input  logic clk,
    input  logic rst_n,

    // Parser outputs
    input  logic                              parsed_valid,
    input  lab12_pkg::rx_cmd_opcode_t         parsed_opcode,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] parsed_addr,
    input  logic [lab12_pkg::CMD_DATA_WIDTH-1:0] parsed_data,
    input  logic                              parse_error,

    // Handshake with BAR / command controller
    input  logic                              cmd_ready,

    output logic                              cmd_valid,
    output lab12_pkg::rx_cmd_opcode_t         cmd_opcode,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] cmd_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0] cmd_data,

    output logic                              classifier_error
);

    // Parser-output pipeline. The parser is combinational, so these
    // registers break the long frame-decode path before the command
    // holding register and its ready/valid control logic.
    logic                              parsed_pending_q;
    lab12_pkg::rx_cmd_opcode_t         parsed_opcode_q;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] parsed_addr_q;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] parsed_data_q;
    logic                              parse_error_q;

    logic command_slot_available;

    assign command_slot_available = !cmd_valid || cmd_ready;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            parsed_pending_q <= 1'b0;
            parsed_opcode_q  <= lab12_pkg::RX_CMD_NOP;
            parsed_addr_q    <= '0;
            parsed_data_q    <= '0;
            parse_error_q    <= 1'b0;

            cmd_valid        <= 1'b0;
            cmd_opcode       <= lab12_pkg::RX_CMD_NOP;
            cmd_addr         <= '0;
            cmd_data         <= '0;
            classifier_error <= 1'b0;
        end
        else begin
            // Register parser errors as well, so the parser has no direct
            // combinational path into the classifier output stage.
            parse_error_q    <= parse_error;
            classifier_error <= parse_error_q;

            // Current command was accepted
            if (cmd_valid && cmd_ready) begin
                cmd_valid  <= 1'b0;
                cmd_opcode <= lab12_pkg::RX_CMD_NOP;
                cmd_addr   <= '0;
                cmd_data   <= '0;
            end

            // Move the pipelined parser result into the command holding
            // register. A command accepted in this same cycle frees the slot.
            if (parsed_pending_q && command_slot_available) begin
                cmd_valid  <= 1'b1;
                cmd_opcode <= parsed_opcode_q;
                cmd_addr   <= parsed_addr_q;
                cmd_data   <= parsed_data_q;

                parsed_pending_q <= 1'b0;
            end

            // Capture the parser outputs into the pipeline register. If the
            // previous pending command moved forward above, a new command may
            // be accepted in the same cycle.
            if (parsed_valid) begin
                if (!parsed_pending_q || command_slot_available) begin
                    parsed_pending_q <= 1'b1;
                    parsed_opcode_q  <= parsed_opcode;
                    parsed_addr_q    <= parsed_addr;
                    parsed_data_q    <= parsed_data;
                end
                else begin
                    // There is no backpressure input toward the parser, so a
                    // second command while both slots are occupied is an
                    // explicit classifier overflow error.
                    classifier_error <= 1'b1;
                end
            end
        end
    end

endmodule
