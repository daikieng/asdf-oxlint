#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit 1

shfmt --language-dialect bash --diff \
	bin/* lib/* scripts/*
