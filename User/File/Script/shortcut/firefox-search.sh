#!/usr/bin/env bash

# Jalankan Wofi untuk input pencarian
query=$(wofi --dmenu --prompt "Search or URL:")

# Jika kosong, keluar
[ -z "$query" ] && exit

# Cek apakah input tampak seperti URL
if [[ "$query" =~ ^https?:// ]]; then
    url="$query"
elif [[ "$query" =~ \. ]]; then
    # Kalau mengandung titik, anggap domain
    url="https://$query"
else
    # Kalau bukan URL, anggap pencarian Google
    url="https://www.google.com/search?q=$(printf '%s' "$query" | jq -s -R -r @uri)"
fi

# Jalankan Firefox Flatpak
flatpak run org.mozilla.firefox "$url"
