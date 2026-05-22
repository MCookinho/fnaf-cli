# Audio Management - Linux port of audiomanager.cmd
# Uses mpg123 (same as original, available on Linux)

AUDIO_DIR="${PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}/audio"
AUDIO_PID_DIR="${TEMP_DIR:-/tmp/fnaf-cli-audio}"

audio_init() {
    mkdir -p "$AUDIO_PID_DIR"
}

audio_stop() {
    local identifier="$1"
    local pid_file="$AUDIO_PID_DIR/${identifier}.pid"
    if [[ -f "$pid_file" ]]; then
        local pid
        pid=$(cat "$pid_file" 2>/dev/null)
        kill "$pid" 2>/dev/null || true
        rm -f "$pid_file"
    fi
}

audio_stop_all() {
    pkill -f "mpg123.*fnaf" 2>/dev/null || true
    rm -f "$AUDIO_PID_DIR"/*.pid 2>/dev/null || true
}

audio_start() {
    local target_audio="$AUDIO_DIR/$1"
    local identifier="$2"
    local loop_bool="$3"
    local volume_percent="$4"

    if [[ ! -f "$target_audio" ]]; then
        return
    fi

    audio_stop "$identifier"

    local params=()
    if [[ $loop_bool == "true" ]]; then
        params+=(--loop -1)
    fi

    local vol=$(( (volume_percent * 32768) / 100 ))
    params+=(-f "$vol")
    params+=(--no-control --no-visual)

    audio_init
    mpg123 "${params[@]}" "$target_audio" >/dev/null 2>&1 &
    local pid=$!
    echo "$pid" > "$AUDIO_PID_DIR/${identifier}.pid"
}
