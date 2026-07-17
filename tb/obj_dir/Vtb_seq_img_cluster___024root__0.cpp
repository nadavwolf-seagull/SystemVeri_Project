// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_seq_img_cluster.h for the primary calling header

#include "Vtb_seq_img_cluster__pch.h"

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_initial__TOP(Vtb_seq_img_cluster___024root* vlSelf);
VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__0(Vtb_seq_img_cluster___024root* vlSelf);
VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__1(Vtb_seq_img_cluster___024root* vlSelf);
VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__2(Vtb_seq_img_cluster___024root* vlSelf);
VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__3(Vtb_seq_img_cluster___024root* vlSelf);

void Vtb_seq_img_cluster___024root___eval_initial(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_initial\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_seq_img_cluster___024root___eval_initial__TOP(vlSelf);
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__1(vlSelf);
    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__2(vlSelf);
    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__3(vlSelf);
}

VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__0(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__wr_clk = 0U;
    while (true) {
        co_await vlSelfRef.__VdlySched.delay(0x0000000000001388ULL, 
                                             nullptr, 
                                             "tb_seq_img_cluster.sv", 
                                             128);
        vlSelfRef.tb_seq_img_cluster__DOT__wr_clk = 
            (1U & (~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk)));
    }
    co_return;
}

VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__1(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__rd_clk = 0U;
    while (true) {
        co_await vlSelfRef.__VdlySched.delay(0x0000000000001388ULL, 
                                             nullptr, 
                                             "tb_seq_img_cluster.sv", 
                                             133);
        vlSelfRef.tb_seq_img_cluster__DOT__rd_clk = 
            (1U & (~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__rd_clk)));
    }
    co_return;
}

void Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0(Vtb_seq_img_cluster___024root* vlSelf, const char* __VeventDescription);
void Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(Vtb_seq_img_cluster___024root* vlSelf, const char* __VeventDescription);
void Vtb_seq_img_cluster___024root____VbeforeTrig_h66869534__0(Vtb_seq_img_cluster___024root* vlSelf, const char* __VeventDescription);

VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__2(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__2\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ tb_seq_img_cluster__DOT__unnamedblk1_1__DOT____Vrepeat0;
    tb_seq_img_cluster__DOT__unnamedblk1_1__DOT____Vrepeat0 = 0;
    IData/*31:0*/ tb_seq_img_cluster__DOT__unnamedblk1_2__DOT____Vrepeat1;
    tb_seq_img_cluster__DOT__unnamedblk1_2__DOT____Vrepeat1 = 0;
    IData/*31:0*/ tb_seq_img_cluster__DOT__unnamedblk1_3__DOT____Vrepeat2;
    tb_seq_img_cluster__DOT__unnamedblk1_3__DOT____Vrepeat2 = 0;
    SData/*13:0*/ __Vtask_tb_seq_img_cluster__DOT__sram_write__0__addr;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__addr = 0;
    CData/*3:0*/ __Vtask_tb_seq_img_cluster__DOT__sram_write__0__byte_en;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__byte_en = 0;
    IData/*31:0*/ __Vtask_tb_seq_img_cluster__DOT__sram_write__0__r_data;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__r_data = 0;
    IData/*31:0*/ __Vtask_tb_seq_img_cluster__DOT__sram_write__0__g_data;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__g_data = 0;
    IData/*31:0*/ __Vtask_tb_seq_img_cluster__DOT__sram_write__0__b_data;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__b_data = 0;
    SData/*13:0*/ __Vtask_tb_seq_img_cluster__DOT__sram_read__1__addr;
    __Vtask_tb_seq_img_cluster__DOT__sram_read__1__addr = 0;
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__start = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__ae_level = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__af_level = 7U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__pixel_count = 0U;
    tb_seq_img_cluster__DOT__unnamedblk1_1__DOT____Vrepeat0 = 4U;
    while (VL_LTS_III(32, 0U, tb_seq_img_cluster__DOT__unnamedblk1_1__DOT____Vrepeat0)) {
        Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0(vlSelf, 
                                                                  "@(posedge tb_seq_img_cluster.wr_clk)");
        co_await vlSelfRef.__VtrigSched_h50a79562__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_seq_img_cluster.wr_clk)", 
                                                             "tb_seq_img_cluster.sv", 
                                                             236);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        tb_seq_img_cluster__DOT__unnamedblk1_1__DOT____Vrepeat0 
            = (tb_seq_img_cluster__DOT__unnamedblk1_1__DOT____Vrepeat0 
               - (IData)(1U));
    }
    vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n = 1U;
    tb_seq_img_cluster__DOT__unnamedblk1_2__DOT____Vrepeat1 = 2U;
    while (VL_LTS_III(32, 0U, tb_seq_img_cluster__DOT__unnamedblk1_2__DOT____Vrepeat1)) {
        Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0(vlSelf, 
                                                                  "@(posedge tb_seq_img_cluster.wr_clk)");
        co_await vlSelfRef.__VtrigSched_h50a79562__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_seq_img_cluster.wr_clk)", 
                                                             "tb_seq_img_cluster.sv", 
                                                             241);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        tb_seq_img_cluster__DOT__unnamedblk1_2__DOT____Vrepeat1 
            = (tb_seq_img_cluster__DOT__unnamedblk1_2__DOT____Vrepeat1 
               - (IData)(1U));
    }
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram[0U] = 0x11223344U;
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram[0U] = 0x55667788U;
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram[0U] = 0x99aabbccU;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__b_data = 0x00cc0000U;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__g_data = 0x00bb0000U;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__r_data = 0x00aa0000U;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__byte_en = 4U;
    __Vtask_tb_seq_img_cluster__DOT__sram_write__0__addr = 0U;
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(vlSelf, 
                                                              "@(negedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79523__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         147);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr 
        = __Vtask_tb_seq_img_cluster__DOT__sram_write__0__addr;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en 
        = __Vtask_tb_seq_img_cluster__DOT__sram_write__0__byte_en;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata 
        = __Vtask_tb_seq_img_cluster__DOT__sram_write__0__r_data;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata 
        = __Vtask_tb_seq_img_cluster__DOT__sram_write__0__g_data;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata 
        = __Vtask_tb_seq_img_cluster__DOT__sram_write__0__b_data;
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(vlSelf, 
                                                              "@(negedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79523__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         159);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en = 0U;
    __Vtask_tb_seq_img_cluster__DOT__sram_read__1__addr = 0U;
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(vlSelf, 
                                                              "@(negedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79523__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         174);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write = 0U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr 
        = __Vtask_tb_seq_img_cluster__DOT__sram_read__1__addr;
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0(vlSelf, 
                                                              "@(posedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79562__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         180);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x00000000000003e8ULL, 
                                         nullptr, "tb_seq_img_cluster.sv", 
                                         181);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(vlSelf, 
                                                              "@(negedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79523__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         183);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en = 0U;
    VL_WRITEF_NX("Readback R = %08h\nReadback G = %08h\nReadback B = %08h\n",3
                 , '#',32,vlSelfRef.tb_seq_img_cluster__DOT__sram_r_rdata
                 , '#',32,vlSelfRef.tb_seq_img_cluster__DOT__sram_g_rdata
                 , '#',32,vlSelfRef.tb_seq_img_cluster__DOT__sram_b_rdata);
    if (vlSymsp->_vm_contextp__->assertOnGet(2, 1)) {
        if (VL_UNLIKELY(((0x11aa3344U != vlSelfRef.tb_seq_img_cluster__DOT__sram_r_rdata)))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:278: Assertion failed in %m: Red SRAM readback mismatch\n",3, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000));
            VL_STOP_MT("tb_seq_img_cluster.sv", 278, "", false);
        }
        if (VL_UNLIKELY(((0x55bb7788U != vlSelfRef.tb_seq_img_cluster__DOT__sram_g_rdata)))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:281: Assertion failed in %m: Green SRAM readback mismatch\n",3, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000));
            VL_STOP_MT("tb_seq_img_cluster.sv", 281, "", false);
        }
        if (VL_UNLIKELY(((0x99ccbbccU != vlSelfRef.tb_seq_img_cluster__DOT__sram_b_rdata)))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:284: Assertion failed in %m: Blue SRAM readback mismatch\n",3, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000));
            VL_STOP_MT("tb_seq_img_cluster.sv", 284, "", false);
        }
    }
    VL_WRITEF_NX("Port-B byte-write test PASSED\n",0);
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(vlSelf, 
                                                              "@(negedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79523__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         291);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__start = 1U;
    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(vlSelf, 
                                                              "@(negedge tb_seq_img_cluster.wr_clk)");
    co_await vlSelfRef.__VtrigSched_h50a79523__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(negedge tb_seq_img_cluster.wr_clk)", 
                                                         "tb_seq_img_cluster.sv", 
                                                         294);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_seq_img_cluster__DOT__start = 0U;
    while ((1U & (~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__transfer_done)))) {
        Vtb_seq_img_cluster___024root____VbeforeTrig_h66869534__0(vlSelf, 
                                                                  "@( tb_seq_img_cluster.transfer_done)");
        co_await vlSelfRef.__VtrigSched_h66869534__0.trigger(1U, 
                                                             nullptr, 
                                                             "@( tb_seq_img_cluster.transfer_done)", 
                                                             "tb_seq_img_cluster.sv", 
                                                             297);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
    }
    tb_seq_img_cluster__DOT__unnamedblk1_3__DOT____Vrepeat2 = 2U;
    while (VL_LTS_III(32, 0U, tb_seq_img_cluster__DOT__unnamedblk1_3__DOT____Vrepeat2)) {
        Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0(vlSelf, 
                                                                  "@(posedge tb_seq_img_cluster.wr_clk)");
        co_await vlSelfRef.__VtrigSched_h50a79562__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_seq_img_cluster.wr_clk)", 
                                                             "tb_seq_img_cluster.sv", 
                                                             298);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        tb_seq_img_cluster__DOT__unnamedblk1_3__DOT____Vrepeat2 
            = (tb_seq_img_cluster__DOT__unnamedblk1_3__DOT____Vrepeat2 
               - (IData)(1U));
    }
    if (vlSymsp->_vm_contextp__->assertOnGet(2, 1)) {
        if (VL_UNLIKELY(((4U != vlSelfRef.tb_seq_img_cluster__DOT__pixel_count)))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:301: Assertion failed in %m: Expected 4 pixels, observed %0d\n",4, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000)
                         , '~',32,vlSelfRef.tb_seq_img_cluster__DOT__pixel_count);
            VL_STOP_MT("tb_seq_img_cluster.sv", 301, "", false);
        }
        if (VL_UNLIKELY(((0x00115599U != vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[0U])))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:309: Assertion failed in %m: Pixel 0 mismatch: %06h\n",4, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000)
                         , '#',24,vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[0U]);
            VL_STOP_MT("tb_seq_img_cluster.sv", 309, "", false);
        }
        if (VL_UNLIKELY(((0x00aabbccU != vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[1U])))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:317: Assertion failed in %m: Pixel 1 mismatch: %06h\n",4, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000)
                         , '#',24,vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[1U]);
            VL_STOP_MT("tb_seq_img_cluster.sv", 317, "", false);
        }
        if (VL_UNLIKELY(((0x003377bbU != vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[2U])))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:325: Assertion failed in %m: Pixel 2 mismatch: %06h\n",4, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000)
                         , '#',24,vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[2U]);
            VL_STOP_MT("tb_seq_img_cluster.sv", 325, "", false);
        }
        if (VL_UNLIKELY(((0x004488ccU != vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[3U])))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:332: Assertion failed in %m: Pixel 3 mismatch: %06h\n",4, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000)
                         , '#',24,vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[3U]);
            VL_STOP_MT("tb_seq_img_cluster.sv", 332, "", false);
        }
        if (VL_UNLIKELY((vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__error))) {
            VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:339: Assertion failed in %m: FIFO error asserted\n",3, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000));
            VL_STOP_MT("tb_seq_img_cluster.sv", 339, "", false);
        }
    }
    VL_WRITEF_NX("========================================\nseq_img_cluster SRAM test PASSED\n========================================\n",0);
    VL_FINISH_MT("tb_seq_img_cluster.sv", 345, "");
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_return;
}

VlCoroutine Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__3(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_initial__TOP__Vtiming__3\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    co_await vlSelfRef.__VdlySched.delay(0x0000000000989680ULL, 
                                         nullptr, "tb_seq_img_cluster.sv", 
                                         350);
    VL_WRITEF_NX("[%0t] %%Fatal: tb_seq_img_cluster.sv:351: Assertion failed in %m: Simulation timeout\n",3, 'M',vlSymsp->name(),"tb_seq_img_cluster", 'T',-9
                 , '#',64,VL_TIME_UNITED_Q(1000));
    VL_STOP_MT("tb_seq_img_cluster.sv", 351, "", false);
    co_return;
}

void Vtb_seq_img_cluster___024root___eval_triggers_vec__act(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_triggers_vec__act\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    (((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__transfer_done) 
                                                        != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__transfer_done__0)) 
                                                       << 6U) 
                                                      | ((((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk)) 
                                                           & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0)) 
                                                          << 5U) 
                                                         | (vlSelfRef.__VdlySched.awaitingCurrentTime() 
                                                            << 4U))) 
                                                     | (((((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n)) 
                                                           & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_rst_n__0)) 
                                                          << 3U) 
                                                         | (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__rd_clk) 
                                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_clk__0))) 
                                                            << 2U)) 
                                                        | ((((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n)) 
                                                             & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_rst_n__0)) 
                                                            << 1U) 
                                                           | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk) 
                                                              & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0))))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__wr_clk;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_rst_n__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_clk__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__rd_clk;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_rst_n__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__transfer_done__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__transfer_done;
}

bool Vtb_seq_img_cluster___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vtb_seq_img_cluster___024root___act_comb__TOP__0(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___act_comb__TOP__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next 
        = ((0x0000000fU & ((IData)(8U) - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next))) 
           <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__af_level));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__error 
        = (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req) 
            & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
           | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full) 
              & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en 
        = ((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
           & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin) 
                          + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next) 
           ^ VL_SHIFTR_III(4,4,32, (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next), 1U));
}

void Vtb_seq_img_cluster___024root___eval_act(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_act\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((0x0000000000000071ULL & vlSelfRef.__VactTriggered[0U])) {
        Vtb_seq_img_cluster___024root___act_comb__TOP__0(vlSelf);
    }
}

extern const VlUnpacked<CData/*3:0*/, 512> Vtb_seq_img_cluster__ConstPool__TABLE_hfb8b0437_0;

void Vtb_seq_img_cluster___024root___nba_sequent__TOP__0(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_sequent__TOP__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*1:0*/ __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx;
    __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx = 0;
    SData/*9:0*/ __Vdly__tb_seq_img_cluster__DOT__row_cnt;
    __Vdly__tb_seq_img_cluster__DOT__row_cnt = 0;
    SData/*9:0*/ __Vdly__tb_seq_img_cluster__DOT__col_cnt;
    __Vdly__tb_seq_img_cluster__DOT__col_cnt = 0;
    // Body
    __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx 
        = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx;
    __Vdly__tb_seq_img_cluster__DOT__col_cnt = vlSelfRef.tb_seq_img_cluster__DOT__col_cnt;
    __Vdly__tb_seq_img_cluster__DOT__row_cnt = vlSelfRef.tb_seq_img_cluster__DOT__row_cnt;
    vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr 
        = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr;
    vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state 
        = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state;
    vlSelfRef.tb_seq_img_cluster__DOT__fifo_almost_full 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n) 
           && (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next));
    vlSelfRef.tb_seq_img_cluster__DOT__fifo_half_full 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n) 
           && (4U <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next)));
    vlSelfRef.tb_seq_img_cluster__DOT__fifo_full = 
        ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n) 
         && (((0x0000000cU & ((~ ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                  >> 2U)) << 2U)) | 
              (3U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2))) 
             == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next)));
    if (vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n) {
        if ((2U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))) {
            __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx = 0U;
            vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q 
                = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_r_data;
            vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q 
                = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_g_data;
            vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q 
                = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_b_data;
        } else if ((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))) {
            __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx 
                = (3U & ((IData)(1U) + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx)));
        }
        if (((0U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state)) 
             & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__start))) {
            __Vdly__tb_seq_img_cluster__DOT__col_cnt = 0U;
            __Vdly__tb_seq_img_cluster__DOT__row_cnt = 0U;
            vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr = 0U;
            vlSelfRef.tb_seq_img_cluster__DOT__transfer_done = 0U;
        } else {
            if ((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))) {
                if ((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt))) {
                    __Vdly__tb_seq_img_cluster__DOT__col_cnt = 0U;
                    if ((0U != (IData)(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt))) {
                        __Vdly__tb_seq_img_cluster__DOT__row_cnt 
                            = (0x000003ffU & ((IData)(1U) 
                                              + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt)));
                    }
                } else {
                    __Vdly__tb_seq_img_cluster__DOT__col_cnt 
                        = (0x000003ffU & ((IData)(1U) 
                                          + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt)));
                }
            }
            if ((((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state)) 
                  & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx))) 
                 & (~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel)))) {
                vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr 
                    = (0x00003fffU & ((IData)(1U) + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr)));
            }
            if (((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state)) 
                 & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel))) {
                vlSelfRef.tb_seq_img_cluster__DOT__transfer_done = 1U;
            }
        }
        vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state 
            = Vtb_seq_img_cluster__ConstPool__TABLE_hfb8b0437_0
            [((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__start) 
                << 8U) | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                          << 6U)) | (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel) 
                                      << 5U) | (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause) 
                                                 << 4U) 
                                                | (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))))];
        if (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next) {
            vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause = 1U;
        } else if (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next) 
                    <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__ae_level))) {
            vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause = 0U;
        }
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray;
    } else {
        __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx = 0U;
        __Vdly__tb_seq_img_cluster__DOT__col_cnt = 0U;
        __Vdly__tb_seq_img_cluster__DOT__row_cnt = 0U;
        vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr = 0U;
        vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__transfer_done = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2 = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1 = 0U;
    }
    vlSelfRef.tb_seq_img_cluster__DOT__row_cnt = __Vdly__tb_seq_img_cluster__DOT__row_cnt;
    vlSelfRef.tb_seq_img_cluster__DOT__col_cnt = __Vdly__tb_seq_img_cluster__DOT__col_cnt;
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx 
        = __Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx;
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel 
        = ((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt)) 
           & (0U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w 
        = ((((2U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                    >> 2U)) | (1U & VL_REDXOR_32((3U 
                                                  & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                                     >> 2U))))) 
            << 2U) | ((2U & (VL_REDXOR_32((7U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                                 >> 1U))) 
                             << 1U)) | (1U & VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2))));
}

void Vtb_seq_img_cluster___024root___nba_sequent__TOP__1(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_sequent__TOP__1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __Vdly__tb_seq_img_cluster__DOT__pixel_count;
    __Vdly__tb_seq_img_cluster__DOT__pixel_count = 0;
    IData/*31:0*/ __VdlyMask__tb_seq_img_cluster__DOT__pixel_count;
    __VdlyMask__tb_seq_img_cluster__DOT__pixel_count = 0;
    IData/*23:0*/ __VdlyVal__tb_seq_img_cluster__DOT__observed_pixels__v0;
    __VdlyVal__tb_seq_img_cluster__DOT__observed_pixels__v0 = 0;
    CData/*1:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__observed_pixels__v0;
    __VdlyDim0__tb_seq_img_cluster__DOT__observed_pixels__v0 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__observed_pixels__v0;
    __VdlySet__tb_seq_img_cluster__DOT__observed_pixels__v0 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 = 0;
    CData/*7:0*/ __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3;
    __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 = 0;
    SData/*13:0*/ __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3;
    __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 = 0;
    CData/*0:0*/ __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 = 0;
    // Body
    __VdlySet__tb_seq_img_cluster__DOT__observed_pixels__v0 = 0U;
    vlSelfRef.__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 = 0U;
    __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 = 0U;
    if (vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n) {
        if (VL_UNLIKELY(((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))))) {
            __VdlyVal__tb_seq_img_cluster__DOT__observed_pixels__v0 
                = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in;
            __VdlyDim0__tb_seq_img_cluster__DOT__observed_pixels__v0 
                = (3U & vlSelfRef.tb_seq_img_cluster__DOT__pixel_count);
            __VdlySet__tb_seq_img_cluster__DOT__observed_pixels__v0 = 1U;
            VL_WRITEF_NX("[%0t] Pixel %0d = R:%02h G:%02h B:%02h\n",6, 'T',-9
                         , '#',64,VL_TIME_UNITED_Q(1000)
                         , '~',32,vlSelfRef.tb_seq_img_cluster__DOT__pixel_count
                         , '#',8,(0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in 
                                                 >> 0x10U))
                         , '#',8,(0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in 
                                                 >> 8U))
                         , '#',8,(0x000000ffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in));
            __Vdly__tb_seq_img_cluster__DOT__pixel_count 
                = ((IData)(1U) + vlSelfRef.tb_seq_img_cluster__DOT__pixel_count);
            __VdlyMask__tb_seq_img_cluster__DOT__pixel_count = 0xffffffffU;
        }
    } else {
        __Vdly__tb_seq_img_cluster__DOT__pixel_count = 0U;
        __VdlyMask__tb_seq_img_cluster__DOT__pixel_count = 0xffffffffU;
    }
    if (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en) {
        vlSelfRef.__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in;
        vlSelfRef.__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 
            = (7U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin));
        vlSelfRef.__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 = 1U;
    }
    if (vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en) {
        if (vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write) {
            if ((8U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en))) {
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 
                    = (vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata 
                       >> 0x18U);
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 
                    = (vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata 
                       >> 0x18U);
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 
                    = (vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata 
                       >> 0x18U);
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0 = 1U;
            }
            if ((4U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en))) {
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 
                    = (0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata 
                                      >> 0x10U));
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 
                    = (0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata 
                                      >> 0x10U));
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 
                    = (0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata 
                                      >> 0x10U));
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1 = 1U;
            }
            if ((2U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en))) {
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 
                    = (0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata 
                                      >> 8U));
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 
                    = (0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata 
                                      >> 8U));
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 
                    = (0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata 
                                      >> 8U));
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2 = 1U;
            }
            if ((1U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en))) {
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 
                    = (0x000000ffU & vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata);
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 
                    = (0x000000ffU & vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata);
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3 = 1U;
                __VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 
                    = (0x000000ffU & vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata);
                __VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 
                    = vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr;
                __VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3 = 1U;
            }
        }
        vlSelfRef.tb_seq_img_cluster__DOT__sram_r_rdata 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram
            [vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr];
        vlSelfRef.tb_seq_img_cluster__DOT__sram_g_rdata 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram
            [vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr];
        vlSelfRef.tb_seq_img_cluster__DOT__sram_b_rdata 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram
            [vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr];
    }
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_r_data 
        = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram
        [vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr];
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_g_data 
        = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram
        [vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr];
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_b_data 
        = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram
        [vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr];
    vlSelfRef.tb_seq_img_cluster__DOT__pixel_count 
        = ((__Vdly__tb_seq_img_cluster__DOT__pixel_count 
            & __VdlyMask__tb_seq_img_cluster__DOT__pixel_count) 
           | (vlSelfRef.tb_seq_img_cluster__DOT__pixel_count 
              & (~ __VdlyMask__tb_seq_img_cluster__DOT__pixel_count)));
    __VdlyMask__tb_seq_img_cluster__DOT__pixel_count = 0U;
    if (__VdlySet__tb_seq_img_cluster__DOT__observed_pixels__v0) {
        vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels[__VdlyDim0__tb_seq_img_cluster__DOT__observed_pixels__v0] 
            = __VdlyVal__tb_seq_img_cluster__DOT__observed_pixels__v0;
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0] 
            = ((0x00ffffffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v0) 
                  << 0x00000018U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1] 
            = ((0xff00ffffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v1) 
                  << 0x00000010U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2] 
            = ((0xffff00ffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v2) 
                  << 8U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3] 
            = ((0xffffff00U & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3]) 
               | (IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram__v3));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0] 
            = ((0x00ffffffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v0) 
                  << 0x00000018U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1] 
            = ((0xff00ffffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v1) 
                  << 0x00000010U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2] 
            = ((0xffff00ffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v2) 
                  << 8U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3] 
            = ((0xffffff00U & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3]) 
               | (IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram__v3));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0] 
            = ((0x00ffffffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v0) 
                  << 0x00000018U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1] 
            = ((0xff00ffffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v1) 
                  << 0x00000010U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2] 
            = ((0xffff00ffU & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2]) 
               | ((IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v2) 
                  << 8U));
    }
    if (__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram[__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3] 
            = ((0xffffff00U & vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram
                [__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3]) 
               | (IData)(__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram__v3));
    }
}

void Vtb_seq_img_cluster___024root___nba_sequent__TOP__2(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_sequent__TOP__2\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__fifo_almost_empty 
        = ((1U & (~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n))) 
           || ((0x0000000fU & (((((2U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                         >> 2U)) | 
                                  (1U & VL_REDXOR_32(
                                                     (3U 
                                                      & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                         >> 2U))))) 
                                 << 2U) | ((2U & (VL_REDXOR_32(
                                                               (7U 
                                                                & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                   >> 1U))) 
                                                  << 1U)) 
                                           | (1U & 
                                              VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2)))) 
                               - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next))) 
               <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__ae_level)));
    vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty = 
        ((1U & (~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n))) 
         || ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
             == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next)));
    if (vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n) {
        if (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en) {
            vlSelfRef.tb_seq_img_cluster__DOT__fifo_data_out 
                = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem
                [(7U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin))];
        }
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray;
    } else {
        vlSelfRef.tb_seq_img_cluster__DOT__fifo_data_out = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2 = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1 = 0U;
    }
}

void Vtb_seq_img_cluster___024root___nba_sequent__TOP__3(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_sequent__TOP__3\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state 
        = vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state;
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in 
        = ((0x00ff0000U & ((vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q 
                            >> (0x0000001fU & (((IData)(0x1fU) 
                                                - ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                   << 3U)) 
                                               - (IData)(7U)))) 
                           << 0x00000010U)) | ((0x0000ff00U 
                                                & ((vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q 
                                                    >> 
                                                    (0x0000001fU 
                                                     & (((IData)(0x1fU) 
                                                         - 
                                                         ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                          << 3U)) 
                                                        - (IData)(7U)))) 
                                                   << 8U)) 
                                               | (0x000000ffU 
                                                  & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q 
                                                     >> 
                                                     (0x0000001fU 
                                                      & (((IData)(0x1fU) 
                                                          - 
                                                          ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                           << 3U)) 
                                                         - (IData)(7U)))))));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr 
        = vlSelfRef.__Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr;
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en 
        = ((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full)) 
           & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state)));
    if (vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray 
            = vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next;
    } else {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin = 0U;
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray = 0U;
    }
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin) 
                          + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next) 
                          - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next) 
           ^ VL_SHIFTR_III(4,4,32, (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next), 1U));
}

void Vtb_seq_img_cluster___024root___nba_sequent__TOP__4(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_sequent__TOP__4\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0) {
        vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem[vlSelfRef.__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0] 
            = vlSelfRef.__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0;
    }
}

void Vtb_seq_img_cluster___024root___nba_comb__TOP__0(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_comb__TOP__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en 
        = ((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
           & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin) 
                          + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next) 
           ^ VL_SHIFTR_III(4,4,32, (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next), 1U));
}

void Vtb_seq_img_cluster___024root___nba_comb__TOP__1(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_comb__TOP__1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__error 
        = (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req) 
            & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
           | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full) 
              & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
}

void Vtb_seq_img_cluster___024root___nba_comb__TOP__2(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___nba_comb__TOP__2\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next 
        = ((0x0000000fU & ((IData)(8U) - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next))) 
           <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__af_level));
}

void Vtb_seq_img_cluster___024root___eval_nba(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_nba\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_sequent__TOP__1(vlSelf);
        vlSelfRef.__Vm_traceActivity[4U] = 1U;
    }
    if ((0x000000000000000cULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_sequent__TOP__2(vlSelf);
        vlSelfRef.__Vm_traceActivity[5U] = 1U;
    }
    if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_sequent__TOP__3(vlSelf);
        vlSelfRef.__Vm_traceActivity[6U] = 1U;
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_sequent__TOP__4(vlSelf);
    }
    if ((0x000000000000007dULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_comb__TOP__0(vlSelf);
    }
    if ((0x000000000000007fULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_comb__TOP__1(vlSelf);
    }
    if ((0x0000000000000073ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtb_seq_img_cluster___024root___nba_comb__TOP__2(vlSelf);
    }
}

void Vtb_seq_img_cluster___024root___timing_ready(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___timing_ready\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h50a79562__0.ready("@(posedge tb_seq_img_cluster.wr_clk)");
    }
    if ((0x0000000000000020ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h50a79523__0.ready("@(negedge tb_seq_img_cluster.wr_clk)");
    }
    if ((0x0000000000000040ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VtrigSched_h66869534__0.ready("@( tb_seq_img_cluster.transfer_done)");
    }
}

void Vtb_seq_img_cluster___024root___timing_resume(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___timing_resume\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VtrigSched_h50a79562__0.moveToResumeQueue(
                                                          "@(posedge tb_seq_img_cluster.wr_clk)");
    vlSelfRef.__VtrigSched_h50a79523__0.moveToResumeQueue(
                                                          "@(negedge tb_seq_img_cluster.wr_clk)");
    vlSelfRef.__VtrigSched_h66869534__0.moveToResumeQueue(
                                                          "@( tb_seq_img_cluster.transfer_done)");
    vlSelfRef.__VtrigSched_h50a79562__0.resume("@(posedge tb_seq_img_cluster.wr_clk)");
    vlSelfRef.__VtrigSched_h50a79523__0.resume("@(negedge tb_seq_img_cluster.wr_clk)");
    vlSelfRef.__VtrigSched_h66869534__0.resume("@( tb_seq_img_cluster.transfer_done)");
    if ((0x0000000000000010ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vtb_seq_img_cluster___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seq_img_cluster___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtb_seq_img_cluster___024root___eval_phase__act(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_phase__act\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    Vtb_seq_img_cluster___024root___eval_triggers_vec__act(vlSelf);
    Vtb_seq_img_cluster___024root___timing_ready(vlSelf);
    Vtb_seq_img_cluster___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_seq_img_cluster___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtb_seq_img_cluster___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vtb_seq_img_cluster___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vtb_seq_img_cluster___024root___timing_resume(vlSelf);
        Vtb_seq_img_cluster___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtb_seq_img_cluster___024root___eval_phase__inact(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_phase__inact\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("tb_seq_img_cluster.sv", 3, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vtb_seq_img_cluster___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vtb_seq_img_cluster___024root___eval_phase__nba(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_phase__nba\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtb_seq_img_cluster___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vtb_seq_img_cluster___024root___eval_nba(vlSelf);
        Vtb_seq_img_cluster___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vtb_seq_img_cluster___024root___eval(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtb_seq_img_cluster___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("tb_seq_img_cluster.sv", 3, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("tb_seq_img_cluster.sv", 3, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vtb_seq_img_cluster___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("tb_seq_img_cluster.sv", 3, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
                }
                vlSelfRef.__VactIterCount = ((IData)(1U) 
                                             + vlSelfRef.__VactIterCount);
                vlSelfRef.__VactPhaseResult = Vtb_seq_img_cluster___024root___eval_phase__act(vlSelf);
            } while (vlSelfRef.__VactPhaseResult);
            vlSelfRef.__VinactPhaseResult = Vtb_seq_img_cluster___024root___eval_phase__inact(vlSelf);
        } while (vlSelfRef.__VinactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vtb_seq_img_cluster___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

void Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0(Vtb_seq_img_cluster___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79562__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk)) 
                                    & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0)) 
                                   << 5U) | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk) 
                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__wr_clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
    }
    if ((0x0000000000000020ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

void Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0(Vtb_seq_img_cluster___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root____VbeforeTrig_h50a79523__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)(((((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk)) 
                                    & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0)) 
                                   << 5U) | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk) 
                                             & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__wr_clk;
    if ((1ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79562__0.ready(__VeventDescription);
    }
    if ((0x0000000000000020ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
        vlSelfRef.__VtrigSched_h50a79523__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

void Vtb_seq_img_cluster___024root____VbeforeTrig_h66869534__0(Vtb_seq_img_cluster___024root* vlSelf, const char* __VeventDescription) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root____VbeforeTrig_h66869534__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlUnpacked<QData/*63:0*/, 1> __VTmp;
    // Body
    __VTmp[0U] = (QData)((IData)((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__transfer_done) 
                                   != (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__transfer_done__0)) 
                                  << 6U)));
    vlSelfRef.__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__transfer_done__0 
        = vlSelfRef.tb_seq_img_cluster__DOT__transfer_done;
    if ((0x0000000000000040ULL & __VTmp[0U])) {
        vlSelfRef.__VtrigSched_h66869534__0.ready(__VeventDescription);
    }
    vlSelfRef.__VactTriggeredAcc[0U] = (vlSelfRef.__VactTriggeredAcc[0U] 
                                        | __VTmp[0U]);
}

#ifdef VL_DEBUG
void Vtb_seq_img_cluster___024root___eval_debug_assertions(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_debug_assertions\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
