// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_seq_img_cluster.h for the primary calling header

#include "Vtb_seq_img_cluster__pch.h"


Vtb_seq_img_cluster___024unit::Vtb_seq_img_cluster___024unit() = default;
Vtb_seq_img_cluster___024unit::~Vtb_seq_img_cluster___024unit() = default;

void Vtb_seq_img_cluster___024unit::ctor(Vtb_seq_img_cluster__Syms* symsp, const char* namep) {
    vlSymsp = symsp;
    vlNamep = strdup(Verilated::catName(vlSymsp->name(), namep));
    // Reset structure values
}

void Vtb_seq_img_cluster___024unit::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

void Vtb_seq_img_cluster___024unit::dtor() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
