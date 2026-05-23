# FullStack1 Duoc 2026
# Project orchestrator Makefile v0.1

REPO_URLS := \
	https://github.com/polirritmico/auth-api \
	https://github.com/lironscallealta/users-api \
	https://github.com/polirritmico/sales-api \
	https://github.com/Fervivi/invoice-api \
	https://github.com/lironscallealta/accounting-manager-api \
	https://github.com/polirritmico/carts-api \
	https://github.com/Fervivi/product-api \
	https://github.com/Fervivi/store-manager-api \
	https://github.com/lironscallealta/pets-api \
	https://github.com/polirritmico/appointments-api \
	https://github.com/lironscallealta/vets-api \
	https://github.com/polirritmico/vet-manager-api

SERVICES := $(notdir $(REPO_URLS))

FULLSTACK_DB_DIR := mysql-init
FULLSTACK_DB_FILE := $(FULLSTACK_DB_DIR)/init.sql

.PHONY: help setup build up start stop run clean clone-all db-init

help:
	@echo "Available targets:"
	@echo "  help      : Show this list"
	@echo "  setup     : Prepares the workspace (clones repos and builds init.sql)"
	@echo "  build     : Compiles docker images for all services (runs setup automatically)"
	@echo "  up        : Runs the containers in the foreground"
	@echo "  start     : Runs the containers detached in the background"
	@echo "  stop      : Stops active containers without wiping data"
	@echo "  run       : One-shot command to clone, generate scripts, build, and run in foreground"
	@echo "  clean     : Teardown. Stops containers, wipes volumes, repos, and scripts"

setup: clone-all db-init

build: setup
	docker compose build

up:
	docker compose up

start:
	docker compose up -d

stop:
	docker compose down

run: setup
	docker compose up --build

clone-all:
	@for url in $(REPO_URLS); do \
		dir=$$(basename $$url); \
		if [ ! -d "$$dir" ]; then \
			git clone $$url $$dir; \
		fi; \
		if [ -f "$$dir/.env.example" ] && [ ! -f "$$dir/.env" ]; then \
			cp "$$dir/.env.example" "$$dir/.env"; \
		fi; \
	done

db-init:
	@mkdir -p $(FULLSTACK_DB_DIR)
	@echo "CREATE DATABASE IF NOT EXISTS auth;" > $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS users;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS sales;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS invoice;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS accounting_manager;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS carts;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS products;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS store_manager;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS pets;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS appointments;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS vets;" >> $(FULLSTACK_DB_FILE)
	@echo "CREATE DATABASE IF NOT EXISTS vet_manager;" >> $(FULLSTACK_DB_FILE)

clean:
	docker compose down -v
	rm -rf $(SERVICES) $(FULLSTACK_DB_DIR)
