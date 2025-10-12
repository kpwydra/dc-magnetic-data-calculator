#!/bin/bash

# UI Settings
MSG_MAX_WIDTH=60
PROG_BAR_SIZE=10
PADDING=2
MAIN_CHAR_RIGHT="="
MAIN_CHAR_LEFT="="
BORDER_LEFT="|"
BORDER_RIGHT="|"
PRINT_CNT=0
ADD_BOTTOM_NEWLINE=1
ADD_TOP_NEWLINE=0
FILL_CHAR="_"

ERR_CHAR="."
INFO_CHAR="="
INFO_COLOR="--green"

# Functions
function log() {
	COUNTER=$(read_counter)
	local ADD_TOP_NEWLINE=${ADD_TOP_NEWLINE}
	local ADD_BOTTOM_NEWLINE=${ADD_BOTTOM_NEWLINE}
	local PRINT_CNT=${PRINT_CNT}
	local MSG=""
	local IS_ERR_MSG=0
	local IS_INFO_MSG=0
	local IS_VERBOSE_MSG=0

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--top-newline) ADD_TOP_NEWLINE=1 ;;
		-bottom-newline) ADD_BOTTOM_NEWLINE=1 ;;
		--counter) PRINT_CNT=1 ;;
		--msg) shift MSG="$1" ;;
		--verbose) IS_VERBOSE_MSG=1 ;;
		--error) IS_ERR_MSG=1 ;;
		--info) export IS_INFO_MSG=1 ;;
		--*) policeman "$1" ;;
		*)
			if [[ -z ${MSG-} ]]; then
				MSG="$1"
			fi
			;;
		esac
		shift
	done
	[[ ${IS_VERBOSE_MSG:-0} -eq 1 && ${VERBOSE:-0} -ne 1 && ${IS_ERR_MSG:-0} -ne 1 ]] && return

	# increment counter
	COUNTER=$(($(read_counter) + 1))
	echo "${COUNTER}" >"${COUNTER_FILE}"

	[[ $ADD_TOP_NEWLINE -eq 1 ]] && printf "\n"
	EMOJIS=$(emoji_count "$MSG")
	# echo "emojis: $EMOJIS"
	bar --align-right --padding-right ${PADDING} --emoji-count ${EMOJIS}
	msg "${MSG}" "${PRINT_CNT}"
	bar --align-left --padding-left ${PADDING}
	[[ $ADD_BOTTOM_NEWLINE -eq 1 ]] && printf "\n"
}

function bar() {
	local ALIGN_LEFT=0
	local ALIGN_RIGHT=0
	local PADDING_LEFT=0
	local PADDING_RIGHT=0
	local EMOJIS=0
	while [[ $# -gt 0 ]]; do
		FLAG="$1"
		case "$FLAG" in
		--align-left)
			ALIGN_LEFT=1
			shift
			;;
		--align-right)
			ALIGN_RIGHT=1
			shift
			;;
		--padding-left)
			PADDING_LEFT=$2
			shift 2
			;;
		--padding-right)
			PADDING_RIGHT=$2
			shift 2
			;;
		--emoji-count)
			EMOJIS=$2
			shift 2
			;;
		--*) policeman "$FLAG" ;;
		esac
	done
	printf "%*s" "${PADDING_LEFT}" ""
	SPACES=$((PROG_BAR_SIZE - COUNTER))
	if [[ ${ALIGN_LEFT} -eq 1 ]]; then
		printf "${BORDER_LEFT}"
		print_fill --char $MAIN_CHAR_LEFT --amount $COUNTER --reversed-rainbow
		print_fill --char $FILL_CHAR --amount $SPACES
		printf "${BORDER_RIGHT}"
		printf "%*s" "${PADDING_RIGHT}" ""

	elif [[ ${ALIGN_RIGHT} -eq 1 ]]; then
		printf "${BORDER_LEFT}"
		print_fill --char $FILL_CHAR --amount $SPACES
		print_fill --char $MAIN_CHAR_RIGHT --amount $COUNTER --rainbow
		printf "${BORDER_RIGHT}"
		printf "%*s" "${PADDING_RIGHT}" ""
	fi
}

function print_fill() {
	local CHAR=""
	local AMOUNT=""
	local RAINBOW=0
	local REVERSED_RAINBOW=0
	local SLEEP=0
	while [[ $# -gt 0 ]]; do
		local FLAG="$1"
		case "$FLAG" in
		--char)
			CHAR=$2
			shift 2
			;;
		--amount)
			AMOUNT=$2
			shift 2
			;;
		--rainbow)
			RAINBOW=1
			shift
			;;
		--reversed-rainbow)
			REVERSED_RAINBOW=1
			shift
			;;
		--sleep)
			SLEEP=$2
			shift 2
			;;
		--*) policeman "$FLAG" ;;
		esac
	done
	if [[ $IS_INFO_MSG -eq 1 ]]; then
		CHAR=$INFO_CHAR
	fi

	[[ $IS_ERR_MSG -eq 1 ]] && CHAR=$ERR_CHAR

	for ((i = 0; i < AMOUNT; i++)); do
		sleep "${SLEEP}"
		if [[ $IS_INFO_MSG -eq 1 ]]; then
			printf "%s" "${CHAR}" | color "$INFO_COLOR"
			continue
		fi

		if [[ $RAINBOW -eq 1 ]]; then
			if ((i < ${#COLORS[@]})); then
				printf "%s" "${CHAR}" | color "${COLORS[$i]}"
			else
				printf "%s" "${CHAR}" | color --random
			fi
		elif [[ $REVERSED_RAINBOW -eq 1 ]]; then
			rev_idx=$((AMOUNT - i - 1))
			if ((rev_idx < ${#COLORS[@]})); then
				printf "%s" "${CHAR}" | color "${COLORS[$rev_idx]}"
			else
				printf "%s" "${CHAR}" | color --cyan
			fi
		else
			printf "%s" "${CHAR}" | color --white
		fi
	done

}

COLORS=("--red" "--orange" "--yellow" "--orange" "--green" "--blue" "--indigo" "--violet" "--cyan")
ALLCOLORS=('\033[0;31m' '\033[0;38;5;214m' '\033[0;33m' '\033[0;32m' '\033[0;34m' '\033[0;38;5;57m' '\033[0;35m' '\033[0;36m' '\033[1;37m' '\033[90m')
function color() {
	local NO_COLOR='\033[0m'
	local ERR_COLOR='\033[0;31m'
	local COLOR="$NO_COLOR"
	local MSG=""

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--red) COLOR='\033[0;31m' ;;
		--orange) COLOR='\033[0;38;5;214m' ;;
		--yellow) COLOR='\033[0;33m' ;;
		--green) COLOR='\033[0;32m' ;;
		--blue) COLOR='\033[0;34m' ;;
		--indigo) COLOR='\033[0;38;5;57m' ;;
		--violet) COLOR='\033[0;35m' ;;
		--cyan) COLOR='\033[0;36m' ;;
		--white) COLOR='\033[1;37m' ;;
		--grey) COLOR='\033[90m' ;;
		--random)
			COLOR=$(rand_color)
			;;
		*) MSG="$1" ;;
		esac
		shift
	done

	[[ $IS_ERR_MSG -eq 1 ]] && COLOR=$ERR_COLOR

	# Handle Piped Input
	if [[ -p /dev/stdin ]]; then
		while IFS= read -r line || [[ -n $line ]]; do
			printf "${COLOR}${line}${NO_COLOR}"
		done
	else
		# Handle Non-Piped Input
		printf "${COLOR}${MSG}${NO_COLOR}"
	fi
}

function rand_color() {
	local n=${#ALLCOLORS[@]}
	local seed=$(((RANDOM + $$ + $(date +%s%N)) % n))
	local i=$((seed % n))
	printf '%s' "${ALLCOLORS[i]}"
}

function render_markup() {
	local s=$1 pre rest tag content color_name colored
	# non-nested: process first <...>...</> repeatedly
	while [[ $s == *'<'*'</>'* ]]; do
		pre=${s%%<*}
		rest=${s#*<}          # rest starts at tag
		tag=${rest%%>*}       # e.g. "red" or "color=red"
		rest=${rest#*>}       # after '>'
		content=${rest%%</>*} # inner text
		rest=${rest#*</>}     # after closing tag

		if [[ $tag == color=* ]]; then
			color_name=${tag#color=}
		else
			color_name=$tag
		fi

		colored="$(color "--$color_name" "$content")"
		s="${pre}${colored}${rest}"
	done
	printf '%s' "$s"
}

function msg() {
	local MSG=$1
	local PRINT_CNT=$2
	local COUNTER_MSG="[${COUNTER}] "
	local COUNTER_MSG_LEN=${#COUNTER_MSG}

	# apply markup -> ANSI (using your color())
	local RENDERED
	RENDERED="$(render_markup "$MSG")"

	# visible width (strip ANSI for padding)
	local VISIBLE
	VISIBLE="$(printf '%s' "$RENDERED" | strip_ansi)"
	local MSG_LEN=${#VISIBLE}

	[[ $PRINT_CNT -eq 1 ]] && printf '%s' "$COUNTER_MSG"
	printf '%b' "$RENDERED"

	# EMOJI_CORRECTION=$((EMOJIS == 0 ? 1 : EMOJIS))
	EMOJI_CORRECTION=$((EMOJIS == 0 ? 1 : 0))
	# echo -e "\ncorrection: $EMOJI_CORRECTION"
	local SPACES=$((MSG_MAX_WIDTH - MSG_LEN - COUNTER_MSG_LEN + EMOJI_CORRECTION))
	((SPACES < 0)) && SPACES=0
	printf '%*s' "$SPACES" ""
}

function policeman() {
	local FLAG="$1"

	echo "🚫 InvalidFlagException:" >&2
	echo "\tIn file: '$0'" >&2
	echo "\tUnrecognized flag: '$FLAG'" >&2
	echo "\tStack trace:" >&2

	# Start at 1 to skip this function itself
	for ((i = 1; i < ${#FUNCNAME[@]}; i++)); do
		local func="${FUNCNAME[$i]}"
		local line="${BASH_LINENO[$((i - 1))]}"
		local src="${BASH_SOURCE[$i]}"
		echo "    at ${func}() in ${src}:${line}" >&2
	done

	exit 1
}

function read_counter() {
	if [[ -f $COUNTER_FILE ]]; then
		read -r VAL <"$COUNTER_FILE"
		echo "$VAL"
	else
		echo "Missing file: '$COUNTER_FILE'" >&2
		echo 0
	fi
}

function strip_ansi() { sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g'; }

function emoji_count() {
	printf '%s' "$1" |
		sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g' |
		{ LC_ALL=C grep -aoE $'([\xE2-\xF7][\x80-\xBF]{2,3})' || true; } |
		wc -l
}
