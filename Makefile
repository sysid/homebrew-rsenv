#
# GOTCHA: changes must be pushed before being effective
#
.DEFAULT_GOAL := help

VERSION = $(shell grep 'url "' rsenv.rb | sed -E 's/.*\/v([0-9.]+)\.tar\.gz.*/\1/')

.PHONY: create-sha
create-sha:  ## Generate SHA256 for release tarball (update URL first)
	@echo "Current version in formula: $(VERSION)"
	curl -sL https://github.com/sysid/rs-env/archive/refs/tags/v$(VERSION).tar.gz | shasum -a 256

.PHONY: init-local
init-local:  ## Set up local tap for testing
	brew untap homebrew/core 2>/dev/null || true
	brew untap sysid/rsenv 2>/dev/null || true
	brew tap sysid/rsenv
	brew info rsenv

.PHONY: init-core
init-core:  ## Switch back to homebrew-core
	brew developer off
	brew untap sysid/rsenv 2>/dev/null || true
	brew tap --force homebrew/core

.PHONY: test
test:  ## Run brew test
	brew test rsenv

.PHONY: install
install:  ## Install rsenv via brew
	brew install rsenv

.PHONY: uninstall
uninstall:  ## Uninstall rsenv via brew
	brew uninstall rsenv

.PHONY: reinstall
reinstall:  ## Reinstall rsenv via brew
	brew reinstall rsenv

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
