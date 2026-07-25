VERILATOR ?= verilator
NPROC     := $(shell nproc)

PROJECT_ROOT := $(abspath ../../..)
TX_TB_DIR    := $(PROJECT_ROOT)/uvm_tb/tx
UVM_DIR      := $(HOME)/my_projects/cdv_feb26/third-party/uvm-latest

TOP      ?= tx_uvm_top
SIM_NAME ?= $(TOP)
SIM_DIR  ?= $(SIM_NAME)-sim

SRCS := \
        $(UVM_DIR)/src/uvm.sv \
        $(PROJECT_ROOT)/lab12_pkg.sv \
        $(TX_TB_DIR)/interfaces/uart_tx_if.sv \
        $(PROJECT_ROOT)/uart_tx_phy.sv \
        $(PROJECT_ROOT)/uart_tx_mac.sv \
        $(PROJECT_ROOT)/uart_tx_top.sv \
        $(TX_TB_DIR)/tx_uvm_pkg.sv \
        $(TX_TB_DIR)/tx_uvm_top.sv

VERILOG_INCLUDE_DIRS := \
        $(UVM_DIR)/src \
        $(TX_TB_DIR)

$(SIM_DIR)/$(SIM_NAME).mk:
	$(VERILATOR) \
		--cc \
		--exe \
		--main \
		--timing \
		--trace-fst \
		-Wno-fatal \
		--top-module $(TOP) \
		-Mdir $(SIM_DIR) \
		--output-groups $(NPROC) \
		--prefix $(SIM_NAME) \
		-o $(SIM_NAME).test \
		-DUVM_NO_DPI \
		$(addprefix +incdir+,$(VERILOG_INCLUDE_DIRS)) \
		$(SRCS)

$(SIM_DIR)/$(SIM_NAME).test: $(SIM_DIR)/$(SIM_NAME).mk
	$(MAKE) -j$(NPROC) \
		-C $(SIM_DIR) \
		-f $(SIM_NAME).mk

simulate: $(SIM_DIR)/$(SIM_NAME).test
	@echo "[RUN] Starting UART TX UVM simulation..."
	$(SIM_DIR)/$(SIM_NAME).test

clean:
	rm -rf $(SIM_DIR)

.PHONY: simulate clean
