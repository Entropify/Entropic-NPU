// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_mac.h for the primary calling header

#include "Vtb_mac__pch.h"
#include "Vtb_mac__Syms.h"
#include "Vtb_mac___024root.h"

VL_INLINE_OPT VlCoroutine Vtb_mac___024root___eval_initial__TOP__Vtiming__0(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_initial__TOP__Vtiming__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__2__want;
    __Vtask_tb_mac__DOT__check_acc__2__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__2__what;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__3__wd;
    __Vtask_tb_mac__DOT__check_flags__3__wd = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__3__wv;
    __Vtask_tb_mac__DOT__check_flags__3__wv = 0;
    std::string __Vtask_tb_mac__DOT__check_flags__3__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__4__w;
    __Vtask_tb_mac__DOT__beat__4__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__4__a;
    __Vtask_tb_mac__DOT__beat__4__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__4__f;
    __Vtask_tb_mac__DOT__beat__4__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__4__l;
    __Vtask_tb_mac__DOT__beat__4__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__6__limit;
    __Vtask_tb_mac__DOT__wait_done__6__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__8__want;
    __Vtask_tb_mac__DOT__check_acc__8__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__8__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__9__w;
    __Vtask_tb_mac__DOT__beat__9__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__9__a;
    __Vtask_tb_mac__DOT__beat__9__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__9__f;
    __Vtask_tb_mac__DOT__beat__9__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__9__l;
    __Vtask_tb_mac__DOT__beat__9__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__11__limit;
    __Vtask_tb_mac__DOT__wait_done__11__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__13__want;
    __Vtask_tb_mac__DOT__check_acc__13__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__13__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__14__w;
    __Vtask_tb_mac__DOT__beat__14__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__14__a;
    __Vtask_tb_mac__DOT__beat__14__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__14__f;
    __Vtask_tb_mac__DOT__beat__14__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__14__l;
    __Vtask_tb_mac__DOT__beat__14__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__16__limit;
    __Vtask_tb_mac__DOT__wait_done__16__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__18__want;
    __Vtask_tb_mac__DOT__check_acc__18__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__18__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__19__w;
    __Vtask_tb_mac__DOT__beat__19__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__19__a;
    __Vtask_tb_mac__DOT__beat__19__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__19__f;
    __Vtask_tb_mac__DOT__beat__19__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__19__l;
    __Vtask_tb_mac__DOT__beat__19__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__21__limit;
    __Vtask_tb_mac__DOT__wait_done__21__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__23__want;
    __Vtask_tb_mac__DOT__check_acc__23__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__23__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__24__w;
    __Vtask_tb_mac__DOT__beat__24__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__24__a;
    __Vtask_tb_mac__DOT__beat__24__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__24__f;
    __Vtask_tb_mac__DOT__beat__24__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__24__l;
    __Vtask_tb_mac__DOT__beat__24__l = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__26__w;
    __Vtask_tb_mac__DOT__beat__26__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__26__a;
    __Vtask_tb_mac__DOT__beat__26__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__26__f;
    __Vtask_tb_mac__DOT__beat__26__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__26__l;
    __Vtask_tb_mac__DOT__beat__26__l = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__28__w;
    __Vtask_tb_mac__DOT__beat__28__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__28__a;
    __Vtask_tb_mac__DOT__beat__28__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__28__f;
    __Vtask_tb_mac__DOT__beat__28__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__28__l;
    __Vtask_tb_mac__DOT__beat__28__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__30__limit;
    __Vtask_tb_mac__DOT__wait_done__30__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__32__want;
    __Vtask_tb_mac__DOT__check_acc__32__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__32__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__33__w;
    __Vtask_tb_mac__DOT__beat__33__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__33__a;
    __Vtask_tb_mac__DOT__beat__33__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__33__f;
    __Vtask_tb_mac__DOT__beat__33__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__33__l;
    __Vtask_tb_mac__DOT__beat__33__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__35__limit;
    __Vtask_tb_mac__DOT__wait_done__35__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__37__want;
    __Vtask_tb_mac__DOT__check_acc__37__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__37__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__38__w;
    __Vtask_tb_mac__DOT__beat__38__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__38__a;
    __Vtask_tb_mac__DOT__beat__38__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__38__f;
    __Vtask_tb_mac__DOT__beat__38__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__38__l;
    __Vtask_tb_mac__DOT__beat__38__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__40__limit;
    __Vtask_tb_mac__DOT__wait_done__40__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__42__want;
    __Vtask_tb_mac__DOT__check_acc__42__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__42__what;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__45__want;
    __Vtask_tb_mac__DOT__check_acc__45__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__45__what;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__48__want;
    __Vtask_tb_mac__DOT__check_acc__48__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__48__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__49__w;
    __Vtask_tb_mac__DOT__beat__49__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__49__a;
    __Vtask_tb_mac__DOT__beat__49__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__49__f;
    __Vtask_tb_mac__DOT__beat__49__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__49__l;
    __Vtask_tb_mac__DOT__beat__49__l = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__51__w;
    __Vtask_tb_mac__DOT__beat__51__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__51__a;
    __Vtask_tb_mac__DOT__beat__51__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__51__f;
    __Vtask_tb_mac__DOT__beat__51__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__51__l;
    __Vtask_tb_mac__DOT__beat__51__l = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__54__want;
    __Vtask_tb_mac__DOT__check_acc__54__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__54__what;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__56__want;
    __Vtask_tb_mac__DOT__check_acc__56__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__56__what;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__57__wd;
    __Vtask_tb_mac__DOT__check_flags__57__wd = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__57__wv;
    __Vtask_tb_mac__DOT__check_flags__57__wv = 0;
    std::string __Vtask_tb_mac__DOT__check_flags__57__what;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__60__limit;
    __Vtask_tb_mac__DOT__wait_done__60__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__62__want;
    __Vtask_tb_mac__DOT__check_acc__62__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__62__what;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__63__w;
    __Vtask_tb_mac__DOT__beat__63__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__63__a;
    __Vtask_tb_mac__DOT__beat__63__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__63__f;
    __Vtask_tb_mac__DOT__beat__63__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__63__l;
    __Vtask_tb_mac__DOT__beat__63__l = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__65__w;
    __Vtask_tb_mac__DOT__beat__65__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__65__a;
    __Vtask_tb_mac__DOT__beat__65__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__65__f;
    __Vtask_tb_mac__DOT__beat__65__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__65__l;
    __Vtask_tb_mac__DOT__beat__65__l = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__67__w;
    __Vtask_tb_mac__DOT__beat__67__w = 0;
    CData/*7:0*/ __Vtask_tb_mac__DOT__beat__67__a;
    __Vtask_tb_mac__DOT__beat__67__a = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__67__f;
    __Vtask_tb_mac__DOT__beat__67__f = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__beat__67__l;
    __Vtask_tb_mac__DOT__beat__67__l = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__70__wd;
    __Vtask_tb_mac__DOT__check_flags__70__wd = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__70__wv;
    __Vtask_tb_mac__DOT__check_flags__70__wv = 0;
    std::string __Vtask_tb_mac__DOT__check_flags__70__what;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__72__wd;
    __Vtask_tb_mac__DOT__check_flags__72__wd = 0;
    CData/*0:0*/ __Vtask_tb_mac__DOT__check_flags__72__wv;
    __Vtask_tb_mac__DOT__check_flags__72__wv = 0;
    std::string __Vtask_tb_mac__DOT__check_flags__72__what;
    IData/*31:0*/ __Vtask_tb_mac__DOT__wait_done__73__limit;
    __Vtask_tb_mac__DOT__wait_done__73__limit = 0;
    IData/*31:0*/ __Vtask_tb_mac__DOT__check_acc__75__want;
    __Vtask_tb_mac__DOT__check_acc__75__want = 0;
    std::string __Vtask_tb_mac__DOT__check_acc__75__what;
    VlWide<4>/*127:0*/ __Vtemp_1;
    // Body
    __Vtemp_1[0U] = 0x2e766364U;
    __Vtemp_1[1U] = 0x5f6d6163U;
    __Vtemp_1[2U] = 0x6d2f7462U;
    __Vtemp_1[3U] = 0x7369U;
    vlSymsp->_vm_contextp__->dumpfile(VL_CVT_PACK_STR_NW(4, __Vtemp_1));
    vlSymsp->_traceDumpOpen();
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__rst = 0U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    VL_WRITEF_NX("\n[1] reset\n",0);
    __Vtask_tb_mac__DOT__check_acc__2__what = std::string{"acc is 0 after reset"};
    __Vtask_tb_mac__DOT__check_acc__2__want = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__2__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__2__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__2__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__2__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__check_flags__3__what = std::string{"done and valid_out are 0 after reset"};
    __Vtask_tb_mac__DOT__check_flags__3__wv = 0U;
    __Vtask_tb_mac__DOT__check_flags__3__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__3__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__3__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__3__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__3__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    VL_WRITEF_NX("\n[2] single beat (first=1, last=1)\n",0);
    __Vtask_tb_mac__DOT__beat__4__l = 1U;
    __Vtask_tb_mac__DOT__beat__4__f = 1U;
    __Vtask_tb_mac__DOT__beat__4__a = 7U;
    __Vtask_tb_mac__DOT__beat__4__w = 3U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__4__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__4__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__4__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__4__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__6__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__6__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__6__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__8__what = std::string{"+3 x +7"};
    __Vtask_tb_mac__DOT__check_acc__8__want = 0x15U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__8__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__8__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__8__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__8__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__beat__9__l = 1U;
    __Vtask_tb_mac__DOT__beat__9__f = 1U;
    __Vtask_tb_mac__DOT__beat__9__a = 7U;
    __Vtask_tb_mac__DOT__beat__9__w = 0xfdU;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__9__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__9__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__9__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__9__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__11__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__11__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__11__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__13__what = std::string{"-3 x +7"};
    __Vtask_tb_mac__DOT__check_acc__13__want = 0xffffffebU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__13__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__13__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__13__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__13__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__beat__14__l = 1U;
    __Vtask_tb_mac__DOT__beat__14__f = 1U;
    __Vtask_tb_mac__DOT__beat__14__a = 0xffU;
    __Vtask_tb_mac__DOT__beat__14__w = 0x80U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__14__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__14__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__14__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__14__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__16__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__16__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__16__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__18__what = std::string{"-128 x 255 (extreme)"};
    __Vtask_tb_mac__DOT__check_acc__18__want = 0xffff8080U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__18__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__18__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__18__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__18__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__beat__19__l = 1U;
    __Vtask_tb_mac__DOT__beat__19__f = 1U;
    __Vtask_tb_mac__DOT__beat__19__a = 0xf9U;
    __Vtask_tb_mac__DOT__beat__19__w = 0xfdU;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__19__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__19__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__19__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__19__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__21__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__21__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__21__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__23__what = std::string{"-3 x 249 (249 is -7 unsigned)"};
    __Vtask_tb_mac__DOT__check_acc__23__want = 0xfffffd15U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__23__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__23__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__23__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__23__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n[3] three beats: 2x5 + 4x5 + 6x5 = 10 + 20 + 30\n",0);
    __Vtask_tb_mac__DOT__beat__24__l = 0U;
    __Vtask_tb_mac__DOT__beat__24__f = 1U;
    __Vtask_tb_mac__DOT__beat__24__a = 5U;
    __Vtask_tb_mac__DOT__beat__24__w = 2U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__24__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__24__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__24__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__24__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__beat__26__l = 0U;
    __Vtask_tb_mac__DOT__beat__26__f = 0U;
    __Vtask_tb_mac__DOT__beat__26__a = 5U;
    __Vtask_tb_mac__DOT__beat__26__w = 4U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__26__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__26__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__26__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__26__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__beat__28__l = 1U;
    __Vtask_tb_mac__DOT__beat__28__f = 0U;
    __Vtask_tb_mac__DOT__beat__28__a = 5U;
    __Vtask_tb_mac__DOT__beat__28__w = 6U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__28__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__28__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__28__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__28__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__30__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__30__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__30__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__32__what = std::string{"sum of the three products"};
    __Vtask_tb_mac__DOT__check_acc__32__want = 0x3cU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__32__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__32__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__32__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__32__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n[4] a new batch with first=1 wipes the previous sum\n",0);
    __Vtask_tb_mac__DOT__beat__33__l = 1U;
    __Vtask_tb_mac__DOT__beat__33__f = 1U;
    __Vtask_tb_mac__DOT__beat__33__a = 2U;
    __Vtask_tb_mac__DOT__beat__33__w = 7U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__33__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__33__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__33__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__33__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__35__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__35__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__35__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__37__what = std::string{"new sum only: the old 60 must be gone"};
    __Vtask_tb_mac__DOT__check_acc__37__want = 0xeU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__37__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__37__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__37__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__37__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n[5] junk on the bus with valid=0 must do nothing\n",0);
    __Vtask_tb_mac__DOT__beat__38__l = 1U;
    __Vtask_tb_mac__DOT__beat__38__f = 1U;
    __Vtask_tb_mac__DOT__beat__38__a = 5U;
    __Vtask_tb_mac__DOT__beat__38__w = 5U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__38__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__38__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__38__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__38__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__40__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__40__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__40__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__42__what = std::string{"baseline"};
    __Vtask_tb_mac__DOT__check_acc__42__want = 0x19U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__42__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__42__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__42__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__42__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0x80U;
    vlSelfRef.tb_mac__DOT__activation = 0xffU;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_acc__45__what = std::string{"unchanged after a tick with valid=0"};
    __Vtask_tb_mac__DOT__check_acc__45__want = 0x19U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__45__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__45__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__45__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__45__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n[6] first=1 and last=1 but valid=0 must do nothing\n",0);
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 1U;
    vlSelfRef.tb_mac__DOT__last = 1U;
    vlSelfRef.tb_mac__DOT__weight = 0x80U;
    vlSelfRef.tb_mac__DOT__activation = 0xffU;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_acc__48__what = std::string{"unchanged after a stray first/last with valid=0"};
    __Vtask_tb_mac__DOT__check_acc__48__want = 0x19U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__48__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__48__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__48__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__48__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n[7] freeze in the middle of a sum\n",0);
    __Vtask_tb_mac__DOT__beat__49__l = 0U;
    __Vtask_tb_mac__DOT__beat__49__f = 1U;
    __Vtask_tb_mac__DOT__beat__49__a = 5U;
    __Vtask_tb_mac__DOT__beat__49__w = 2U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__49__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__49__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__49__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__49__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__beat__51__l = 0U;
    __Vtask_tb_mac__DOT__beat__51__f = 0U;
    __Vtask_tb_mac__DOT__beat__51__a = 5U;
    __Vtask_tb_mac__DOT__beat__51__w = 4U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__51__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__51__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__51__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__51__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_acc__54__what = std::string{"two beats accumulated before the freeze"};
    __Vtask_tb_mac__DOT__check_acc__54__want = 0x1eU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__54__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__54__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__54__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__54__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    vlSelfRef.tb_mac__DOT__freeze = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_acc__56__what = std::string{"acc holds while frozen"};
    __Vtask_tb_mac__DOT__check_acc__56__want = 0x1eU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__56__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__56__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__56__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__56__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__check_flags__57__what = std::string{"done stays 0 while frozen"};
    __Vtask_tb_mac__DOT__check_flags__57__wv = 0U;
    __Vtask_tb_mac__DOT__check_flags__57__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__57__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__57__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__57__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__57__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_acc__56__what = std::string{"acc holds while frozen"};
    __Vtask_tb_mac__DOT__check_acc__56__want = 0x1eU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__56__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__56__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__56__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__56__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__check_flags__57__what = std::string{"done stays 0 while frozen"};
    __Vtask_tb_mac__DOT__check_flags__57__wv = 0U;
    __Vtask_tb_mac__DOT__check_flags__57__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__57__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__57__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__57__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__57__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_acc__56__what = std::string{"acc holds while frozen"};
    __Vtask_tb_mac__DOT__check_acc__56__want = 0x1eU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__56__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__56__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__56__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__56__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    __Vtask_tb_mac__DOT__check_flags__57__what = std::string{"done stays 0 while frozen"};
    __Vtask_tb_mac__DOT__check_flags__57__wv = 0U;
    __Vtask_tb_mac__DOT__check_flags__57__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__57__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__57__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__57__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__57__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    vlSelfRef.tb_mac__DOT__freeze = 0U;
    VL_WRITEF_NX("\n[8] final beat held across a freeze\n",0);
    vlSelfRef.tb_mac__DOT__weight = 6U;
    vlSelfRef.tb_mac__DOT__activation = 5U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 1U;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    vlSelfRef.tb_mac__DOT__freeze = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__freeze = 0U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__wait_done__60__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__60__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__60__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__62__what = std::string{"held final beat landed: 30 + 30"};
    __Vtask_tb_mac__DOT__check_acc__62__want = 0x3cU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__62__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__62__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__62__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__62__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n[9] freeze while a batch is in flight\n",0);
    __Vtask_tb_mac__DOT__beat__63__l = 0U;
    __Vtask_tb_mac__DOT__beat__63__f = 1U;
    __Vtask_tb_mac__DOT__beat__63__a = 2U;
    __Vtask_tb_mac__DOT__beat__63__w = 1U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__63__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__63__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__63__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__63__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__beat__65__l = 0U;
    __Vtask_tb_mac__DOT__beat__65__f = 0U;
    __Vtask_tb_mac__DOT__beat__65__a = 4U;
    __Vtask_tb_mac__DOT__beat__65__w = 1U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__65__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__65__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__65__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__65__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    __Vtask_tb_mac__DOT__beat__67__l = 1U;
    __Vtask_tb_mac__DOT__beat__67__f = 0U;
    __Vtask_tb_mac__DOT__beat__67__a = 6U;
    __Vtask_tb_mac__DOT__beat__67__w = 1U;
    vlSelfRef.tb_mac__DOT__weight = __Vtask_tb_mac__DOT__beat__67__w;
    vlSelfRef.tb_mac__DOT__activation = __Vtask_tb_mac__DOT__beat__67__a;
    vlSelfRef.tb_mac__DOT__first = __Vtask_tb_mac__DOT__beat__67__f;
    vlSelfRef.tb_mac__DOT__last = __Vtask_tb_mac__DOT__beat__67__l;
    vlSelfRef.tb_mac__DOT__valid = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_flags__70__what = std::string{"in the window: valid_out high, done low"};
    __Vtask_tb_mac__DOT__check_flags__70__wv = 1U;
    __Vtask_tb_mac__DOT__check_flags__70__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__70__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__70__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__70__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__70__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    vlSelfRef.tb_mac__DOT__freeze = 1U;
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_flags__72__what = std::string{"frozen: acc did not change, so valid_out must be 0"};
    __Vtask_tb_mac__DOT__check_flags__72__wv = 0U;
    __Vtask_tb_mac__DOT__check_flags__72__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__72__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__72__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__72__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__72__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                         nullptr, 
                                                         "@(posedge tb_mac.clk)", 
                                                         "sim/tb_mac.sv", 
                                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                         nullptr, "sim/tb_mac.sv", 
                                         53);
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    __Vtask_tb_mac__DOT__check_flags__72__what = std::string{"frozen: acc did not change, so valid_out must be 0"};
    __Vtask_tb_mac__DOT__check_flags__72__wv = 0U;
    __Vtask_tb_mac__DOT__check_flags__72__wd = 0U;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((((IData)(vlSelfRef.tb_mac__DOT__done) != (IData)(__Vtask_tb_mac__DOT__check_flags__72__wd)) 
         | ((IData)(vlSelfRef.tb_mac__DOT__valid_out) 
            != (IData)(__Vtask_tb_mac__DOT__check_flags__72__wv)))) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__72__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    } else {
        VL_WRITEF_NX("pass  %-46@ done=%b valid_out=%b\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_flags__72__what),
                     1,(IData)(vlSelfRef.tb_mac__DOT__done),
                     1,vlSelfRef.tb_mac__DOT__valid_out);
    }
    vlSelfRef.tb_mac__DOT__freeze = 0U;
    __Vtask_tb_mac__DOT__wait_done__73__limit = 0x14U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
    while ((VL_LTS_III(32, vlSelfRef.tb_mac__DOT__t, __Vtask_tb_mac__DOT__wait_done__73__limit) 
            & (~ (IData)(vlSelfRef.tb_mac__DOT__got)))) {
        co_await vlSelfRef.__VtrigSched_h5c392597__0.trigger(0U, 
                                                             nullptr, 
                                                             "@(posedge tb_mac.clk)", 
                                                             "sim/tb_mac.sv", 
                                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        co_await vlSelfRef.__VdlySched.delay(0x3e8ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             53);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
        vlSelfRef.tb_mac__DOT__t = ((IData)(1U) + vlSelfRef.tb_mac__DOT__t);
        if (vlSelfRef.tb_mac__DOT__done) {
            vlSelfRef.tb_mac__DOT__got = 1U;
        }
    }
    if (VL_UNLIKELY((1U & (~ (IData)(vlSelfRef.tb_mac__DOT__got))))) {
        vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) 
                                         + vlSelfRef.tb_mac__DOT__checks);
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  not done in %0d ticks\n",0,
                     32,__Vtask_tb_mac__DOT__wait_done__73__limit);
    }
    __Vtask_tb_mac__DOT__check_acc__75__what = std::string{"batch completed: 2 + 4 + 6"};
    __Vtask_tb_mac__DOT__check_acc__75__want = 0xcU;
    vlSelfRef.tb_mac__DOT__checks = ((IData)(1U) + vlSelfRef.tb_mac__DOT__checks);
    if ((vlSelfRef.tb_mac__DOT__acc != __Vtask_tb_mac__DOT__check_acc__75__want)) {
        vlSelfRef.tb_mac__DOT__fails = ((IData)(1U) 
                                        + vlSelfRef.tb_mac__DOT__fails);
        VL_WRITEF_NX("FAIL  %-46@ acc = %0d, wanted %0d\n",0,
                     -1,&(__Vtask_tb_mac__DOT__check_acc__75__what),
                     32,vlSelfRef.tb_mac__DOT__acc,
                     32,__Vtask_tb_mac__DOT__check_acc__75__want);
    } else {
        VL_WRITEF_NX("pass  %-46@ acc = %0d\n",0,-1,
                     &(__Vtask_tb_mac__DOT__check_acc__75__what),
                     32,vlSelfRef.tb_mac__DOT__acc);
    }
    VL_WRITEF_NX("\n==================================================\n  checks: %0d    failures: %0d\n",0,
                 32,vlSelfRef.tb_mac__DOT__checks,32,
                 vlSelfRef.tb_mac__DOT__fails);
    if ((0U == vlSelfRef.tb_mac__DOT__fails)) {
        VL_WRITEF_NX("  RESULT: ALL PASS\n",0);
    } else {
        VL_WRITEF_NX("  RESULT: *** %0d FAILURES ***\n",0,
                     32,vlSelfRef.tb_mac__DOT__fails);
    }
    VL_WRITEF_NX("==================================================\n\n",0);
    if (VL_UNLIKELY(VL_GTS_III(32, 0x14U, vlSelfRef.tb_mac__DOT__checks))) {
        VL_WRITEF_NX("[%0t] %%Fatal: tb_mac.sv:310: Assertion failed in %Ntb_mac: only %0d checks ran, the suite did not exercise the design\n",0,
                     64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name(),
                     32,vlSelfRef.tb_mac__DOT__checks);
        VL_STOP_MT("sim/tb_mac.sv", 310, "", false);
    }
    if (VL_UNLIKELY((0U != vlSelfRef.tb_mac__DOT__fails))) {
        VL_WRITEF_NX("[%0t] %%Fatal: tb_mac.sv:311: Assertion failed in %Ntb_mac: verification failed\n",0,
                     64,VL_TIME_UNITED_Q(1000),-9,vlSymsp->name());
        VL_STOP_MT("sim/tb_mac.sv", 311, "", false);
    }
    VL_FINISH_MT("sim/tb_mac.sv", 313, "");
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mac___024root___dump_triggers__act(Vtb_mac___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_mac___024root___eval_triggers__act(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.set(0U, ((IData)(vlSelfRef.tb_mac__DOT__clk) 
                                       & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_mac__DOT__clk__0))));
    vlSelfRef.__VactTriggered.set(1U, ((IData)(vlSelfRef.tb_mac__DOT__rst) 
                                       & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__tb_mac__DOT__rst__0))));
    vlSelfRef.__VactTriggered.set(2U, vlSelfRef.__VdlySched.awaitingCurrentTime());
    vlSelfRef.__Vtrigprevexpr___TOP__tb_mac__DOT__clk__0 
        = vlSelfRef.tb_mac__DOT__clk;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_mac__DOT__rst__0 
        = vlSelfRef.tb_mac__DOT__rst;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_mac___024root___dump_triggers__act(vlSelf);
    }
#endif
}
