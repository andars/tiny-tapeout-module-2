VERILATOR ?= verilator

CPU_FILES = cpu.v cpu_control.v pc_stack.v datapath.v alu.v
TEST_SYSTEM_FILES = $(CPU_FILES) test_system.v test_rom.v test_ram.v

.PHONY: lint
lint:
	$(VERILATOR) -DNO_TRISTATE --lint-only --top-module test_system $(TEST_SYSTEM_FILES)

TEST_DIR = ./tests
TEST_BIN_DIR = ./tests
TEST_SOURCES := $(sort $(shell find $(TEST_DIR) -name '*.s' | grep -v -f skip.txt))
$(info skipping $(shell find $(TEST_DIR) -name '*.s' | grep -f skip.txt))
TEST_BINARIES := $(patsubst $(TEST_DIR)/%.s,$(TEST_BIN_DIR)/%.bin,$(TEST_SOURCES))
TEST_RUNS := $(patsubst $(TEST_BIN_DIR)/%.bin,testruns/%.log,$(TEST_BINARIES))
TEST_HEX := $(patsubst testruns/%.log,testruns/%.hex,$(TEST_RUNS))
TEST_WAVES := $(patsubst testruns/%.log,testruns/%.waves,$(TEST_RUNS))
$(info $(TEST_SOURCES))
$(info "")
$(info $(TEST_BINARIES))
$(info "")
$(info $(TEST_RUNS))

$(TEST_HEX): testruns/%.hex: $(TEST_BIN_DIR)/%.bin
	@echo "Generating hex for $*"
	mkdir -p $(@D)
	xxd -l4096 -p -c1 $(word 1,$^) > $@

$(TEST_RUNS): lint

.PHONY: $(TEST_RUNS)
$(TEST_RUNS): testruns/%.log: $(TEST_BIN_DIR)/%.bin $(TEST_DIR)/%.s testruns/%.hex
	mkdir -p $(@D)
	iverilog -DNO_TRISTATE -DROM_SIZE=$(firstword $(shell wc -l testruns/$*.hex)) tb_system.v $(TEST_SYSTEM_FILES)
	cp $(word 3,$^) rom.hex
	split -d -a 1 -l 256 --additional-suffix=".hex" rom.hex "rom_"
	./a.out > $@
	mv waves.vcd testruns/$*.vcd
	bash ./check.sh $(word 2,$^) $@ #|| (cat $@; echo "test $(word 2,$^) failed: $@"; exit 1)

.PHONY: $(TEST_WAVES)
$(TEST_WAVES): testruns/%.waves: |testruns/%.log
	gtkwave testruns/$*.vcd -S signals.tcl #--rcvar 'do_initial_zoom_fit yes'

.PHONY: test
test: $(TEST_RUNS)
