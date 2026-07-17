// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VTB_SEQ_IMG_CLUSTER__SYMS_H_
#define VERILATED_VTB_SEQ_IMG_CLUSTER__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vtb_seq_img_cluster.h"

// INCLUDE MODULE CLASSES
#include "Vtb_seq_img_cluster___024root.h"
#include "Vtb_seq_img_cluster___024unit.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vtb_seq_img_cluster__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vtb_seq_img_cluster* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vtb_seq_img_cluster___024root  TOP;

    // CONSTRUCTORS
    Vtb_seq_img_cluster__Syms(VerilatedContext* contextp, const char* namep, Vtb_seq_img_cluster* modelp);
    ~Vtb_seq_img_cluster__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
};

#endif  // guard
