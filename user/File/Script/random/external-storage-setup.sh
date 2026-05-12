#!/usr/bin/env bash

set -euo pipefail

# Check argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path>"
    exit 1
fi

BASE_PATH="$1"

echo "Creating folder structure in: $BASE_PATH"

# Main folders
mkdir -p "$BASE_PATH/File/Documents"
mkdir -p "$BASE_PATH/File/Downloads"
mkdir -p "$BASE_PATH/File/File"
mkdir -p "$BASE_PATH/File/Pictures"
mkdir -p "$BASE_PATH/File/Playlists"
mkdir -p "$BASE_PATH/File/Videos"

# Subfolders inside File/File
mkdir -p "$BASE_PATH/File/File/Code"
mkdir -p "$BASE_PATH/File/File/Software"
mkdir -p "$BASE_PATH/File/File/Temp"

# Subfolders inside Software
mkdir -p "$BASE_PATH/File/File/Software/Game"
mkdir -p "$BASE_PATH/File/File/Software/Podman"
mkdir -p "$BASE_PATH/File/File/Software/VM"

echo "Folder structure created successfully."