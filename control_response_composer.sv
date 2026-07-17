timeunit 1ns;
timeprecision 1ps;

module control_response_composer #(
    parameter int unsigned PACKET_WIDTH =
        lab12_pkg::TX_PACKET_WIDTH,

    parameter int unsigned CMD_ADDR_WIDTH =
        lab12_pkg::CMD_ADDR_WIDTH,

    parameter int unsigned CMD_DATA_WIDTH =
        lab12_pkg::CMD_DATA_WIDTH
) (
    input logic clk,
    input logic rst_n,

    // ============================================================
    // Unified response from BAR
    // ============================================================
    input  logic                              rsp_valid,
    output logic                              rsp_ready,
    input  lab12_pkg::bar_target_t            rsp_source,
    input  logic [CMD_ADDR_WIDTH-1:0]         rsp_addr,
    input  logic [CMD_DATA_WIDTH-1:0]         rsp_data,
    input  logic                              rsp_error,

    // ============================================================
    // Packet interface toward UART packet mux
    // ============================================================
    output logic                              packet_valid,
    output logic [PACKET_WIDTH-1:0]           packet_data,
    input  logic                              packet_ready,
    input  logic                              packet_done,

    // Debug/status
    output logic                              response_busy,
    output logic                              response_error
);

    logic packet_in_flight;

    logic [7:0] pixel_row;
    logic [7:0] pixel_col;

    /*
     * For the current 256x256 image:
     * rsp_addr[15:8] = row
     * rsp_addr[7:0]  = column
     */
    assign pixel_row = rsp_addr[15:8];
    assign pixel_col = rsp_addr[7:0];

    assign rsp_ready =
        !packet_valid && !packet_in_flight;

    assign response_busy =
        packet_valid || packet_in_flight;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            packet_valid     <= 1'b0;
            packet_data      <= '0;
            packet_in_flight <= 1'b0;
            response_error   <= 1'b0;
        end
        else begin
            /*
             * Capture one BAR response and convert it into
             * the corresponding UART packet.
             */
            if (rsp_valid && rsp_ready) begin
                packet_valid   <= 1'b1;
                response_error <= rsp_error;

                unique case (rsp_source)

                    // ------------------------------------------------
                    // APB / RGF read response
                    //
                    // Byte 0-1 : "RD"
                    // Byte 2   : RGF address
                    // Byte 3-4 : reserved
                    // Byte 5-8 : register data
                    // ------------------------------------------------
                    lab12_pkg::BAR_TARGET_APB: begin
                        packet_data <= {
                            8'h52,                    // "R"
                            8'h44,                    // "D"
                            4'h0,
                            rsp_addr[
                                lab12_pkg::RGF_ADDR_WIDTH-1:0
                            ],
                            16'h0000,
                            rsp_data[
                                lab12_pkg::RGF_DATA_WIDTH-1:0
                            ]
                        };
                    end

                    // ------------------------------------------------
                    // AHB pixel read response
                    //
                    // Row    = 24 bits
                    // Column = 24 bits
                    // Pixel  = 24 bits: {R,G,B}
                    // ------------------------------------------------
                    lab12_pkg::BAR_TARGET_AHB: begin
                        packet_data <= {
                            16'h0000,
                            pixel_row,

                            16'h0000,
                            pixel_col,

                            rsp_data[
                                lab12_pkg::CMD_PIXEL_WIDTH-1:0
                            ]
                        };
                    end

                    default: begin
                        packet_data    <= '0;
                        response_error <= 1'b1;
                    end

                endcase
            end

            /*
             * UART accepted the packet. Keep ownership of the
             * response until transmission completes.
             */
            if (packet_valid && packet_ready) begin
                packet_in_flight <= 1'b1;
            end

            /*
             * Clear the response only after the corresponding
             * packet finished transmission.
             */
            if (packet_in_flight && packet_done) begin
                packet_valid     <= 1'b0;
                packet_data      <= '0;
                packet_in_flight <= 1'b0;
                response_error   <= 1'b0;
            end
        end
    end

endmodule