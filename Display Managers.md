# Switch Display Managers

To switch display managers (also known as login managers), you need to run something like this:

```sh
sudo systemctl disable <old-dm> && sudo systemctl enable <new-dm>
```

Where <old-dm> and <new-dm> correspond to your current display manager and the new display manager, respectively.

For example, to switch from greetd to sddm, do this:

```sh
sudo systemctl disable greetd && sudo systemctl enable sddm
```

# SDDM

## Adding themes

Add themes under /usr/share/sddm/themes/

## Testing themes

sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/theme-name
Example:
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/Candy
for Candy theme

Note: theme names are case-sensitive. If you have a theme named "elarun", type /usr/share/sddm/themes/elarun, not /usr/share/sddm/themes/Elarun.

## Missing stuff on some themes

Some themes, like Candy and Corners need this for certain graphical effects, which uses qt5. The current latest version for Qt is qt6.
sudo pacman -S qt5-graphicaleffects
This one is for controls:
sudo pacman -S qt5-quickcontrols2
sudo pacman -S qt5-quickcontrols

## Customization

The file is located at /etc/sddm.conf
