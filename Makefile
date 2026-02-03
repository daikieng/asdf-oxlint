fmt:
	@scripts/format-write.bash
.PHONY: fmt

fmt-check:
	@scripts/format.bash
.PHONY: fmt-check

lint:
	@scripts/lint.bash
.PHONY: lint

test:
	bats test
.PHONY: test
