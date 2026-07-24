#!/usr/bin/env bash

# Only applicable for CachyOS with Limine
sudo rm -rf /var/lib/sbctl # delete secure boot folder
sudo paru -Rns sbctl # delete sbctl
sudo paru -Syu sbctl # install sbctl again

# Secure Boot Setup Proper
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
# sudo sbctl status

# Extra Limine steps
sudo limine-enroll-config
sudo limine-update

# Dealing with the BOOTX64.EFI quirk
sudo sbctl verify
sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
