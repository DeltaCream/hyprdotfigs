#!/usr/bin/env bash

set -euo pipefail

# This script is meant for Rust/cargo installations, both libraries and binaries.
# As such, this will be separated between binaries and libraries.

# typst
cargo install --locked typst-cli

# command-line stuff
cargo install du-dust # du but for Rust; du + Rust = dust
cargo install bat # Rust version of cat; cat with wings
cargo install ripgrep # Rust version of grep
cargo install fd # fast, pretty drop-in replacement for find
cargo install eza # drop-in replacement for ls; a well-maintained fork of exa, which is a fork of ls
cargo install zoxide # a smarter cd command for your terminal
cargo install dua # interactive disk use analyzer
cargo install skim # fuzzy finder for Rust

# No Boilerplate's recommendations
# https://www.youtube.com/watch?v=dFkGNe4oaKk
# https://www.youtube.com/watch?v=rWMQ-g2QDsI
cargo install sccache # reduces compile times by reusing compiled artifacts to skip redundant compilation
# Then use "RUSTC_WRAPPER=sccache cargo install {package}"
cargo install nu # nu shell
cargo install coreutils # Rust rewrite of the GNU coreutils by uutils
cargo install starship # shell prompt customizer
# cargo install eza # a well-maintained fork of exa, which is a fork of ls
# cargo install du-dust
cargo install zellij # terminal multiplexer for code workspaces with batteries included; tmux alternative
cargo install mprocs # terminal process runner; allows monitoring of process output
# cargo install ripgrep
cargo install bob-nvim # cross-platform Neovim version manager
cargo install gitui # performant terminal UI for git
cargo install irust # interactive rust coding
cargo install evcxr_jupyter # Jupyter Notebook Rust kernel, recommended if running irust on a web browser
cargo install bacon # *Recommended* can act as an auto-reloader and linter; tip: use "bacon clippy"
cargo install cargo-info # options to show the features of a cargo crate as well as its info
cargo install ncspot # ncurses version of Spotify with vim bindings
cargo install porsmo # command line pomodoro timer for the terminal
cargo install speedtest-rs # test your internet speed via speedtest on the command line
cargo install wiki-tui # Wikipedia on a terminal user interface
cargo install mise # short for mise-en-place (French for "setting things up in their place"; formerly known as rtx or rtx-cli; asdf rust clone; polyglot (multiple programming languages) runtime manager
cargo install fish # friendly, interactive shell
cargo install nushell # probably also nu
# cargo install fd
# cargo install zoxide
cargo install xh # friendly and fast tool for sending HTTP requests; simpler interface than curl with pretty-print; inspired by httpie
# cargo install dua
cargo install yazi # terminal file manager
cargo install hyperfine # command line benchmarking tool
cargo install evil-helix # helix with vim bindings
cargo install fselect # find files with SQL-like queries
cargo install rusty-man # command line viewer for rust.doc documentation
cargo install delta # syntax highlighting pager for git; prettier backend for "git diff" and other commands; tip: edit your git config to use delta
cargo install ripgrep-all # rga; ripgrep, but also search in PDFs, e-books, office documents, zip, tar.gz, etc.
cargo install tokei # recursively counts lines of code (LoC) in a project and summarizes by language; handy for a project's README
cargo install just # just a command runner; sane, modern make replacement for running and chaining commands in a project
cargo install mask # cli task runner defined by a simple markdown file
cargo install presenterm # a terminal slideshow presentation tool
cargo install kondo # dependency and build artifact cleaner for projects
cargo install espanso # cross-platform text expander

# Applications
cargo install alacritty
cargo install weathr # terminal weather app with ascii animation
cargo install wallust # wallpaper color theme manager
