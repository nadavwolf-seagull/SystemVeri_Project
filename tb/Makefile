TOP       ?= tb_seq_img_cluster
RTL_DIR   := ..
TB_FILE   := $(TOP).sv
OBJ_DIR   := /home/adminuser/verilator_build/lab12_tb_seq_img_cluster

VERILATOR := verilator

RTL_SRCS := \
	$(RTL_DIR)/rgb_sram_subsystem.sv \
	$(RTL_DIR)/sequencer.sv \
	$(RTL_DIR)/fifo_controller.sv \
	$(RTL_DIR)/ram_1r1w.sv \
	$(RTL_DIR)/seq_tx_img_fifo.sv \
	$(RTL_DIR)/ahb_pixel_slave.sv \
	$(RTL_DIR)/seq_img_cluster.sv

.PHONY: all build sim clean lint

all: sim

build:
	mkdir -p $(OBJ_DIR)
	$(VERILATOR) \
		--binary \
		--timing \
		--trace \
		-Wall \
		-Wno-fatal \
		--top-module $(TOP) \
		--Mdir $(OBJ_DIR) \
		$(RTL_SRCS) \
		$(TB_FILE)

sim: build
	cd $(RTL_DIR) && $(OBJ_DIR)/V$(TOP)

lint:
	$(VERILATOR) \
		--lint-only \
		--timing \
		-Wall \
		-Wno-fatal \
		--top-module $(TOP) \
		$(RTL_SRCS) \
		$(TB_FILE)

clean:
	rm -rf $(OBJ_DIR)
	rm -f *.vcd *.fst