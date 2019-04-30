SHELL := /bin/bash
.DEFAULT_GOAL := build

# For local non-IntelliJ deploys
.PHONY: build
build: clean install

.PHONY: clean
clean:
	go clean -i ./git-account

.PHONY: install
install:
	go install ./git-account