#!/usr/bin/env bash
# Runs ONCE, when the container is first created — and, crucially, at PREBUILD
# time. That is the only reason this is a separate file from post-create.sh.
#
# GitHub Codespaces bakes `onCreateCommand` and `updateContentCommand` into the
# prebuilt image, but re-runs `postCreateCommand` for every codespace created
# from it. So everything slow, network-heavy, and identical for every student
# belongs here: elan, the Mathlib cache, and the shared import surface. With
# `lake exe cache get` in postCreateCommand instead, every student would sit
# through the download at the start of every practical and prebuilds would buy
# nothing.
set -euo pipefail
cd "$(dirname "$0")/.."

# elan is the Lean version manager; --default-toolchain none because the
# version we want is whatever lean-toolchain says, installed on the next line.
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y --default-toolchain none
# shellcheck disable=SC1091
source "$HOME/.elan/env"
grep -q 'elan/env' "$HOME/.bashrc" || echo 'source $HOME/.elan/env' >> "$HOME/.bashrc"

elan toolchain install "$(cat lean-toolchain)"

# Mathlib, pre-built. Without this Lean builds it from source, which takes
# hours; see docs/setup.md.
lake exe cache get
lake build Thread3.Common
