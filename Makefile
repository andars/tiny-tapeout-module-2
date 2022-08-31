# derived from https://github.com/mattvenn/wokwi-verilog-gds-test/blob/main/Makefile

WOKWI_PROJECT_ID=341469966803927634

VERILOG_FILES = user_module.v cpu.v cpu_control.v pc_stack.v datapath.v alu.v 
VERILOG_HEADERS = pc_stack.vh datapath.vh
PROCESSED_VERILOG_FILES = $(patsubst %.v,src/%_$(WOKWI_PROJECT_ID).v,$(VERILOG_FILES))
PROCESSED_VERILOG_HEADERS = $(patsubst %.vh,src/%_$(WOKWI_PROJECT_ID).vh,$(VERILOG_HEADERS))
$(info processed verilog files: $(PROCESSED_VERILOG_FILES))
$(info processed verilog headers: $(PROCESSED_VERILOG_HEADERS))

fetch: $(PROCESSED_VERILOG_FILES) $(PROCESSED_VERILOG_HEADERS)
	echo "Project ID = $(WOKWI_PROJECT_ID)"
	ls src
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' template/scan_wrapper.v > src/scan_wrapper_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' template/config.tcl > src/config.tcl
	echo $(WOKWI_PROJECT_ID) > src/ID

# needs PDK_ROOT and OPENLANE_ROOT, OPENLANE_IMAGE_NAME set from your environment
harden:
	docker run --rm \
	-v $(OPENLANE_ROOT):/openlane \
	-v $(PDK_ROOT):$(PDK_ROOT) \
	-v $(CURDIR):/work \
	-e PDK_ROOT=$(PDK_ROOT) \
	-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
	$(OPENLANE_IMAGE_NAME) \
	/bin/bash -c "./flow.tcl -overwrite -design /work/src -run_path /work/runs -tag wokwi"

$(PROCESSED_VERILOG_FILES): src/%_$(WOKWI_PROJECT_ID).v: verilog/%.v
	mkdir -p src
	sed -e 's/PROJECT_ID/$(WOKWI_PROJECT_ID)/g' -e 's/^`include "\(.*\)\.vh"/`include "\1\_$(WOKWI_PROJECT_ID).vh"/g' $< > $@

$(PROCESSED_VERILOG_HEADERS): src/%_$(WOKWI_PROJECT_ID).vh: verilog/%.vh
	mkdir -p src
	sed -e 's/PROJECT_ID/$(WOKWI_PROJECT_ID)/g' -e 's/^`include "\(.*\)\.vh"/`include "\1\_$(WOKWI_PROJECT_ID).vh"/g' $< > $@

.PHONY: clean
clean:
	rm -rf src
