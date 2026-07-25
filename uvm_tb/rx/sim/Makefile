VERILATOR ?= verilator
NPROC     := $(shell nproc)

PROJECT_ROOT := $(abspath ../../..)
RX_TB_DIR    := $(PROJECT_ROOT)/uvm_tb/rx
UVM_DIR      := $(HOME)/my_projects/cdv_feb26/third-party/uvm-latest

TOP      ?= tb_top
TEST     ?= uart_rx_base_test
SIM_NAME ?= $(TOP)
SIM_DIR  ?= $(SIM_NAME)-sim

SRCS := \
	$(UVM_DIR)/src/uvm.sv \
	$(PROJECT_ROOT)/lab12_pkg.sv \
	$(RX_TB_DIR)/interfaces/uart_rx_if.sv \
	$(PROJECT_ROOT)/uart_rx_phy.sv \
	$(RX_TB_DIR)/uart_rx_pkg.sv \
	$(RX_TB_DIR)/tb_top.sv

VERILOG_INCLUDE_DIRS := \
	$(UVM_DIR)/src \
	$(RX_TB_DIR)

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
	@echo "[RUN] Starting UART RX UVM simulation..."
	$(SIM_DIR)/$(SIM_NAME).test +UVM_TESTNAME=$(TEST)

clean:
	rm -rf $(SIM_DIR)

.PHONY: simulate clean