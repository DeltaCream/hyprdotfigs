
# For cursor-clip
sudo pacman -S gtk4 libadwaita gtk4-layer-shell

# For hyprland (compiling from source)
paru -S ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprwire-git xcb-util-errors hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git muparser

# For hyprland (via CachyOS repos)
sudo pacman -S hyprlang hyprcursor hyprwayland-scanner hyprwire hyprutils hyprgraphics aquamarine hyprland-qtutils

# For wayle
sudo pacman -S --needed git gtk4 gtk4-layer-shell gtksourceview5 \
  libpulse fftw libpipewire systemd-libs clang base-devel

# For wayle (wayle-settings)
# paru -S gtksourceview5

# Runtime daemons for the battery, bluetooth, network, power, and audio modules (skip any you don't need)
sudo pacman -S --needed bluez bluez-utils networkmanager upower \
  power-profiles-daemon pipewire wireplumber pipewire-pulse
sudo systemctl enable --now bluetooth NetworkManager upower power-profiles-daemon

# For wleave
sudo pacman -S gtk4-layer-shell gtk4 librsvg libadwaita
