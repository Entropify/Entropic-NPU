// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_mac__Syms.h"


void Vtb_mac___024root__trace_chg_0_sub_0(Vtb_mac___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_mac___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root__trace_chg_0\n"); );
    // Init
    Vtb_mac___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_mac___024root*>(voidSelf);
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtb_mac___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_mac___024root__trace_chg_0_sub_0(Vtb_mac___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    (void)vlSelf;  // Prevent unused variable warning
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root__trace_chg_0_sub_0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U] 
                     | vlSelfRef.__Vm_traceActivity
                     [2U]))) {
        bufp->chgBit(oldp+0,(vlSelfRef.tb_mac__DOT__rst));
        bufp->chgBit(oldp+1,(vlSelfRef.tb_mac__DOT__valid));
        bufp->chgBit(oldp+2,(vlSelfRef.tb_mac__DOT__first));
        bufp->chgBit(oldp+3,(vlSelfRef.tb_mac__DOT__last));
        bufp->chgBit(oldp+4,(vlSelfRef.tb_mac__DOT__freeze));
        bufp->chgCData(oldp+5,(vlSelfRef.tb_mac__DOT__weight),8);
        bufp->chgCData(oldp+6,(vlSelfRef.tb_mac__DOT__activation),8);
        bufp->chgIData(oldp+7,(vlSelfRef.tb_mac__DOT__checks),32);
        bufp->chgIData(oldp+8,(vlSelfRef.tb_mac__DOT__fails),32);
        bufp->chgIData(oldp+9,(vlSelfRef.tb_mac__DOT__t),32);
        bufp->chgBit(oldp+10,(vlSelfRef.tb_mac__DOT__got));
    }
    if (VL_UNLIKELY(vlSelfRef.__Vm_traceActivity[3U])) {
        bufp->chgIData(oldp+11,(vlSelfRef.tb_mac__DOT__acc),32);
        bufp->chgBit(oldp+12,(vlSelfRef.tb_mac__DOT__valid_out));
        bufp->chgBit(oldp+13,(vlSelfRef.tb_mac__DOT__done));
        bufp->chgCData(oldp+14,(vlSelfRef.tb_mac__DOT__dut__DOT__w_r),8);
        bufp->chgSData(oldp+15,(vlSelfRef.tb_mac__DOT__dut__DOT__act_r),9);
        bufp->chgBit(oldp+16,(vlSelfRef.tb_mac__DOT__dut__DOT__valid_s1));
        bufp->chgIData(oldp+17,(vlSelfRef.tb_mac__DOT__dut__DOT__prod_r),17);
        bufp->chgBit(oldp+18,(vlSelfRef.tb_mac__DOT__dut__DOT__valid_s2));
        bufp->chgBit(oldp+19,(vlSelfRef.tb_mac__DOT__dut__DOT__first_s1));
        bufp->chgBit(oldp+20,(vlSelfRef.tb_mac__DOT__dut__DOT__first_s2));
        bufp->chgBit(oldp+21,(vlSelfRef.tb_mac__DOT__dut__DOT__last_s1));
        bufp->chgBit(oldp+22,(vlSelfRef.tb_mac__DOT__dut__DOT__last_s2));
    }
    bufp->chgBit(oldp+23,(vlSelfRef.tb_mac__DOT__clk));
}

void Vtb_mac___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_mac___024root__trace_cleanup\n"); );
    // Init
    Vtb_mac___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_mac___024root*>(voidSelf);
    Vtb_mac__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
}
