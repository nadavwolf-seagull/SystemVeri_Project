// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_seq_img_cluster.h for the primary calling header

#ifndef VERILATED_VTB_SEQ_IMG_CLUSTER___024ROOT_H_
#define VERILATED_VTB_SEQ_IMG_CLUSTER___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_seq_img_cluster__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_seq_img_cluster___024root final {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*0:0*/ tb_seq_img_cluster__DOT__wr_clk;
        CData/*0:0*/ tb_seq_img_cluster__DOT__wr_rst_n;
        CData/*0:0*/ tb_seq_img_cluster__DOT__rd_clk;
        CData/*0:0*/ tb_seq_img_cluster__DOT__rd_rst_n;
        CData/*0:0*/ tb_seq_img_cluster__DOT__start;
        CData/*0:0*/ tb_seq_img_cluster__DOT__fifo_pop_req;
        CData/*3:0*/ tb_seq_img_cluster__DOT__ae_level;
        CData/*3:0*/ tb_seq_img_cluster__DOT__af_level;
        CData/*0:0*/ tb_seq_img_cluster__DOT__sram_bus_en;
        CData/*0:0*/ tb_seq_img_cluster__DOT__sram_bus_write;
        CData/*3:0*/ tb_seq_img_cluster__DOT__sram_byte_en;
        CData/*0:0*/ tb_seq_img_cluster__DOT__fifo_empty;
        CData/*0:0*/ tb_seq_img_cluster__DOT__fifo_almost_empty;
        CData/*0:0*/ tb_seq_img_cluster__DOT__fifo_half_full;
        CData/*0:0*/ tb_seq_img_cluster__DOT__fifo_almost_full;
        CData/*0:0*/ tb_seq_img_cluster__DOT__fifo_full;
        CData/*0:0*/ tb_seq_img_cluster__DOT__transfer_done;
        CData/*0:0*/ tb_seq_img_cluster__DOT__dut__DOT__rom_pause;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state;
        CData/*1:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx;
        CData/*0:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel;
        CData/*0:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en;
        CData/*0:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en;
        CData/*0:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__error;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w;
        CData/*3:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next;
        CData/*0:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next;
        CData/*3:0*/ __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state;
        CData/*2:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0;
        CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VstlPhaseResult;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_rst_n__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_clk__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_rst_n__0;
        CData/*0:0*/ __Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__transfer_done__0;
        CData/*0:0*/ __VactPhaseResult;
        CData/*0:0*/ __VinactPhaseResult;
        CData/*0:0*/ __VnbaPhaseResult;
        SData/*13:0*/ tb_seq_img_cluster__DOT__sram_bus_addr;
        SData/*9:0*/ tb_seq_img_cluster__DOT__row_cnt;
        SData/*9:0*/ tb_seq_img_cluster__DOT__col_cnt;
        SData/*13:0*/ tb_seq_img_cluster__DOT__dut__DOT__rom_addr;
        SData/*13:0*/ __Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr;
        IData/*31:0*/ tb_seq_img_cluster__DOT__sram_r_wdata;
        IData/*31:0*/ tb_seq_img_cluster__DOT__sram_g_wdata;
        IData/*31:0*/ tb_seq_img_cluster__DOT__sram_b_wdata;
        IData/*31:0*/ tb_seq_img_cluster__DOT__sram_r_rdata;
        IData/*31:0*/ tb_seq_img_cluster__DOT__sram_g_rdata;
        IData/*31:0*/ tb_seq_img_cluster__DOT__sram_b_rdata;
        IData/*23:0*/ tb_seq_img_cluster__DOT__fifo_data_out;
    };
    struct {
        IData/*31:0*/ tb_seq_img_cluster__DOT__pixel_count;
        IData/*31:0*/ tb_seq_img_cluster__DOT__dut__DOT__rom_r_data;
        IData/*31:0*/ tb_seq_img_cluster__DOT__dut__DOT__rom_g_data;
        IData/*31:0*/ tb_seq_img_cluster__DOT__dut__DOT__rom_b_data;
        IData/*31:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q;
        IData/*31:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q;
        IData/*31:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q;
        IData/*23:0*/ tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in;
        IData/*23:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0;
        IData/*31:0*/ __VactIterCount;
        IData/*31:0*/ __VinactIterCount;
        IData/*31:0*/ __Vi;
        VlUnpacked<IData/*23:0*/, 4> tb_seq_img_cluster__DOT__observed_pixels;
        VlUnpacked<IData/*31:0*/, 16384> tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram;
        VlUnpacked<IData/*31:0*/, 16384> tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram;
        VlUnpacked<IData/*31:0*/, 16384> tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram;
        VlUnpacked<IData/*23:0*/, 8> tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem;
        VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
        VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
        VlUnpacked<CData/*0:0*/, 7> __Vm_traceActivity;
    };
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_h50a79562__0;
    VlTriggerScheduler __VtrigSched_h50a79523__0;
    VlTriggerScheduler __VtrigSched_h66869534__0;

    // INTERNAL VARIABLES
    Vtb_seq_img_cluster__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_seq_img_cluster___024root(Vtb_seq_img_cluster__Syms* symsp, const char* namep);
    ~Vtb_seq_img_cluster___024root();
    VL_UNCOPYABLE(Vtb_seq_img_cluster___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
