#!/usr/bin/env bash

set -euo pipefail

# This file contains CachyOS-specific packages

# Hyprland
paru -S aquamarine hyprcursor hyprgraphics hyprland-guiutils hyprlang hyprtoolkit hyprutils hyprwayland-scanner hyprwire tomlplusplus wayland-protocols hyprland

# Hyprland extras
paru -S glaze sdbus-cpp hypridle hyprland-qt-support hyprlock hyprpicker hyprpolkitagent hyprshutdown hyprsunset xdg-desktop-portal-hyprland
