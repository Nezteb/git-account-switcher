SHELL := /bin/bash
.DEFAULT_GOAL := build

# For local non-IntelliJ deploys
.PHONY: build
build: clean install

.PHONY: clean
clean:
	go clean -i

.PHONY: install
install:
	go build -o git-account
	go install