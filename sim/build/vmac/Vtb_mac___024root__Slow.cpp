// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_mac.h for the primary calling header

#include "Vtb_mac__pch.h"
#include "Vtb_mac__Syms.h"
#include "Vtb_mac___024root.h"

void Vtb_mac___024root___ctor_var_reset(Vtb_mac___024root* vlSelf);

Vtb_mac___024root::Vtb_mac___024root(Vtb_mac__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_mac___024root___ctor_var_reset(this);
}

void Vtb_mac___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtb_mac___024root::~Vtb_mac___024root() {
}
