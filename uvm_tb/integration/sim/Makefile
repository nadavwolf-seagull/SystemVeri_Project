VERILATOR ?= verilator
NPROC     := $(shell nproc)

PROJECT_ROOT := $(abspath ../../..)
INT_TB_DIR   := $(PROJECT_ROOT)/uvm_tb/integration
UVM_DIR      := $(HOME)/my_projects/cdv_feb26/third-party/uvm-latest

TOP      ?= integration_uvm_top
TEST     ?= integration_smoke_test
SIM_NAME ?= $(TOP)
SIM_DIR  ?= $(INT_TB_DIR)/sim/$(SIM_NAME)-sim

.RECIPEPREFIX := >

UVM_SRCS := \
    $(UVM_DIR)/src/uvm.sv

TB_SRCS := \
    $(INT_TB_DIR)/interfaces/integration_if.sv \
    $(INT_TB_DIR)/integration_uvm_pkg.sv \
    $(INT_TB_DIR)/integration_uvm_top.sv

VERILOG_INCLUDE_DIRS := \
    $(UVM_DIR)/src \
    $(INT_TB_DIR)

$(SIM_DIR)/$(SIM_NAME).mk:
>cd $(PROJECT_ROOT) && \
>$(VERILATOR) \
>    --cc \
>    --exe \
>    --main \
>    --timing \
>    --trace-fst \
>    -Wno-fatal \
>    --top-module $(TOP) \
>    -Mdir $(SIM_DIR) \
>    --output-groups $(NPROC) \
>    --prefix $(SIM_NAME) \
>    -o $(SIM_NAME).test \
>    -DUVM_NO_DPI \
>    $(addprefix +incdir+,$(VERILOG_INCLUDE_DIRS)) \
>    $(UVM_SRCS) \
>    -f final_project_chip.f \
>    $(TB_SRCS)

$(SIM_DIR)/$(SIM_NAME).test: $(SIM_DIR)/$(SIM_NAME).mk
>$(MAKE) -j$(NPROC) \
>    -C $(SIM_DIR) \
>    -f $(SIM_NAME).mk

simulate: $(SIM_DIR)/$(SIM_NAME).test
>@echo "[RUN] Starting chip-level integration UVM simulation..."
>cd $(PROJECT_ROOT) && \
>$(SIM_DIR)/$(SIM_NAME).test +UVM_TESTNAME=$(TEST)

clean:
>rm -rf $(SIM_DIR)
>rm -f $(PROJECT_ROOT)/integration_uvm_top.fst

.PHONY: simulate clean
