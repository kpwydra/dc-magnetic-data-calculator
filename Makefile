# 🧰 Makefile - https://github.com/vampy/Makefile
# Simplifies developer setup, testing, linting, and packaging.

# ------------------------------------------
#    ⚙️ # Makefile Special Variables
# ------------------------------------------
# Makefile Special Variables
SHELL := $(shell echo $$SHELL)
.ONESHELL:
ALL_TARGETS := _init help install test venv hints build clean reset dotenv remove-venv clear-cache activate check-venv
.PHONY: $(PHONY_TARGETS)
MAKEFLAGS += --no-print-directory --silent
# .SHELLFLAGS := -e -o pipefail -c

# ------------------------------------------
#    	⚙️ Variables & Folder Tree
# ------------------------------------------
export ROOT_DIR 	:= $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
export TMP_DIR		:= ${ROOT_DIR}/installer/tmp
export COUNTER_FILE := ${TMP_DIR}/msg_count.state
export MENU_FILE	:= ${TMP_DIR}/menu_params.state
export INIT_FILE 	:= ${TMP_DIR}/init.state
TESTS_DIR			:= ${ROOT_DIR}/tests
SRC_DIR 			:= ${ROOT_DIR}/src
SDF_DIR 			:= ${ROOT_DIR}/data/sdf
VENV    			:= .venv
DOTENV 				:= ${ROOT_DIR}/.env
export VERBOSE_CHAR := |-----
export VERBOSE 		:= 1

# ------------------------------------------
#   			📝 Scripts
# ------------------------------------------
IMPORT_UTILS		:= . ${ROOT_DIR}/installer/utils.sh; . ${ROOT_DIR}/installer/runtime.sh
ACTIVATE_VENV		:= . $(VENV)/bin/activate 2> /dev/null
PYTHON				:= $(shell command -v python3 2>/dev/null || command -v python || command -v py)
PIP 				:= $(shell command -v pip3 2>/dev/null || command -v pip || command -v py)
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
install: venv pip dotenv
	$(MAKE) --no-print-directory activate

# 3. 🧩 pip
pip:
	@$(IMPORT_UTILS)
	@$(ACTIVATE_VENV)

	log "🚀 Upgrading pip"
	run_with_spinner pip install --quiet --upgrade pip
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

	log "🧩 Installing pip requirements"
	run_with_spinner pip install --quiet -r requirements.txt -r requirements-dev.txt
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

# 4. 🧩 venv
venv:
	@$(IMPORT_UTILS)
	log "🐍 Creating Python <color=grey>.venv</>"
	run_with_spinner $(PYTHON) -m venv $(VENV)
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"
	$(MAKE) check-venv
	@if [ "$(MAIN_GOAL)" = "venv" ]; then \
		$(MAKE) activate; \
	fi

activate:
	@$(IMPORT_UTILS)
	log --info "✨ Activating Virtual Environment <color=grey>.venv</>"
	@exec env -u MAKELEVEL $(SHELL) -l
# 	log "✨ Environment <color=forest>ready to go!</>"

# 	@exec env -u MAKELEVEL $(SHELL) -l -c 'stty sane; exec $(SHELL) -l'

check-venv:
	@$(SHELL) -ic '\
		$(IMPORT_UTILS); \
		PYTHON=$$(command -v python3 2>/dev/null || command -v python || command -v py); \
		PIP=$$(command -v pip3 2>/dev/null || command -v pip || command -v py); \
		PYTHON_SHORT=$$(echo $$PYTHON | sed -E "s|.*(\.venv/.*)|\1|"); \
		PIP_SHORT=$$(echo $$PIP | sed -E "s|.*(\.venv/.*)|\1|"); \
		PIP_VERSION=$$($$PIP --version 2>&1); \
		PYTHON_VERSION=$$($$PYTHON --version 2>&1); \
		log --verbose "$(VERBOSE_CHAR) pip:    <color=grey>$${PIP_SHORT}</>"; \
		log --verbose --info "$(VERBOSE_CHAR) python: <color=grey>$${PYTHON_SHORT}</>, version: <color=green>$${PYTHON_VERSION}</>"; \
		log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"'

# 5. 🧩 .env
dotenv:
	@$(IMPORT_UTILS)
	log "📝 Creating <color=grey>.env</> file"
	echo "PYTHONPATH=${ROOT_DIR}:${SRC_DIR}:${TESTS_DIR}" > ${DOTENV}
	echo "ROOT_DIR=${ROOT_DIR}" >> ${DOTENV}
	echo "SRC_DIR=${SRC_DIR}" >> ${DOTENV}
	echo "TESTS_DIR=${TESTS_DIR}" >> ${DOTENV}
	echo "SDF_DIR=${SDF_DIR}" >> ${DOTENV}
	[[ -f "${DOTENV}" ]] && log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>" || log --error "❌ <color=grey>.env</> missing!"

# 6. Cleanup
reset:
	@$(IMPORT_UTILS)
	log "♻️  Reset Workspace? This <color=cyan>WILL NOT</> affect your code."

	@if echo " $(MAKECMDGOALS) " | grep -q -- '--yes'; then \
		yn=y; \
	else \
		log --warn --no-bottom-newline "⚙️  Proceed? [y/N]"; \
		read -p " : " yn; \
	fi

	@if [[ $$yn =~ ^[Yy] ]]; then \
		set -e; \
		$(MAKE) remove-venv 2> /dev/null; \
		set +e; \
		log --info "✅ <color=grey>Reset complete</>"; \
	else \
		log --info "Reset skipped by user"; \
	fi
	$(MAKE) install

remove-venv:
	@$(IMPORT_UTILS)
	log "🧹 Removing <color=grey>.venv</>"
	@rm -fr $(VENV)
	log --verbose "$(VERBOSE_CHAR) <color=forest>OK</>"

clear-cache:
	@$(IMPORT_UTILS)
	@$(ACTIVATE_VENV)
	@if [ ! -f "$(VENV)/bin/activate" ]; then
		hint NO_VENV
		exit 1
	fi

	log "🧹 Clearing Python caches"
	@if ! command -v pyclean >/dev/null 2>&1; then
		hint NO_PYCLEAN
		exit 1
	fi

	@pyclean --quiet $${ROOT_DIR}
	log --verbose "$$VERBOSE_CHAR <color=forest>OK</>"

# ------------------------------------------
#   💡 Helpers
# ------------------------------------------
hints:
	@$(IMPORT_UTILS)
	log --warning "♻️  <color=cinnamon>Please reload editor to apply new environment</>, hints:"
	log --info "$(VERBOSE_CHAR) <color=olive>VS Code</>: <color=grey>Ctrl + Shift + P -> 'Reload Window'</>"
	log --info "$(VERBOSE_CHAR) <color=olive>PyCharm</>: <color=grey>File -> Invalidate Caches -> Restart</>"
	log --info ""
# 	copy_to_clipboard "make dev"
	log --info "✨ Then run: <color=green>make dev</> (copied to clipboard)"

# ------------------------------------------
#   ⚙️ Entrypoint - executes once at start
# 	|-- Initializes make runtime workspace
# ------------------------------------------
ifeq ($(MAKELEVEL),0)
export MAIN_GOAL := $(firstword $(MAKECMDGOALS))

ifneq ($(MAKECMDGOALS),_init)
# # debug
# $(info [init] running setup for $(MAIN_GOAL))
# $(info MAKELEVEL=$(MAKELEVEL))
# $(info MAKECMDGOALS=$(MAKECMDGOALS))
# $(info SHELL=$(SHELL))
# $(info $(shell $(MAKE) _init))
$(shell $(MAKE) _init >/dev/null)
endif

endif

_init:
	@[[ -n "$(TMP_DIR)" ]] && mkdir -p "$(TMP_DIR)"
	@echo "0" >"$(COUNTER_FILE)"
	@cat $(COUNTER_FILE)

#	debug
	$(eval $(call set_menu_params,$(MAIN_GOAL)))
# 	$(call set_menu_params,$(MAIN_GOAL))
	@{ \
		echo "BARSIZE=$(BARSIZE)"; \
		echo "MSG_SPACE=$(MSG_SPACE)"; \
	} >"$(MENU_FILE)"

# ---------- macro ----------
export DEFAULT_BARSIZE 		:= 20
export DEFAULT_MSG_SPACE 	:= 69

# $(info $(ALL_TARGETS))
define set_menu_params
$(eval GOAL := $(strip $(1)))

$(if $(filter install,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 17) $(eval MSG_SPACE := 78), \
		$(eval BARSIZE := 10) $(eval MSG_SPACE := 69)))

$(if $(filter venv,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 11) $(eval MSG_SPACE := 66), \
		$(eval BARSIZE := 2) $(eval MSG_SPACE := 26)))

$(if $(filter pip,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 4) $(eval MSG_SPACE := 44), \
		$(eval BARSIZE := 2) $(eval MSG_SPACE := 44)))

$(if $(filter dotenv,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 2) $(eval MSG_SPACE := 35), \
		$(eval BARSIZE := 1) $(eval MSG_SPACE := 35)))

$(if $(filter dotenv,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 2) $(eval MSG_SPACE := 26), \
		$(eval BARSIZE := 1) $(eval MSG_SPACE := 26)))

$(if $(filter reset,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 22) $(eval MSG_SPACE := 78), \
		$(eval BARSIZE := 14) $(eval MSG_SPACE := 69)))

$(if $(filter remove-venv,$(GOAL)), \
	$(if $(filter 1,$(VERBOSE)), \
		$(eval BARSIZE := 2) $(eval MSG_SPACE := 23), \
		$(eval BARSIZE := 1) $(eval MSG_SPACE := 23)))

$(if $(filter-out $(ALL_TARGETS),$(GOAL)), \
	$(eval BARSIZE := $(DEFAULT_BARSIZE)) \
	$(eval MSG_SPACE := $(DEFAULT_MSG_SPACE)))
endef

define WITH_SPINNER
${IMPORT_UTILS}
run_with_spinner
endef
