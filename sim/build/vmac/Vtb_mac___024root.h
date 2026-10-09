// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtb_mac.h for the primary calling header

#ifndef VERILATED_VTB_MAC___024ROOT_H_
#define VERILATED_VTB_MAC___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vtb_mac__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtb_mac___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ tb_mac__DOT__clk;
    CData/*0:0*/ tb_mac__DOT__rst;
    CData/*0:0*/ tb_mac__DOT__valid;
    CData/*0:0*/ tb_mac__DOT__first;
    CData/*0:0*/ tb_mac__DOT__last;
    CData/*0:0*/ tb_mac__DOT__freeze;
    CData/*7:0*/ tb_mac__DOT__weight;
    CData/*7:0*/ tb_mac__DOT__activation;
    CData/*0:0*/ tb_mac__DOT__valid_out;
    CData/*0:0*/ tb_mac__DOT__done;
    CData/*0:0*/ tb_mac__DOT__got;
    CData/*7:0*/ tb_mac__DOT__dut__DOT__w_r;
    CData/*0:0*/ tb_mac__DOT__dut__DOT__valid_s1;
    CData/*0:0*/ tb_mac__DOT__dut__DOT__valid_s2;
    CData/*0:0*/ tb_mac__DOT__dut__DOT__first_s1;
    CData/*0:0*/ tb_mac__DOT__dut__DOT__first_s2;
    CData/*0:0*/ tb_mac__DOT__dut__DOT__last_s1;
    CData/*0:0*/ tb_mac__DOT__dut__DOT__last_s2;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_mac__DOT__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__tb_mac__DOT__rst__0;
    CData/*0:0*/ __VactContinue;
    SData/*8:0*/ tb_mac__DOT__dut__DOT__act_r;
    IData/*31:0*/ tb_mac__DOT__acc;
    IData/*31:0*/ tb_mac__DOT__checks;
    IData/*31:0*/ tb_mac__DOT__fails;
    IData/*31:0*/ tb_mac__DOT__t;
    IData/*16:0*/ tb_mac__DOT__dut__DOT__prod_r;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*0:0*/, 4> __Vm_traceActivity;
    VlDelayScheduler __VdlySched;
    VlTriggerScheduler __VtrigSched_h5c392597__0;
    VlTriggerVec<3> __VactTriggered;
    VlTriggerVec<3> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtb_mac__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtb_mac___024root(Vtb_mac__Syms* symsp, const char* v__name);
    ~Vtb_mac___024root();
    VL_UNCOPYABLE(Vtb_mac___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
