#!/usr/bin/env bash

# exit on errors
set -euo pipefail

# About: This file contains all the build steps for manually compiling/building software from source.
# For any dependencies that may be needed, please refer to the "<distro>-dependencies.sh"
# Where <distro> is the family of your choice:
# debian-dependencies.sh for Debian/Ubuntu and its derivatives (to be implemented)
# fedora-dependencies.sh for Fedora, Red Hat Linux, Bazzite, and other derivatives
# arch-dependencies.sh for Arch Linux, CachyOS, EndeavourOS, and other derivatives
# nix-dependencies.sh for NixOS (to be implemented)
# void-dependencies.sh for Void Linux (to be implemented)

# How to use: If you see "install x", refer to <distro>-dependencies.sh, or cargo_install_script.sh
# Otherwise, proceed with building by source as usual



# Spacedrive
# First install the requirements (if not yet downloaded)
# install rustup for Rust
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# install bun for JavaScript via tauri
# curl -fsSL https://bun.sh/install | bash
# a node build tool somehow needed
# npm install -g node-gyp

# Switch to source build directory
cd "/home/cream/Documents/sourcebuild"

# Clone the repository
git clone https://github.com/spacedriveapp/spacedrive
cd spacedrive

# Install dependencies
bun install
cargo run -p xtask -- setup  # generates .cargo/config.toml with aliases
cargo build # builds all core and apps (including the daemon and cli)

# Copy dependencies into the debug Folder ( probably windows only )
# Copy-Item -Path "apps\.deps\lib\*.dll" -Destination "target\debug" -ErrorAction SilentlyContinue
# Copy-Item -Path "apps\.deps\bin\*.dll" -Destination "target\debug" -ErrorAction SilentlyContinue

# Run the desktop app (automatically starts daemon)
cd apps/tauri
bun run tauri:dev



# MineGRUB and MineSDDM
# change directory to sourcebuild
cd /home/cream/Documents/sourcebuild

# install MineSDDM
# you can customize the installation path, which will then be your source path
git clone https://github.com/Davi-S/sddm-theme-minesddm.git ~/Documents/sourcebuild/sddm-theme-minesddm
sudo cp -r ~/Documents/sourcebuild/sddm-theme-minesddm /usr/share/sddm/themes/

# Then adjust the theme configuration file for SDDM
sudo sed -i 's/Theme=/Theme=minesddm/' /etc/sddm.conf

# The above line just does this: (changes the "Current" parameter to "minesddm")
# [Theme]
# Current=minesddm

# install Minecraft World Loading KDE Splash
git clone https://github.com/Samsu-F/minecraftworldloading-kde-splash ~/.local/share/plasma/look-and-feel/minecraftworldloading-kde-splash

# install Minecraft Main Menu for GRUB
git clone https://github.com/Lxtharia/minegrub-theme.git
cd minegrub-theme

# Optionally choose background
./choose_background.sh

# change paths in minegrub-update.service file to change all occurences of "grub" to "grub2"
sudo sed -i 's/\/boot\/grub/\/boot\/grub2/' ./minegrub-update.service

# Copy Minecraft Main Menu themes to GRUB
sudo cp -ruv ./minegrub /boot/grub/themes/

# install Minecraft World Selection for GRUB
git clone https://github.com/Lxtharia/minegrub-world-sel-theme.git && cd minegrub-world-sel-theme
sudo ./install_theme.sh

# install double-minegrub-menu
git clone https://github.com/Lxtharia/double-minegrub-menu.git
cd double-minegrub-menu
sudo ./install.sh



# Hyprland and its ecosystem
# hyprwayland-scanner (Aquamarine depends on this)
git clone --recursive https://github.com/hyprwm/hyprwayland-scanner.git
cd hyprwayland-scanner
cmake -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build -j `nproc`
sudo cmake --install build

# hyprutils (Aquamarine depends on this)
git clone https://github.com/hyprwm/hyprutils.git
cd hyprutils/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependencies that may be needed by aquamarine
# install libseat-devel \
# libinput-devel \
# wayland-protocols-devel.noarch \
# libdrm-devel \
# mesa-libgbm-devel \
# libdisplay-info-devel \
# hwdata-devel.noarch

# Aquamarine (Hyprland depends on this)
git clone --recursive https://github.com/hyprwm/aquamarine.git
cd aquamarine
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build

# hyprlang (Hyprland depends on this)
git clone --recursive https://github.com/hyprwm/hyprlang.git
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build

# dependencies that may be needed by hyprcursor
# install cairo-devel \
# libzip-devel \
# librsvg2-devel \
# tomlplusplus-devel

# hyprcursor (Hyprland depends on this)
git clone --recursive https://github.com/hyprwm/hyprcursor.git
cd hyprcursor
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build

# dnf installations that may be needed by hyprgraphics
# install pixman-devel \
# libjpeg-turbo-devel \
# libwebp-devel \
# libjxl-devel \
# file-devel \
# libpng-devel

# Notes:
# libjxl-devel is optional
# file-devel contains/is libmagic

# hyprgraphics (Hyprland depends on this)
git clone https://github.com/hyprwm/hyprgraphics
cd hyprgraphics/
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependencies that may be needed by Hyprland
# install libuuid-devel \
# re2-devel \
# muParser-devel \
# xcb-util-errors-devel \
# xcb-util-wm-devel

# Notes:
# use libuuid-devel for installing development files for uuid, not uuid-devel
# do not use libxcb-devel for xcb-icccm and xcb-errors
# use xcb-util-errors-devel for xcb-errors
# use xcb-util-wm-devel for xcb-icccm

# hyprwire (Hyprland depends on this)
git clone --recursive https://github.com/hyprwm/hyprwire.git
cd hyprwire
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# Hyprland (the very thing I need to install)
git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install

# Post-install (optional stuff for Hyprland dependencies as well as Hyprland ecosystem)

# dependency for hyprtoolkit
# install iniparser-devel

# hyprtoolkit (a dependency of many Hyprland ecosystem packages)
git clone --recursive https://github.com/hyprwm/hyprtoolkit.git
cd hyprtoolkit
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# hyprshutdown
git clone --recursive https://github.com/hyprwm/hyprshutdown.git
cd hyprshutdown
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependency for hyprlauncher
# install libqalculate-devel

# hyprlauncher
git clone --recursive https://github.com/hyprwm/hyprlauncher.git
cd hyprlauncher
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependencies for walker
# install gtk4-devel \
# gtk4-layer-shell-devel \
# poppler-glib-devel \
# protobuf-compiler

# dependency for elephant
# install golang-bin # Go compiler (gc)

# assuming you have not added go, set GOPATH and GOBIN
go env -w GOPATH=$HOME/go
go env -w GOBIN=$HOME/go/bin

# and add/append GOPATH and GOBIN to PATH in .bashrc (or .zshrc)
printf "export GOPATH=\"$HOME/go\"\nexport GOBIN=\"$GOPATH/bin\"\nexport PATH=\"$PATH:$GOBIN\"" >> ~/.bashrc

# elephant (walker needs this)
git clone https://github.com/abenz1267/elephant
cd elephant

# Build and install the main binary
cd cmd/elephant
go install elephant.go

# Create configuration directories
mkdir -p ~/.config/elephant/providers

# Build and install a provider (example: desktop applications)
cd ../../internal/providers/desktopapplications
go build -buildmode=plugin
cp desktopapplications.so ~/.config/elephant/providers/

# bookmarks provider
cd ../bookmarks
go build -buildmode=plugin
cp bookmarks.so ~/.config/elephant/providers/

# bluetooth provider
cd ../bluetooth
go build -buildmode=plugin
cp bluetooth.so ~/.config/elephant/providers/

# calculator provider
cd ../calc
go build -buildmode=plugin
cp calc.so ~/.config/elephant/providers/

# clipboard provider
cd ../clipboard
go build -buildmode=plugin
cp clipboard.so ~/.config/elephant/providers/

# files provider
cd ../files
go build -buildmode=plugin
cp files.so ~/.config/elephant/providers/

# menus provider
cd ../menus
go build -buildmode=plugin
cp menus.so ~/.config/elephant/providers/

# providerlist provider
cd ../providerlist
go build -buildmode=plugin
cp providerlist.so ~/.config/elephant/providers/

# runner provider
cd ../runner
go build -buildmode=plugin
cp runner.so ~/.config/elephant/providers/

# snippets provider
cd ../snippets
go build -buildmode=plugin
cp snippets.so ~/.config/elephant/providers/

# symbols provider
cd ../symbols
go build -buildmode=plugin
cp symbols.so ~/.config/elephant/providers/

# todo provider
cd ../todo
go build -buildmode=plugin
cp todo.so ~/.config/elephant/providers/

# unicode provider
cd ../unicode
go build -buildmode=plugin
cp unicode.so ~/.config/elephant/providers/

# websearch provider
cd ../websearch
go build -buildmode=plugin
cp websearch.so ~/.config/elephant/providers/

# windows provider
cd ../windows
go build -buildmode=plugin
cp windows.so ~/.config/elephant/providers/

# custom clipvault provider (requires clipvault, not provided in official repositories)
cd ../clipvault
go build -buildmode=plugin
cp clipvault.so ~/.config/elephant/providers/

# enable elephant as a service
elephant service enable

# walker (hyprlauncher alternative)
git clone https://github.com/abenz1267/walker.git
cd walker

# Build with Cargo
cargo build --release

# Run Walker
# ./target/release/walker

# or install it system-wide
sudo cp target/release/walker /usr/bin

# dependencies for hyprqt6engine
# install qt6-qtbase-devel \
# qt6-qtdeclarative-devel \
# qt6-qttools-devel \
# qt6-qtgraphs-devel \
# qt6-qtmultimedia-devel \
# qt6-qtsvg-devel \
# qt6-qtbase-private-devel

# Note: All of the packages above comprise the tools needed for qt6ct

# hyprqt6engine
git clone --recursive https://github.com/hyprwm/hyprqt6engine.git
cd hyprqt6engine
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependency for hyprpwcenter
# install pipewire-libs

# hyprpwcenter
git clone --recursive https://github.com/hyprwm/hyprpwcenter.git
cd hyprpwcenter
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# hyprland-guiutils
git clone --recursive https://github.com/hyprwm/hyprland-guiutils.git
cd hyprland-guiutils
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependencies for hyprsunset
git clone https://github.com/hyprwm/hyprland-protocols && cd hyprland-protocols
cmake -S . -B ./build
cmake --build ./build

# also do this for hyprland-protocols
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# hyprsunset
git clone --recursive https://github.com/hyprwm/hyprsunset.git
cd hyprsunset
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# sunsetr (hyprsunset, but automatically switches blue-light filter)
git clone https://github.com/psi4j/sunsetr.git &&
cd sunsetr

# Build with cargo
cargo build --release

# Then install manually
sudo cp target/release/sunsetr /usr/local/bin/

# hyprland-qt-support
git clone --recursive https://github.com/hyprwm/hyprland-qt-support.git
cd hyprland-qt-support
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# xdg-desktop-portal-hyprland
git clone --recursive https://github.com/hyprwm/xdg-desktop-portal-hyprland
cd xdg-desktop-portal-hyprland/
cmake -DCMAKE_INSTALL_LIBEXECDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -B build
cmake --build build
sudo cmake --install build

# dependencies for hyprpolkitagent
install polkit-devel \
polkit-qt6-1-devel

# Notes
# polkit-devel is polkit-agent-1
# polkit-qt6-1-devel is polkit-qt6-1

# hyprpolkitagent
git clone --recursive https://github.com/hyprwm/hyprpolkitagent.git
cd hyprpolkitagent
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# hyprsysteminfo
git clone --recursive https://github.com/hyprwm/hyprsysteminfo.git
cd hyprsysteminfo
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# hyprpaper
git clone --recursive https://github.com/hyprwm/hyprpaper.git
cd hyprpaper
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build

# hyprpicker
git clone --recursive https://github.com/hyprwm/hyprpicker.git
cd hyprpicker
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# dependency for hyprlock
# install sdbus-cpp-devel

# hyprlock
git clone --recursive https://github.com/hyprwm/hyprlock.git
cd hyprlock
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
cmake --build ./build --config Release --target hyprlock -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install build

# dependencies for hyprshot
# install slurp grim

# hyprshot (screenshot utility)
git clone https://github.com/Gustash/hyprshot.git Hyprshot
ln -s $(pwd)/Hyprshot/hyprshot $HOME/.local/bin
chmod +x Hyprshot/hyprshot

# hypridle (idle screen saver)
git clone https://github.com/hyprwm/hypridle.git
cd hypridle
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build

# waybar (status bar)
# install waybar

# ashell (also a status bar, alternative to waybar)
git clone https://github.com/MalpenZibo/ashell.git
cd ashell
cargo build --release

# To install it system-wide
sudo cp target/release/ashell /usr/bin

# Install meson, a build system used by SwayOSD
# install meson

# Dependencies for SwayOSD (if compiling from source)
# install sassc

# dnf dependencies for eww
# install libdbusmenu-devel \
libdbusmenu-gtk3-devel \
gtk-layer-shell-devel

# eww (Rust-based widget system, alternative to Quickshell)
echo "Creating temporary working directory for eww..."
rm -rf /tmp/eww
mkdir /tmp/eww
cd /tmp/eww
git clone https://github.com/elkowar/eww
cd eww
cargo build --release --no-default-features --features=wayland
cd target/release
chmod +x ./eww
sudo cp eww /usr/bin
# To open eww
# ./eww daemon
# ./eww open <window_name>

# SwayOSD (OSD for Hyprland)

# Use this below if downloading from cargo
# sudo dnf copr enable erikreider/swayosd
# # install swayosd

# Use this if building from source
git clone --recursive https://github.com/ErikReider/SwayOSD.git
cd SwayOSD
meson setup build --buildtype release
ninja -C build
meson install -C build

# Used for notifying when caps-lock, scroll-lock, and num-lock is changed.
sudo systemctl enable --now swayosd-libinput-backend.service

# clipvault (cliphist-inspired clipboard manager)
cargo install clipvault --locked

# dnf dependencies for awww
# install lz4-devel

# awww (Wayland Wallpaper Manager, formerly named swww)
git clone https://codeberg.org/LGFae/awww.git
cd awww
cargo build --release
sudo cp target/release/awww /usr/bin
sudo cp target/release/awww-daemon /usr/bin

# optionally copy awww completion files
# sudo cp completions/awww.bash ~/.local/share/bash-completion/completions/awww.bash
# sudo cp completions/_awww ~/.local/share/zsh/site-functions/_awww.zsh #sudo cp target/release/_awww ~/.local/share/zsh/site-functions/_awww.zsh # before
# sudo cp completions/awww.fish ~/.local/share/fish/vendor_completions.d/awww.fish # sudo cp target/release/awww.fish ~/.local/share/fish/vendor_completions.d/awww.fish # before
sudo cp completions/awww.fish /usr/share/fish/vendor_completions.d/awww.fish # for CachyOS

# waypaper (frontend for awww and hyprpaper)
sudo dnf copr enable solopasha/hyprland
# install waypaper

# fastfetch (system display)
# install fastfetch

# dnf dependencies for wleave
# install libadwaita-devel

# wleave (Wayland logout prompt utility based from wlogout, written in Rust)
git clone https://github.com/AMNatty/wleave.git
cd wleave
cargo build --release
sudo cp target/release/wleave /usr/bin

# tweaks from Hyprland

# from https://wiki.hypr.land/Nvidia/
# install egl-wayland2

# hyprland.conf necessities

# install brightnessctl # for brightness/backlight adjustment
# install nm-applet # used for Wi-Fi pop-up dialogs
# install gnome-keyring # needed as a keyring for nm-applet and NetworkManager on non-GNOME/non-KDE environments

# waybar necessities
# install pavucontrol # used to control audio
git clone https://github.com/bjesus/wttrbar.git
cd wttrbar
cargo build --release
sudo cp target/release/wttrbar /usr/bin



# Create some folders that might be needed
mkdir -p ~/.local/bin

# Dependencies for sherlock
# install git gtk4 gtk4-layer-shell dbus sqlite librsvg gdk-pixbuf2

# Install rust via this curl script
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Note: sqlite package provides libsqlite3-dev

# Go to temp directory
cd /tmp

# Clone the repository
git clone https://github.com/skxxtz/sherlock.git
cd sherlock

# Build sherlock
cargo build --release

# Install the binary
sudo cp target/release/sherlock /usr/local/bin/

# (Optional) Remove the build directory
rm -rf /tmp/sherlock

# Installing sherlock-wiki to access Wikipedia
# Go to temp directory
cd /tmp

# Clone the repository
git clone https://github.com/Skxxtz/sherlock-wiki.git
cd sherlock-wiki

# Build sherlock-wiki
cargo build --release

mkdir -p ~/.config/sherlock/scripts/
cp target/release/sherlock-wiki ~/.config/sherlock/scripts/

# Add the following to sherlock's fallback.json after
# {
#     "name": "Wikipedia Search",
#     "alias": "wiki",
#     "type": "bulk_text",
#     "on_return": "next",
#     "async": true,
#     "args": {"icon": "wikipedia", "exec": "~/.config/sherlock/scripts/sherlock-wiki", "exec-args": "'{keyword}'"},
#     "priority": 0
# }

# (Optional) Remove the build directory
rm -rf /tmp/sherlock-wiki

# Installing sherlock-confetti

# Install dependencies for sherlock-confetti
# install libxkbcommon vulkan-icd-loader mesa wayland wayland-protocols

# Go to temp directory
cd /tmp

# Clone the repository
git clone https://github.com/skxxtz/sherlock-confetti.git
cd sherlock-confetti

# Build sherlock-confetti
cargo build --release

# Install the binary
sudo cp target/release/confetti /usr/local/bin/

# (Optional) Remove the build directory
rm -rf /tmp/sherlock-confetti

# Installing sherlock-dict to access dictionary entries via dict.org

# Go to temp directory
cd /tmp

# Clone the repository
git clone https://github.com/MoonBurst/sherlock_dict_rs.git

# Change directory into the newly created one
cd sherlock_dict_rs

# Build the binary
cargo build --release

# Move the binary to the scripts directory
mv target/release/sherlock-dictionary ~/.config/sherlock/scripts/

# Add the following to sherlock's fallback.json after (and running it with "define $words")
# {
#     "name": "Dictionary Lookup",
#     "alias": "define",
#     "type": "bulk_text",
#     "async": true,
#     "args": {
#         "icon": "dictionary",
#         "exec": "~/.config/sherlock/scripts/sherlock-dictionary",
#         "exec-args": "{keyword}"
#     },
#     "priority": 0,
#     "shortcut": false
# }

# (Optional) Remove the build directory
sudo rm -rf /tmp/sherlock-dict

# Installing wayshot as a Rust-native alternative to hyprshot

# Install dependencies for wayshot
# install scdoc rustup make

# Install wayshot
cd /tmp
git clone https://github.com/waycrate/wayshot && cd wayshot
make setup
make
sudo make install
sudo rm -rf /tmp/wayshot

# Before you use wayshot, create the directory which you will save screenshots in
# For my case, it's ~/Pictures/Wayshot Screenshots
mkdir -p ~/Pictures/Wayshot\ Screenshots

# Go to temp directory
cd /tmp

# Clone the repository
# git clone https://github.com/Skxxtz/sherlock-clipboard.git
# cd sherlock-clipboard

# Build the binary
# cargo build --release

# Install the binary
# sudo cp target/release/sherlock-clp /usr/local/bin/

# (Optional) Remove the build directory
# sudo rm -rf /tmp/sherlock-clipboard

# My personal alternative to sherlock-clipboard, sherlock-clipvault, which uses clipvault
cd /tmp
git clone https://github.com/DeltaCream/sherlock-clipvault.git
cd sherlock-clipvault
cargo build --release
sudo cp target/release/sherlock-clipvault /usr/local/bin/
sudo rm -rf /tmp/sherlock-clipvault

# ironbar installation
# build requirements for ironbar
# install gtk4 gtk4-layer-shell dbus pkg-config
# for http support
# install openssl
# for volume support
# install libpulse
# for keyboard support
# install libinput
# for lua/cairo support
# install luajit lua51-lgi

# runtime requirements for ironbar
# for lua/cairo support
# install lua51-lgi

cd /tmp
git clone https://github.com/jakestanger/ironbar.git
cd ironbar
cargo build --release # you can add or remove --locked flag
# change path to wherever you want to install
install target/release/ironbar ~/.local/bin/ironbar # or /usr/local/bin/
sudo rm -rf /tmp/ironbar

# Install meson, a build system used by SwayOSD (if compiling from source)
# install meson

# Dependencies for SwayOSD (if compiling from source)
# install sassc

# SwayOSD (OSD for Hyprland)
# Note that SwayOSD is present in CachyOS' repos
# install SwayOSD
# Or build from source
cd /tmp
git clone --recursive https://github.com/ErikReider/SwayOSD.git
cd SwayOSD
# Please note that the command below might require `--prefix /usr` on some systems
meson setup build --buildtype release
meson compile -C build
meson install -C build
sudo rm -rf /tmp/SwayOSD

# Installing an updated fork of rsmatrix, a cmatrix Rust clone
cd /tmp
git clone https://github.com/DeltaCream/rsmatrix.git
cd rsmatrix
cargo build --release
sudo cp target/release/rsmatrix /usr/local/bin
sudo rm -rf /tmp/rsmatrix

# curl script to install unimatrix, a Unicode variant based on cmatrix
sudo curl -L https://raw.githubusercontent.com/will8211/unimatrix/master/unimatrix.py -o /usr/local/bin/unimatrix
sudo chmod a+rx /usr/local/bin/unimatrix

# Installing cmatrix, the original Matrix-like effect simulator on the terminal
# install cmatrix

# pacman dependencies for wleave
# install gtk4-layer-shell gtk4 librsvg libadwaita

# wleave (Wayland logout prompt utility based from wlogout, written in Rust)
cd /tmp
git clone https://github.com/AMNatty/wleave.git
cd wleave
cargo build --release
sudo cp target/release/wleave /usr/bin
# Optionally copy wleave.fish
sudo cp completions/wleave.fish /usr/share/fish/vendor_completions.d/wleave.fish
sudo rm -rf /tmp/wleave

# Optionally copy wleave icons to /usr/share
sudo mkdir -p /usr/share/wleave/icons # create the wleave/icons directory on /usr/share just in case
sudo cp wleave/icons/* /usr/share/wleave/icons # or more specifically icons/*.svg

# awww (Wayland Wallpaper Manager, formerly named swww)
git clone https://codeberg.org/LGFae/awww.git
cd awww
cargo build --release
sudo cp target/release/awww /usr/bin
sudo cp target/release/awww-daemon /usr/bin
# Generate man pages, installing *scdoc* required
./doc/gen.sh
# Move generated man pages to /usr/local/share/man
# Why /usr/local/share instead of /usr/share or /usr/local?
# Because /usr/local/share holds read-only, architecture-independent data for applications installed in /usr/local
# Which are basically documentation files or configuration files for a locally compiled/installed program
sudo mv doc/generated/* /usr/local/share/man


# optionally copy awww completion files
# sudo cp completions/awww.bash ~/.local/share/bash-completion/completions/awww.bash
# sudo cp completions/_awww ~/.local/share/zsh/site-functions/_awww.zsh
# sudo cp completions/awww.fish ~/.local/share/fish/vendor_completions.d/awww.fish

# For CachyOS vendor completions for fish
sudo cp completions/awww.fish /usr/share/fish/vendor_completions.d/awww.fish

# Creation of symlinks for waypaper in case it somehow only recognizes swww (awww's old name) and not awww
sudo ln -s /usr/bin/awww-daemon /usr/bin/swww-daemon
sudo ln -s /usr/bin/awww /usr/bin/swww

# Install waypaper
# install waypaper

# Install hyprpaper
# install hyprpaper

# Install uv
# Either:
# # install uv
# or
curl -LsSf https://astral.sh/uv/install.sh | sh

# Then optionally add shell completion for uv commands and uvx for fish
# echo 'uv generate-shell-completion fish | source' > ~/.config/fish/completions/uv.fish
# echo 'uvx --generate-shell-completion fish | source' > ~/.config/fish/completions/uvx.fish
# For CachyOS specifically (which uses /usr/share/fish/completions)
# echo 'uv generate-shell-completion fish | source' > /usr/share/fish/completions/uv.fish
# echo 'uvx --generate-shell-completion fish | source' > /usr/share/fish/completions/uvx.fish

# Install Stirling PDF
# Reference: https://docs.stirlingpdf.com/Installation/Unix%20Installation/
# install git automake autoconf libtool \
    leptonica pkg-config make gcc \
    jdk21-openjdk

# Notes:
# leptonica is libleptonica-dev for CachyOS
# zlib-ng-compat *might* count as zlib1g-dev for CachyOS
# jdk21-openjdk is openjdk-21-jdk for CachyOS
# Installing python on Arch/CachyOS *might* install both python3 and python3-pip

# Clone and Build jbig2enc (Only required for certain OCR functionality)
mkdir ~/.git
cd ~/.git &&\
git clone https://github.com/agl/jbig2enc.git &&\
cd jbig2enc &&\
./autogen.sh &&\
./configure &&\
make &&\
sudo make install

# Install Additional Software
# LibreOffice for conversions, tesseract for OCR, and opencv for pattern recognition functionality
# Also include OCR Language Support for English and Filipino
# installyu libreoffice-fresh tesseract tesseract-data-eng tesseract-data-fil
uv pip install uno opencv-python-headless unoserver pngquant WeasyPrint

# Notes:
# libreoffice-fresh-xx installs Libre Office with the latest features
# while libreoffice-still-xx installs the most stable version of Libre Office
# either of the two options install the *entire* Libre Office suite including:
# LibreOffice Writer, LibreOffice Calc, LibreOffice Impress, LibreOffice Draw, LibreOffice Base, and LibreOffice Math

# Install
sudo wget https://files.stirlingpdf.com/Stirling-PDF-with-login.jar
sudo chmod +x Stirling-PDF-with-login.jar

# Install GitHub repository Stirling PDF
cd ~/.git
git clone https://github.com/Stirling-Tools/Stirling-PDF.git
cd Stirling-PDF
sudo mv scripts /opt/Stirling-PDF

# Add a Desktop Icon (Bash)
# location=$(pwd)/gradlew
# image=$(pwd)/docs/stirling-transparent.svg

# cat > ~/.local/share/applications/Stirling-PDF.desktop <<EOF
# [Desktop Entry]
# Name=Stirling PDF;
# GenericName=Launch StirlingPDF and open its WebGUI;
# Category=Office;
# Exec=xdg-open http://localhost:8080 && nohup $location java -jar /opt/Stirling-PDF/Stirling-PDF-*.jar &;
# Icon=$image;
# Keywords=pdf;
# Type=Application;
# NoDisplay=false;
# Terminal=true;
# EOF

# Fish equivalent script
set location "$PWD/gradlew"
set image "$PWD/docs/stirling-transparent.svg"

printf '[Desktop Entry]
Name=Stirling PDF
GenericName=Launch StirlingPDF and open its WebGUI
Category=Office
Exec=sh -c "xdg-open http://localhost:8080 && nohup %s java -jar /opt/Stirling-PDF/Stirling-PDF-*.jar &"
Icon=%s
Keywords=pdf;
Type=Application
NoDisplay=false
Terminal=true' "$location" "$image" > ~/.local/share/applications/Stirling-PDF.desktop

# Download devtui
# The format to download a latest release file from a repository is the following:
# curl -L https://github.com/<owner>/<repository>/releases/latest/download/<asset_name> -O
curl -L https://github.com/skatkov/devtui/releases/latest/download/devtui_Linux_x86_64.tar.gz  -O

# Extract devtui
tar -xvf devtui_Linux_x86_64.tar.gz
rm devtui_Linux_x86_64.tar.gz LICENSE README.md # optionally include the LICENSE file and README.md

# Move devtui to /usr/local/bin
sudo mv devtui /usr/local/bin

# Install skim
# install skim # or cargo install skim

# For fish, add to ~/.config/fish/completions/
# sk --shell fish > ~/.config/fish/completions/sk.fish

# Specifically for CachyOS, use sudo tee because writing to /usr/share requires root privileges
sk --shell fish | sudo tee /usr/share/fish/completions/sk.fish

# Install zoxide
# install zoxide
# Then add to ~/.config/fish/config.fish
echo 'zoxide init fish | source' >> ~/.config/fish/config.fish

# The entire set you would need for Hyprland
# install hyprland
# Must-haves: https://wiki.hypr.land/Useful-Utilities/Must-have/
# Install notification daemon here, e.g. dunst, mako, fnott and swaync
# Update: chosen notification daemon is end-rs
# install pipewire wireplumber
# install xdg-desktop-portal-hyprland
# install hyprpolkitagent
# install qt5-wayland qt6-wayland
# Install fonts here
# Status Bars: https://wiki.hypr.land/Useful-Utilities/Status-Bars/
# e.g. waybar, ashell, ironbar, astal or ags, eww, quickshell
# Wallpapers: https://wiki.hypr.land/Useful-Utilities/Wallpapers/
# e.g. hyprpaper, mpvpaper, awww, waypaper, wallrizz
# App launcher: sherlock
# install hyprpicker
# install clipvault
# install dolphin # or yazi
# install udiskie # for automatic disk mounting
# Hyprland ecosystem
# install  hyprpaper hypridle hyprlock hyprsunset hyprpwcenter
# install hyprsysteminfo hyprshutdown # Only available in the AUR
# Utilities
# install sunsetr
# For screenshot utility, either go wayshot or hyprshot

# Install end-rs, probably the *only* notification daemon I know for Hyprland built in Rust
# end-rs is inspiredfrom end, or Eww Notification Daemon, which was written in Haskell
# Compile from source
cd /tmp
git clone https://github.com/Dr-42/end-rs
cd end-rs
cargo build --release
sudo cp target/release/end-rs /usr/bin/
sudo rm -rf /tmp/end-rs
# Or just install from crates.io
cargo install end-rs

# After installation, create eww folder for end-rs configs if the folder has not been created yet
mkdir -p ~/.config/eww
# end-rs generate yuck # If you want to generate yuck file only
# end-rs generate scss # If you want to generate scss file only
end-rs generate all # Generates both yuck and scss files for end-rs

# Install package dependencies for eww
# install gtk-layer-shell

# Install eww, the very widget system that end-rs is based on
cd /tmp
git clone https://github.com/elkowar/eww
cd eww
cargo build --release --no-default-features --features=wayland
chmod +x target/release/eww
# Put eww on ~/.local/bin to ensure compatibility with end-rs
sudo cp target/release/eww ~/.local/bin
sudo rm -rf /tmp/eww

# Installing RustConn (a connection app for various remote connections)
# dependencies
# install vte4 # for vte-2.91-gtk4, required by the vte4-sys crate

# From source
cd /tmp
git clone https://github.com/totoshko88/rustconn.git
cd rustconn
cargo build --release
sudo cp target/release/rustconn /usr/bin
sudo rm -rf /tmp/rustconn

# Install wayle, Wayland Elements
cd /tmp
git clone --recursive https://github.com/Jas-SinghFSU/wayle
cd wayle
# cargo install --path crates/wayle-shell # pre-0.1.0
cargo install --path wayle
sudo rm -rf /tmp/wayle

# Install bundled icons (automatic on first launch)
wayle icons setup
wayle panel start

# Install sherlock-gpui
cd /tmp
git clone https://github.com/skxxtz/sherlock-gpui.git
cd sherlock-gpui

# Build sherlock
cargo build --release

# Install the binary
sudo cp target/release/sherlock-gpui /usr/local/bin/

# (Optional) Remove the build directory
rm -rf /tmp/sherlock-gpui

# Install cursor-clip, a Windows 11-like clipboard history
# Clone the repository
git clone https://github.com/Sirulex/cursor-clip
cd cursor-clip

# Build in release mode
cargo build --release
sudo cp target/release/cursor-clip /usr/bin

# Install zlaunch, a gpui-based app launcher built in Rust
cd /tmp
git clone https://github.com/zortax/zlaunch.git
cd zlaunch
cargo build --release
sudo cp target/release/zlaunch /usr/local/bin

# (Optional) Remove the build directory
rm -rf /tmp/zlaunch
