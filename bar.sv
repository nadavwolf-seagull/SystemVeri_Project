timeunit 1ns;
timeprecision 1ps;

module bar (
    input logic clk,
    input logic rst_n,

    // ============================================================
    // Classifier command input
    // ============================================================
    input  logic                              cmd_valid,
    output logic                              cmd_ready,
    input  lab12_pkg::rx_cmd_opcode_t         cmd_opcode,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] cmd_addr,
    input  logic [lab12_pkg::CMD_DATA_WIDTH-1:0] cmd_data,

    // ============================================================
    // APB Master command output
    // ============================================================
    output logic                              apb_cmd_valid,
    input  logic                              apb_cmd_ready,
    output lab12_pkg::rx_cmd_opcode_t         apb_cmd_opcode,
    output logic [lab12_pkg::RGF_ADDR_WIDTH-1:0] apb_cmd_addr,
    output logic [lab12_pkg::RGF_DATA_WIDTH-1:0] apb_cmd_data,

    // ============================================================
    // APB Master response input
    // ============================================================
    input  logic                              apb_rsp_valid,
    output logic                              apb_rsp_ready,
    input  logic [lab12_pkg::RGF_ADDR_WIDTH-1:0] apb_rsp_addr,
    input  logic [lab12_pkg::RGF_DATA_WIDTH-1:0] apb_rsp_data,
    input  logic                              apb_rsp_error,

    // ============================================================
    // AHB Master command output
    // ============================================================
    output logic                              ahb_cmd_valid,
    input  logic                              ahb_cmd_ready,
    output logic                              ahb_cmd_write,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] ahb_cmd_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0] ahb_cmd_data,

    // ============================================================
    // AHB Master response input
    // ============================================================
    input  logic                              ahb_rsp_valid,
    output logic                              ahb_rsp_ready,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] ahb_rsp_addr,
    input  logic [lab12_pkg::CMD_DATA_WIDTH-1:0] ahb_rsp_data,
    input  logic                              ahb_rsp_error,

    // ============================================================
    // Unified response output
    // ============================================================
    output logic                              rsp_valid,
    input  logic                              rsp_ready,
    output lab12_pkg::bar_target_t            rsp_source,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] rsp_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0] rsp_data,
    output logic                              rsp_error
);

    typedef enum logic [2:0] {
        BAR_IDLE,
        BAR_WAIT_APB_WRITE,
        BAR_WAIT_APB_READ,
        BAR_WAIT_AHB_WRITE,
        BAR_WAIT_AHB_READ,
        BAR_RSP_HOLD
    } bar_state_t;

    bar_state_t state;

    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] saved_addr;

    // ============================================================
    // Command routing
    // ============================================================
    always_comb begin
        cmd_ready = 1'b0;

        apb_cmd_valid  = 1'b0;
        apb_cmd_opcode = lab12_pkg::RX_CMD_NOP;
        apb_cmd_addr   = '0;
        apb_cmd_data   = '0;

        ahb_cmd_valid = 1'b0;
        ahb_cmd_write = 1'b0;
        ahb_cmd_addr  = '0;
        ahb_cmd_data  = '0;

        apb_rsp_ready = 1'b0;
        ahb_rsp_ready = 1'b0;

        if (state == BAR_IDLE) begin
            unique case (cmd_opcode)

                lab12_pkg::RX_CMD_RGF_WRITE,
                lab12_pkg::RX_CMD_RGF_READ,
                lab12_pkg::RX_CMD_IMAGE_READ: begin
                    cmd_ready = apb_cmd_ready;

                    apb_cmd_valid  = cmd_valid;
                    apb_cmd_opcode = cmd_opcode;
                    apb_cmd_addr   =
                        cmd_addr[lab12_pkg::RGF_ADDR_WIDTH-1:0];
                    apb_cmd_data   =
                        cmd_data[lab12_pkg::RGF_DATA_WIDTH-1:0];
                end

                lab12_pkg::RX_CMD_PIXEL_WRITE,
                lab12_pkg::RX_CMD_PIXEL_READ: begin
                    cmd_ready = ahb_cmd_ready;

                    ahb_cmd_valid = cmd_valid;
                    ahb_cmd_write =
                        (cmd_opcode ==
                         lab12_pkg::RX_CMD_PIXEL_WRITE);

                    ahb_cmd_addr = cmd_addr;
                    ahb_cmd_data = cmd_data;
                end

                default: begin
                    // Invalid commands are accepted and converted
                    // into an error response.
                    cmd_ready = 1'b1;
                end

            endcase
        end

        if (state == BAR_WAIT_APB_READ) begin
            apb_rsp_ready = 1'b1;
        end

        if (state == BAR_WAIT_AHB_READ) begin
            ahb_rsp_ready = 1'b1;
        end
    end

    // ============================================================
    // BAR state machine
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= BAR_IDLE;
            saved_addr <= '0;

            rsp_valid  <= 1'b0;
            rsp_source <= lab12_pkg::BAR_TARGET_NONE;
            rsp_addr   <= '0;
            rsp_data   <= '0;
            rsp_error  <= 1'b0;
        end
        else begin
            unique case (state)

                BAR_IDLE: begin
                    rsp_valid  <= 1'b0;
                    rsp_source <= lab12_pkg::BAR_TARGET_NONE;
                    rsp_addr   <= '0;
                    rsp_data   <= '0;
                    rsp_error  <= 1'b0;

                    if (cmd_valid && cmd_ready) begin
                        saved_addr <= cmd_addr;

                        unique case (cmd_opcode)

                            lab12_pkg::RX_CMD_RGF_WRITE,
                            lab12_pkg::RX_CMD_IMAGE_READ: begin
                                state <= BAR_WAIT_APB_WRITE;
                            end

                            lab12_pkg::RX_CMD_RGF_READ: begin
                                state <= BAR_WAIT_APB_READ;
                            end

                            lab12_pkg::RX_CMD_PIXEL_WRITE: begin
                                state <= BAR_WAIT_AHB_WRITE;
                            end

                            lab12_pkg::RX_CMD_PIXEL_READ: begin
                                state <= BAR_WAIT_AHB_READ;
                            end

                            default: begin
                                rsp_valid  <= 1'b1;
                                rsp_source <= lab12_pkg::BAR_TARGET_NONE;
                                rsp_addr   <= cmd_addr;
                                rsp_data   <= '0;
                                rsp_error  <= 1'b1;
                                state      <= BAR_RSP_HOLD;
                            end

                        endcase
                    end
                end

                // The APB master lowers cmd_ready while busy.
                // When cmd_ready rises again, the write completed.
                BAR_WAIT_APB_WRITE: begin
                    if (apb_cmd_ready) begin
                        state <= BAR_IDLE;
                    end
                end

                BAR_WAIT_APB_READ: begin
                    if (apb_rsp_valid && apb_rsp_ready) begin
                        rsp_valid  <= 1'b1;
                        rsp_source <= lab12_pkg::BAR_TARGET_APB;
                        rsp_addr   <= saved_addr;
                        rsp_data   <= apb_rsp_data;
                        rsp_error  <= apb_rsp_error;
                        state      <= BAR_RSP_HOLD;
                    end
                end

                // The AHB master follows the same ready/busy rule
                // for a write transaction.
                BAR_WAIT_AHB_WRITE: begin
                    if (ahb_cmd_ready) begin
                        state <= BAR_IDLE;
                    end
                end

                BAR_WAIT_AHB_READ: begin
                    if (ahb_rsp_valid && ahb_rsp_ready) begin
                        rsp_valid  <= 1'b1;
                        rsp_source <= lab12_pkg::BAR_TARGET_AHB;
                        rsp_addr   <= ahb_rsp_addr;
                        rsp_data   <= ahb_rsp_data;
                        rsp_error  <= ahb_rsp_error;
                        state      <= BAR_RSP_HOLD;
                    end
                end

                BAR_RSP_HOLD: begin
                    if (rsp_valid && rsp_ready) begin
                        rsp_valid  <= 1'b0;
                        rsp_source <= lab12_pkg::BAR_TARGET_NONE;
                        rsp_addr   <= '0;
                        rsp_data   <= '0;
                        rsp_error  <= 1'b0;
                        state      <= BAR_IDLE;
                    end
                end

                default: begin
                    state      <= BAR_IDLE;
                    rsp_valid  <= 1'b0;
                    rsp_source <= lab12_pkg::BAR_TARGET_NONE;
                    rsp_addr   <= '0;
                    rsp_data   <= '0;
                    rsp_error  <= 1'b0;
                end

            endcase
        end
    end

endmodule