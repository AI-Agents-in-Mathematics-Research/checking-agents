# Dev container image for Thread 3.
#
# This file is where the work that used to live in `.devcontainer/on-create.sh`
# now lives: elan, the pinned toolchain, Mathlib's pre-built oleans and
# `Thread3.Common`, all built once here instead of once per student. Appendix A
# of the teaching pack calls moving that work out of the script and into the
# image "the one circumstance in which moving work out of that script is
# correct rather than a mistake". This is that circumstance; on-create.sh is
# gone.
#
# `.github/workflows/devcontainer-image.yml` builds this from the staff
# repository and pushes it to GHCR, and `devcontainer.json` names the published
# package as its "image". A student codespace pulls a ready environment instead
# of spending seven minutes building one. The package has to be PUBLIC or every
# student's codespace fails to start — Appendix A has that step.
#
# Because the package is public, only the five files needed to build
# Thread3.Common are copied in: no Solutions/, no teaching pack, no CLAUDE.md.
# The workflow re-checks the built image against that exact list before it
# pushes.
#
# Build it locally, from the repository ROOT (the build context is the
# repository, not .devcontainer/):
#
#   docker build -f .devcontainer/Dockerfile -t thread3-devcontainer .

FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Default RUN shell is `sh -c`, which has no pipefail: the `curl ... | sh`
# below would report success if curl died and handed the installer an empty
# script, and the build would fail one step later with a confusing error about
# elan instead of the download that actually broke.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# git and curl come with the base image. devcontainer.json used to add the
# `git:1` *feature* on top of it, which is no longer wanted: features are
# applied by building a derived image when the container is created, which is
# the very cost this image exists to remove. Assert rather than `apt-get
# install`, so a base image that stops shipping them breaks this build instead
# of a student's codespace.
RUN command -v git >/dev/null && command -v curl >/dev/null

# python3 does NOT come with the base image, and scripts/verify.sh needs it for
# scripts/count_sorry.py — which the student README tells students to run. That
# was broken in the container before this image existed, for the same reason:
# the base image has no python3 and nothing was adding one.
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends python3 \
 && rm -rf /var/lib/apt/lists/*

# The seed directory lives outside /workspaces deliberately. Codespaces mounts
# the cloned repository over /workspaces, so a .lake this build wrote there
# would be invisible at runtime; post-create.sh copies it in from here.
ENV THREAD3_SEED=/opt/thread3-seed
RUN mkdir -p "$THREAD3_SEED" && chown vscode:vscode "$THREAD3_SEED"

# Back to the user a codespace actually runs as: elan must land in
# /home/vscode/.elan, which is where devcontainer.json's remoteEnv PATH points.
USER vscode
WORKDIR /opt/thread3-seed

# elan first, and on its own layer keyed only on lean-toolchain, so a Mathlib
# revision bump does not re-download the toolchain.
COPY --chown=vscode:vscode lean-toolchain ./
RUN curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y --default-toolchain none \
 && { grep -q 'elan/env' "$HOME/.bashrc" || echo 'source $HOME/.elan/env' >> "$HOME/.bashrc"; }
# The lean4 extension does not run in a login shell and so never reads .bashrc;
# devcontainer.json sets the same PATH in remoteEnv for the same reason.
ENV PATH=/home/vscode/.elan/bin:$PATH
RUN elan toolchain install "$(cat lean-toolchain)"

# Then Mathlib and our import surface. The cache tool fetches Mathlib
# pre-built; without it Lean builds Mathlib from source, which takes hours.
COPY --chown=vscode:vscode lakefile.toml lake-manifest.json Thread3.lean ./
COPY --chown=vscode:vscode Thread3/Common.lean Thread3/
# Narrowed on purpose, and the reason is a hard limit rather than a preference.
# A bare `lake exe cache get` fetches all 8,459 files of Mathlib's cache, which
# made this image 12 GB unpacked — and a codespace CANNOT UNPACK THAT. A 32 GB
# Codespaces machine leaves nowhere near 32 GB for Docker's layer store, so the
# pull died with "no space left on device" part-way through the Mathlib layer
# and the student got a recovery container instead of an environment. Measured
# 10 September 2026; see Appendix A.
#
# Passing Common.lean makes the cache tool resolve its transitive imports and
# fetch only those: 1,472 files rather than 8,459. It prints a warning that
# "some files were not found in the cache" and that the checkout "has diverged
# from upstream" — that is Thread3/Common.lean itself, which is ours and has no
# entry in Mathlib's cache. It is harmless, it exits 0, and the Mathlib
# closure is still fetched.
#
# The cost is that a student importing something Common.lean does not already
# pull in has to run `lake exe cache get` once themselves; docs/setup.md tells
# them so. That is the accepted trade against a container that will not start.
#
# Deleting .lake/packages/mathlib/.git (494 MB) was measured and rejected
# separately: without it lake re-clones Mathlib and rebuilds from source.
#
# The tarballs the cache tool downloads are unpacked into .lake and then never
# read again; deleting them in the same layer keeps them out of the image. It
# must be the same RUN — a file removed in a later layer is whited out, not
# reclaimed.
RUN lake exe cache get Thread3/Common.lean \
 && lake build Thread3.Common \
 && rm -rf "$HOME/.cache/mathlib"

# WORKDIR is left here so that `docker run --rm IMAGE lake build Thread3.Common`
# is a working smoke test of the image; the workflow uses exactly that.
