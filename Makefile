
# Define default variables
PYTHON := python3
POETRY := poetry

# Run all necessary steps to start the project
start: init submodules install

# Initialize the workspace
init:
	python3 -m venv .venv
	source .venv/bin/activate
	pip install --upgrade pip
	pip install poetry
	poetry config virtualenvs.create false
# Checkout submodules
submodules:
	git submodule update --init --recursive
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
# run docker compose for local development
compose:
	docker compose up
# Docker system cleanup
#- Stopped containers
#- Dangling images
#- Unused volumes
#- Unused networks
#- Build cache
clean:
	docker compose down
	docker compose rm -f
	docker system prune -f
# Run both linting and formatting
check: format lint
