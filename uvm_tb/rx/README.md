# UART RX PHY UVM Verification Environment

## Overview

This environment verifies the `uart_rx_phy` block of the final project.

The environment drives complete UART serial frames into the DUT and checks the received byte, valid indication, and UART error outputs.

## UART Configuration

- UART clock frequency: 256 MHz
- Baud rate: 8 Mbps
- Clocks per bit: 32
- Data bits: 8
- Parity: enabled
- Parity type: even
- Stop bits: 1
- Data order: LSB first

## DUT

The verified DUT is:

```text
uart_rx_phy
```

This is a block-level environment. The downstream RX blocks, including the frame collector, parser, and classifier, are outside the scope of this environment.

## Environment Structure

```text
uvm_tb/rx/
├── agents/
│   ├── uart_rx_agent.sv
│   ├── uart_rx_driver.sv
│   ├── uart_rx_item.sv
│   ├── uart_rx_monitor.sv
│   └── uart_rx_sequencer.sv
├── env/
│   └── uart_rx_env.sv
├── interfaces/
│   └── uart_rx_if.sv
├── scoreboards/
│   └── uart_rx_scoreboard.sv
├── sequences/
│   ├── uart_rx_base_seq.sv
│   └── uart_rx_random_seq.sv
├── tests/
│   └── uart_rx_base_test.sv
├── sim/
│   └── Makefile
├── tb_top.sv
├── uart_rx_pkg.sv
└── README.md
```

## Verification Components

### RX Transaction

The transaction contains:

- UART byte data
- Number of idle cycles before transmission
- Optional parity-error injection
- Optional framing-error injection
- DUT parity-error result
- DUT framing-error result

### RX Driver

The driver converts each transaction into a serial UART frame:

1. Idle-high period
2. Start bit
3. Eight data bits, LSB first
4. Even parity bit
5. Stop bit
6. Return to idle

The driver can intentionally corrupt the parity bit or stop bit.

The expected transaction is published before transmission begins, ensuring that the scoreboard expectation is available before the DUT response arrives.

### RX Monitor

The monitor collects all DUT output events associated with one UART frame:

- `rx_byte`
- `rx_byte_valid`
- `parity_err`
- `framing_err`
- `rx_busy`

Exactly one observed transaction is published for each completed frame.

### Scoreboard

The scoreboard compares the expected transaction against the DUT response.

For valid frames, it checks:

- Received byte value
- No parity error
- No framing error

For corrupted frames, it checks the expected parity-error or framing-error indication.

## Verified Scenarios

- Valid UART byte reception
- Random byte values
- Correct LSB-first serialization
- Even-parity calculation
- Injected parity errors
- Injected framing errors
- Correct valid-byte behavior
- Correct error reporting
- Correct RX busy behavior
- Expected and observed transaction synchronization

## Regression Result

```text
matched=10
mismatched=0
queue_left=0

UVM_ERROR=0
UVM_FATAL=0
```

## Running the Test

```bash
cd uvm_tb/rx/sim
make clean
make simulate
```

## Known Scope Limitation

This environment verifies only `uart_rx_phy`.

The following downstream blocks require separate block-level or integration verification:

- `rx_frame_collector`
- `rx_parser`
- `rx_classifier`
- RX command and control-path integration