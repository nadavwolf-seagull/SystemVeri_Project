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

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cmd_valid        <= 1'b0;
            cmd_opcode       <= lab12_pkg::RX_CMD_NOP;
            cmd_addr         <= '0;
            cmd_data         <= '0;
            classifier_error <= 1'b0;
        end
        else begin
            // One-cycle error pulse
            classifier_error <= 1'b0;

            // Current command was accepted
            if (cmd_valid && cmd_ready) begin
                cmd_valid  <= 1'b0;
                cmd_opcode <= lab12_pkg::RX_CMD_NOP;
                cmd_addr   <= '0;
                cmd_data   <= '0;
            end

            // Parser detected an invalid command
            if (parse_error) begin
                classifier_error <= 1'b1;
            end

            // Capture a new command only when no command is pending
            if (parsed_valid && !cmd_valid) begin
                cmd_valid  <= 1'b1;
                cmd_opcode <= parsed_opcode;
                cmd_addr   <= parsed_addr;
                cmd_data   <= parsed_data;
            end
        end
    end

endmodule