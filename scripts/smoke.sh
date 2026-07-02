#!/usr/bin/env bash
set -euo pipefail

cargo run -p monad-cli -- --help
cargo run -p monad-cli -- version --verbose
cargo run -p monad-cli -- pack list
cargo run -p monad-cli -- policy check --help
cargo run -p monad-cli -- workpacket plan --help
