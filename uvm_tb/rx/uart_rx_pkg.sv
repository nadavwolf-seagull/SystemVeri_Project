`ifndef UART_RX_PKG_SV
`define UART_RX_PKG_SV

package uart_rx_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Transaction and agent components
    `include "agents/uart_rx_item.sv"
    `include "agents/uart_rx_sequencer.sv"
    `include "agents/uart_rx_driver.sv"
    `include "agents/uart_rx_monitor.sv"
    `include "agents/uart_rx_agent.sv"

    // Sequences
    `include "sequences/uart_rx_base_seq.sv"
    `include "sequences/uart_rx_random_seq.sv"

    // Checking and environment
    `include "scoreboards/uart_rx_scoreboard.sv"
    `include "env/uart_rx_env.sv"

    // Tests must come last because they reference env and sequences
    `include "tests/uart_rx_base_test.sv"

endpackage

`endif