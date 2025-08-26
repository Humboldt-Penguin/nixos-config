#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 TIME" >&2
    echo "Example: $0 1h, $0 30m, $0 120s" >&2
    exit 1
fi

TIME="$1"

# convert input time to seconds
if [[ $TIME =~ ^([0-9]+)([smhd])$ ]]; then
    VAL=${BASH_REMATCH[1]}
    UNIT=${BASH_REMATCH[2]}
    case $UNIT in
    s) TOTAL=$VAL        ;;
    m) TOTAL=$((VAL * 60))   ;;
    h) TOTAL=$((VAL * 3600)) ;;
    d) TOTAL=$((VAL * 86400));;
    esac
else
    TOTAL=$TIME
fi

# compute epochs & format timestamps
START_EPOCH=$(date +%s)
END_EPOCH=$((START_EPOCH + TOTAL))
START_TIME=$(date +"%I:%M:%S %p")
END_TIME=$(date -d "@$END_EPOCH" +"%I:%M:%S %p")

echo
echo "Start: $START_TIME | End: $END_TIME"
echo

# handle cleanup/exit
cleanup() {
    kill -0 "$SLEEP_PID" 2>/dev/null && kill "$SLEEP_PID"  # kill sleep process if still running
    tput cnorm  # restore cursor
}
trap cleanup SIGINT EXIT  # run cleanup on ctrl+c or script exit

# prepare terminal
tput civis  # hide cursor
tput sc     # save cursor pos (this marks the start of the bar line)

# sleep process in background
systemd-inhibit --what=idle:sleep --why="Timer for $TIME" sleep "$TIME" &
SLEEP_PID=$!

BAR_WIDTH=50

# progress-bar update function
redraw_bar() {
    local elapsed=$1 remain=$2
    local pct=$((100 * elapsed / TOTAL))
    local filled=$((BAR_WIDTH * elapsed / TOTAL))
    local empty=$((BAR_WIDTH - filled))
    local bar

    # build bar w/ hashes and hyphens
    bar=$(printf "%0.s#" $(seq 1 $filled))
    if (( empty > 0 )); then
    bar+=$(printf "%0.s-" $(seq 1 $empty))
    fi

    # format remaining as HH:MM:SS
    local h=$((remain/3600)) m=$((remain%3600/60)) s=$((remain%60))
    local rem_hms; rem_hms=$(printf "%02d:%02d:%02d" $h $m $s)

    tput rc  # restore cursor
    tput el  # clear to end of line
    printf "[%s] %3d%% | Remain: %s" \
    "$bar" "$pct" "$rem_hms"
}

# MAIN LOOP: update until sleep exits
while kill -0 "$SLEEP_PID" 2>/dev/null; do  # test process alive
    NOW=$(date +%s)
    ELAPSED=$((NOW - START_EPOCH))
    REMAIN=$((END_EPOCH - NOW))
    (( REMAIN < 0 )) && REMAIN=0

    redraw_bar "$ELAPSED" "$REMAIN"
    sleep 1
done

# final redraw at 100% (ensure final frame prints)
redraw_bar "$TOTAL" 0

# cleanup terminal
echo
