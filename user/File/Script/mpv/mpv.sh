#!/usr/bin/env bash

# Cek argumen
if [ $# -eq 0 ]; then
    echo "Usage: $0 <video-file>"
    exit 1
fi

VIDEO="$1"

if tmux has-session -t mpvdefault 2>/dev/null; then
    TIMESTAMP=$(date +%s)
    SESSION_NAME="mpv-$TIMESTAMP"
else
    SESSION_NAME="mpvdefault"
fi

tmux new-session -d -s "$SESSION_NAME" "mpv \"$VIDEO\""

echo "MPV started in tmux session: $SESSION_NAME"