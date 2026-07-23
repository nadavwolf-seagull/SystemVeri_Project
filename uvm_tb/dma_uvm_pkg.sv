package dma_uvm_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "agents/control/dma_control_item.sv"

    `include "agents/control/dma_control_sequencer.sv"
    `include "agents/control/dma_control_driver.sv"
    `include "agents/control/dma_control_monitor.sv"
    `include "agents/control/dma_control_agent.sv"

    `include "models/dma_response_model.sv"
    `include "scoreboards/dma_scoreboard.sv"
    `include "env/dma_env.sv"

    `include "sequences/dma_validation_sequence.sv"
    `include "sequences/dma_valid_read_sequence.sv"
    `include "tests/dma_uvm_smoke_test.sv"

endpackage