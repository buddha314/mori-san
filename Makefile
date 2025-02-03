
# Define default variables
PYTHON := python3
POETRY := poetry

# Initialize the workspace
init:
	python3 -m venv .venv
	source .venv/bin/activate
	pip install --upgrade pip
	pip install poetry
	poetry config virtualenvs.create false
# Checkout submodules
submodules:
	git submodule update --remote --merge --recursive
# Install dependencies
install:
	$(POETRY) install --no-interaction --no-ansi --no-root
# Run formatting
format:
	$(POETRY) run black app/
# Run linting
lint:
	$(POETRY) run flake8 app/
# run docker build for local development
build:
	docker build -t app:latest .
# Docker system cleanup
#- Stopped containers
#- Dangling images
#- Unused volumes
#- Unused networks
#- Build cache
clean:
	docker system prune -f
# Run both linting and formatting
check: format lint
