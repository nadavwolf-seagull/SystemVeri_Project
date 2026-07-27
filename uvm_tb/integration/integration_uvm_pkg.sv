`ifndef INTEGRATION_UVM_PKG_SV
`define INTEGRATION_UVM_PKG_SV

package integration_uvm_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Transactions
    `include "transactions/integration_cmd_item.sv"
    `include "transactions/integration_rsp_item.sv"

    // UART RX agent
    `include "agents/uart_rx/integration_uart_rx_sequencer.sv"
    `include "agents/uart_rx/integration_uart_rx_driver.sv"
    `include "agents/uart_rx/integration_uart_rx_agent.sv"

    // UART TX agent
    `include "agents/uart_tx/integration_uart_tx_monitor.sv"
    `include "agents/uart_tx/integration_uart_tx_agent.sv"

    // Models and checking
    `include "models/integration_reference_model.sv"
    `include "scoreboards/integration_scoreboard.sv"

    // Environment
    `include "env/integration_env.sv"

    // Sequences
    `include "sequences/integration_invalid_command_sequence.sv"
    `include "sequences/integration_control_sequence.sv"
    `include "sequences/integration_pixel_sequence.sv"

    // Tests
    `include "tests/integration_smoke_test.sv"
    `include "tests/integration_invalid_command_test.sv"
    `include "tests/integration_control_test.sv"
    `include "tests/integration_pixel_test.sv"

endpackage

`endif
