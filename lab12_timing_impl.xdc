set mux_i0 [get_pins \
    u_lab12_clock_wrapper/u_glitchless_clk_mux/u_bufgmux/I0]

set mux_i1 [get_pins \
    u_lab12_clock_wrapper/u_glitchless_clk_mux/u_bufgmux/I1]

set mux_o [get_pins \
    u_lab12_clock_wrapper/u_glitchless_clk_mux/u_bufgmux/O]

create_generated_clock \
    -name clk_fast_100 \
    -source $mux_i0 \
    -master_clock [get_clocks sys_clk_pin] \
    -divide_by 1 \
    -add \
    $mux_o

create_generated_clock \
    -name clk_fast_280 \
    -source $mux_i1 \
    -master_clock [get_clocks clk_out1_lab12_clk_wiz] \
    -divide_by 1 \
    -add \
    $mux_o

set_clock_groups -logically_exclusive \
    -group [get_clocks clk_fast_100] \
    -group [get_clocks clk_fast_280]

set_false_path \
    -from [get_cells u_lab12_clock_wrapper/pll_locked_sync_reg] \
    -to [get_pins \
        u_lab12_clock_wrapper/u_glitchless_clk_mux/u_bufgmux/S]
