#!/usr/bin/env bash


query=$(wofi --dmenu --prompt "Search or URL:")


[ -z "$query" ] && exit

if [[ "$query" =~ ^https?:// ]]; then
    url="$query"
elif [[ "$query" =~ \. ]]; then
    
    url="https://$query"
else
    
    url="https://www.google.com/search?q=$(printf '%s' "$query" | jq -s -R -r @uri)"
fi


flatpak run org.mozilla.firefox "$url"
