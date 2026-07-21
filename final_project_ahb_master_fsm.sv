`timescale 1ns / 1ps

// AHB-Lite manager shared by BAR single accesses and RGB DMA INCR4 bursts.
// Command addresses are global byte addresses; no implicit address shift is
// performed in this module.
module final_project_ahb_master_fsm (
    input  logic                                  clk,
    input  logic                                  rst_n,

    // Single-pixel access from BAR. Reads and writes both return a response.
    input  logic                                  bar_cmd_valid,
    output logic                                  bar_cmd_ready,
    input  logic                                  bar_cmd_write,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]  bar_cmd_addr,
    input  logic [lab12_pkg::CMD_DATA_WIDTH-1:0]  bar_cmd_data,

    output logic                                  bar_rsp_valid,
    input  logic                                  bar_rsp_ready,
    output logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]  bar_rsp_addr,
    output logic [lab12_pkg::CMD_DATA_WIDTH-1:0]  bar_rsp_data,
    output logic                                  bar_rsp_error,

    // Full-image DMA request. Four words are captured atomically with the
    // command, avoiding a timing dependency between FIFO latency and AHB.
    input  logic                                  seq_cmd_valid,
    output logic                                  seq_cmd_ready,
    input  logic                                  seq_cmd_write,
    input  logic [lab12_pkg::CMD_ADDR_WIDTH-1:0]  seq_cmd_addr,
    input  logic [127:0]                          seq_cmd_wdata,

    output logic                                  seq_rsp_valid,
    input  logic                                  seq_rsp_ready,
    output logic                                  seq_rsp_error,
    output logic [127:0]                          seq_rsp_rdata,

    output logic                                  ahb_error_pulse,

    ahb_lite_if.master ahb
);

    typedef enum logic [2:0] {
        ST_IDLE,
        ST_SINGLE_ADDR,
        ST_SINGLE_DATA,
        ST_BURST_FIRST_ADDR,
        ST_BURST_PIPE,
        ST_BURST_LAST_DATA,
        ST_RSP_HOLD
    } state_t;

    state_t state_q;

    logic saved_write_q;
    logic rsp_owner_seq_q;
    logic [lab12_pkg::CMD_ADDR_WIDTH-1:0] saved_addr_q;
    logic [lab12_pkg::CMD_DATA_WIDTH-1:0] saved_single_wdata_q;
    logic [127:0] saved_burst_wdata_q;

    // In ST_BURST_PIPE, addr_index_q is the address phase on the bus and
    // data_index_q is the preceding data phase completing in parallel.
    logic [1:0] addr_index_q;
    logic [1:0] data_index_q;

    function automatic logic [31:0] select_burst_word(
        input logic [127:0] packed_words,
        input logic [1:0]   index
    );
        case (index)
            2'd0: select_burst_word = packed_words[31:0];
            2'd1: select_burst_word = packed_words[63:32];
            2'd2: select_burst_word = packed_words[95:64];
            default: select_burst_word = packed_words[127:96];
        endcase
    endfunction

    assign bar_cmd_ready = (state_q == ST_IDLE) && !seq_cmd_valid;
    assign seq_cmd_ready = (state_q == ST_IDLE);

    always_comb begin
        ahb.HADDR     = '0;
        ahb.HWDATA    = '0;
        ahb.HWRITE    = 1'b0;
        ahb.HTRANS    = lab12_pkg::AHB_HTRANS_IDLE;
        ahb.HSIZE     = lab12_pkg::AHB_HSIZE_WORD;
        ahb.HBURST    = lab12_pkg::AHB_HBURST_SINGLE;
        ahb.HPROT     = lab12_pkg::AHB_HPROT_DEFAULT;
        ahb.HMASTLOCK = 1'b0;

        unique case (state_q)
            ST_SINGLE_ADDR: begin
                ahb.HADDR  = {{(lab12_pkg::AHB_ADDR_WIDTH-lab12_pkg::CMD_ADDR_WIDTH){1'b0}},
                              saved_addr_q};
                ahb.HWRITE = saved_write_q;
                ahb.HTRANS = lab12_pkg::AHB_HTRANS_NONSEQ;
            end

            ST_SINGLE_DATA: begin
                ahb.HWDATA = saved_single_wdata_q;
            end

            ST_BURST_FIRST_ADDR: begin
                ahb.HADDR  = {{(lab12_pkg::AHB_ADDR_WIDTH-lab12_pkg::CMD_ADDR_WIDTH){1'b0}},
                              saved_addr_q};
                ahb.HWRITE = saved_write_q;
                ahb.HTRANS = lab12_pkg::AHB_HTRANS_NONSEQ;
                ahb.HBURST = lab12_pkg::AHB_HBURST_INCR4;
            end

            ST_BURST_PIPE: begin
                ahb.HADDR  = {{(lab12_pkg::AHB_ADDR_WIDTH-lab12_pkg::CMD_ADDR_WIDTH){1'b0}},
                              saved_addr_q} + ({30'd0, addr_index_q} << 2);
                ahb.HWDATA = select_burst_word(saved_burst_wdata_q, data_index_q);
                ahb.HWRITE = saved_write_q;
                ahb.HTRANS = lab12_pkg::AHB_HTRANS_SEQ;
                ahb.HBURST = lab12_pkg::AHB_HBURST_INCR4;
            end

            ST_BURST_LAST_DATA: begin
                ahb.HWDATA = select_burst_word(saved_burst_wdata_q, 2'd3);
            end

            default: begin
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q              <= ST_IDLE;
            saved_write_q        <= 1'b0;
            rsp_owner_seq_q      <= 1'b0;
            saved_addr_q         <= '0;
            saved_single_wdata_q <= '0;
            saved_burst_wdata_q  <= '0;
            addr_index_q         <= '0;
            data_index_q         <= '0;

            bar_rsp_valid        <= 1'b0;
            bar_rsp_addr         <= '0;
            bar_rsp_data         <= '0;
            bar_rsp_error        <= 1'b0;

            seq_rsp_valid        <= 1'b0;
            seq_rsp_error        <= 1'b0;
            seq_rsp_rdata        <= '0;
            ahb_error_pulse      <= 1'b0;
        end
        else begin
            ahb_error_pulse <= 1'b0;

            unique case (state_q)
                ST_IDLE: begin
                    if (seq_cmd_valid) begin
                        saved_write_q       <= seq_cmd_write;
                        saved_addr_q        <= seq_cmd_addr;
                        saved_burst_wdata_q <= seq_cmd_wdata;
                        addr_index_q        <= 2'd1;
                        data_index_q        <= 2'd0;
                        seq_rsp_error       <= 1'b0;
                        seq_rsp_rdata       <= '0;
                        rsp_owner_seq_q     <= 1'b1;
                        state_q             <= ST_BURST_FIRST_ADDR;
                    end
                    else if (bar_cmd_valid) begin
                        saved_write_q        <= bar_cmd_write;
                        saved_addr_q         <= bar_cmd_addr;
                        saved_single_wdata_q <= bar_cmd_data;
                        bar_rsp_error        <= 1'b0;
                        bar_rsp_data         <= '0;
                        rsp_owner_seq_q      <= 1'b0;
                        state_q              <= ST_SINGLE_ADDR;
                    end
                end

                ST_SINGLE_ADDR: begin
                    if (ahb.HREADY)
                        state_q <= ST_SINGLE_DATA;
                end

                ST_SINGLE_DATA: begin
                    if (ahb.HREADY) begin
                        bar_rsp_valid <= 1'b1;
                        bar_rsp_addr  <= saved_addr_q;
                        bar_rsp_data  <= saved_write_q ? '0 : ahb.HRDATA;
                        bar_rsp_error <= ahb.HRESP;
                        if (ahb.HRESP)
                            ahb_error_pulse <= 1'b1;
                        state_q <= ST_RSP_HOLD;
                    end
                end

                ST_BURST_FIRST_ADDR: begin
                    if (ahb.HREADY)
                        state_q <= ST_BURST_PIPE;
                end

                ST_BURST_PIPE: begin
                    if (ahb.HREADY) begin
                        if (ahb.HRESP) begin
                            seq_rsp_valid   <= 1'b1;
                            seq_rsp_error   <= 1'b1;
                            ahb_error_pulse <= 1'b1;
                            state_q         <= ST_RSP_HOLD;
                        end
                        else begin
                            if (!saved_write_q) begin
                                case (data_index_q)
                                    2'd0: seq_rsp_rdata[31:0]   <= ahb.HRDATA;
                                    2'd1: seq_rsp_rdata[63:32]  <= ahb.HRDATA;
                                    2'd2: seq_rsp_rdata[95:64]  <= ahb.HRDATA;
                                    default: seq_rsp_rdata[127:96] <= ahb.HRDATA;
                                endcase
                            end

                            if (addr_index_q == 2'd3) begin
                                data_index_q <= 2'd3;
                                state_q      <= ST_BURST_LAST_DATA;
                            end
                            else begin
                                addr_index_q <= addr_index_q + 1'b1;
                                data_index_q <= data_index_q + 1'b1;
                            end
                        end
                    end
                end

                ST_BURST_LAST_DATA: begin
                    if (ahb.HREADY) begin
                        if (!saved_write_q)
                            seq_rsp_rdata[127:96] <= ahb.HRDATA;

                        seq_rsp_valid <= 1'b1;
                        seq_rsp_error <= ahb.HRESP;
                        if (ahb.HRESP)
                            ahb_error_pulse <= 1'b1;
                        state_q <= ST_RSP_HOLD;
                    end
                end

                ST_RSP_HOLD: begin
                    if (rsp_owner_seq_q) begin
                        if (seq_rsp_valid && seq_rsp_ready) begin
                            seq_rsp_valid <= 1'b0;
                            state_q       <= ST_IDLE;
                        end
                    end
                    else if (bar_rsp_valid && bar_rsp_ready) begin
                        bar_rsp_valid <= 1'b0;
                        state_q       <= ST_IDLE;
                    end
                end

                default: state_q <= ST_IDLE;
            endcase
        end
    end

endmodule
