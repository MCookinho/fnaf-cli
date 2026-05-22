# Input handling - Linux port of choice.cmd
# Uses stty for raw input (single keypress)

CHOICE_INPUT=""

get_input() {
    CHOICE_INPUT=""
    local key=""

    if [[ -n $1 ]]; then
        # Timeout mode not yet implemented
        true
    fi

    # Save terminal settings
    local old_stty
    old_stty=$(stty -g 2>/dev/null || echo "")
    if [[ -z $old_stty ]]; then
        CHOICE_INPUT="TIMEOUT"
        return
    fi

    # Set raw mode - read single char without echo
    stty -echo -icanon min 1 time 0 2>/dev/null

    # Read one character
    IFS= read -r -n1 key 2>/dev/null || true

    # Restore terminal
    stty "$old_stty" 2>/dev/null || true

    if [[ -z $key ]]; then
        CHOICE_INPUT="TIMEOUT"
        return
    fi

    # Convert key to known values
    case "$key" in
        ' ') CHOICE_INPUT="SPACE" ;;
        $'\t') CHOICE_INPUT="TAB" ;;
        $'\n') CHOICE_INPUT="ENTER" ;;
        $'\r') CHOICE_INPUT="ENTER" ;;
        ',') CHOICE_INPUT="COMMA" ;;
        '=') CHOICE_INPUT="EQUAL" ;;
        $'\x60') CHOICE_INPUT='`' ;;
        $'\x7e') CHOICE_INPUT='~' ;;
        # CTRL combinations
        $'\x0e') CHOICE_INPUT=$'\x0e' ;;  # CTRL+N
        $'\x02') CHOICE_INPUT=$'\x02' ;;  # CTRL+B
        $'\x18') CHOICE_INPUT=$'\x18' ;;  # CTRL+X
        $'\x0f') CHOICE_INPUT=$'\x0f' ;;  # CTRL+O
        $'\x17') CHOICE_INPUT=$'\x17' ;;  # CTRL+W
        $'\x11') CHOICE_INPUT=$'\x11' ;;  # CTRL+Q
        $'\t') CHOICE_INPUT=$'\t' ;;      # TAB
        *) CHOICE_INPUT="$key" ;;
    esac
}
