# ============================================================
# CLOCK-DOMAIN RELATIONSHIP
# ============================================================

# The Clock Wizard output is the normal-operation fast clock. The
# BUFGMUX temporarily selects the 100 MHz input while the PLL locks.
set fast_clock [get_clocks -of_objects \
    [get_pins \
        u_lab12_clock_wrapper/u_lab12_clk_wiz/clk_out1]]

# System logic and normal-operation fast logic communicate only through
# explicit asynchronous FIFOs, 2FF synchronizers and handshakes.
set_clock_groups \
    -name sys_fast_async \
    -asynchronous \
    -group [get_clocks sys_clk_pin] \
    -group $fast_clock

# PLL lock controls the BUFGMUX selection.
set_false_path \
    -from [get_cells \
        u_lab12_clock_wrapper/pll_locked_sync_reg] \
    -to [get_pins \
        u_lab12_clock_wrapper/u_glitchless_clk_mux/u_bufgmux/CE1]

# ============================================================
# ASYNCHRONOUS BOARD INTERFACES
# ============================================================

set_false_path -from [get_ports CPU_RESETN]
set_false_path -from [get_ports RX]
set_false_path -from [get_ports UART_RTS]

set_false_path -to [get_ports TX]
set_false_path -to [get_ports UART_CTS]
set_false_path -to [get_ports {LED[*]}]

# Nexys A7 configuration bank voltage.
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
