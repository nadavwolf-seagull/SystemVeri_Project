// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_seq_img_cluster.h for the primary calling header

#ifndef VERILATED_VTB_SEQ_IMG_CLUSTER___024UNIT_H_
#define VERILATED_VTB_SEQ_IMG_CLUSTER___024UNIT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_seq_img_cluster__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_seq_img_cluster___024unit final {
  public:

    // INTERNAL VARIABLES
    Vtb_seq_img_cluster__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vtb_seq_img_cluster___024unit();
    ~Vtb_seq_img_cluster___024unit();
    void ctor(Vtb_seq_img_cluster__Syms* symsp, const char* namep);
    void dtor();
    VL_UNCOPYABLE(Vtb_seq_img_cluster___024unit);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
