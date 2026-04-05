#!/usr/bin/env bash
# Building from the ground up for CachyOS, with some conveniences by downloading via pacman and paru
# Create some folders that might be needed
mkdir -p ~/.local/bin

# Dependencies for sherlock
paru -S git gtk4 gtk4-layer-shell dbus sqlite librsvg gdk-pixbuf2

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
paru -S libxkbcommon vulkan-icd-loader mesa wayland wayland-protocols

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
paru -S scdoc rustup make

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
sudo pacman -S gtk4 gtk4-layer-shell dbus pkg-config
# for http support
sudo pacman -S openssl
# for volume support
sudo pacman -S libpulse
# for keyboard support
sudo pacman -S libinput
# for lua/cairo support
sudo pacman -S luajit lua51-lgi

# runtime requirements for ironbar
# for lua/cairo support
sudo pacman -S lua51-lgi

cd /tmp
git clone https://github.com/jakestanger/ironbar.git
cd ironbar
cargo build --release # you can add or remove --locked flag
# change path to wherever you want to install
install target/release/ironbar ~/.local/bin/ironbar # or /usr/local/bin/
sudo rm -rf /tmp/ironbar

# Install meson, a build system used by SwayOSD (if compiling from source)
sudo pacman -S meson

# Dependencies for SwayOSD (if compiling from source)
sudo pacman -S sassc

# SwayOSD (OSD for Hyprland)
# Note that SwayOSD is present in CachyOS' repos
sudo pacman -S SwayOSD
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
sudo pacman -S cmatrix

# pacman dependencies for wleave
sudo pacman -S gtk4-layer-shell gtk4 librsvg libadwaita

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
sudo pacman -S waypaper

# Install hyprpaper
sudo pacman -S hyprpaper

# Install uv
# Either:
# sudo pacman -S uv
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
sudo pacman -S git automake autoconf libtool \
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
sudo pacman -Syu libreoffice-fresh tesseract tesseract-data-eng tesseract-data-fil
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
sudo pacman -S skim # or cargo install skim

# For fish, add to ~/.config/fish/completions/
# sk --shell fish > ~/.config/fish/completions/sk.fish

# Specifically for CachyOS, use sudo tee because writing to /usr/share requires root privileges
sk --shell fish | sudo tee /usr/share/fish/completions/sk.fish

# Install zoxide
sudo pacman -S zoxide
# Then add to ~/.config/fish/config.fish
echo 'zoxide init fish | source' >> ~/.config/fish/config.fish

# The entire set you would need for Hyprland
sudo pacman -S hyprland
# Must-haves: https://wiki.hypr.land/Useful-Utilities/Must-have/
# Install notification daemon here, e.g. dunst, mako, fnott and swaync
# Update: chosen notification daemon is end-rs
sudo pacman -S pipewire wireplumber
sudo pacman -S xdg-desktop-portal-hyprland
sudo pacman -S hyprpolkitagent
sudo pacman -S qt5-wayland qt6-wayland
# Install fonts here
# Status Bars: https://wiki.hypr.land/Useful-Utilities/Status-Bars/
# e.g. waybar, ashell, ironbar, astal or ags, eww, quickshell
# Wallpapers: https://wiki.hypr.land/Useful-Utilities/Wallpapers/
# e.g. hyprpaper, mpvpaper, awww, waypaper, wallrizz
# App launcher: sherlock
sudo pacman -S hyprpicker
paru -S clipvault
sudo pacman -S dolphin # or yazi
sudo pacman -S udiskie # for automatic disk mounting
# Hyprland ecosystem
sudo pacman -S  hyprpaper hypridle hyprlock hyprsunset hyprpwcenter
paru -S hyprsysteminfo hyprshutdown # Only available in the AUR
# Utilities
paru -S sunsetr
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
sudo pacman -S gtk-layer-shell

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
paru -S vte4 # for vte-2.91-gtk4, required by the vte4-sys crate

# From source
cd /tmp
git clone https://github.com/totoshko88/rustconn.git
cd rustconn
cargo build --release
sudo cp target/release/rustconn /usr/bin
sudo rm -rf /tmp/rustconn
