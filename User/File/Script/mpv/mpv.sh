#!/usr/bin/env bash

# Cek argumen
if [ $# -eq 0 ]; then
    echo "Usage: $0 <video-file>"
    exit 1
fi

VIDEO="$1"
TIMESTAMP=$(date +%s)
SESSION_NAME="mpv-$TIMESTAMP"

# Jalankan mpv di tmux session baru, lalu otomatis exit setelah selesai
tmux new-session -d -s "$SESSION_NAME" "mpv \"$VIDEO\""

echo "MPV started in tmux session: $SESSION_NAME"
