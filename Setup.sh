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
    run ln -sf "$ROOT_DIR/OtherRepo/art-hypr" "$HOME/Documents/art-hypr"

    # Tmux
    run rm -rf "$HOME/.tmux.conf"
    run ln -sf "$ROOT_DIR/User/.tmux.conf" "$HOME/.tmux.conf"

    # Nano
    run rm -rf "$HOME/.nanorc"
    run ln -sf "$ROOT_DIR/User/.nanorc" "$HOME/.nanorc"

    # btop
    run rm -rf "$HOME/.config/btop"
    run ln -sf "$ROOT_DIR/User/.config/btop" "$HOME/.config/btop"

    # cava
    run rm -rf "$HOME/.config/cava"
    run ln -sf "$ROOT_DIR/User/.config/cava" "$HOME/.config/cava"

    # Fish
    rm -rf "$HOME/.config/fish"
    mkdir -p "$HOME/.config/fish"
    ln -sf "$ROOT_DIR/User/.config/fish/config.fish" "$HOME/.config/fish/config.fish"

    # foot
    run rm -rf "$HOME/.config/foot"
    run ln -sf "$ROOT_DIR/User/.config/foot" "$HOME/.config/foot"

    # Kitty
    run rm -rf "$HOME/.config/kitty"
    run ln -sf "$ROOT_DIR/User/.config/kitty" "$HOME/.config/kitty"



    log "=== ALWAYS RUN TASKS END ==="
}

# =========================
# First Setup Only Tasks
# =========================
first_setup_only() {
    log "=== FIRST SETUP TASKS START ==="

    # Home Folder
    run mkdir -p "$HOME/.config"
    run mkdir -p "$HOME/Documents"
    run mkdir -p "$HOME/Downloads"

    run mkdir -p "$HOME/Pictures"
    run mkdir -p "$HOME/Pictures/Screenshot"
    
    run mkdir -p "$HOME/playlist"

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

    # Tmux
    run rm -rf "$HOME/.config/tmux"
    run mkdir -p "$HOME/.config/tmux/plugins/catppuccin/"
    run unzip "$ROOT_DIR/OtherRepo/tmux.zip" \
        -d "$HOME/.config/tmux/plugins/catppuccin/"

    log "=== FIRST SETUP TASKS END ==="
}

# =========================
# Main
# =========================
echo -e "\n$SEPARATOR" >>"$LOG_FILE"
log "Setup script started"

always_run

if is_first_setup; then
    log "First setup detected"
    first_setup_only
    mark_setup_done
else
    log "First setup already done, skipping"
fi

log "Setup script finished"
echo "$SEPARATOR" >>"$LOG_FILE"


# Bruh GPT 