// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_mac.h for the primary calling header

#include "Vtb_mac__pch.h"
#include "Vtb_mac___024root.h"

VL_ATTR_COLD void Vtb_mac___024root___eval_static__TOP(Vtb_mac___024root* vlSelf);
VL_ATTR_COLD void Vtb_mac___024root____Vm_traceActivitySetAll(Vtb_mac___024root* vlSelf);

VL_ATTR_COLD void Vtb_mac___024root___eval_static(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_static\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtb_mac___024root___eval_static__TOP(vlSelf);
    Vtb_mac___024root____Vm_traceActivitySetAll(vlSelf);
}

VL_ATTR_COLD void Vtb_mac___024root___eval_static__TOP(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_static__TOP\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.tb_mac__DOT__clk = 0U;
    vlSelfRef.tb_mac__DOT__rst = 1U;
    vlSelfRef.tb_mac__DOT__valid = 0U;
    vlSelfRef.tb_mac__DOT__first = 0U;
    vlSelfRef.tb_mac__DOT__last = 0U;
    vlSelfRef.tb_mac__DOT__freeze = 0U;
    vlSelfRef.tb_mac__DOT__weight = 0U;
    vlSelfRef.tb_mac__DOT__activation = 0U;
    vlSelfRef.tb_mac__DOT__checks = 0U;
    vlSelfRef.tb_mac__DOT__fails = 0U;
    vlSelfRef.tb_mac__DOT__t = 0U;
    vlSelfRef.tb_mac__DOT__got = 0U;
}

VL_ATTR_COLD void Vtb_mac___024root___eval_final(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_final\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtb_mac___024root___eval_settle(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___eval_settle\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mac___024root___dump_triggers__act(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___dump_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge tb_mac.clk)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(posedge tb_mac.rst)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_mac___024root___dump_triggers__nba(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___dump_triggers__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge tb_mac.clk)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(posedge tb_mac.rst)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtb_mac___024root____Vm_traceActivitySetAll(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root____Vm_traceActivitySetAll\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
    vlSelfRef.__Vm_traceActivity[3U] = 1U;
}

VL_ATTR_COLD void Vtb_mac___024root___ctor_var_reset(Vtb_mac___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->tb_mac__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__rst = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__valid = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__first = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__last = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__freeze = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__weight = VL_RAND_RESET_I(8);
    vlSelf->tb_mac__DOT__activation = VL_RAND_RESET_I(8);
    vlSelf->tb_mac__DOT__acc = VL_RAND_RESET_I(32);
    vlSelf->tb_mac__DOT__valid_out = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__done = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__checks = 0;
    vlSelf->tb_mac__DOT__fails = 0;
    vlSelf->tb_mac__DOT__t = 0;
    vlSelf->tb_mac__DOT__got = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__dut__DOT__w_r = VL_RAND_RESET_I(8);
    vlSelf->tb_mac__DOT__dut__DOT__act_r = VL_RAND_RESET_I(9);
    vlSelf->tb_mac__DOT__dut__DOT__valid_s1 = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__dut__DOT__prod_r = VL_RAND_RESET_I(17);
    vlSelf->tb_mac__DOT__dut__DOT__valid_s2 = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__dut__DOT__first_s1 = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__dut__DOT__first_s2 = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__dut__DOT__last_s1 = VL_RAND_RESET_I(1);
    vlSelf->tb_mac__DOT__dut__DOT__last_s2 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__tb_mac__DOT__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__tb_mac__DOT__rst__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 4; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
