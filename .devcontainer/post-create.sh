#!/usr/bin/env bash
# Runs on every container creation, and must stay cheap. Everything here is
# idempotent.
#
# This is now the load-bearing half of the dev container setup, and it was
# nearly decorative before. `.devcontainer/on-create.sh` is gone: elan, the
# toolchain, Mathlib's pre-built oleans and Thread3.Common all moved into
# .devcontainer/Dockerfile and are baked into the image devcontainer.json
# pulls. Appendix A of docs/teaching-pack.md is explicit that this was the one
# circumstance in which taking that work out of the script was correct rather
# than a mistake.
#
# Two jobs are left, and they are the two the image cannot do for itself:
#
#  1. Point .lake at the pre-built state. The image cannot deliver it in
#     place: Codespaces mounts the cloned repository over /workspaces, so
#     anything the image build wrote there is invisible at runtime. The
#     Dockerfile therefore builds into $THREAD3_SEED, outside the workspace,
#     and this SYMLINKS it in rather than copying it. Copying would write a
#     second 7.5 GB into a 32 GB container and put one stored codespace over
#     a student's whole 15 GB storage allowance; the symlink costs nothing and
#     is instant. Lake writes through it into the image's writable overlay,
#     which is ordinary container behaviour.
#  2. Reconcile the image with this checkout. devcontainer.json tracks the
#     image by :latest, and a student's fork can be older or newer than the
#     image they get. If Thread3/Common.lean or the pins here disagree with
#     the ones the image was built from, `lake build` below notices and the
#     fallback fetches what is missing. That is the case this script was
#     originally written for, back when a prebuild was what might go stale.
set -uo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
source "$HOME/.elan/env"

SEED=${THREAD3_SEED:-/opt/thread3-seed}

if [ ! -e .lake ] && [ -d "$SEED/.lake" ]; then
  echo "Linking the pre-built Lean state ($(du -sh "$SEED/.lake" | cut -f1))."
  ln -s "$SEED/.lake" .lake
elif [ ! -e .lake ]; then
  # Only reachable if the container was built from something other than our
  # image — a local `docker build` of the base image, say. The fallback below
  # handles it, slowly.
  echo "note: no pre-built Lean state in this image; building from the cache instead."
fi

if ! lake build Thread3.Common; then
  echo
  echo "Thread3.Common needs Mathlib modules this image does not have."
  echo "Fetching the cache — a few minutes, once."
  lake exe cache get
  lake build Thread3.Common
fi

cat <<'EOF'

  Setup finished.

  Open Thread3/Week01.lean from the Explorer on the left, then wait for the
  Infoview to appear on the right. That can take a minute the first time.

  This codespace stops after 30 minutes of inactivity and your files are kept.
  Commit and push your work anyway — see the README.

EOF
