# 🧰 Makefile - https://github.com/vampy/Makefile
# Simplifies developer setup, testing, linting, and packaging.

# Makefile Special Variables
SHELL := /bin/bash
.ONESHELL:
# .SECONDEXPANSION:
.PHONY: _init help install dev test lint format typecheck build clean reset dotenv

# Structure Tree
export ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
export COUNTER_FILE := ${ROOT_DIR}/installer/tmp/msg_count.state
export INIT_FILE := ${ROOT_DIR}/installer/tmp/init.state
TESTS_DIR	:= ${ROOT_DIR}/tests
SRC_DIR 	:= ${ROOT_DIR}/src
SDF_DIR 	:= ${ROOT_DIR}/data/sdf
VENV    	:= .venv
DOTENV 		:= ${ROOT_DIR}/.env

# Scripts
USE_LOG := . ${ROOT_DIR}/installer/logging.sh
USE_VENV	:= . $(VENV)/bin/activate

# Variables
PYTHON	:= $(shell command -v python3 2>/dev/null || command -v python || command -v py)

# 🎯 Targets
# 📘 Help Info, API
help:
	@echo ""
	@echo "Mag-Bridge Development Commands:"
	@echo "--------------------------------"
	@echo "make install      – Create venv, install requirements"
	@echo "make dev          – Install dev tools (pytest, ruff, mypy)"
	@echo "make test         – Run pytest with full traceback and color"
	@echo "make lint         – Run Ruff linter"
	@echo "make format       – Format code using Ruff"
	@echo "make typecheck    – Run mypy type checks"
	@echo "make build        – Build package wheel and sdist"
	@echo "make clean        – Remove build artifacts"
	@echo "make reset        – Delete venv and rebuild everything"
	@echo ""

# 🧩 Environment Setup
install: venv pip dotenv
	@$(USE_LOG)
	log "✅ Developer setup complete."
	printf "Using Python: "; printf "$(PYTHON)" | color --grey

venv: 
	@$(USE_LOG)
	log "🐍 Creating Python .venv"
	@$(PYTHON) -m venv $(VENV)

pip: 
	@$(USE_LOG)
	log "🚀 Upgrading pip"
	@$(USE_VENV); pip install --quiet --upgrade pip
	log "🧩 Installing pip requirements"
	@$(USE_VENV); pip install --quiet -r requirements.txt -r requirements-dev.txt

dotenv:
	@$(USE_LOG)
	log "📝 Creating $(color --grey '.env') file"
	echo "PYTHONPATH=${ROOT_DIR}:${SRC_DIR}:${TESTS_DIR}" > ${DOTENV}
	echo "ROOT_DIR=${ROOT_DIR}" >> ${DOTENV}
	echo "SRC_DIR=${SRC_DIR}" >> ${DOTENV}
	echo "TESTS_DIR=${TESTS_DIR}" >> ${DOTENV}
	echo "SDF_DIR=${SDF_DIR}" >> ${DOTENV}
	[[ -f ${DOTENV} ]] && log "📝 .env file created." || log "❌ .env missing!"


# 🚀 Entrypoint - executes only once at first target
ifeq (0,$(MAKELEVEL))
ifneq ($(MAKECMDGOALS),_init)
$(info $(shell $(MAKE) --no-print-directory _init))
endif
endif

_init:
#	reset counter for proper logging display
	@[[ -f ${COUNTER_FILE} ]] || mkdir -p "$(dirname -- "${COUNTER_FILE}")"
	@echo "0" >"${COUNTER_FILE}"
	
# 	debug
	@CNT=$$(cat ${COUNTER_FILE}); \
	if [[ $$CNT == "0" ]]; then \
		echo "✅ Counter file: 0"; \
	else \
		echo "Counter file: $${CNT}"; \
	fi
