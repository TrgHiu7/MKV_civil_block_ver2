rvi-bmark-tests = \
	median.riscv \
	multiply.riscv \
	qsort.riscv \
	towers.riscv \
	vvadd.riscv \
	dhrystone.riscv \
	mt-matmul.riscv

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rvi-bmark-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/benchmarks/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rvi-bmark-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/benchmarks/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rvi-bmark-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rvi-bmark-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rvi-bmark-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-bmark-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-bmark-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-bmark-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-bmark-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32ui-p-asm-tests = \
	rv32ui-p-simple \
	rv32ui-p-add \
	rv32ui-p-addi \
	rv32ui-p-and \
	rv32ui-p-andi \
	rv32ui-p-auipc \
	rv32ui-p-beq \
	rv32ui-p-bge \
	rv32ui-p-bgeu \
	rv32ui-p-blt \
	rv32ui-p-bltu \
	rv32ui-p-bne \
	rv32ui-p-fence_i \
	rv32ui-p-jal \
	rv32ui-p-jalr \
	rv32ui-p-lb \
	rv32ui-p-lbu \
	rv32ui-p-lh \
	rv32ui-p-lhu \
	rv32ui-p-lui \
	rv32ui-p-lw \
	rv32ui-p-or \
	rv32ui-p-ori \
	rv32ui-p-sb \
	rv32ui-p-sh \
	rv32ui-p-sw \
	rv32ui-p-sll \
	rv32ui-p-slli \
	rv32ui-p-slt \
	rv32ui-p-slti \
	rv32ui-p-sra \
	rv32ui-p-srai \
	rv32ui-p-srl \
	rv32ui-p-srli \
	rv32ui-p-sub \
	rv32ui-p-xor \
	rv32ui-p-xori

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32ui-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32ui-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32ui-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ui-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ui-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ui-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ui-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ui-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32uc-p-asm-tests = \
	rv32uc-p-rvc

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32uc-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32uc-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32uc-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32uc-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32uc-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32uc-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32uc-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32uc-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32ua-v-asm-tests = \
	rv32ua-v-amoadd_w \
	rv32ua-v-amoand_w \
	rv32ua-v-amoor_w \
	rv32ua-v-amoxor_w \
	rv32ua-v-amoswap_w \
	rv32ua-v-amomax_w \
	rv32ua-v-amomaxu_w \
	rv32ua-v-amomin_w \
	rv32ua-v-amominu_w \
	rv32ua-v-lrsc

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32ua-v-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32ua-v-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32ua-v-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ua-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ua-v-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ua-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ua-v-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ua-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32si-p-asm-tests = \
	rv32si-p-csr \
	rv32si-p-ma_fetch \
	rv32si-p-scall \
	rv32si-p-sbreak \
	rv32si-p-wfi \
	rv32si-p-dirty

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32si-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32si-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32si-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32si-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32si-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32si-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32si-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32si-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32um-v-asm-tests = \
	rv32um-v-mul \
	rv32um-v-mulh \
	rv32um-v-mulhsu \
	rv32um-v-mulhu \
	rv32um-v-div \
	rv32um-v-divu \
	rv32um-v-rem \
	rv32um-v-remu

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32um-v-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32um-v-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32um-v-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32um-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32um-v-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32um-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32um-v-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32um-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32um-p-asm-tests = \
	rv32um-p-mul \
	rv32um-p-mulh \
	rv32um-p-mulhsu \
	rv32um-p-mulhu \
	rv32um-p-div \
	rv32um-p-divu \
	rv32um-p-rem \
	rv32um-p-remu

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32um-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32um-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32um-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32um-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32um-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32um-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32um-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32um-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32uc-v-asm-tests = \
	rv32uc-v-rvc

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32uc-v-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32uc-v-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32uc-v-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32uc-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32uc-v-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32uc-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32uc-v-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32uc-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32ua-p-asm-tests = \
	rv32ua-p-amoadd_w \
	rv32ua-p-amoand_w \
	rv32ua-p-amoor_w \
	rv32ua-p-amoxor_w \
	rv32ua-p-amoswap_w \
	rv32ua-p-amomax_w \
	rv32ua-p-amomaxu_w \
	rv32ua-p-amomin_w \
	rv32ua-p-amominu_w \
	rv32ua-p-lrsc

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32ua-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32ua-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32ua-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ua-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ua-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ua-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ua-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ua-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32mi-p-asm-tests = \
	rv32mi-p-csr \
	rv32mi-p-mcsr \
	rv32mi-p-illegal \
	rv32mi-p-ma_addr \
	rv32mi-p-ma_fetch \
	rv32mi-p-sbreak \
	rv32mi-p-scall

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32mi-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32mi-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32mi-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32mi-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32mi-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32ui-v-asm-tests = \
	rv32ui-v-simple \
	rv32ui-v-add \
	rv32ui-v-addi \
	rv32ui-v-and \
	rv32ui-v-andi \
	rv32ui-v-auipc \
	rv32ui-v-beq \
	rv32ui-v-bge \
	rv32ui-v-bgeu \
	rv32ui-v-blt \
	rv32ui-v-bltu \
	rv32ui-v-bne \
	rv32ui-v-fence_i \
	rv32ui-v-jal \
	rv32ui-v-jalr \
	rv32ui-v-lb \
	rv32ui-v-lbu \
	rv32ui-v-lh \
	rv32ui-v-lhu \
	rv32ui-v-lui \
	rv32ui-v-lw \
	rv32ui-v-or \
	rv32ui-v-ori \
	rv32ui-v-sb \
	rv32ui-v-sh \
	rv32ui-v-sw \
	rv32ui-v-sll \
	rv32ui-v-slli \
	rv32ui-v-slt \
	rv32ui-v-slti \
	rv32ui-v-sra \
	rv32ui-v-srai \
	rv32ui-v-srl \
	rv32ui-v-srli \
	rv32ui-v-sub \
	rv32ui-v-xor \
	rv32ui-v-xori

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32ui-v-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32ui-v-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32ui-v-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ui-v-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ui-v-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-asm-v-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ua-v-asm-tests) $(rv32um-v-asm-tests) $(rv32uc-v-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-v-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ua-v-asm-tests) $(rv32um-v-asm-tests) $(rv32uc-v-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-v-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ua-v-asm-tests) $(rv32um-v-asm-tests) $(rv32uc-v-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-v-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rv32ua-v-asm-tests) $(rv32um-v-asm-tests) $(rv32uc-v-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'


run-asm-p-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32si-p-asm-tests) $(rv32um-p-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-p-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32si-p-asm-tests) $(rv32um-p-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-p-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32si-p-asm-tests) $(rv32um-p-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-p-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32si-p-asm-tests) $(rv32um-p-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ua-v-asm-tests) $(rv32si-p-asm-tests) $(rv32um-v-asm-tests) $(rv32um-p-asm-tests) $(rv32uc-v-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ua-v-asm-tests) $(rv32si-p-asm-tests) $(rv32um-v-asm-tests) $(rv32um-p-asm-tests) $(rv32uc-v-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ua-v-asm-tests) $(rv32si-p-asm-tests) $(rv32um-v-asm-tests) $(rv32um-p-asm-tests) $(rv32uc-v-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rv32ui-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ua-v-asm-tests) $(rv32si-p-asm-tests) $(rv32um-v-asm-tests) $(rv32um-p-asm-tests) $(rv32uc-v-asm-tests) $(rv32ua-p-asm-tests) $(rv32mi-p-asm-tests) $(rv32ui-v-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

regression-tests = \
rv32mi-p-ma_addr \
rv32mi-p-csr \
rv32ui-p-sh \
rv32ui-p-lh \
rv32uc-p-rvc \
rv32mi-p-sbreak \
rv32ui-p-sll
run-regression-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-regression-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-regression-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-regression-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
