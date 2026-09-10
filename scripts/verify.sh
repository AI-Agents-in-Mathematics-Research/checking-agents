#!/usr/bin/env bash
# Build every file in the module and report sorry usage per file.
#
# Expected: exercise files contain many `sorry`; Week05Audit contains exactly
# one (deliberately, in a private helper lemma); every Solutions file contains
# NONE and compiles cleanly. Any deviation in the last of those is a defect.
set -uo pipefail
cd "$(dirname "$0")/.."

# --- build the modules that other files import ---------------------------
#
# `lake env lean FILE` elaborates FILE but writes no .olean, so any file whose
# first line is `import Thread3.Common` fails with
#
#     error: unknown module prefix 'Thread3'
#
# unless that module has already been built. On a developer machine it usually
# has been; on a fresh checkout it has not, because `lake exe cache get` fetches
# Mathlib's cache and nothing of ours. That made this script pass locally and
# fail in CI. Build them here so both behave the same.
#
# The list is derived from the imports rather than hardcoded, so adding a new
# shared module does not silently reintroduce the bug.
prereqs=$(grep -rhoE '^import Thread3\.[A-Za-z0-9_.]+' Thread3 --include='*.lean' \
          | awk '{print $2}' | sort -u)
if [ -n "$prereqs" ]; then
  echo "building imported modules:" $prereqs
  # shellcheck disable=SC2086
  if ! lake build $prereqs; then
    echo >&2
    echo "FAILED to build prerequisite modules — aborting before the file checks," >&2
    echo "since every file importing them would report a spurious error." >&2
    exit 1
  fi
  echo
fi

fail=0
files=$(find Thread3 -name '*.lean' | sort)

printf '%-42s %-10s %-8s %s\n' FILE COMPILES WARNSORRY TEXTSORRY
printf '%-42s %-10s %-8s %s\n' "------------------------------------------" "--------" "--------" "---------"

for f in $files; do
  out=$(lake env lean "$f" 2>&1)
  rc=$?
  # Lean emits: declaration uses `sorry`   (backticks on 4.30; quotes earlier)
  n=$(printf '%s\n' "$out" | grep -c "declaration uses")
  # Independent check: `sorry` in code, ignoring comments and docstrings, so
  # that prose discussing `sorry` does not trip the check.
  t=$(python3 scripts/count_sorry.py "$f")
  if [ $rc -eq 0 ]; then ok=yes; else ok=NO; fi
  printf '%-42s %-10s %-8s %s\n' "$f" "$ok" "$n" "$t"

  if [ $rc -ne 0 ]; then
    fail=1
    echo "----- errors in $f -----"
    printf '%s\n' "$out" | grep -E "error" | head -20
    echo "------------------------"
  fi
  case "$f" in
    Thread3/Solutions/*)
      if [ "$n" -ne 0 ] || [ "$t" -ne 0 ]; then
        fail=1; echo "  !! $f is a solutions file and uses sorry ($n warnings, $t in text)"
      fi ;;
    Thread3/Common.lean)
      if [ "$n" -ne 0 ]; then fail=1; echo "  !! Common.lean uses sorry"; fi ;;
    Thread3/Week05Audit.lean)
      if [ "$n" -ne 1 ]; then
        fail=1; echo "  !! Week05Audit should have exactly 1 sorry warning, has $n"
      fi ;;
    *)
      if [ "$n" -eq 0 ]; then
        fail=1; echo "  !! $f is an exercise file with no sorry — has it been overwritten with solutions?"
      fi ;;
  esac
done

if [ $fail -ne 0 ]; then echo; echo "VERIFY FAILED"; exit 1; fi
echo
echo "VERIFY OK"
echo "  - every file compiles"
echo "  - no solutions file uses sorry, in warnings or in source text"
echo "  - every exercise file still has its sorry placeholders"
echo "  - Week05Audit has exactly the one deliberate hidden sorry"
