# 🧰 Makefile - https://github.com/vampy/Makefile
# Simplifies developer setup, testing, linting, and packaging.

# ------------------------------------------
#    ⚙️ # Makefile Special Variables
# ------------------------------------------
# Makefile Special Variables
SHELL := bash
.ONESHELL:
.PHONY: _init help rainbow install dev test hints lint format typecheck build clean reset dotenv
.SHELLFLAGS: -e

# ------------------------------------------
#    	⚙️ Variables & Folder Tree
# ------------------------------------------
export ROOT_DIR 	:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
export COUNTER_FILE := ${ROOT_DIR}/installer/tmp/msg_count.state
export INIT_FILE 	:= ${ROOT_DIR}/installer/tmp/init.state
TESTS_DIR			:= ${ROOT_DIR}/tests
SRC_DIR 			:= ${ROOT_DIR}/src
SDF_DIR 			:= ${ROOT_DIR}/data/sdf
VENV    			:= .venv
DOTENV 				:= ${ROOT_DIR}/.env
VERBOSE_CHAR 		:= |-----
export VERBOSE 		:= 1

# ------------------------------------------
#   			📝 Scripts
# ------------------------------------------
IMPORT_UTILS		:= . ${ROOT_DIR}/installer/logging.sh; . ${ROOT_DIR}/installer/runtime.sh
ACTIVATE_VENV		:= . $(VENV)/bin/activate && echo $(PYTHON) | grep ".vcenv"
export PYTHON		:= $(shell command -v python3 2>/dev/null || command -v python || command -v py)
export PIP 			:= $(shell command -v pip3 2>/dev/null || command -v pip || command -v py)
PYTHON_SHORT		:= $(shell echo $(PYTHON)	| sed -E 's|.*(\.venv/.*)|\1|')
PIP_SHORT			:= $(shell echo $(PIP) 		| sed -E 's|.*(\.venv/.*)|\1|')
PIP_VERSION 		:= $(shell $(PIP) --version 2>&1)
PYTHON_VERSION 		:= $(shell $(PYTHON) --version 2>&1)

# ------------------------------------------
#    			🎯 Targets
# ------------------------------------------
# 1. 📘 Docs
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

# 2. 🧩 Environment Setup

install: venv pip dotenv hints
# install: dotenv hints

venv: 
	@$(IMPORT_UTILS)
	log "🐍 Creating Python <color=grey>.venv</>"
	run_with_spinner $(PYTHON) -m venv $(VENV)
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

	log "✨ Activating Virtual Environment <color=grey>.venv</>"
	log --verbose "$(VERBOSE_CHAR) pip: <color=grey>$(PIP_SHORT)</>"
	log --info "🐍 python: <color=grey>$(PYTHON_SHORT)</>, version: <color=green>$(PYTHON_VERSION)</>"
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

pip:
	@$(IMPORT_UTILS)
	@$(ACTIVATE_VENV)

	log "🚀 Upgrading pip"
	run_with_spinner pip install --quiet --upgrade pip
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

	log "🧩 Installing pip requirements"
	run_with_spinner pip install --quiet -r requirements.txt -r requirements-dev.txt
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

dotenv:
	@$(IMPORT_UTILS)
	log "📝 Creating <color=grey>.env</> file"
	echo "PYTHONPATH=${ROOT_DIR}:${SRC_DIR}:${TESTS_DIR}" > ${DOTENV}
	echo "ROOT_DIR=${ROOT_DIR}" >> ${DOTENV}
	echo "SRC_DIR=${SRC_DIR}" >> ${DOTENV}
	echo "TESTS_DIR=${TESTS_DIR}" >> ${DOTENV}
	echo "SDF_DIR=${SDF_DIR}" >> ${DOTENV}
	[[ -f "${DOTENV}" ]] && log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>" || log --error "❌ <color=grey>.env</> missing!"


# 3. Workflow
reset:
	@if echo " $(MAKECMDGOALS) " | grep -q -- '--yes'; then yn=y; else read -p "Proceed with removal? [y/N] " yn; fi; \
	if [[ $$yn =~ ^[Yy] ]]; then
		echo "ok."
		@$(MAKE) remove-venv
		@$(MAKE) clear-cache
	else
		echo "Reset skipped."
	fi

remove-venv:
	@$(IMPORT_UTILS)
	rm -rf $(VENV)

clear-cache:
	@$(IMPORT_UTILS)
	@$(ACTIVATE_VENV)
	if [ ! -f "$(VENV)/bin/activate" ]; then
		hint NO_VENV
		exit 1
	fi

	log "🧹 Clearing Python caches"
	if ! command -v pyclean >/dev/null 2>&1; then
		hint NO_PYCLEAN
		exit 1
	fi

	pyclean --quiet $${ROOT_DIR}
	log --verbose "✅ <color=green>Python caches cleared</>"


# ------------------------------------------
#   💡 Helpers
# ------------------------------------------
hints:
	@$(IMPORT_UTILS)
	log --warning "✨ Please restart terminal to apply changes"
	log "$(VERBOSE_CHAR) <color=yellow>VS Code</>: <color=grey>Ctrl + Shift + P -> 'Reload Window'</>"
	log "$(VERBOSE_CHAR) <color=yellow>PyCharm</>: <color=grey>File -> Invalidate Caches -> Restart</>"
	log ""
	log "$(VERBOSE_CHAR) Then run: <color=green>make dev</>, or press Ctrl + V to paste"

# ------------------------------------------
#   ⚙️ Entrypoint - executes once at start
# ------------------------------------------
ifeq (0,$(MAKELEVEL))
ifneq ($(MAKECMDGOALS),_init)
$(shell $(MAKE) --no-print-directory _init >/dev/null)
endif
endif
_init:
	@[[ -f ${COUNTER_FILE} ]] || mkdir -p "$(dirname -- "${COUNTER_FILE}")"
	@echo "0" >"${COUNTER_FILE}"
# ---------- macro ----------
define WITH_SPINNER
${IMPORT_UTILS}
run_with_spinner
endef
