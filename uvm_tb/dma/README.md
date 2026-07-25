# DMA UVM Verification Environment

## Scope

This environment verifies the `rgb_dma_sequencer` at block level.

The DUT supports RGB image transfers in two directions:

- DMA WRITE: data is consumed from the RGB RX FIFOs and written through the DMA command interface.
- DMA READ: data is read through the DMA response interface and forwarded toward the RGB TX FIFOs.

## Environment Structure

- `agents/control/`
  - DMA sequence item
  - Sequencer
  - Driver
  - Monitor
  - Active control agent

- `models/`
  - DMA response model
  - RGB RX FIFO model

- `scoreboards/`
  - Checks legal and illegal DMA command outcomes

- `coverage/`
  - Functional coverage collector

- `sequences/`
  - Invalid configuration validation
  - Legal DMA READ
  - Legal DMA WRITE
  - Constrained-random legal transfers

- `tests/`
  - DMA UVM smoke test

- `sim/`
  - Verilator Makefile and generated simulation output

## Verified Scenarios

- Legal DMA READ
- Legal DMA WRITE
- Width not divisible by 16
- Misaligned base address
- Base address below the R SRAM window
- Transfer larger than ROM depth
- Base address outside the channel window
- Transfer crossing the channel boundary
- Multiple constrained-random legal READ and WRITE transfers
- DMA command and response handshake
- RGB FIFO behavior during DMA WRITE

## Final Regression Result

```text
PASS=28
FAIL=0
UVM_ERROR=0
UVM_FATAL=0






