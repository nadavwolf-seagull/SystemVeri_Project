`timescale 1ns / 1ps

// ============================================================
// APB Master FSM
//
// Receives decoded UART commands from rx_classifier and converts
// them into APB read/write transfers toward the RGF APB slave.
//
// APB sequence:
//   IDLE   : wait for cmd_valid
//   SETUP  : PSEL=1, PENABLE=0, address/control/data stable
//   ACCESS : PSEL=1, PENABLE=1, wait for PREADY
//   RESP   : hold read response until the TX response path accepts it
//
// Lab 11 note:
//   RX_CMD_IMAGE_READ is implemented as read-modify-write of CTRL.
//   This sets CTRL[0] without clearing clk_sel/parity_enable bits.
// ============================================================
module apb_master_fsm (
    input  logic clk,
    input  logic rst_n,

    // Command input from rx_classifier
    input  logic                                  cmd_valid,
    output logic                                  cmd_ready,
    input  lab12_pkg::rx_cmd_opcode_t             cmd_opcode,
    input  logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]  cmd_addr,
    input  logic [lab12_pkg::RGF_DATA_WIDTH-1:0]  cmd_data,

    // Read response toward the existing UART response formatter
    output logic                                  rsp_valid,
    input  logic                                  rsp_ready,
    output logic [lab12_pkg::RGF_ADDR_WIDTH-1:0]  rsp_addr,
    output logic [lab12_pkg::RGF_DATA_WIDTH-1:0]  rsp_data,
    output logic                                  rsp_error,

    // One-cycle error indication for APB write/read errors
    output logic                                  apb_error_pulse,

    // APB master bus
    apb_if.master                                 apb
);

    typedef enum logic [2:0] {
        ST_IDLE,
        ST_SETUP,
        ST_ACCESS,
        ST_RESP,

        // Internal read-modify-write states for RX_CMD_IMAGE_READ
        ST_IMG_RD_SETUP,
        ST_IMG_RD_ACCESS,
        ST_IMG_WR_SETUP,
        ST_IMG_WR_ACCESS
    } state_t;

    state_t state;

    logic [lab12_pkg::RGF_ADDR_WIDTH-1:0] addr_reg;
    logic [lab12_pkg::RGF_DATA_WIDTH-1:0] wdata_reg;
    logic                                write_reg;
    logic                                read_reg;

    logic accept_cmd;
    logic cmd_is_write;
    logic cmd_is_read;

    assign accept_cmd = cmd_valid && cmd_ready;

    assign cmd_is_write =
        (cmd_opcode == lab12_pkg::RX_CMD_RGF_WRITE);

    assign cmd_is_read =
        (cmd_opcode == lab12_pkg::RX_CMD_RGF_READ);

    // Ready only when the master can capture a new command.
    assign cmd_ready = (state == ST_IDLE);

    // APB output controls. Address/control/data remain stable in
    // SETUP and ACCESS, as required by APB.
    always_comb begin
        apb.PSEL    = 1'b0;
        apb.PENABLE = 1'b0;
        apb.PADDR   = addr_reg;
        apb.PWRITE  = write_reg;
        apb.PWDATA  = wdata_reg;
        apb.PSTRB   = {(lab12_pkg::RGF_DATA_WIDTH/8){1'b1}};
        apb.PPROT   = 3'b000;

        unique case (state)
            ST_SETUP,
            ST_IMG_RD_SETUP,
            ST_IMG_WR_SETUP: begin
                apb.PSEL    = 1'b1;
                apb.PENABLE = 1'b0;
            end

            ST_ACCESS,
            ST_IMG_RD_ACCESS,
            ST_IMG_WR_ACCESS: begin
                apb.PSEL    = 1'b1;
                apb.PENABLE = 1'b1;
            end

            default: begin
                apb.PSEL    = 1'b0;
                apb.PENABLE = 1'b0;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= ST_IDLE;
            addr_reg        <= '0;
            wdata_reg       <= '0;
            write_reg       <= 1'b0;
            read_reg        <= 1'b0;
            rsp_valid       <= 1'b0;
            rsp_addr        <= '0;
            rsp_data        <= '0;
            rsp_error       <= 1'b0;
            apb_error_pulse <= 1'b0;
        end
        else begin
            apb_error_pulse <= 1'b0;

            unique case (state)

                ST_IDLE: begin
                    rsp_valid <= 1'b0;

                    if (accept_cmd) begin
                        if (cmd_opcode == lab12_pkg::RX_CMD_IMAGE_READ) begin
                            // Do not overwrite CTRL with 32'h1.
                            // First read current CTRL, then OR bit 0, then write back.
                            addr_reg  <= lab12_pkg::RGF_ADDR_CTRL;
                            wdata_reg <= '0;
                            write_reg <= 1'b0;
                            read_reg  <= 1'b0;
                            state     <= ST_IMG_RD_SETUP;
                        end
                        else if (cmd_is_write) begin
                            addr_reg  <= cmd_addr;
                            wdata_reg <= cmd_data;
                            write_reg <= 1'b1;
                            read_reg  <= 1'b0;
                            state     <= ST_SETUP;
                        end
                        else if (cmd_is_read) begin
                            addr_reg  <= cmd_addr;
                            wdata_reg <= '0;
                            write_reg <= 1'b0;
                            read_reg  <= 1'b1;
                            state     <= ST_SETUP;
                        end
                        else begin
                            state <= ST_IDLE;
                        end
                    end
                end

                // ------------------------------------------------
                // Normal APB transaction path
                // ------------------------------------------------
                ST_SETUP: begin
                    state <= ST_ACCESS;
                end

                ST_ACCESS: begin
                    if (apb.PREADY) begin
                        apb_error_pulse <= apb.PSLVERR;

                        if (read_reg) begin
                            rsp_valid <= 1'b1;
                            rsp_addr  <= addr_reg;
                            rsp_data  <= apb.PRDATA;
                            rsp_error <= apb.PSLVERR;
                            state     <= ST_RESP;
                        end
                        else begin
                            state <= ST_IDLE;
                        end
                    end
                end

                ST_RESP: begin
                    if (rsp_ready) begin
                        rsp_valid <= 1'b0;
                        rsp_error <= 1'b0;
                        state     <= ST_IDLE;
                    end
                end

                // ------------------------------------------------
                // IMAGE_READ read-modify-write path:
                // APB read CTRL, then APB write CTRL | 1
                // ------------------------------------------------
                ST_IMG_RD_SETUP: begin
                    state <= ST_IMG_RD_ACCESS;
                end

                ST_IMG_RD_ACCESS: begin
                    if (apb.PREADY) begin
                        apb_error_pulse <= apb.PSLVERR;

                        // Prepare write-back value.
                        // Set bit 0 while preserving all other CTRL bits.
                        addr_reg  <= lab12_pkg::RGF_ADDR_CTRL;
                        wdata_reg <= apb.PRDATA | lab12_pkg::RGF_DATA_WIDTH'(1);
                        write_reg <= 1'b1;
                        read_reg  <= 1'b0;
                        state     <= ST_IMG_WR_SETUP;
                    end
                end

                ST_IMG_WR_SETUP: begin
                    state <= ST_IMG_WR_ACCESS;
                end

                ST_IMG_WR_ACCESS: begin
                    if (apb.PREADY) begin
                        apb_error_pulse <= apb.PSLVERR;
                        write_reg       <= 1'b0;
                        state           <= ST_IDLE;
                    end
                end

                default: begin
                    state <= ST_IDLE;
                end

            endcase
        end
    end

endmodule
