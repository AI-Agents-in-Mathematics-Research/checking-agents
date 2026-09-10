#!/usr/bin/env bash
# Runs on every codespace creation, including from a prebuilt image, so it must
# stay cheap. Everything here is idempotent and a no-op on a warm prebuild.
#
# It exists to cover the one case a prebuild cannot: commits pushed since the
# prebuild was made that changed Thread3/Common.lean, and so need Mathlib
# modules the baked cache does not contain. `lake build` is seconds when there
# is nothing to do, and only then do we pay for a fetch.
set -uo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC1091
source "$HOME/.elan/env"

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
