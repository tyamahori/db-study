SHELL=/bin/bash
.DEFAULT_GOAL := help

USER_NAME := $(shell whoami)
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
PROJECT_NAME := tyamahori

COMPOSE_BASE_COMMAND := \
  COMPOSE_PROJECT_NAME=$(PROJECT_NAME) \
  USER_ID=$(USER_ID) \
  GROUP_ID=$(GROUP_ID) \
  USER_NAME=$(USER_NAME) \
  docker compose -f ./.docker/compose.yaml

.PHONY:
help: # @see https://postd.cc/auto-documented-makefile/
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: reset
reset: ## docker compose down -v --rmi all --remove-orphans
	$(COMPOSE_BASE_COMMAND) down -v --rmi all --remove-orphans

.PHONY: init
init: reset up ## set up

.PHONY: down
down: ## docker compose down
	$(COMPOSE_BASE_COMMAND) down

.PHONY: up
up: down ## docker compose up
	$(COMPOSE_BASE_COMMAND) up -d

.PHONY: logs
logs: ## docker compose logs
	$(COMPOSE_BASE_COMMAND) logs -f

.PHONY: clean
clean: ## docker compose down -v
	$(COMPOSE_BASE_COMMAND) down -v

.PHONY: ps
ps: ## docker compose ps -a
	$(COMPOSE_BASE_COMMAND) ps -a
