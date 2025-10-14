# ============================================================
# Makefile.windows — Windows EXE Builder
# ============================================================

SHELL 			:= cmd.exe
.SHELLFLAGS 	:= /C

# .SHELLFLAGS 	:= -NoLogo -NoProfile -ExecutionPolicy Bypass -Command

# ------------------------------------------------------------
# Configurable Variables
# ------------------------------------------------------------
ROOT_DIR      	:= $(abspath .)
BUILD_DIR     	:= $(ROOT_DIR)/build
SCRIPTS_DIR   	:= $(ROOT_DIR)/scripts
UTILS_DIR     	:= $(SCRIPTS_DIR)/utils
BUILD_WRAPPER 	:= $(SCRIPTS_DIR)/build_wrapper.ps1

INSTALL_SRC   	:= $(SCRIPTS_DIR)/install.ps1
UNINSTALL_SRC 	:= $(SCRIPTS_DIR)/uninstall.ps1

INSTALL_EXE   	:= $(BUILD_DIR)/Install.exe
UNINSTALL_EXE 	:= $(BUILD_DIR)/Uninstall.exe

TITLE          	:= MagBridge Dependencies Installer

# ------------------------------------------------------------
# Targets
# ------------------------------------------------------------
.PHONY: all install build-install uninstall build-uninstall clean

build-install:
	@powershell -ExecutionPolicy Bypass -File "$(BUILD_WRAPPER)" -OutDir "$(BUILD_DIR)" -InstallSript "$(INSTALL_SRC)" -Output "$(INSTALL_EXE)" -Title "$(TITLE)"

install:
	@powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "$(INSTALL_SRC)"

build-uninstall:
	@powershell -ExecutionPolicy Bypass -File "$(BUILD_WRAPPER)" -OutDir "$(BUILD_DIR)" -InstallSript "$(UNINSTALL_SRC)" -Output "$(UNINSTALL_EXE)" -Title "$(TITLE)"

clean:
	@powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Test-Path \"$(OUT_DIR)\") { Remove-Item -Recurse -Force \"$(OUT_DIR)\"; Write-Host \"Cleaned $(OUT_DIR)\" } else { Write-Host \"Nothing to clean.\" }"
