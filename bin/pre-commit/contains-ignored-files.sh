#!/usr/bin/env sh

# ---
# description: >-
#   Checks whether a commit contains ignored files
# ---

# ---

# NOTE: Script is intended to be run as git pre-commit hook

# ---

ignored_files="$(
    git status --ignored --porcelain |
        awk '/^!!/ {print $2}' |
        xargs git diff --cached --name-only
)"

if [ -n "${ignored_files}" ]; then
    printf "%s\n" \
        "Ignored files found in the commit:" \
        "  ${ignored_files}" \
        "If you really want to commit, run:" \
        "  git commit --no-verify" \
        >&2
    exit 1
fi
