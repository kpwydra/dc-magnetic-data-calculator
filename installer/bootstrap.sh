#!/bin/bash
load_menu() {
	. "${ROOT_DIR}/installer/logging.sh"
}

# Run 'once' before each phony target
# test linter install: once
# once:
# 	@trap 'rm -f $(INIT_FILE)' EXIT
# 	@. $(ROOT_DIR)/installer/bootstrap.sh
# 	load_menu
