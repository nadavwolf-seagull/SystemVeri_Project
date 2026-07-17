// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtb_seq_img_cluster__Syms.h"


VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_sub__TOP__lab12_pkg__0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep);
VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction);
VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_sub__TOP__0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_sub__TOP__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "lab12_pkg", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    Vtb_seq_img_cluster___024root__trace_init_sub__TOP__lab12_pkg__0(vlSelf, tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "tb_seq_img_cluster", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+88,0,"IMG_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+89,0,"IMG_HEIGHT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+90,0,"ROM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+91,0,"ROM_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+92,0,"ROM_ADDR_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+93,0,"FIFO_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+94,0,"FIFO_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+88,0,"LEVEL_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"wr_clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"wr_rst_n",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+67,0,"rd_clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"rd_rst_n",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"start",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+3,0,"fifo_pop_req",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"ae_level",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"af_level",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+6,0,"sram_bus_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+7,0,"sram_bus_write",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+8,0,"sram_bus_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 13,0);
    VL_TRACE_DECL_BUS(tracep,c+9,0,"sram_r_wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+10,0,"sram_g_wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+11,0,"sram_b_wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+12,0,"sram_byte_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+33,0,"sram_r_rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+34,0,"sram_g_rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+35,0,"sram_b_rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+43,0,"fifo_data_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BUS(tracep,c+68,0,"fifo_level",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+44,0,"fifo_empty",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+45,0,"fifo_almost_empty",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+13,0,"fifo_half_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+14,0,"fifo_almost_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+15,0,"fifo_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+69,0,"fifo_error",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+16,0,"row_cnt",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 9,0);
    VL_TRACE_DECL_BUS(tracep,c+17,0,"col_cnt",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 9,0);
    VL_TRACE_DECL_BIT(tracep,c+18,0,"transfer_done",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"busy",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"rts",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);

    Vtb_seq_img_cluster___024root__trace_init_dtype____0(vlSelf, tracep, "observed_pixels", 0, c+36, VerilatedTraceSigDirection::NONE);
    VL_TRACE_DECL_BUS(tracep,c+70,0,"pixel_count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_PUSH_PREFIX(tracep, "dut", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"IMG_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+96,0,"IMG_HEIGHT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+97,0,"ROM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+98,0,"ROM_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+99,0,"ROM_ADDR_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"FIFO_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"FIFO_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"wr_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"wr_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+67,0,"rd_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"rd_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"start",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+3,0,"fifo_pop_req",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"ae_level",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"af_level",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+43,0,"fifo_data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BUS(tracep,c+68,0,"fifo_level",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+44,0,"fifo_empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+45,0,"fifo_almost_empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+13,0,"fifo_half_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+14,0,"fifo_almost_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+15,0,"fifo_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+69,0,"fifo_error",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+6,0,"sram_bus_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+7,0,"sram_bus_write",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+8,0,"sram_bus_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 13,0);
    VL_TRACE_DECL_BUS(tracep,c+9,0,"sram_r_wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+10,0,"sram_g_wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+11,0,"sram_b_wdata",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+12,0,"sram_byte_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+33,0,"sram_r_rdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+34,0,"sram_g_rdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+35,0,"sram_b_rdata",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+16,0,"row_cnt",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 9,0);
    VL_TRACE_DECL_BUS(tracep,c+17,0,"col_cnt",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 9,0);
    VL_TRACE_DECL_BIT(tracep,c+18,0,"transfer_done",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"busy",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"rts",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+53,0,"rom_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 13,0);
    VL_TRACE_DECL_BUS(tracep,c+40,0,"rom_r_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+41,0,"rom_g_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+42,0,"rom_b_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+54,0,"fifo_wr_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+55,0,"fifo_data_in",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BIT(tracep,c+19,0,"rom_pause",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_PUSH_PREFIX(tracep, "u_rgb_sram_subsystem", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+90,0,"SRAM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+91,0,"WORD_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+92,0,"ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"clk_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+53,0,"seq_addr_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 13,0);
    VL_TRACE_DECL_BUS(tracep,c+40,0,"seq_r_data_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+41,0,"seq_g_data_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+42,0,"seq_b_data_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+6,0,"bus_en_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+7,0,"bus_write_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+8,0,"bus_addr_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 13,0);
    VL_TRACE_DECL_BUS(tracep,c+9,0,"bus_r_wdata_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+10,0,"bus_g_wdata_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+11,0,"bus_b_wdata_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+12,0,"bus_byte_en_i",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+33,0,"bus_r_rdata_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+34,0,"bus_g_rdata_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+35,0,"bus_b_rdata_o",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "u_seq_tx_img_fifo", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"FIFO_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"FIFO_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"wr_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"wr_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+67,0,"rd_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"rd_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+54,0,"push_req",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+3,0,"pop_req",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+55,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"ae_level",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"af_level",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+43,0,"data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BUS(tracep,c+68,0,"fifo_level",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+44,0,"empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+45,0,"almost_empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+13,0,"half_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+14,0,"almost_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+15,0,"full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+69,0,"error",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+19,0,"rom_pause",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+56,0,"wr_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+71,0,"rd_en",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+57,0,"wr_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+46,0,"rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_PUSH_PREFIX(tracep, "u_fifo_controller", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"FIFO_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"wr_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"wr_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+54,0,"push_req",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+67,0,"rd_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"rd_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+3,0,"pop_req",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"ae_level",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"af_level",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+56,0,"wr_en",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+71,0,"rd_en",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+57,0,"wr_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+46,0,"rd_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+68,0,"fifo_level",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+44,0,"empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+45,0,"almost_empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+13,0,"half_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+14,0,"almost_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+15,0,"full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+19,0,"rom_pause",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+69,0,"error",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+102,0,"ADDR_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"PTR_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"LEVEL_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+103,0,"FIFO_DEPTH_PTR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+104,0,"HALF_LEVEL_PTR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+58,0,"wbin",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+59,0,"wbin_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+47,0,"rbin",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+72,0,"rbin_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+60,0,"wgray",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+61,0,"wgray_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+48,0,"rgray",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+73,0,"rgray_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+20,0,"rgray_wq1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+21,0,"rgray_wq2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+49,0,"wgray_rq1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+50,0,"wgray_rq2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+22,0,"rbin_sync_w",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+51,0,"wbin_sync_r",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+68,0,"w_level_cur",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+62,0,"w_level_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+74,0,"r_level_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+63,0,"w_free_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BIT(tracep,c+75,0,"wfull_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+76,0,"rempty_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+77,0,"walmost_full_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+78,0,"ralmost_empty_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+64,0,"whalf_full_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "u_ram_1r1w", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"RAM_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"RAM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"wr_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+56,0,"wr_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+57,0,"wr_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+55,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BIT(tracep,c+67,0,"rd_clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+1,0,"rd_rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+71,0,"rd_en",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+46,0,"rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 2,0);
    VL_TRACE_DECL_BUS(tracep,c+43,0,"data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);

    Vtb_seq_img_cluster___024root__trace_init_dtype____1(vlSelf, tracep, "mem", 0, c+79, VerilatedTraceSigDirection::NONE);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "u_sequencer", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+88,0,"IMG_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+89,0,"IMG_HEIGHT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+90,0,"ROM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+92,0,"ROM_ADDR_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+66,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+0,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+2,0,"start",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+19,0,"rom_pause",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+40,0,"rom_r_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+41,0,"rom_g_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+42,0,"rom_b_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+54,0,"fifo_wr_en",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+55,0,"fifo_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 23,0);
    VL_TRACE_DECL_BUS(tracep,c+53,0,"rom_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 13,0);
    VL_TRACE_DECL_BUS(tracep,c+16,0,"row_cnt",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 9,0);
    VL_TRACE_DECL_BUS(tracep,c+17,0,"col_cnt",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 9,0);
    VL_TRACE_DECL_BIT(tracep,c+18,0,"transfer_done",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"busy",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+52,0,"rts",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+65,0,"state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+87,0,"next_state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+23,0,"pixel_idx",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 1,0);
    VL_TRACE_DECL_BUS(tracep,c+24,0,"rom_r_q",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+25,0,"rom_g_q",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+26,0,"rom_b_q",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+27,0,"r_pixel",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+28,0,"g_pixel",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+29,0,"b_pixel",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BIT(tracep,c+30,0,"last_col",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+31,0,"last_row",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+32,0,"last_pixel",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype_sub____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_dtype____0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_seq_img_cluster___024root__trace_init_dtype_sub____0(vlSelf, tracep, name, fidx, c, direction);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype_sub____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_dtype_sub____0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_TRACE_PUSH_PREFIX(tracep, name, VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 3);
    for (int i = 0; i < 4; ++i) {
        VL_TRACE_DECL_BUS_ARRAY(tracep,c+0+i*1,fidx,"",-1, direction, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, (i + 0), 23,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype_sub____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_dtype____1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_seq_img_cluster___024root__trace_init_dtype_sub____1(vlSelf, tracep, name, fidx, c, direction);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_dtype_sub____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep, const char* name, uint32_t fidx, uint32_t c, VerilatedTraceSigDirection direction) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_dtype_sub____1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_TRACE_PUSH_PREFIX(tracep, name, VerilatedTracePrefixType::ARRAY_UNPACKED, 0, 7);
    for (int i = 0; i < 8; ++i) {
        VL_TRACE_DECL_BUS_ARRAY(tracep,c+0+i*1,fidx,"",-1, direction, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, (i + 0), 23,0);
    }
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_sub__TOP__lab12_pkg__0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_sub__TOP__lab12_pkg__0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_DECL_BUS(tracep,c+105,0,"SYS_CLK_FREQ_HZ",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+106,0,"UART_CLK_FREQ_HZ",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+107,0,"UART_BAUD_RATE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+108,0,"UART_CLKS_PER_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"IMG_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+109,0,"IMG_HEIGHT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+110,0,"ROW_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+110,0,"COL_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+98,0,"ROM_WORD_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+97,0,"ROM_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+99,0,"ROM_ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"CHANNEL_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"PIXEL_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"COORD_FIELD_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+111,0,"TX_PACKET_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+112,0,"TX_PACKET_BYTES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+108,0,"RX_MAX_FRAME_BYTES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+113,0,"ASCII_LBRACE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+114,0,"ASCII_RBRACE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+115,0,"ASCII_COMMA",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+116,0,"ASCII_W",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+117,0,"ASCII_R",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+118,0,"ASCII_I",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 7,0);
    VL_TRACE_DECL_BUS(tracep,c+100,0,"FIFO_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+98,0,"FIFO_DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"FIFO_AE_LEVEL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+101,0,"FIFO_AF_LEVEL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+119,0,"FIFO_LEVEL_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"RGF_ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+98,0,"RGF_DATA_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"APB_ADDR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+98,0,"APB_DATA_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"APB_STRB_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+120,0,"RGF_ADDR_CTRL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+121,0,"RGF_ADDR_STATUS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+122,0,"RGF_ADDR_IMG_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+123,0,"RGF_ADDR_IMG_HEIGHT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+104,0,"RGF_ADDR_FIFO_AE_LEVEL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+124,0,"RGF_ADDR_FIFO_AF_LEVEL",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+125,0,"RGF_ADDR_ERROR_STATUS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+126,0,"RGF_ADDR_VERSION",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+103,0,"RGF_ADDR_UART_ERROR_CNT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 3,0);
    VL_TRACE_DECL_BUS(tracep,c+127,0,"RGF_CTRL_IMAGE_START_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+96,0,"RGF_CTRL_CLK_SEL_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+128,0,"RGF_CTRL_PARITY_ENABLE_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+127,0,"RGF_STATUS_SEQ_BUSY_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+96,0,"RGF_STATUS_IMAGE_DONE_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+128,0,"RGF_STATUS_FIFO_EMPTY_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+102,0,"RGF_STATUS_FIFO_FULL_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"RGF_STATUS_FIFO_ERROR_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+129,0,"RGF_STATUS_UART_PARITY_ERR_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+119,0,"RGF_STATUS_UART_FRAMING_ERR_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+127,0,"RGF_ERROR_INVALID_ADDR_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+96,0,"RGF_ERROR_ILLEGAL_WRITE_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+128,0,"RGF_ERROR_FIFO_ERROR_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+102,0,"RGF_ERROR_UART_PARITY_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+95,0,"RGF_ERROR_UART_FRAMING_BIT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+130,0,"RGF_VERSION_VALUE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+131,0,"UART_PARITY_EN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+131,0,"UART_EVEN_PARITY",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_init_top(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_init_top\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_seq_img_cluster___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_seq_img_cluster___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_seq_img_cluster___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_register(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_register\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vtb_seq_img_cluster___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vtb_seq_img_cluster___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vtb_seq_img_cluster___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vtb_seq_img_cluster___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_const_0_sub_0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_const_0\n"); );
    // Body
    Vtb_seq_img_cluster___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_seq_img_cluster___024root*>(voidSelf);
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtb_seq_img_cluster___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_const_0_sub_0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_const_0_sub_0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+88,(4U),32);
    bufp->fullIData(oldp+89,(1U),32);
    bufp->fullIData(oldp+90,(0x00004000U),32);
    bufp->fullIData(oldp+91,(0x00000020U),32);
    bufp->fullIData(oldp+92,(0x0000000eU),32);
    bufp->fullIData(oldp+93,(0x00000018U),32);
    bufp->fullIData(oldp+94,(8U),32);
    bufp->fullIData(oldp+95,(4U),32);
    bufp->fullIData(oldp+96,(1U),32);
    bufp->fullIData(oldp+97,(0x00004000U),32);
    bufp->fullIData(oldp+98,(0x00000020U),32);
    bufp->fullIData(oldp+99,(0x0000000eU),32);
    bufp->fullIData(oldp+100,(0x00000018U),32);
    bufp->fullIData(oldp+101,(8U),32);
    bufp->fullIData(oldp+102,(3U),32);
    bufp->fullCData(oldp+103,(8U),4);
    bufp->fullCData(oldp+104,(4U),4);
    bufp->fullIData(oldp+105,(0x05f5e100U),32);
    bufp->fullIData(oldp+106,(0x07bfa480U),32);
    bufp->fullIData(oldp+107,(0x007bfa48U),32);
    bufp->fullIData(oldp+108,(0x00000010U),32);
    bufp->fullIData(oldp+109,(0x00000100U),32);
    bufp->fullIData(oldp+110,(0x0000000aU),32);
    bufp->fullIData(oldp+111,(0x00000048U),32);
    bufp->fullIData(oldp+112,(9U),32);
    bufp->fullCData(oldp+113,(0x7bU),8);
    bufp->fullCData(oldp+114,(0x7dU),8);
    bufp->fullCData(oldp+115,(0x2cU),8);
    bufp->fullCData(oldp+116,(0x57U),8);
    bufp->fullCData(oldp+117,(0x52U),8);
    bufp->fullCData(oldp+118,(0x49U),8);
    bufp->fullIData(oldp+119,(6U),32);
    bufp->fullCData(oldp+120,(0U),4);
    bufp->fullCData(oldp+121,(1U),4);
    bufp->fullCData(oldp+122,(2U),4);
    bufp->fullCData(oldp+123,(3U),4);
    bufp->fullCData(oldp+124,(5U),4);
    bufp->fullCData(oldp+125,(6U),4);
    bufp->fullCData(oldp+126,(7U),4);
    bufp->fullIData(oldp+127,(0U),32);
    bufp->fullIData(oldp+128,(2U),32);
    bufp->fullIData(oldp+129,(5U),32);
    bufp->fullIData(oldp+130,(0x00110001U),32);
    bufp->fullBit(oldp+131,(1U));
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_0_sub_0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_full_0\n"); );
    // Body
    Vtb_seq_img_cluster___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_seq_img_cluster___024root*>(voidSelf);
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vtb_seq_img_cluster___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_dtype____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 4>& __VdtypeVar);
VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_dtype____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 8>& __VdtypeVar);
extern const VlUnpacked<CData/*3:0*/, 512> Vtb_seq_img_cluster__ConstPool__TABLE_hfb8b0437_0;

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_0_sub_0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_full_0_sub_0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullBit(oldp+0,(vlSelfRef.tb_seq_img_cluster__DOT__wr_rst_n));
    bufp->fullBit(oldp+1,(vlSelfRef.tb_seq_img_cluster__DOT__rd_rst_n));
    bufp->fullBit(oldp+2,(vlSelfRef.tb_seq_img_cluster__DOT__start));
    bufp->fullBit(oldp+3,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req));
    bufp->fullCData(oldp+4,(vlSelfRef.tb_seq_img_cluster__DOT__ae_level),4);
    bufp->fullCData(oldp+5,(vlSelfRef.tb_seq_img_cluster__DOT__af_level),4);
    bufp->fullBit(oldp+6,(vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_en));
    bufp->fullBit(oldp+7,(vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_write));
    bufp->fullSData(oldp+8,(vlSelfRef.tb_seq_img_cluster__DOT__sram_bus_addr),14);
    bufp->fullIData(oldp+9,(vlSelfRef.tb_seq_img_cluster__DOT__sram_r_wdata),32);
    bufp->fullIData(oldp+10,(vlSelfRef.tb_seq_img_cluster__DOT__sram_g_wdata),32);
    bufp->fullIData(oldp+11,(vlSelfRef.tb_seq_img_cluster__DOT__sram_b_wdata),32);
    bufp->fullCData(oldp+12,(vlSelfRef.tb_seq_img_cluster__DOT__sram_byte_en),4);
    bufp->fullBit(oldp+13,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_half_full));
    bufp->fullBit(oldp+14,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_almost_full));
    bufp->fullBit(oldp+15,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full));
    bufp->fullSData(oldp+16,(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt),10);
    bufp->fullSData(oldp+17,(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt),10);
    bufp->fullBit(oldp+18,(vlSelfRef.tb_seq_img_cluster__DOT__transfer_done));
    bufp->fullBit(oldp+19,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause));
    bufp->fullCData(oldp+20,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq1),4);
    bufp->fullCData(oldp+21,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2),4);
    bufp->fullCData(oldp+22,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w),4);
    bufp->fullCData(oldp+23,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx),2);
    bufp->fullIData(oldp+24,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q),32);
    bufp->fullIData(oldp+25,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q),32);
    bufp->fullIData(oldp+26,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q),32);
    bufp->fullCData(oldp+27,((0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_r_q 
                                             >> (0x0000001fU 
                                                 & (((IData)(0x1fU) 
                                                     - 
                                                     ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                      << 3U)) 
                                                    - (IData)(7U)))))),8);
    bufp->fullCData(oldp+28,((0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_g_q 
                                             >> (0x0000001fU 
                                                 & (((IData)(0x1fU) 
                                                     - 
                                                     ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                      << 3U)) 
                                                    - (IData)(7U)))))),8);
    bufp->fullCData(oldp+29,((0x000000ffU & (vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__rom_b_q 
                                             >> (0x0000001fU 
                                                 & (((IData)(0x1fU) 
                                                     - 
                                                     ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                                      << 3U)) 
                                                    - (IData)(7U)))))),8);
    bufp->fullBit(oldp+30,((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__col_cnt))));
    bufp->fullBit(oldp+31,((0U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__row_cnt))));
    bufp->fullBit(oldp+32,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel));
    bufp->fullIData(oldp+33,(vlSelfRef.tb_seq_img_cluster__DOT__sram_r_rdata),32);
    bufp->fullIData(oldp+34,(vlSelfRef.tb_seq_img_cluster__DOT__sram_g_rdata),32);
    bufp->fullIData(oldp+35,(vlSelfRef.tb_seq_img_cluster__DOT__sram_b_rdata),32);
    Vtb_seq_img_cluster___024root__trace_full_dtype____0(vlSelf, bufp, 36, vlSelfRef.tb_seq_img_cluster__DOT__observed_pixels);
    bufp->fullIData(oldp+40,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_r_data),32);
    bufp->fullIData(oldp+41,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_g_data),32);
    bufp->fullIData(oldp+42,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_b_data),32);
    bufp->fullIData(oldp+43,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_data_out),24);
    bufp->fullBit(oldp+44,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty));
    bufp->fullBit(oldp+45,(vlSelfRef.tb_seq_img_cluster__DOT__fifo_almost_empty));
    bufp->fullCData(oldp+46,((7U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin))),3);
    bufp->fullCData(oldp+47,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin),4);
    bufp->fullCData(oldp+48,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray),4);
    bufp->fullCData(oldp+49,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq1),4);
    bufp->fullCData(oldp+50,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2),4);
    bufp->fullCData(oldp+51,(((((2U & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                       >> 2U)) | (1U 
                                                  & VL_REDXOR_32(
                                                                 (3U 
                                                                  & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                     >> 2U))))) 
                               << 2U) | ((2U & (VL_REDXOR_32(
                                                             (7U 
                                                              & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                                                                 >> 1U))) 
                                                << 1U)) 
                                         | (1U & VL_REDXOR_4(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2))))),4);
    bufp->fullBit(oldp+52,((0U != (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
    bufp->fullSData(oldp+53,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_addr),14);
    bufp->fullBit(oldp+54,((3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))));
    bufp->fullIData(oldp+55,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__data_in),24);
    bufp->fullBit(oldp+56,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wr_en));
    bufp->fullCData(oldp+57,((7U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin))),3);
    bufp->fullCData(oldp+58,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin),4);
    bufp->fullCData(oldp+59,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin_next),4);
    bufp->fullCData(oldp+60,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray),4);
    bufp->fullCData(oldp+61,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next),4);
    bufp->fullCData(oldp+62,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next),4);
    bufp->fullCData(oldp+63,((0x0000000fU & ((IData)(8U) 
                                             - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next)))),4);
    bufp->fullBit(oldp+64,((4U <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__w_level_next))));
    bufp->fullCData(oldp+65,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state),4);
    bufp->fullBit(oldp+66,(vlSelfRef.tb_seq_img_cluster__DOT__wr_clk));
    bufp->fullBit(oldp+67,(vlSelfRef.tb_seq_img_cluster__DOT__rd_clk));
    bufp->fullCData(oldp+68,((0x0000000fU & ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wbin) 
                                             - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_sync_w)))),4);
    bufp->fullBit(oldp+69,((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_pop_req) 
                             & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_empty)) 
                            | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__fifo_full) 
                               & (3U == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))))));
    bufp->fullIData(oldp+70,(vlSelfRef.tb_seq_img_cluster__DOT__pixel_count),32);
    bufp->fullBit(oldp+71,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rd_en));
    bufp->fullCData(oldp+72,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next),4);
    bufp->fullCData(oldp+73,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next),4);
    bufp->fullCData(oldp+74,((0x0000000fU & (((((2U 
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
    bufp->fullBit(oldp+75,((((0x0000000cU & ((~ ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2) 
                                                 >> 2U)) 
                                             << 2U)) 
                             | (3U & (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_wq2))) 
                            == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_next))));
    bufp->fullBit(oldp+76,(((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__wgray_rq2) 
                            == (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rgray_next))));
    bufp->fullBit(oldp+77,(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__walmost_full_next));
    bufp->fullBit(oldp+78,(((0x0000000fU & (((((2U 
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
                                            - (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_fifo_controller__DOT__rbin_next))) 
                            <= (IData)(vlSelfRef.tb_seq_img_cluster__DOT__ae_level))));
    Vtb_seq_img_cluster___024root__trace_full_dtype____1(vlSelf, bufp, 79, vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_seq_tx_img_fifo__DOT__u_ram_1r1w__DOT__mem);
    bufp->fullCData(oldp+87,(Vtb_seq_img_cluster__ConstPool__TABLE_hfb8b0437_0
                             [((((IData)(vlSelfRef.tb_seq_img_cluster__DOT__start) 
                                 << 8U) | ((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__pixel_idx) 
                                           << 6U)) 
                               | (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__last_pixel) 
                                   << 5U) | (((IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__rom_pause) 
                                              << 4U) 
                                             | (IData)(vlSelfRef.tb_seq_img_cluster__DOT__dut__DOT__u_sequencer__DOT__state))))]),4);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_dtype____0(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 4>& __VdtypeVar) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_full_dtype____0\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + offset);
    bufp->fullIData(oldp+0,(__VdtypeVar[0]),24);
    bufp->fullIData(oldp+1,(__VdtypeVar[1]),24);
    bufp->fullIData(oldp+2,(__VdtypeVar[2]),24);
    bufp->fullIData(oldp+3,(__VdtypeVar[3]),24);
}

VL_ATTR_COLD void Vtb_seq_img_cluster___024root__trace_full_dtype____1(Vtb_seq_img_cluster___024root* vlSelf, VerilatedVcd::Buffer* bufp, uint32_t offset, const VlUnpacked<IData/*23:0*/, 8>& __VdtypeVar) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_seq_img_cluster___024root__trace_full_dtype____1\n"); );
    Vtb_seq_img_cluster__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + offset);
    bufp->fullIData(oldp+0,(__VdtypeVar[0]),24);
    bufp->fullIData(oldp+1,(__VdtypeVar[1]),24);
    bufp->fullIData(oldp+2,(__VdtypeVar[2]),24);
    bufp->fullIData(oldp+3,(__VdtypeVar[3]),24);
    bufp->fullIData(oldp+4,(__VdtypeVar[4]),24);
    bufp->fullIData(oldp+5,(__VdtypeVar[5]),24);
    bufp->fullIData(oldp+6,(__VdtypeVar[6]),24);
    bufp->fullIData(oldp+7,(__VdtypeVar[7]),24);
}
