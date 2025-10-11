# ⚙️ INSTALL.md  
### Developer & Contributor Installation Guide for `mag-bridge`

This document describes how to set up, build, and maintain a local development environment for `mag-bridge`.  
It covers **installation methods, Makefile commands, troubleshooting**, and known platform-specific notes.

> [!WARNING] Install make 
# add some options to install make on linux mac and win, with inline coments


## 🧭 Overview

The project uses a `Makefile` to simplify all developer workflows — environment creation, dependency installation, testing, linting, and packaging.  
You can install everything with **one command**:

```bash
make dev
```
## 🧩 Makefile Commands
> Each command below can be executed directly, for example:
```bash
make test
```

| Command | Purpose | Description |
|----------|----------|-------------|
| `make install` | 🧱 Environment setup | Creates `.venv` and installs runtime dependencies only (for running the package). |
| `make dev` | 🧰 Developer setup | Runs `make install`, then adds developer tools (`pytest`, `ruff`, `mypy`, `build`). Ideal for contributors. |
| `make test` | 🧪 Run tests | Executes `pytest` with colorized one-line output for passing tests and full stack traces for failures. |
| `make lint` | 🔍 Linting | Runs Ruff in lint mode across all source files. |
| `make format` | 🧹 Formatting | Reformats the entire `src/` tree using Ruff’s built-in formatter (consistent style, 4-space indentation, single quotes). |
| `make typecheck` | 🔎 Type checking | Validates typing annotations with `mypy`. |
| `make build` | 📦 Build package | Builds a wheel (`.whl`) and source distribution (`.tar.gz`) into the `dist/` folder. |
| `make clean` | 🧽 Clean | Removes build artifacts (`dist/`, `build/`, and `*.egg-info`). |
| `make reset` | ♻️ Full reset | Deletes the virtual environment and rebuilds it using `make dev`. |


[!WARNING]  
### 🧩 Install `make` 
The `make` command is not installed by default on some systems.  
Install it using one of the following methods depending on your OS:
#### **Linux (Debian/Ubuntu):**
```bash
apt update -y
apt install make -y
```
#### **Windows:**
```
winget install GNU.Make
```
💡 *reload your terminal (close and reopen, or run `exec $SHELL`)*
```bash
make --version
```
You should see a version string like `GNU Make 3.81` confirming it’s installed.
