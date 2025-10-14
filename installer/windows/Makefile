# ============================================================
# Makefile.windows — Professional PowerShell EXE Builder
# ============================================================
# Multiline PowerShell recipes use comment blocks (<# \n #>)
# instead of '\' for safe continuation across shells.
# ------------------------------------------------------------

SHELL := powershell.exe
.SHELLFLAGS := -NoLogo -NoProfile -ExecutionPolicy Bypass -Command

# ------------------------------------------------------------
# Configurable Variables
# ------------------------------------------------------------
BUILD_WRAPPER  		:= build_wrapper.ps1
SCRIPTS_DIR			:= scripts
INSTALL_SRC    		:= $(SCRIPTS_DIR)/install.ps1
UNINSTALL_SRC  		:= $(SCRIPTS_DIR)/uninstall.ps1
BUILD_DIR      		:= build
INSTALL_EXE    		:= $(BUILD_DIR)/Install.exe
UNINSTALL_EXE  		:= $(BUILD_DIR)/Uninstall.exe
TITLE          		:= MagBridge Dependencies Installer

# ------------------------------------------------------------
# Targets
# ------------------------------------------------------------
.PHONY: all installer uninstaller clean
all: installer uninstaller

# Build Installer Executable
# ------------------------------------------------------------
installer:
	@$(SHELL) -ExecutionPolicy Bypass -File "$(BUILD_WRAPPER)" -OutDir "$(BUILD_DIR)" -Source "$(INSTALL_SRC)" -Output "$(INSTALL_EXE)" -Title "$(TITLE)"

# ------------------------------------------------------------
# Build Uninstaller Executable
# ------------------------------------------------------------
uninstaller:
	@$(SHELL) -ExecutionPolicy Bypass -File "$(BUILD_WRAPPER)" -OutDir "$(BUILD_DIR)" -Source "$(UNINSTALL_SRC)" -Output "$(UNINSTALL_EXE)" -Title "$(TITLE)"

# ------------------------------------------------------------
# Clean Build Artifacts
# ------------------------------------------------------------
clean:
	@$(SHELL) -NoProfile -ExecutionPolicy Bypass -Command "if (Test-Path \"$(OUT_DIR)\") { Remove-Item -Recurse -Force \"$(OUT_DIR)\"; Write-Host \"Cleaned $(OUT_DIR)\" } else { Write-Host \"Nothing to clean.\" }"
