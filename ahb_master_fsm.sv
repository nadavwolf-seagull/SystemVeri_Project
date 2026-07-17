timeunit 1ns;
timeprecision 1ps;

module ahb_master_fsm (
    input logic clk,
    input logic rst_n,

    // ============================================================
    // Command input from BAR
    // ============================================================
    input  logic                                  cmd_valid,
    output logic                                  cmd_ready,
    input  logic                                  cmd_write,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] cmd_addr,
    input  logic [lab12_pkg::CMD_DATA_WIDTH-1:0] cmd_data,

    // ============================================================
    // Read response toward BAR
    // ============================================================
    output logic                                  rsp_valid,
    input  logic                                  rsp_ready,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] rsp_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0] rsp_data,
    output logic                                  rsp_error,

    // One-cycle error pulse for any failed AHB transaction
    output logic                                  ahb_error_pulse,

    // ============================================================
    // AHB-Lite manager interface
    // ============================================================
    ahb_lite_if.master ahb
);

    typedef enum logic [2:0] {
        AHB_IDLE,
        AHB_ADDR_PHASE,
        AHB_DATA_PHASE,
        AHB_RSP_HOLD
    } ahb_state_t;

    ahb_state_t state;

    logic                                  saved_write;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] saved_cmd_addr;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] saved_cmd_data;

    logic [lab12_pkg::AHB_ADDR_WIDTH-1:0] aligned_ahb_addr;

    /*
     * The command address represents a logical pixel index.
     * AHB is byte-addressed, so a 32-bit transfer uses:
     *
     * HADDR = pixel_index << 2
     */
    always_comb begin
        aligned_ahb_addr = '0;

        aligned_ahb_addr[
            lab12_pkg::CMD_ADDR_WIDTH +
            lab12_pkg::AHB_PIXEL_ADDR_SHIFT - 1 : 0
        ] = {
            saved_cmd_addr,
            {lab12_pkg::AHB_PIXEL_ADDR_SHIFT{1'b0}}
        };
    end

    // ============================================================
    // AHB output control
    // ============================================================
    always_comb begin
        cmd_ready = (state == AHB_IDLE);

        ahb.HADDR     = '0;
        ahb.HWDATA    = '0;
        ahb.HWRITE    = 1'b0;
        ahb.HTRANS    = lab12_pkg::AHB_HTRANS_IDLE;
        ahb.HSIZE     = lab12_pkg::AHB_HSIZE_WORD;
        ahb.HBURST    = lab12_pkg::AHB_HBURST_SINGLE;
        ahb.HPROT     = lab12_pkg::AHB_HPROT_DEFAULT;
        ahb.HMASTLOCK = 1'b0;

        unique case (state)

            AHB_ADDR_PHASE: begin
                ahb.HADDR  = aligned_ahb_addr;
                ahb.HWRITE = saved_write;
                ahb.HTRANS = lab12_pkg::AHB_HTRANS_NONSEQ;
            end

            AHB_DATA_PHASE: begin
                /*
                 * Write data belongs to the data phase, one cycle
                 * after the address/control phase.
                 */
                ahb.HWDATA = saved_cmd_data;
            end

            default: begin
                // Keep the bus idle.
            end

        endcase
    end

    // ============================================================
    // State machine
    // ============================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state           <= AHB_IDLE;

            saved_write     <= 1'b0;
            saved_cmd_addr  <= '0;
            saved_cmd_data  <= '0;

            rsp_valid       <= 1'b0;
            rsp_addr        <= '0;
            rsp_data        <= '0;
            rsp_error       <= 1'b0;

            ahb_error_pulse <= 1'b0;
        end
        else begin
            // Default: one-cycle pulse
            ahb_error_pulse <= 1'b0;

            unique case (state)

                // ------------------------------------------------
                // Wait for a new BAR command
                // ------------------------------------------------
                AHB_IDLE: begin
                    rsp_valid <= 1'b0;
                    rsp_addr  <= '0;
                    rsp_data  <= '0;
                    rsp_error <= 1'b0;

                    if (cmd_valid && cmd_ready) begin
                        saved_write    <= cmd_write;
                        saved_cmd_addr <= cmd_addr;
                        saved_cmd_data <= cmd_data;

                        state <= AHB_ADDR_PHASE;
                    end
                end

                // ------------------------------------------------
                // Address/control phase
                //
                // Stay here if HREADY is low, because the bus has
                // not yet accepted the address phase.
                // ------------------------------------------------
                AHB_ADDR_PHASE: begin
                    if (ahb.HREADY) begin
                        state <= AHB_DATA_PHASE;
                    end
                end

                // ------------------------------------------------
                // Data/response phase
                //
                // For writes, HWDATA is driven in this state.
                // For reads, HRDATA is sampled when HREADY is high.
                // ------------------------------------------------
                AHB_DATA_PHASE: begin
                    if (ahb.HREADY) begin
                        if (ahb.HRESP) begin
                            ahb_error_pulse <= 1'b1;
                        end

                        if (saved_write) begin
                            /*
                             * BAR identifies write completion when
                             * cmd_ready becomes high again.
                             */
                            state <= AHB_IDLE;
                        end
                        else begin
                            rsp_valid <= 1'b1;
                            rsp_addr  <= saved_cmd_addr;
                            rsp_data  <= ahb.HRDATA;
                            rsp_error <= ahb.HRESP;

                            state <= AHB_RSP_HOLD;
                        end
                    end
                end

                // ------------------------------------------------
                // Hold a read response until BAR accepts it
                // ------------------------------------------------
                AHB_RSP_HOLD: begin
                    if (rsp_valid && rsp_ready) begin
                        rsp_valid <= 1'b0;
                        rsp_addr  <= '0;
                        rsp_data  <= '0;
                        rsp_error <= 1'b0;

                        state <= AHB_IDLE;
                    end
                end

                default: begin
                    state           <= AHB_IDLE;

                    saved_write     <= 1'b0;
                    saved_cmd_addr  <= '0;
                    saved_cmd_data  <= '0;

                    rsp_valid       <= 1'b0;
                    rsp_addr        <= '0;
                    rsp_data        <= '0;
                    rsp_error       <= 1'b0;

                    ahb_error_pulse <= 1'b0;
                end

            endcase
        end
    end

endmodule