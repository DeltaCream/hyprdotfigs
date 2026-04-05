#!/usr/bin/env bash

set -euo pipefail

# Adding plugin support for various audio filters
sudo pacman -S lsp-plugins

sudo pacman -S calf

# Installing DeepFilterNet
# Either:
# Compiling from source:
# git clone https://github.com/Rikorose/DeepFilterNet.git
# cargo build --release -p deep-filter-ladspa
# ls target/release/libdeep_filter_ladspa* # here should be the compiled plugin

# Or... downloading an so file
# Credits to Adam Gradzki: https://adamgradzki.com/adding-deepfilternet-noise-reduction-to-easy-effects-on-arch-linux.html

# Example downloading version 0.5.6 for x86_64
curl -LO https://github.com/Rikorose/DeepFilterNet/releases/download/v0.5.6/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so

# Move the plugin to the system LADSPA directory and rename it
sudo mv -v libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so /usr/lib64/ladspa/libdeep_filter_ladspa.so

# Check that the file exists and has appropriate permissions
ls -la /usr/lib64/ladspa/libdeep_filter_ladspa.so
