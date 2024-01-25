define make-formula
.PHONY: tests/formula/$(1) $(1).rb
tests/formula/$(1): $(1).rb
	brew install shaunplee/asic-dev/$(1)
endef

FORMULAS := $(shell find Formula -type f -name '*.rb' -exec bash -c 'basename $$1 .rb' _ {} \;)

.PHONY: tests/formula
$(foreach f,$(FORMULAS),$(eval $(call make-formula,$(f))))

tests/formula: $(foreach f,$(FORMULAS),tests/formula/$(f))
