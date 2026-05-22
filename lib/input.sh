# Input handling - Linux port of choice.cmd
# Uses stty for raw input (single keypress with timeout)

CHOICE_INPUT=""

get_input() {
    CHOICE_INPUT=""
    local key=""

    local old_stty
    old_stty=$(stty -g 2>/dev/null || echo "")
    if [[ -z $old_stty ]]; then
        CHOICE_INPUT="TIMEOUT"
        return
    fi

    stty -echo -icanon 2>/dev/null

    IFS= read -r -t 1 -n1 key 2>/dev/null || true

    stty "$old_stty" 2>/dev/null || true

    if [[ -z $key ]]; then
        CHOICE_INPUT="TIMEOUT"
        return
    fi

    case "$key" in
        ' ') CHOICE_INPUT="SPACE" ;;
        $'\t'|$'\x09') CHOICE_INPUT="TAB" ;;
        $'\n') CHOICE_INPUT="ENTER" ;;
        $'\r') CHOICE_INPUT="ENTER" ;;
        ',') CHOICE_INPUT="COMMA" ;;
        '=') CHOICE_INPUT="EQUAL" ;;
        $'\x60') CHOICE_INPUT='`' ;;
        $'\x7e') CHOICE_INPUT='~' ;;
        $'\x0e') CHOICE_INPUT=$'\x0e' ;;
        $'\x02') CHOICE_INPUT=$'\x02' ;;
        $'\x18') CHOICE_INPUT=$'\x18' ;;
        $'\x0f') CHOICE_INPUT=$'\x0f' ;;
        $'\x17') CHOICE_INPUT=$'\x17' ;;
        $'\x11') CHOICE_INPUT=$'\x11' ;;
        *) CHOICE_INPUT="$key" ;;
    esac
}
