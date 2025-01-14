.PHONY: help install clean update-deps setup-uv

GIT_ROOT ?= $(shell git rev-parse --show-toplevel)
PYTHON_VERSION ?= 3.11

help:	## Show all Makefile targets.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[33m%-30s\033[0m %s\n", $$1, $$2}'

install:	## Install the package and dependencies.
	uv venv
	uv pip install -e .

clean:	## Clean up build artifacts.
	find . -name '__pycache__' -exec rm -rf {} +
	find . -name '*.pyc' -exec rm -rf {} +
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf .ruff_cache
	rm -rf dist
	rm -rf build
	rm -rf .venv

update-deps:	## Update dependencies.
	uv pip compile pyproject.toml -o requirements.txt
	uv pip sync requirements.txt
	uv run pre-commit autoupdate

setup-uv:	## Setup uv with the specified version
	curl -LsSf https://astral.sh/uv/install.sh | sh -s
