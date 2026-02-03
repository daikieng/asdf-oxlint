#!/usr/bin/env bash

cd "$(dirname "$0")/.." || exit 1

shellcheck --shell=bash --external-sources --severity=warning \
	bin/* lib/* scripts/*
