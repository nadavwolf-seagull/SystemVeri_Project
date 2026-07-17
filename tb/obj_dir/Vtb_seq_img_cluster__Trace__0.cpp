// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtb_seq_img_cluster__Syms.h"


void Vtb_seq_img_cluster___024root__trace_chg_0_sub_0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_seq_img_cluster___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_chg_0\n"); );
    // Body
    Vtb_seq_img_cluster___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_seq_img_cluster___024root*>(voidSelf);
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vtb_seq_img_cluster___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_seq_img_cluster___024root__trace_chg_dtype____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 4>& __VdtypeVar);
void Vtb_seq_img_cluster___024root__trace_chg_dtype____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 8>& __VdtypeVar);
extern const VlUnpacked<CData/*3:0*/, 512> Vtb_seq_img_cluster__ConstPool__TABLE_hfb8b0437_0;

void Vtb_seq_img_cluster___024root__trace_chg_0_sub_0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_chg_0_sub_0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY(((vlSelfRef.__Vm_traceActivity[1U] 
                      | vlSelfRef.__Vm_traceActivity[2U])))) {
        bufp->chgBit(oldp+0,(vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n));
        bufp->chgBit(oldp+1,(vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n));
        bufp->chgBit(oldp+2,(vlSelfRef.tb_seq_img_cluster__DOT__start));
        bufp->chgBit(oldp+3,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req));
        bufp->chgCData(oldp+4,(vlSelfRef.tb_seq_img_cluster__DOT__ae_level),4);
        bufp->chgCData(oldp+5,(vlSelfRef.tb_seq_img_cluster__DOT__af_level),4);
        bufp->chgBit(oldp+6,(vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en));
        bufp->chgBit(oldp+7,(vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write));
        bufp->chgSData(oldp+8,(vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr),14);
        bufp->chgIData(oldp+9,(vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata),32);
        bufp->chgIData(oldp+10,(vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata),32);
        bufp->chgIData(oldp+11,(vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata),32);
        bufp->chgCData(oldp+12,(vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en),4);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[3U]))) {
        bufp->chgBit(oldp+13,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_half_full));
        bufp->chgBit(oldp+14,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_almost_full));
        bufp->chgBit(oldp+15,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full));
        bufp->chgSData(oldp+16,(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt),10);
        bufp->chgSData(oldp+17,(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt),10);
        bufp->chgBit(oldp+18,(vlSelfRef.tb_seq_img_cluster__DOT__transfer_done));
        bufp->chgBit(oldp+19,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause));
        bufp->chgCData(oldp+20,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1),4);
        bufp->chgCData(oldp+21,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2),4);
        bufp->chgCData(oldp+22,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w),4);
        bufp->chgCData(oldp+23,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx),2);
        bufp->chgIData(oldp+24,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q),32);
        bufp->chgIData(oldp+25,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q),32);
        bufp->chgIData(oldp+26,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q),32);
        bufp->chgCData(oldp+27,((0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q 
                                                >> 
                                                (0x0000001fU 
                                                 & (((IData)(0x1fU) 
                                                     - 
                                                     ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                      << 3U)) 
                                                    - (IData)(7U)))))),8);
        bufp->chgCData(oldp+28,((0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q 
                                                >> 
                                                (0x0000001fU 
                                                 & (((IData)(0x1fU) 
                                                     - 
                                                     ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                      << 3U)) 
                                                    - (IData)(7U)))))),8);
        bufp->chgCData(oldp+29,((0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q 
                                                >> 
                                                (0x0000001fU 
                                                 & (((IData)(0x1fU) 
                                                     - 
                                                     ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                      << 3U)) 
                                                    - (IData)(7U)))))),8);
        bufp->chgBit(oldp+30,((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt))));
        bufp->chgBit(oldp+31,((0U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt))));
        bufp->chgBit(oldp+32,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel));
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[4U]))) {
        bufp->chgIData(oldp+33,(vlSelfRef.tb_seq_img_cluster__DOT__sram_r_rdata),32);
        bufp->chgIData(oldp+34,(vlSelfRef.tb_seq_img_cluster__DOT__sram_g_rdata),32);
        bufp->chgIData(oldp+35,(vlSelfRef.tb_seq_img_cluster__DOT__sram_b_rdata),32);
        Vtb_seq_img_cluster___024root__trace_chg_dtype____0(vlSelf, bufp, 36, vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels);
        bufp->chgIData(oldp+40,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_r_data),32);
        bufp->chgIData(oldp+41,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_g_data),32);
        bufp->chgIData(oldp+42,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_b_data),32);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[5U]))) {
        bufp->chgIData(oldp+43,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_data_out),24);
        bufp->chgBit(oldp+44,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty));
        bufp->chgBit(oldp+45,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_almost_empty));
        bufp->chgCData(oldp+46,((7U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin))),3);
        bufp->chgCData(oldp+47,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin),4);
        bufp->chgCData(oldp+48,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray),4);
        bufp->chgCData(oldp+49,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1),4);
        bufp->chgCData(oldp+50,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2),4);
        bufp->chgCData(oldp+51,(((((2U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                          >> 2U)) | 
                                   (1U & VL_REDXOR_32(
                                                      (3U 
                                                       & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                          >> 2U))))) 
                                  << 2U) | ((2U & (
                                                   VL_REDXOR_32(
                                                                (7U 
                                                                 & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                    >> 1U))) 
                                                   << 1U)) 
                                            | (1U & 
                                               VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2))))),4);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[6U]))) {
        bufp->chgBit(oldp+52,((0U != (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
        bufp->chgSData(oldp+53,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr),14);
        bufp->chgBit(oldp+54,((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
        bufp->chgIData(oldp+55,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in),24);
        bufp->chgBit(oldp+56,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en));
        bufp->chgCData(oldp+57,((7U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin))),3);
        bufp->chgCData(oldp+58,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin),4);
        bufp->chgCData(oldp+59,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next),4);
        bufp->chgCData(oldp+60,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray),4);
        bufp->chgCData(oldp+61,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next),4);
        bufp->chgCData(oldp+62,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next),4);
        bufp->chgCData(oldp+63,((0x0000000fU & ((IData)(8U) 
                                                - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next)))),4);
        bufp->chgBit(oldp+64,((4U <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next))));
        bufp->chgCData(oldp+65,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state),4);
    }
    bufp->chgBit(oldp+66,(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk));
    bufp->chgBit(oldp+67,(vlSelfRef.tb_seq_img_cluster__DOT__rd_clk));
    bufp->chgCData(oldp+68,((0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin) 
                                            - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w)))),4);
    bufp->chgBit(oldp+69,((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req) 
                            & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
                           | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full) 
                              & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))))));
    bufp->chgIData(oldp+70,(vlSelfRef.tb_seq_img_cluster__DOT__pixel_count),32);
    bufp->chgBit(oldp+71,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en));
    bufp->chgCData(oldp+72,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next),4);
    bufp->chgCData(oldp+73,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next),4);
    bufp->chgCData(oldp+74,((0x0000000fU & (((((2U 
                                                & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                   >> 2U)) 
                                               | (1U 
                                                  & VL_REDXOR_32(
                                                                 (3U 
                                                                  & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                     >> 2U))))) 
                                              << 2U) 
                                             | ((2U 
                                                 & (VL_REDXOR_32(
                                                                 (7U 
                                                                  & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                     >> 1U))) 
                                                    << 1U)) 
                                                | (1U 
                                                   & VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2)))) 
                                            - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next)))),4);
    bufp->chgBit(oldp+75,((((0x0000000cU & ((~ ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                                >> 2U)) 
                                            << 2U)) 
                            | (3U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2))) 
                           == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next))));
    bufp->chgBit(oldp+76,(((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                           == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next))));
    bufp->chgBit(oldp+77,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next));
    bufp->chgBit(oldp+78,(((0x0000000fU & (((((2U & 
                                               ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                >> 2U)) 
                                              | (1U 
                                                 & VL_REDXOR_32(
                                                                (3U 
                                                                 & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                    >> 2U))))) 
                                             << 2U) 
                                            | ((2U 
                                                & (VL_REDXOR_32(
                                                                (7U 
                                                                 & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                    >> 1U))) 
                                                   << 1U)) 
                                               | (1U 
                                                  & VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2)))) 
                                           - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next))) 
                           <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__ae_level))));
    Vtb_seq_img_cluster___024root__trace_chg_dtype____1(vlSelf, bufp, 79, vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem);
    bufp->chgCData(oldp+87,(Vtb_seq_img_cluster__ConstPool__TABLE_hfb8b0437_0
                            [((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__start) 
                                << 8U) | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                          << 6U)) | 
                              (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel) 
                                << 5U) | (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause) 
                                           << 4U) | (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))))]),4);
}

void Vtb_seq_img_cluster___024root__trace_chg_dtype____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 4>& __VdtypeVar) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_chg_dtype____0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode +  offset);
    bufp->chgIData(oldp+0,(__VdtypeVar[0]),24);
    bufp->chgIData(oldp+1,(__VdtypeVar[1]),24);
    bufp->chgIData(oldp+2,(__VdtypeVar[2]),24);
    bufp->chgIData(oldp+3,(__VdtypeVar[3]),24);
}

void Vtb_seq_img_cluster___024root__trace_chg_dtype____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 8>& __VdtypeVar) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_chg_dtype____1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode +  offset);
    bufp->chgIData(oldp+0,(__VdtypeVar[0]),24);
    bufp->chgIData(oldp+1,(__VdtypeVar[1]),24);
    bufp->chgIData(oldp+2,(__VdtypeVar[2]),24);
    bufp->chgIData(oldp+3,(__VdtypeVar[3]),24);
    bufp->chgIData(oldp+4,(__VdtypeVar[4]),24);
    bufp->chgIData(oldp+5,(__VdtypeVar[5]),24);
    bufp->chgIData(oldp+6,(__VdtypeVar[6]),24);
    bufp->chgIData(oldp+7,(__VdtypeVar[7]),24);
}

void Vtb_seq_img_cluster___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_cleanup\n"); );
    // Body
    Vtb_seq_img_cluster___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_seq_img_cluster___024root*>(voidSelf);
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[4U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[5U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[6U] = 0U;
}
