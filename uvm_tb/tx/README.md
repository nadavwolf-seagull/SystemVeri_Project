# UART TX UVM Verification Environment

## Overview

This environment verifies the UART TX subsystem of the final project.

The DUT under test is:

uart_tx_top

which internally contains:

- uart_tx_mac
- uart_tx_phy

The environment verifies the complete packet-to-UART transmission path.

---

## Verification Components

### Packet Agent

Responsible for driving packet-level transactions into the DUT.

Contains:

- Driver
- Sequencer
- Packet Monitor

---

### Serial Agent

Passively monitors the UART TX serial line.

Checks:

- Start bit
- Data bits
- Parity bit
- Stop bit

and reconstructs transmitted packets.

---

### Scoreboard

Compares

Expected packet

vs

Observed UART transmission.

Comparison is performed only on the valid packet length.

---

## Tested Features

- Variable packet lengths
- Random payloads
- Maximum packet size
- Invalid packet lengths
- TX Enable behavior
- CTS flow control
- UART serialization
- Packet reconstruction

---

## Current Status

PASS = 25

FAIL = 0

No UVM errors.

Environment validated successfully.