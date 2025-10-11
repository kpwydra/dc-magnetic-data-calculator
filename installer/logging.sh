#!/bin/bash

# UI Settings
MSG_MAX_WIDTH=41
PROG_BAR_SIZE=6
PADDING=2
MAIN_CHAR_RIGHT="="
MAIN_CHAR_LEFT="="
FILL_CHAR="_"
ERROR_CHAR="#"
BORDER_LEFT="|"
BORDER_RIGHT="|"
PRINT_CNT=0
ADD_BOTTOM_NEWLINE=1
ADD_TOP_NEWLINE=0

# Functions
function log() {
	COUNTER=$(read_counter)
	local ADD_TOP_NEWLINE=${ADD_TOP_NEWLINE}
	local ADD_BOTTOM_NEWLINE=${ADD_BOTTOM_NEWLINE}
	local PRINT_CNT=${PRINT_CNT}
	local MSG=""
	local IS_ERROR=""
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--top-newline)
			ADD_TOP_NEWLINE=1
			;;
		--bottom-newline)
			ADD_BOTTOM_NEWLINE=1
			;;
		--counter)
			PRINT_CNT=1
			;;
		--msg)
			shift
			MSG="$1"
			;;
		--error)
			IS_ERROR=1
			;;
		--*)
			raise_invalid_flag_exception "$1"
			;;
		*)
			if [[ -z ${MSG-} ]]; then
				MSG="$1"
			fi
			;;
		esac
		shift
	done

	# increment counter
	COUNTER=$(($(read_counter) + 1))
	echo "$COUNTER" >"$COUNTER_FILE"

	[[ $ADD_TOP_NEWLINE -eq 1 ]] && printf "\n"
	progress_bar --align-right --padding-right ${PADDING}
	msg "${MSG}" "${PRINT_CNT}"
	progress_bar --align-left --padding-left ${PADDING}
	[[ $ADD_BOTTOM_NEWLINE -eq 1 ]] && printf "\n"
}

function progress_bar() {
	local ALIGN_LEFT=0
	local ALIGN_RIGHT=0
	local PADDING_LEFT=0
	local PADDING_RIGHT=0
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
		--*) raise_invalid_flag_exception "$FLAG" ;;
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
		--*) raise_invalid_flag_exception "$FLAG" ;;
		esac
	done

	[[ $IS_ERROR -eq 1 ]] && CHAR=$ERROR_CHAR

	for ((i = 0; i < AMOUNT; i++)); do
		if [[ $RAINBOW -eq 1 ]]; then
			if ((i < ${#COLORS[@]})); then
				printf "${CHAR}" | color ${COLORS[$i]}
			else
				printf "${CHAR}" | color --cyan
			fi
		elif [[ $REVERSED_RAINBOW -eq 1 ]]; then
			reversed_index=$((AMOUNT - i - 1))
			if ((reversed_index < ${#COLORS[@]})); then
				printf "${CHAR}" | color ${COLORS[$reversed_index]}
			else
				printf "${CHAR}" | color --cyan
			fi
		else
			printf "${CHAR}" | color --white
		fi
	done
}

function msg() {
	local MSG=$1
	local PRINT_CNT=$2
	local COUNTER_MSG="[${COUNTER}] "
	local COUNTER_MSG_LEN=${#COUNTER_MSG}
	local MSG_LEN=${#MSG}
	[[ $PRINT_CNT -eq 1 ]] && printf "${COUNTER_MSG}"
	printf "${MSG}"
	SPACES=$((MSG_MAX_WIDTH - MSG_LEN - COUNTER_MSG_LEN))
	printf "%*s" "$((SPACES))" ""
}

COLORS=("--red" "--orange" "--yellow" "--orange" "--green" "--blue" "--indigo" "--violet" "--cyan")
function color() {
	local NO_COLOR='\033[0m'
	local ERROR_COLOR='\033[0;31m'
	local COLOR="$NO_COLOR"

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
		*) COLOR="$NO_COLOR" ;;
		esac
		shift
	done

	[[ $IS_ERROR -eq 1 ]] && COLOR=$ERROR_COLOR

	# Handle Piped Input
	if [[ -p /dev/stdin ]]; then
		while IFS= read -r line || [[ -n $line ]]; do
			printf "${COLOR}${line}${NO_COLOR}"
		done
	else
		# Handle Non-Piped Input
		printf "${COLOR}${1}${NO_COLOR}"
	fi
}

function raise_invalid_flag_exception() {
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
		echo "    at $func() in $src:$line" >&2
	done

	exit 997
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
