# Differences between the different bin files

/bin: Contains essential system binaries required for minimal system functionality, such as ls, mv, and mkdir. These commands must be available even if other filesystems (like /usr) are not yet mounted.

/usr/bin: Contains most user-space executable programs that are not essential for basic system booting or repair.

/usr/local/bin: The conventional place for locally-installed software, compiled from source or installed outside of the distribution's package manager.

~/bin (or ~/.local/bin): A directory within a user's home directory (~) for personal scripts and programs. This is typically included in the user's $PATH by default in modern distributions, but only if the directory exists.

~/.cargo/bin: The directory where Rust-based binaries are installed with `cargo install`
