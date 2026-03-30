#!/usr/bin/env bash


ACTIVE_WIN=$(hyprctl activewindow -j)

if [ -z "$ACTIVE_WIN" ] || [ "$ACTIVE_WIN" = "null" ]; then
    notify-send "Hyprland" "Tidak ada window aktif"
    exit 1
fi

WIN_CLASS=$(echo "$ACTIVE_WIN" | jq -r '.class')
WIN_TITLE=$(echo "$ACTIVE_WIN" | jq -r '.title')

echo "Window aktif:"
echo "Class : $WIN_CLASS"
echo "Title : $WIN_TITLE"

OPTIONS="1\n0.95\n0.9\n0.8\n0.7\n0.5\n0.3\n0.2\n0.1"

CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Pilih opacity")

[ -z "$CHOICE" ] && exit 0

TITLE_OPTION=$(echo -e "Class + Title\nClass saja" | wofi --dmenu --prompt "Target rule")

if [ "$TITLE_OPTION" = "Class + Title" ]; then
    RULE="opacity $CHOICE, match:class $WIN_CLASS, match:title $WIN_TITLE"
else
    RULE="opacity $CHOICE, match:class $WIN_CLASS"
fi

echo "Apply rule:"
echo "$RULE"

hyprctl keyword windowrule "$RULE"
