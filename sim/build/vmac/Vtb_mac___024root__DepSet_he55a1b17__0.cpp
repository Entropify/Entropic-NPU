// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_mac.h for the primary calling header

#include "Vtb_mac__pch.h"
#include "Vtb_mac___024root.h"

VlCoroutine Vtb_mac___024root___eval_initial__TOP__Vtiming__0(Vtb_mac___024root* vlSelf);
VlCoroutine Vtb_mac___024root___eval_initial__TOP__Vtiming__1(Vtb_mac___024root* vlSelf);

void Vtb_mac___024root___eval_initial(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_initial\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    Vtb_mac___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vtb_mac___024root___eval_initial__TOP__Vtiming__1(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__tb_mac__DOT__clk__0 
        = vlSelfRef.tb_mac__DOT__clk;
    vlSelfRef.__Vtrigprevexpr___TOP__tb_mac__DOT__rst__0 
        = vlSelfRef.tb_mac__DOT__rst;
}

VL_INLINE_OPT VlCoroutine Vtb_mac___024root___eval_initial__TOP__Vtiming__1(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_initial__TOP__Vtiming__1\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (1U) {
        co_await vlSelfRef.__VdlySched.delay(0x1388ULL, 
                                             nullptr, 
                                             "sim/tb_mac.sv", 
                                             47);
        vlSelfRef.tb_mac__DOT__clk = (1U & (~ (IData)(vlSelfRef.tb_mac__DOT__clk)));
    }
}

void Vtb_mac___024root___eval_act(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vtb_mac___024root___nba_sequent__TOP__0(Vtb_mac___024root* vlSelf);

void Vtb_mac___024root___eval_nba(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vtb_mac___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[3U] = 1U;
    }
}

VL_INLINE_OPT void Vtb_mac___024root___nba_sequent__TOP__0(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___nba_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*7:0*/ __Vdly__tb_mac__DOT__dut__DOT__w_r;
    __Vdly__tb_mac__DOT__dut__DOT__w_r = 0;
    SData/*8:0*/ __Vdly__tb_mac__DOT__dut__DOT__act_r;
    __Vdly__tb_mac__DOT__dut__DOT__act_r = 0;
    CData/*0:0*/ __Vdly__tb_mac__DOT__dut__DOT__valid_s1;
    __Vdly__tb_mac__DOT__dut__DOT__valid_s1 = 0;
    IData/*31:0*/ __Vdly__tb_mac__DOT__acc;
    __Vdly__tb_mac__DOT__acc = 0;
    IData/*16:0*/ __Vdly__tb_mac__DOT__dut__DOT__prod_r;
    __Vdly__tb_mac__DOT__dut__DOT__prod_r = 0;
    CData/*0:0*/ __Vdly__tb_mac__DOT__dut__DOT__valid_s2;
    __Vdly__tb_mac__DOT__dut__DOT__valid_s2 = 0;
    CData/*0:0*/ __Vdly__tb_mac__DOT__dut__DOT__first_s1;
    __Vdly__tb_mac__DOT__dut__DOT__first_s1 = 0;
    CData/*0:0*/ __Vdly__tb_mac__DOT__dut__DOT__first_s2;
    __Vdly__tb_mac__DOT__dut__DOT__first_s2 = 0;
    CData/*0:0*/ __Vdly__tb_mac__DOT__dut__DOT__last_s1;
    __Vdly__tb_mac__DOT__dut__DOT__last_s1 = 0;
    CData/*0:0*/ __Vdly__tb_mac__DOT__dut__DOT__last_s2;
    __Vdly__tb_mac__DOT__dut__DOT__last_s2 = 0;
    // Body
    __Vdly__tb_mac__DOT__dut__DOT__w_r = vlSelfRef.tb_mac__DOT__dut__DOT__w_r;
    __Vdly__tb_mac__DOT__dut__DOT__act_r = vlSelfRef.tb_mac__DOT__dut__DOT__act_r;
    __Vdly__tb_mac__DOT__dut__DOT__valid_s1 = vlSelfRef.tb_mac__DOT__dut__DOT__valid_s1;
    __Vdly__tb_mac__DOT__acc = vlSelfRef.tb_mac__DOT__acc;
    __Vdly__tb_mac__DOT__dut__DOT__prod_r = vlSelfRef.tb_mac__DOT__dut__DOT__prod_r;
    __Vdly__tb_mac__DOT__dut__DOT__valid_s2 = vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2;
    __Vdly__tb_mac__DOT__dut__DOT__first_s1 = vlSelfRef.tb_mac__DOT__dut__DOT__first_s1;
    __Vdly__tb_mac__DOT__dut__DOT__first_s2 = vlSelfRef.tb_mac__DOT__dut__DOT__first_s2;
    __Vdly__tb_mac__DOT__dut__DOT__last_s1 = vlSelfRef.tb_mac__DOT__dut__DOT__last_s1;
    __Vdly__tb_mac__DOT__dut__DOT__last_s2 = vlSelfRef.tb_mac__DOT__dut__DOT__last_s2;
    if (vlSelfRef.tb_mac__DOT__rst) {
        __Vdly__tb_mac__DOT__dut__DOT__w_r = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__act_r = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__valid_s1 = 0U;
        vlSelfRef.tb_mac__DOT__valid_out = 0U;
        __Vdly__tb_mac__DOT__acc = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__prod_r = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__valid_s2 = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__first_s1 = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__first_s2 = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__last_s1 = 0U;
        __Vdly__tb_mac__DOT__dut__DOT__last_s2 = 0U;
        vlSelfRef.tb_mac__DOT__done = 0U;
    } else {
        if (vlSelfRef.tb_mac__DOT__freeze) {
            __Vdly__tb_mac__DOT__dut__DOT__w_r = vlSelfRef.tb_mac__DOT__dut__DOT__w_r;
            __Vdly__tb_mac__DOT__dut__DOT__act_r = vlSelfRef.tb_mac__DOT__dut__DOT__act_r;
            __Vdly__tb_mac__DOT__dut__DOT__valid_s1 
                = vlSelfRef.tb_mac__DOT__dut__DOT__valid_s1;
            __Vdly__tb_mac__DOT__dut__DOT__first_s1 
                = vlSelfRef.tb_mac__DOT__dut__DOT__first_s1;
            __Vdly__tb_mac__DOT__dut__DOT__last_s1 
                = vlSelfRef.tb_mac__DOT__dut__DOT__last_s1;
            __Vdly__tb_mac__DOT__dut__DOT__valid_s2 
                = vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2;
            __Vdly__tb_mac__DOT__dut__DOT__prod_r = 
                (0x1ffffU & vlSelfRef.tb_mac__DOT__dut__DOT__prod_r);
            __Vdly__tb_mac__DOT__dut__DOT__first_s2 
                = vlSelfRef.tb_mac__DOT__dut__DOT__first_s2;
            __Vdly__tb_mac__DOT__dut__DOT__last_s2 
                = vlSelfRef.tb_mac__DOT__dut__DOT__last_s2;
            __Vdly__tb_mac__DOT__acc = vlSelfRef.tb_mac__DOT__acc;
        } else {
            __Vdly__tb_mac__DOT__dut__DOT__w_r = vlSelfRef.tb_mac__DOT__weight;
            __Vdly__tb_mac__DOT__dut__DOT__act_r = vlSelfRef.tb_mac__DOT__activation;
            __Vdly__tb_mac__DOT__dut__DOT__valid_s1 
                = vlSelfRef.tb_mac__DOT__valid;
            __Vdly__tb_mac__DOT__dut__DOT__first_s1 
                = vlSelfRef.tb_mac__DOT__first;
            __Vdly__tb_mac__DOT__dut__DOT__last_s1 
                = vlSelfRef.tb_mac__DOT__last;
            __Vdly__tb_mac__DOT__dut__DOT__valid_s2 
                = vlSelfRef.tb_mac__DOT__dut__DOT__valid_s1;
            __Vdly__tb_mac__DOT__dut__DOT__prod_r = 
                (0x1ffffU & VL_MULS_III(17, (0x1ffffU 
                                             & VL_EXTENDS_II(17,8, (IData)(vlSelfRef.tb_mac__DOT__dut__DOT__w_r))), 
                                        (0x1ffffU & 
                                         VL_EXTENDS_II(17,9, (IData)(vlSelfRef.tb_mac__DOT__dut__DOT__act_r)))));
            __Vdly__tb_mac__DOT__dut__DOT__first_s2 
                = vlSelfRef.tb_mac__DOT__dut__DOT__first_s1;
            __Vdly__tb_mac__DOT__dut__DOT__last_s2 
                = vlSelfRef.tb_mac__DOT__dut__DOT__last_s1;
            if (((IData)(vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2) 
                 & (IData)(vlSelfRef.tb_mac__DOT__dut__DOT__first_s2))) {
                __Vdly__tb_mac__DOT__acc = (((- (IData)(
                                                        (1U 
                                                         & (vlSelfRef.tb_mac__DOT__dut__DOT__prod_r 
                                                            >> 0x10U)))) 
                                             << 0x11U) 
                                            | vlSelfRef.tb_mac__DOT__dut__DOT__prod_r);
            } else if (vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2) {
                __Vdly__tb_mac__DOT__acc = (vlSelfRef.tb_mac__DOT__acc 
                                            + (((- (IData)(
                                                           (1U 
                                                            & (vlSelfRef.tb_mac__DOT__dut__DOT__prod_r 
                                                               >> 0x10U)))) 
                                                << 0x11U) 
                                               | vlSelfRef.tb_mac__DOT__dut__DOT__prod_r));
            }
        }
        vlSelfRef.tb_mac__DOT__valid_out = ((~ (IData)(vlSelfRef.tb_mac__DOT__freeze)) 
                                            & (IData)(vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2));
        vlSelfRef.tb_mac__DOT__done = ((~ (IData)(vlSelfRef.tb_mac__DOT__freeze)) 
                                       & ((IData)(vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2) 
                                          & (IData)(vlSelfRef.tb_mac__DOT__dut__DOT__last_s2)));
    }
    vlSelfRef.tb_mac__DOT__dut__DOT__w_r = __Vdly__tb_mac__DOT__dut__DOT__w_r;
    vlSelfRef.tb_mac__DOT__dut__DOT__act_r = __Vdly__tb_mac__DOT__dut__DOT__act_r;
    vlSelfRef.tb_mac__DOT__dut__DOT__valid_s1 = __Vdly__tb_mac__DOT__dut__DOT__valid_s1;
    vlSelfRef.tb_mac__DOT__acc = __Vdly__tb_mac__DOT__acc;
    vlSelfRef.tb_mac__DOT__dut__DOT__prod_r = __Vdly__tb_mac__DOT__dut__DOT__prod_r;
    vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2 = __Vdly__tb_mac__DOT__dut__DOT__valid_s2;
    vlSelfRef.tb_mac__DOT__dut__DOT__first_s1 = __Vdly__tb_mac__DOT__dut__DOT__first_s1;
    vlSelfRef.tb_mac__DOT__dut__DOT__first_s2 = __Vdly__tb_mac__DOT__dut__DOT__first_s2;
    vlSelfRef.tb_mac__DOT__dut__DOT__last_s1 = __Vdly__tb_mac__DOT__dut__DOT__last_s1;
    vlSelfRef.tb_mac__DOT__dut__DOT__last_s2 = __Vdly__tb_mac__DOT__dut__DOT__last_s2;
}

void Vtb_mac___024root___timing_resume(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___timing_resume\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        vlSelfRef.__VtrigSched_h5c392597__0.resume(
                                                   "@(posedge tb_mac.clk)");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vtb_mac___024root___timing_commit(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___timing_commit\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((! (1ULL & vlSelfRef.__VactTriggered.word(0U)))) {
        vlSelfRef.__VtrigSched_h5c392597__0.commit(
                                                   "@(posedge tb_mac.clk)");
    }
}

void Vtb_mac___024root___eval_triggers__act(Vtb_mac___024root* vlSelf);

bool Vtb_mac___024root___eval_phase__act(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_phase__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<3> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vtb_mac___024root___eval_triggers__act(vlSelf);
    Vtb_mac___024root___timing_commit(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vtb_mac___024root___timing_resume(vlSelf);
        Vtb_mac___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vtb_mac___024root___eval_phase__nba(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_phase__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vtb_mac___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mac___024root___dump_triggers__nba(Vtb_mac___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mac___024root___dump_triggers__act(Vtb_mac___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_mac___024root___eval(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vtb_mac___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("sim/tb_mac.sv", 7, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelfRef.__VactIterCount))) {
#ifdef VL_DEBUG
                Vtb_mac___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("sim/tb_mac.sv", 7, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vtb_mac___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vtb_mac___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vtb_mac___024root___eval_debug_assertions(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_debug_assertions\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
