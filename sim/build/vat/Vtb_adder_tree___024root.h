// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_adder_tree.h for the primary calling header

#ifndef VERILATED_VTB_ADDER_TREE___024ROOT_H_
#define VERILATED_VTB_ADDER_TREE___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_adder_tree__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_adder_tree___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_adder_tree__DOT__clk;
    CData/*0:0*/ tb_adder_tree__DOT__rst;
    CData/*0:0*/ tb_adder_tree__DOT__freeze;
    CData/*0:0*/ tb_adder_tree__DOT__capture;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_adder_tree__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_adder_tree__DOT__rst__0;
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ tb_adder_tree__DOT__d0;
    IData/*31:0*/ tb_adder_tree__DOT__d1;
    IData/*31:0*/ tb_adder_tree__DOT__d2;
    IData/*31:0*/ tb_adder_tree__DOT__d3;
    IData/*31:0*/ tb_adder_tree__DOT__d4;
    IData/*31:0*/ tb_adder_tree__DOT__d5;
    IData/*31:0*/ tb_adder_tree__DOT__d6;
    IData/*31:0*/ tb_adder_tree__DOT__d7;
    IData/*31:0*/ tb_adder_tree__DOT__d8;
    IData/*31:0*/ tb_adder_tree__DOT__sum;
    IData/*31:0*/ tb_adder_tree__DOT__checks;
    IData/*31:0*/ tb_adder_tree__DOT__fails;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*0:0*/, 3> __Vm_traceActivity;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_hafa49738__0;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_adder_tree__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_adder_tree___024root(Vtb_adder_tree__Syms* symsp, const char* v__name);
    ~Vtb_adder_tree___024root();
    VL_UNCOPYABLE(Vtb_adder_tree___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
