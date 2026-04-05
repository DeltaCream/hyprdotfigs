#!/usr/bin/env bash

# exit on errors
set -euo pipefail

printf 'BASH_SOURCE[0]=%s\n' "${BASH_SOURCE[0]}"
printf 'dirname(BASH_SOURCE[0])=%s\n' "$(dirname "${BASH_SOURCE[0]}")"
printf 'dirname(dirname(BASH_SOURCE[0]))=%s\n' "$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
printf 'pwd when cd to that: %s\n' "$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd -P)"

# Colors (optional)
BLUE='\e[34m'
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m" # No color

echo -e "${BLUE}=== Hyprdotfiles Setup Script ===${NC}"

echo -e "${GREEN}Creating symlinks for Hyprland configs...${NC}"

SCRIPT_PATH="${BASH_SOURCE[0]}"

# Prefer readlink -f (Linux) / realpath if available; otherwise make absolute via $PWD
if command -v readlink >/dev/null 2>&1; then
  # readlink -f resolves symlinks and returns absolute path
  SCRIPT_PATH="$(readlink -f "$SCRIPT_PATH" 2>/dev/null || true)"
fi

if [ -z "${SCRIPT_PATH:-}" ] || [[ "$SCRIPT_PATH" != /* ]]; then
  # fallback: make absolute relative to current working directory
  SCRIPT_PATH="$PWD/${BASH_SOURCE[0]}"
fi

# directory containing script.sh
ROOT_DIR="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd -P)"

# list of config files to link (basename only)
# FILES=(
#   hyprland.conf
#   hypridle.conf
#   hyprlock.conf
#   hyprpaper.conf
#   gamemode.sh
# )

# ln -s "$ROOT_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
# ln -s "$ROOT_DIR/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
# ln -s "$ROOT_DIR/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
# ln -s "$ROOT_DIR/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"

# for f in "${FILES[@]}"; do
#   SRC="$ROOT_DIR/hypr/$f"
#   LINK="$HOME/.config/hypr/$f"

#   # ensure parent exists
#   mkdir -p "$(dirname "$LINK")"

#   # if there's already a symlink there
#   if [ -L "$LINK" ]; then
#     if command -v realpath >/dev/null 2>&1; then
#       # resolve absolute canonical paths for reliable comparison
#       ABS_SRC="$(realpath -m "$SRC")"
#       # readlink may be relative; make it absolute relative to link's dir
#       LINK_TARGET="$(readlink "$LINK")"
#       ABS_LINK_TARGET="$(realpath -m "$(dirname "$LINK")/$LINK_TARGET")"
#       if [ "$ABS_LINK_TARGET" = "$ABS_SRC" ]; then
#         echo -e "${YELLOW}Skipping (correct symlink exists):${NC} $LINK -> $LINK_TARGET"
#         continue
#       else
#         echo -e "${YELLOW}Skipping (symlink exists but points to different target):${NC} $LINK -> $LINK_TARGET"
#         continue
#       fi
#     else
#       # fallback: compare the raw readlink text with SRC (less robust)
#       if [ "$(readlink "$LINK")" = "$SRC" ]; then
#         echo -e "${YELLOW}Skipping (correct symlink exists):${NC} $LINK -> $(readlink "$LINK")"
#         continue
#       else
#         echo -e "${YELLOW}Skipping (symlink exists but points elsewhere):${NC} $LINK -> $(readlink "$LINK")"
#         continue
#       fi
#     fi
#   fi

#   # if a non-symlink file or directory exists at LINK, skip (don't overwrite)
#   if [ -e "$LINK" ]; then
#     echo -e "${YELLOW}Skipping (path exists and is not a symlink):${NC} $LINK"
#     continue
#   fi

#   # create the symlink (relative if possible)
#   if command -v realpath >/dev/null 2>&1 && realpath --help 2>&1 | grep -q -- '--relative-to'; then
#     ABS_SRC="$(realpath -m "$SRC")"
#     REL_SRC="$(realpath --relative-to="$(dirname "$LINK")" "$ABS_SRC")"
#     ln -s "$REL_SRC" "$LINK"
#   else
#     ln -s "$SRC" "$LINK"
#   fi

#   echo -e "${GREEN}Created symlink:${NC} $LINK -> $(readlink "$LINK")"
# done

# ---------

# SRC="$ROOT_DIR/starship/starship.toml"
# LINK="$HOME/.config/starship.toml"

# echo -e "${GREEN}Creating symlink for starship...${NC}"

# ln -s "$SRC" "$LINK"

# Use this if checking for a link name (be it a file, symlink, or directory)
# if [ ! -e "$LINK" ]; then
#   ln -s "$SRC" "$LINK"
# fi

# Use this instead if you want to check specifically for a symlink
# if [ ! -L "$LINK" ]; then
#   ln -s "$SRC" "$LINK"
# fi


# ---------

# SRC="$ROOT_DIR/bash/.bashrc"
# LINK="$HOME/.bashrc"

# echo -e "${GREEN}Creating symlink for bash...${NC}"

# ln -s "$SRC" "$LINK"

# optionally:
# source ~/.bashrc

# --------

# SRC="$ROOT_DIR/zsh/.zshrc"
# LINK="$HOME/.zsh"

# echo -e "${GREEN}Creating symlink for zsh...${NC}"

# ln -s "$SRC" "$LINK"

# optionally:
# source ~/.zshrc

# --------

# list of config folders to link (basename only)
FOLDERS=(
  # waybar
  # hypr/hyprlock
  hypr
  # alacritty
  # ashell
  wleave
  # swayosd
  # walker
  nvim
  ironbar
  sunsetr
  zed
  wayshot
  eww
  end-rs
  wayle
  zlaunch
)

for f in "${FOLDERS[@]}"; do
  SRC="$ROOT_DIR/$f"
  LINK="$HOME/.config/$f"
  echo -e "${GREEN}Creating symlink for $f folder...${NC}"
  mkdir -p "$(dirname "$LINK")"
  # Replace any existing file/symlink and force treat DEST as file (not directory)
  ln -sTfn "$SRC" "$LINK"
done

echo -e "${GREEN}Setup complete!${NC}"
