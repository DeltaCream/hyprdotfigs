#!/usr/bin/env bash

# exit on errors
set -euo pipefail

cd ../../sherlock-gpui
cargo update
cargo build --release
sudo cp target/release/sherlock-gpui /usr/local/bin

echo "sherlock-gpui binary built and updated!"
