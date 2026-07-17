// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_seq_img_cluster.h for the primary calling header

#include "Vtb_seq_img_cluster__pch.h"

void Vtb_seq_img_cluster___024root___timing_ready(Vtb_seq_img_cluster___024root* vlSelf);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_static(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_static\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (0x0000000000000040ULL 
                                     | vlSelfRef.__VactTriggered[0U]);
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
    Vtb_seq_img_cluster___024root___timing_ready(vlSelf);
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_initial__TOP(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_initial__TOP\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_READMEM_N(true, 32, 16384, 0, "red_hex.mem"s
                 ,  &(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram)
                 , 0, ~0ULL);
    VL_READMEM_N(true, 32, 16384, 0, "green_hex.mem"s
                 ,  &(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram)
                 , 0, ~0ULL);
    VL_READMEM_N(true, 32, 16384, 0, "blue_hex.mem"s
                 ,  &(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram)
                 , 0, ~0ULL);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_final(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_final\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seq_img_cluster___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtb_seq_img_cluster___024root___eval_phase__stl(Vtb_seq_img_cluster___024root* vlSelf);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_settle(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_settle\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtb_seq_img_cluster___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("tb_seq_img_cluster.sv", 3, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vtb_seq_img_cluster___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_triggers_vec__stl(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_triggers_vec__stl\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vtb_seq_img_cluster___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seq_img_cluster___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_seq_img_cluster___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vtb_seq_img_cluster___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___trigger_anySet__stl\n"); );
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

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___stl_sequent__TOP__0(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___stl_sequent__TOP__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel 
        = ((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt)) 
           & (0U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__error 
        = (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req) 
            & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
           | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full) 
              & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
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
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en 
        = ((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
           & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w 
        = ((((2U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                    >> 2U)) | (1U & VL_REDXOR_32((3U 
                                                  & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                                     >> 2U))))) 
            << 2U) | ((2U & (VL_REDXOR_32((7U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                                 >> 1U))) 
                             << 1U)) | (1U & VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2))));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en 
        = ((~ (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full)) 
           & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin) 
                          + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin) 
                          + (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next) 
           ^ VL_SHIFTR_III(4,4,32, (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next), 1U));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next 
        = ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next) 
           ^ VL_SHIFTR_III(4,4,32, (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next), 1U));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next 
        = (0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next) 
                          - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w)));
    vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next 
        = ((0x0000000fU & ((IData)(8U) - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next))) 
           <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__af_level));
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root____Vm_traceActivitySetAll(Vtb_seq_img_cluster___024root* vlSelf);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___eval_stl(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_stl\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        Vtb_seq_img_cluster___024root___stl_sequent__TOP__0(vlSelf);
        Vtb_seq_img_cluster___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD bool Vtb_seq_img_cluster___024root___eval_phase__stl(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___eval_phase__stl\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtb_seq_img_cluster___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_seq_img_cluster___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vtb_seq_img_cluster___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vtb_seq_img_cluster___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vtb_seq_img_cluster___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_seq_img_cluster___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vtb_seq_img_cluster___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge tb_seq_img_cluster.wr_clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(negedge tb_seq_img_cluster.wr_rst_n)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 2U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 2 is active: @(posedge tb_seq_img_cluster.rd_clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 3U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 3 is active: @(negedge tb_seq_img_cluster.rd_rst_n)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 4U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 4 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
    if ((1U & (IData)((triggers[0U] >> 5U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 5 is active: @(negedge tb_seq_img_cluster.wr_clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 6U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 6 is active: @( tb_seq_img_cluster.transfer_done)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_seq_img_cluster___024root____Vm_traceActivitySetAll(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root____Vm_traceActivitySetAll\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
    vlSelfRef.__Vm_traceActivity[4U] = 1U;
    vlSelfRef.__Vm_traceActivity[5U] = 1U;
    vlSelfRef.__Vm_traceActivity[6U] = 1U;
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root___ctor_var_reset(Vtb_seq_img_cluster___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root___ctor_var_reset\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->tb_seq_img_cluster__DOT__wr_clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 17579865265717877935ull);
    vlSelf->tb_seq_img_cluster__DOT__wr_rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15102081407967378015ull);
    vlSelf->tb_seq_img_cluster__DOT__rd_clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12958750073168285969ull);
    vlSelf->tb_seq_img_cluster__DOT__rd_rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12369841432684162419ull);
    vlSelf->tb_seq_img_cluster__DOT__start = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8231158251612074735ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_pop_req = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11989823584081957142ull);
    vlSelf->tb_seq_img_cluster__DOT__ae_level = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 15356600321411740432ull);
    vlSelf->tb_seq_img_cluster__DOT__af_level = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 16047028389484705041ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_bus_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5238783893624753104ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_bus_write = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10515909007709530604ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_bus_addr = VL_SCOPED_RAND_RESET_I(14, __VscopeHash, 64172126803054137ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_r_wdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10015932589009575112ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_g_wdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7224456369663339745ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_b_wdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14355557860019738398ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_byte_en = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 4787448109886944242ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_r_rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15662555136428809178ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_g_rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 141565315828568028ull);
    vlSelf->tb_seq_img_cluster__DOT__sram_b_rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9844466235215276757ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_data_out = VL_SCOPED_RAND_RESET_I(24, __VscopeHash, 5574798198690914268ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_empty = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1461921368719394987ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_almost_empty = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2234616272782138279ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_half_full = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15963314258888214682ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_almost_full = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1903985640265489690ull);
    vlSelf->tb_seq_img_cluster__DOT__fifo_full = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2044882633735848384ull);
    vlSelf->tb_seq_img_cluster__DOT__row_cnt = VL_SCOPED_RAND_RESET_I(10, __VscopeHash, 14602861448328796908ull);
    vlSelf->tb_seq_img_cluster__DOT__col_cnt = VL_SCOPED_RAND_RESET_I(10, __VscopeHash, 9606679694253080337ull);
    vlSelf->tb_seq_img_cluster__DOT__transfer_done = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13639189212470743746ull);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->tb_seq_img_cluster__DOT__observed_pixels[__Vi0] = VL_SCOPED_RAND_RESET_I(24, __VscopeHash, 10461034452781605233ull);
    }
    vlSelf->tb_seq_img_cluster__DOT__pixel_count = 0;
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__rom_addr = VL_SCOPED_RAND_RESET_I(14, __VscopeHash, 13835884463151595583ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__rom_r_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3311127158689689176ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__rom_g_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 758974215526554149ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__rom_b_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14927957457937349229ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__rom_pause = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8513440042235169433ull);
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__red_sram[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 979047201372002760ull);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__green_sram[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16364171543807185899ull);
    }
    for (int __Vi0 = 0; __Vi0 < 16384; ++__Vi0) {
        vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_rgb_sram_subsystem__DOT__blue_sram[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3767509297761871378ull);
    }
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 1939048671047476728ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 8046574581475937774ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17899445783562359282ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 16694208982389607012ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 70578817017287062ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12518204472434689938ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 11416475178185987730ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1939417429073488479ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__error = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8208557543264526159ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 12338871302118149417ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 7618951158275574059ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 6026044773694591557ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 18096045139881689035ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 4193368377697375934ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 5106135196046384874ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 6667998596745699104ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 6673116350775388457ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 12297106582609733229ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 1101912344826003327ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 2563770623779665301ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2 = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 16358471297962104924ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 14790490787003381623ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 13419633568379156560ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 63649448623168363ull);
    vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in = VL_SCOPED_RAND_RESET_I(24, __VscopeHash, 15001258774851113354ull);
    for (int __Vi0 = 0; __Vi0 < 8; ++__Vi0) {
        vlSelf->tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(24, __VscopeHash, 14211870894621687045ull);
    }
    vlSelf->__Vdly__tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state = 0;
    vlSelf->__Vdly__tb_seq_img_cluster__DOT__dut__DOT__rom_addr = 0;
    vlSelf->__VdlyVal__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 = 0;
    vlSelf->__VdlyDim0__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 = 0;
    vlSelf->__VdlySet__tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem__v0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggeredAcc[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__wr_rst_n__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__rd_rst_n__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__tb_seq_img_cluster__DOT__transfer_done__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    vlSelf->__Vi = 0;
    for (int __Vi0 = 0; __Vi0 < 7; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
