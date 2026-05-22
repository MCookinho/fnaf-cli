#!/usr/bin/env bash
# Events/AI Manager - Linux port of events.cmd
# Runs as a background process communicating via files

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RUN_DIR="${XDG_RUNTIME_DIR:-/tmp}/fnaf-cli-$UID"
mkdir -p "$RUN_DIR" 2>/dev/null || true
cd "$PROJECT_DIR" || exit 1

TIMER=1
FREDDY=0
TIMER_FREDDY=0
CHICA=0
BONNIE=0
FOXY=0
TIMER_FOXY=1
S_TIMER_FOXY=0
A_TIMER_FOXY=31
FOXY_ATTACKS=0
PLAYED_BG=""
BATTERY=10000
SEND_BATTERY=99
OLD_BATTERY=99
WIN=0

touch "$RUN_DIR/MOVEMENTS.cmd" 2>/dev/null || true

freddy_level=1
freddy_file="${XDG_DATA_HOME:-$HOME/.local/share}/fnaf-cli/freddy"
if [[ -f "$freddy_file" ]]; then
    freddy_level=$(grep "^level=" "$freddy_file" 2>/dev/null | cut -d= -f2)
fi

MO_FREDDY=${1:-0}
MO_CHICA=${2:-0}
MO_BONNIE=${3:-0}
MO_FOXY=${4:-0}

while true; do
    STATES=""
    [[ -f "$RUN_DIR/office_states" ]] && STATES=$(cat "$RUN_DIR/office_states" 2>/dev/null || echo "")
    CAMS_STATES=""
    [[ -f "$RUN_DIR/cams_state" ]] && CAMS_STATES=$(cat "$RUN_DIR/cams_state" 2>/dev/null || echo "")

    DRAIN=5
    [[ $STATES == *"_doorL"* ]] && ((DRAIN+=15))
    [[ $STATES == *"_doorR"* ]] && ((DRAIN+=15))
    [[ $STATES == *"_lightL"* ]] && ((DRAIN+=15))
    [[ $STATES == *"_lightR"* ]] && ((DRAIN+=15))
    [[ $STATES == *"_bonnie"* ]] && ((DRAIN+=15))
    [[ $STATES == *"_chica"* ]] && ((DRAIN+=15))
    [[ -f "$RUN_DIR/cams_state" ]] && ((DRAIN+=13))

    ((BATTERY -= DRAIN))
    SEND_BATTERY=$((BATTERY / 100))

    if [[ $OLD_BATTERY -ne $SEND_BATTERY ]]; then
        echo "$SEND_BATTERY" > "$RUN_DIR/BATTERY" 2>/dev/null || true
        touch "$RUN_DIR/refresh" 2>/dev/null || true
    fi
    OLD_BATTERY=$SEND_BATTERY

    [[ $freddy_level -ge 2 && $MO_BONNIE -le 19 && $TIMER -eq 25 ]] && ((MO_BONNIE++))
    [[ $freddy_level -ge 2 && $MO_CHICA -le 19 && $TIMER -eq 60 ]] && ((MO_CHICA++))
    [[ $freddy_level -ge 1 && $MO_BONNIE -le 19 && $TIMER -eq 150 ]] && ((MO_BONNIE++))
    [[ $freddy_level -ge 4 && $MO_FREDDY -le 19 && $TIMER -eq 240 ]] && ((MO_FREDDY++))
    [[ $freddy_level -ge 2 && $MO_CHICA -le 19 && $TIMER -eq 300 ]] && ((MO_CHICA++))
    [[ $freddy_level -ge 3 && $MO_FOXY -le 19 && $TIMER -eq 300 ]] && ((MO_FOXY++))
    [[ $freddy_level -ge 5 && $MO_FREDDY -le 19 && $TIMER -eq 330 ]] && ((MO_FREDDY++))
    [[ $freddy_level -ge 4 && $MO_FOXY -le 19 && $TIMER -eq 360 ]] && ((MO_FOXY++))
    [[ $freddy_level -ge 1 && $MO_CHICA -le 19 && $TIMER -eq 420 ]] && ((MO_CHICA++))
    [[ $freddy_level -ge 3 && $MO_BONNIE -le 19 && $TIMER -eq 450 ]] && ((MO_BONNIE++))
    [[ $freddy_level -ge 4 && $MO_FREDDY -le 19 && $TIMER -eq 480 ]] && ((MO_FREDDY++))

    if [[ $((TIMER % 4)) -eq 0 ]]; then
        rnd_chica=$((RANDOM % 19 + 1))
        if [[ $rnd_chica -le $MO_CHICA ]]; then
            if [[ $CHICA -le 1 ]]; then ((CHICA++))
            elif [[ $CHICA -ge 5 ]]; then ((CHICA++))
            else
                nohup mpg123 --no-control --no-visual -f $((22 * 32768 / 100)) "$PROJECT_DIR/audio/deepsteps.mp3" >/dev/null 2>&1 &
                rnd_chica=$((RANDOM % 5 + 1))
                [[ $rnd_chica -le 3 ]] && ((CHICA++)) || ((CHICA--))
            fi
            [[ $CHICA -gt 6 && $STATES == *"doorR"* ]] && CHICA=1
            touch "$RUN_DIR/refresh" 2>/dev/null || true
        fi

        rnd_bonnie=$((RANDOM % 19 + 1))
        if [[ $rnd_bonnie -le $MO_BONNIE ]]; then
            nohup mpg123 --no-control --no-visual -f $((22 * 32768 / 100)) "$PROJECT_DIR/audio/deepsteps.mp3" >/dev/null 2>&1 &
            if [[ $BONNIE -eq 1 ]]; then
                BONNIE=$((RANDOM % 4 + 1)); [[ $BONNIE -eq 1 ]] && ((BONNIE += 2))
            elif [[ $BONNIE -eq 2 ]]; then
                BONNIE=$((RANDOM % 4 + 1)); [[ $BONNIE -eq 2 ]] && ((BONNIE += 2))
            elif [[ $BONNIE -eq 3 ]]; then
                BONNIE=$((RANDOM % 5 + 1)); [[ $BONNIE -eq 3 ]] && ((BONNIE += 2))
            elif [[ $BONNIE -eq 4 ]]; then
                BONNIE=$((RANDOM % 5 + 1)); [[ $BONNIE -eq 4 ]] && ((BONNIE++))
            else ((BONNIE++))
            fi
            [[ $BONNIE -gt 6 && $STATES == *"doorL"* ]] && BONNIE=$((RANDOM % 3 + 1))
            touch "$RUN_DIR/refresh" 2>/dev/null || true
        fi
    fi

    if [[ $FOXY -ge 5 ]]; then
        if [[ $STATES == *"doorL"* ]]; then
            nohup mpg123 --no-control --no-visual -f $((95 * 32768 / 100)) "$PROJECT_DIR/audio/knock2.mp3" >/dev/null 2>&1 &
            FOXY=0; S_TIMER_FOXY=31
            rm -f "$RUN_DIR/SEEN_FOXY" 2>/dev/null || true
            touch "$RUN_DIR/refresh" 2>/dev/null || true
        else
            ((FOXY++)); touch "$RUN_DIR/refresh" 2>/dev/null || true
        fi
    fi

    [[ -f "$RUN_DIR/cams_state" ]] && TIMER_FOXY=0
    if [[ -f "$RUN_DIR/saw_cams" ]]; then TIMER_FOXY=0; rm -f "$RUN_DIR/saw_cams" 2>/dev/null || true; fi

    f_calc=1; [[ $TIMER_FOXY -ge 5 ]] && f_calc=$((TIMER_FOXY % 5))
    rnd_foxy=$((RANDOM % 19 + 1))

    if [[ $f_calc -eq 0 && $rnd_foxy -le $MO_FOXY && $FOXY -lt 3 && ! -f "$RUN_DIR/cams_state" ]]; then
        ((FOXY++)); touch "$RUN_DIR/refresh" 2>/dev/null || true
    fi

    if [[ -f "$RUN_DIR/SEEN_FOXY" ]]; then
        if [[ $FOXY -ge 3 ]]; then
            [[ $A_TIMER_FOXY -ne 31 ]] && A_TIMER_FOXY=31
            [[ $S_TIMER_FOXY -eq 0 ]] && nohup mpg123 --no-control --no-visual -f $((100 * 32768 / 100)) "$PROJECT_DIR/audio/run.mp3" >/dev/null 2>&1 &
            if [[ $S_TIMER_FOXY -eq 1 ]]; then
                S_TIMER_FOXY=5; ((FOXY++)); touch "$RUN_DIR/refresh" 2>/dev/null || true
            elif [[ $S_TIMER_FOXY -eq 5 ]]; then
                if [[ $STATES == *"doorL"* ]]; then
                    nohup mpg123 --no-control --no-visual -f $((95 * 32768 / 100)) "$PROJECT_DIR/audio/knock2.mp3" >/dev/null 2>&1 &
                    FOXY=0; S_TIMER_FOXY=0; ((FOXY_ATTACKS++))
                    ((BATTERY -= (FOXY_ATTACKS * 2) * 100))
                    rm -f "$RUN_DIR/SEEN_FOXY" 2>/dev/null || true
                else
                    ((FOXY++)); rm -f "$RUN_DIR/SEEN_FOXY" 2>/dev/null || true
                fi
                touch "$RUN_DIR/refresh" 2>/dev/null || true
            else
                [[ $S_TIMER_FOXY -lt 3 ]] && ((S_TIMER_FOXY++))
                [[ $S_TIMER_FOXY -gt 3 ]] && ((S_TIMER_FOXY--))
            fi
        else rm -f "$RUN_DIR/SEEN_FOXY" 2>/dev/null || true
        fi
    elif [[ $FOXY -ge 3 ]]; then
        if [[ $A_TIMER_FOXY -eq 29 ]]; then
            ((A_TIMER_FOXY++))
            [[ $FOXY -eq 3 ]] && { nohup mpg123 --no-control --no-visual -f $((100 * 32768 / 100)) "$PROJECT_DIR/audio/run.mp3" >/dev/null 2>&1 & ((FOXY++)); touch "$RUN_DIR/refresh" 2>/dev/null || true; }
        elif [[ $A_TIMER_FOXY -eq 31 ]]; then
            ((A_TIMER_FOXY++))
            if [[ $FOXY -eq 4 ]]; then
                if [[ $STATES == *"doorL"* ]]; then
                    nohup mpg123 --no-control --no-visual -f $((95 * 32768 / 100)) "$PROJECT_DIR/audio/knock2.mp3" >/dev/null 2>&1 &
                    FOXY=0; A_TIMER_FOXY=0; ((FOXY_ATTACKS++))
                    ((BATTERY -= (FOXY_ATTACKS * 2) * 100))
                    rm -f "$RUN_DIR/SEEN_FOXY" 2>/dev/null || true
                else
                    ((FOXY++)); rm -f "$RUN_DIR/SEEN_FOXY" 2>/dev/null || true
                fi
                touch "$RUN_DIR/refresh" 2>/dev/null || true
            fi
        elif [[ $A_TIMER_FOXY -gt 31 ]]; then A_TIMER_FOXY=0
        else ((A_TIMER_FOXY++))
        fi
    fi

    rnd_freddy=$((RANDOM % 19 + 1))
    f_calc=$((TIMER % 5))

    if [[ $FREDDY -gt 0 ]]; then
        if [[ $FREDDY -le 3 ]]; then
            if [[ $TIMER_FREDDY -gt 1 ]]; then
                if [[ ! -f "$RUN_DIR/saw_freddy" ]]; then
                    ((TIMER_FREDDY -= MO_FREDDY))
                    [[ $FREDDY -eq 1 && $CAMS_STATES == "_2" ]] && ((TIMER_FREDDY += MO_FREDDY))
                    [[ $FREDDY -eq 2 && $CAMS_STATES == "_4" ]] && ((TIMER_FREDDY += MO_FREDDY))
                    [[ $FREDDY -eq 3 && $CAMS_STATES == "_10" ]] && ((TIMER_FREDDY += MO_FREDDY))
                    [[ $TIMER_FREDDY -lt 1 ]] && TIMER_FREDDY=1
                else rm -f "$RUN_DIR/saw_freddy" 2>/dev/null || true
                fi
            fi

            if [[ $TIMER_FREDDY -eq 1 ]]; then
                nohup mpg123 --no-control --no-visual -f $((40 * 32768 / 100)) "$PROJECT_DIR/audio/running_fast3.mp3" >/dev/null 2>&1 &
                rnd=$((RANDOM % 3 + 1))
                nohup mpg123 --no-control --no-visual -f $((40 * 32768 / 100)) "$PROJECT_DIR/audio/Laugh_Giggle_Girl_${rnd}d.mp3" >/dev/null 2>&1 &
                ((FREDDY++)); TIMER_FREDDY=0
                touch "$RUN_DIR/refresh" 2>/dev/null || true
            fi

            [[ $f_calc -eq 0 && $rnd_freddy -le $MO_FREDDY && $TIMER_FREDDY -eq 0 ]] && TIMER_FREDDY=10
        elif [[ $FREDDY -eq 4 ]]; then
            if [[ $f_calc -eq 0 && $rnd_freddy -le $MO_FREDDY && ! -f "$RUN_DIR/saw_freddy" ]]; then
                if [[ $CAMS_STATES != "_11" && $STATES != *"doorR"* ]]; then
                    nohup mpg123 --no-control --no-visual -f $((40 * 32768 / 100)) "$PROJECT_DIR/audio/running_fast3.mp3" >/dev/null 2>&1 &
                    rnd=$((RANDOM % 3 + 1))
                    nohup mpg123 --no-control --no-visual -f $((40 * 32768 / 100)) "$PROJECT_DIR/audio/Laugh_Giggle_Girl_${rnd}d.mp3" >/dev/null 2>&1 &
                    ((FREDDY -= rnd)); touch "$RUN_DIR/refresh" 2>/dev/null || true
                else
                    ((FREDDY++)); touch "$RUN_DIR/refresh" 2>/dev/null || true
                fi
            else rm -f "$RUN_DIR/saw_freddy" 2>/dev/null || true
            fi
        else ((FREDDY--))
        fi
    else
        if [[ $f_calc -eq 0 && $rnd_freddy -le $MO_FREDDY && $TIMER_FREDDY -eq 0 && $BONNIE -gt 0 && $CHICA -gt 0 ]]; then
            nohup mpg123 --no-control --no-visual -f $((40 * 32768 / 100)) "$PROJECT_DIR/audio/running_fast3.mp3" >/dev/null 2>&1 &
            rnd=$((RANDOM % 3 + 1))
            nohup mpg123 --no-control --no-visual -f $((40 * 32768 / 100)) "$PROJECT_DIR/audio/Laugh_Giggle_Girl_${rnd}d.mp3" >/dev/null 2>&1 &
            ((FREDDY++)); touch "$RUN_DIR/refresh" 2>/dev/null || true
        fi
    fi

    if [[ -f "$RUN_DIR/refresh" ]]; then
        cat > "$RUN_DIR/MOVEMENTS.cmd" << EOF
FREDDY=$FREDDY
BONNIE=$BONNIE
CHICA=$CHICA
FOXY=$FOXY
EOF
    fi

    case $TIMER in
         89) echo "1" > "$RUN_DIR/TIME" 2>/dev/null || true; touch "$RUN_DIR/refresh" 2>/dev/null || true ;;
        178) echo "2" > "$RUN_DIR/TIME" 2>/dev/null || true; touch "$RUN_DIR/refresh" 2>/dev/null || true ;;
        267) echo "3" > "$RUN_DIR/TIME" 2>/dev/null || true; touch "$RUN_DIR/refresh" 2>/dev/null || true ;;
        356) echo "4" > "$RUN_DIR/TIME" 2>/dev/null || true; touch "$RUN_DIR/refresh" 2>/dev/null || true ;;
        445) echo "5" > "$RUN_DIR/TIME" 2>/dev/null || true; touch "$RUN_DIR/refresh" 2>/dev/null || true ;;
    esac

    [[ $SEND_BATTERY -le 0 ]] && { pkill -f "fnaf-cli$" 2>/dev/null || true; break; }
    [[ -f "$RUN_DIR/refresh" ]] && rm -f "$RUN_DIR/refresh" 2>/dev/null || true

    if [[ $TIMER -ge 534 ]]; then
        [[ $WIN -eq 0 ]] && touch "$RUN_DIR/WIN" 2>/dev/null || true
        WIN=1; exit 0
    fi

    rnd_sfx=$((RANDOM % 770 + 1))
    [[ $rnd_sfx -eq 1 ]] && nohup mpg123 --no-control --no-visual -f $((10 * 32768 / 100)) "$PROJECT_DIR/audio/circus.mp3" >/dev/null 2>&1 &
    rnd_sfx=$((RANDOM % 770 + 1))
    [[ $rnd_sfx -eq 1 ]] && nohup mpg123 --no-control --no-visual -f $((14 * 32768 / 100)) "$PROJECT_DIR/audio/pirate_song2.mp3" >/dev/null 2>&1 &
    rnd_sfx=$((RANDOM % 550 + 1))
    [[ $rnd_sfx -eq 1 && -z $PLAYED_BG ]] && { PLAYED_BG=1; nohup mpg123 --no-control --no-visual -f $((75 * 32768 / 100)) "$PROJECT_DIR/audio/EerieAmbienceLargeSca_MV005.mp3" >/dev/null 2>&1 & }

    ((TIMER++)); ((TIMER_FOXY++))
    sleep 1
done

while true; do
    [[ $TIMER -ge 534 ]] && { touch "$RUN_DIR/WIN" 2>/dev/null || true; exit 0; }
    ((TIMER++)); sleep 1
done
