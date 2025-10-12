#!/bin/bash
SPINNER_CMD="print_fill --char '.' --amount 999 --sleep 0.1 --rainbow"

function run_with_spinner() {
	if [ -t 1 ] && [ -w /dev/tty ]; then
		exec 3>/dev/tty
		eval "$SPINNER_CMD" >&3 &
		PF=$!
	fi

	# Run main command in foreground
	"$@"
	ST=$?

	# Stop spinner cleanly
	if [ -n "${PF-}" ]; then
		kill "$PF" 2>/dev/null || true
		wait "$PF" 2>/dev/null || true
		printf '\r\033[K' >&3
		exec 3>&-
	fi

	return $ST
}

function hint() {
	local code="$1"
	case "$code" in
	"NO_VENV")
		log --error "❌ Virtual environment was not found."
		copy_to_clipboard "make venv"
		log --info "✨ Run: <color=blue>make venv</> to create one."
		;;
	"NO_PYCLEAN")
		log --error "❌ 'pyclean' not found in current environment."
		copy_to_clipboard "make pip"
		log --info "✨ Run: <color=blue>make pip</> (inside your venv)."
		;;
	"GENERIC")
		log --error "⚠️ Unknown error occurred."
		copy_to_clipboard "make install"
		log --info "✨ Try: <color=blue>make install</> or <color=grey>make reset</>."
		;;
	esac
}

copy_to_clipboard() {
	local data="$1" b64
	b64=$(printf %s "$data" | base64 | tr -d '\n')
	if [ -n "$TMUX" ]; then
		printf '\ePtmux;\e\e]52;c;%s\a\e\\' "$b64"
	else
		printf '\e]52;c;%s\a' "$b64"
	fi
	command -v pbcopy >/dev/null && { printf %s "$data" | pbcopy; }
	command -v wl-copy >/dev/null && { printf %s "$data" | wl-copy; }
	command -v xclip >/dev/null && { printf %s "$data" | xclip -selection clipboard; }
	command -v xsel >/dev/null && { printf %s "$data" | xsel --clipboard --input; }
}
