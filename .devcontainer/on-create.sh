#!/usr/bin/env bash
# Runs ONCE, when the container is first created.
#
# This file was split out from post-create.sh for Codespaces prebuilds. GitHub
# baked `onCreateCommand` and `updateContentCommand` into the prebuilt image
# and re-ran `postCreateCommand` for every codespace made from it, so
# everything slow, network-heavy and identical for every student belonged
# here: elan, the Mathlib cache, and the shared import surface.
#
# THERE IS NO PREBUILD ANY MORE. GitHub Classroom, which carried the
# organisation prebuild benefit, was retired on 2026-08-28; prebuilds now need
# an organisation payment method and do not reach forks. Both scripts run at
# creation and every student waits through all of this once.
#
# Keep the split regardless. It is the seam along which the slow work can be
# moved into a prebuilt image published to GHCR, which is the supported way to
# get the wait back down (docs/teaching-pack.md, Appendix A). Do not merge
# these two files.
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
