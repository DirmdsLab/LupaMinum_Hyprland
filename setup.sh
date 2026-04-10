#!/usr/bin/env bash
set -e

# =========================
# Paths & State
# =========================
ROOT_DIR="$(pwd)"
TEMP_DIR="$ROOT_DIR/temp"
STATE_FILE="$TEMP_DIR/UwU.temp"
LOG_FILE="$TEMP_DIR/setup.log"

mkdir -p "$TEMP_DIR"

# =========================
# Run Metadata
# =========================
RUN_ID="$(date '+%Y-%m-%d %H:%M:%S')"
SEPARATOR="============================================================"

# =========================
# Logging Helpers
# =========================
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

log() {
    echo "[$RUN_ID] $1" | tee -a "$LOG_FILE"
}

run() {
    log "RUN: $*"
    "$@" >>"$LOG_FILE" 2>&1
}

# =========================
# State Helpers
# =========================
is_first_setup() {
    [[ ! -f "$STATE_FILE" ]]
}

mark_setup_done() {
    echo "Delete This ReSetup" > "$STATE_FILE"
    log "State file created: $STATE_FILE"
}

# =========================
# Always Run Tasks
# =========================
always_run() {
    log "=== ALWAYS RUN TASKS START ==="

    # Art-hypr
    run rm -rf "$HOME/Documents/art-hypr"
    run ln -sf "$ROOT_DIR/external/art-hypr" "$HOME/Documents/art-hypr"

    # Tmux
    run rm -rf "$HOME/.tmux.conf"
    run ln -sf "$ROOT_DIR/user/.tmux.conf" "$HOME/.tmux.conf"

    # Nano
    run rm -rf "$HOME/.nanorc"
    run ln -sf "$ROOT_DIR/user/.nanorc" "$HOME/.nanorc"

    # btop
    run rm -rf "$HOME/.config/btop"
    run ln -sf "$ROOT_DIR/user/.config/btop" "$HOME/.config/btop"

    # cava
    run rm -rf "$HOME/.config/cava"
    run ln -sf "$ROOT_DIR/user/.config/cava" "$HOME/.config/cava"

    # Fish
    rm -rf "$HOME/.config/fish"
    mkdir -p "$HOME/.config/fish"
    ln -sf "$ROOT_DIR/user/.config/fish/config.fish" "$HOME/.config/fish/config.fish"

    # foot
    run rm -rf "$HOME/.config/foot"
    run ln -sf "$ROOT_DIR/user/.config/foot" "$HOME/.config/foot"

    # hypr
    run rm -rf "$HOME/.config/hypr"
    run ln -sf "$ROOT_DIR/user/.config/hypr" "$HOME/.config/hypr"

    # Kitty
    run rm -rf "$HOME/.config/kitty"
    run ln -sf "$ROOT_DIR/user/.config/kitty" "$HOME/.config/kitty"

    # mako
    run rm -rf "$HOME/.config/mako"
    run ln -sf "$ROOT_DIR/user/.config/mako" "$HOME/.config/mako"

    # mpv
    run rm -f "$ROOT_DIR/user/.config/mpv/playlists"
    run ln -s "$HOME/Playlists" "$ROOT_DIR/user/.config/mpv/playlists"
    run rm -rf "$HOME/.config/mpv"
    run ln -sf "$ROOT_DIR/user/.config/mpv" "$HOME/.config/mpv"

    # fastfetch
    run rm -rf "$HOME/.config/fastfetch"
    run ln -sf "$ROOT_DIR/user/.config/fastfetch" "$HOME/.config/fastfetch"

    # quickshell
    run rm -rf "$HOME/.config/quickshell"
    run ln -sf "$ROOT_DIR/user/.config/quickshell" "$HOME/.config/quickshell"

    # wofi
    run rm -rf "$HOME/.config/wofi"
    run ln -sf "$ROOT_DIR/user/.config/wofi" "$HOME/.config/wofi"

    # mimeapps.list
    run rm -rf "$HOME/.config/mimeapps.list"
    run ln -sf "$ROOT_DIR/user/.config/mimeapps.list" "$HOME/.config/mimeapps.list"

    # starship.toml
    run rm -rf "$HOME/.config/starship.toml"
    run ln -sf "$ROOT_DIR/user/.config/starship.toml" "$HOME/.config/starship.toml"

    # Script
    run rm -rf "$HOME/File/Script"
    run ln -sf "$ROOT_DIR/user/File/Script" "$HOME/File/Script"

    log "=== ALWAYS RUN TASKS END ==="
}

# =========================
# First Setup Only Tasks
# =========================
first_setup_only() {
    log "=== FIRST SETUP TASKS START ==="

    # Home Folder
    run mkdir -p "$HOME/.config"
    run mkdir -p "$HOME/.local"
    run mkdir -p "$HOME/Documents"
    run mkdir -p "$HOME/Downloads"

    run mkdir -p "$HOME/Pictures"
    run mkdir -p "$HOME/Pictures/Screenshot"
    
    run mkdir -p "$HOME/Playlists"

    run mkdir -p "$HOME/Videos"
    run mkdir -p "$HOME/Videos/Wallpaper"

    run mkdir -p "$HOME/File"
    run mkdir -p "$HOME/File/Code"
    run mkdir -p "$HOME/File/Temp"
    
    run mkdir -p "$HOME/File/Software"
    run mkdir -p "$HOME/File/Software/Game"
    run mkdir -p "$HOME/File/Software/Storage/HDD/hddex"
    run mkdir -p "$HOME/File/Software/Storage/NetworkStorage/SFTP"
    run mkdir -p "$HOME/File/Software/Storage/temphdd"

    # .local
    run cp -r "$ROOT_DIR/user/.local" "$HOME/"

    # Tmux
    run rm -rf "$HOME/.config/tmux"
    run mkdir -p "$HOME/.config/tmux/plugins/catppuccin/"
    run rm -rf "$ROOT_DIR/external/tmux/tmux-main"
    run unzip "$ROOT_DIR/external/tmux/catppuccin-tmux.zip" -d "$ROOT_DIR/external/tmux/"
    run mv "$ROOT_DIR/external/tmux/tmux-main" "$HOME/.config/tmux/plugins/catppuccin/tmux"

    # Mpv shaders
    run rm -rf external/mpv/GLSL_Mac_Linux_High-end
    run mkdir -p external/mpv/GLSL_Mac_Linux_High-end
    run unzip "$ROOT_DIR/external/mpv/GLSL_Mac_Linux_High-end.zip" -d "external/mpv/GLSL_Mac_Linux_High-end"
    run rm -rf "$ROOT_DIR/user/.config/mpv/shaders"
    run mv "$ROOT_DIR/external/mpv/GLSL_Mac_Linux_High-end/shaders" "$ROOT_DIR/user/.config/mpv/"

    # themes

    run mkdir -p "$HOME/.themes"

    run rm -rf "$ROOT_DIR/external/themes/gtk/Graphite-Dark-nord"
    run mkdir -p "$ROOT_DIR/external/themes/gtk/Graphite-Dark-nord"
    run tar -xf "$ROOT_DIR/external/themes/gtk/Graphite-Dark-nord.tar.xz" -C "$ROOT_DIR/external/themes/gtk/Graphite-Dark-nord"
    run cp -r "$ROOT_DIR/external/themes/gtk/Graphite-Dark-nord/Graphite-Dark-nord" "$HOME/.themes"

    # Cursor
    run mkdir -p "$HOME/.icons"

    run rm -rf "$ROOT_DIR/external/themes/cursor/Bibata-Modern-Ice"
    run mkdir -p "$ROOT_DIR/external/themes/cursor/Bibata-Modern-Ice"
    run tar -xf "$ROOT_DIR/external/themes/cursor/Bibata-Modern-Ice.tar.xz" -C "$ROOT_DIR/external/themes/cursor/Bibata-Modern-Ice"
    run cp -r "$ROOT_DIR/external/themes/cursor/Bibata-Modern-Ice/Bibata-Modern-Ice" "$HOME/.icons"

    # Icon
    run rm -rf "$ROOT_DIR/external/themes/icon/01-Colloid"
    run mkdir -p "$ROOT_DIR/external/themes/icon/01-Colloid"
    run tar -xf "$ROOT_DIR/external/themes/icon/01-Colloid.tar.xz" -C "$ROOT_DIR/external/themes/icon/01-Colloid"
    run cp -r $ROOT_DIR/external/themes/icon/01-Colloid/* "$HOME/.icons"

    # To apply themes
    run echo "Run 'nwg-look' to apply themes"

    log "=== FIRST SETUP TASKS END ==="
}

# =========================
# Main
# =========================
echo -e "\n$SEPARATOR" >>"$LOG_FILE"
log "Setup script started"

if is_first_setup; then
    log "First setup detected"
    first_setup_only
    mark_setup_done
else
    log "First setup already done, skipping"
fi

always_run

log "Setup script finished"
echo "$SEPARATOR" >>"$LOG_FILE"


# Bruh GPT 