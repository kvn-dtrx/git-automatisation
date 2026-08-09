#!/bin/sh

# ---
# description: >-
#   Checks whether a commit contains ignored files
# ---

# ---

# NOTE: Script is intended to be run as git pre-commit hook

# ---

ignored_files=$(
    git status --ignored --porcelain |
        awk '/^!!/ {print $2}' |
        xargs git diff --cached --name-only
)

if [ -n "${ignored_files}" ]; then
    echo "Ignored files found in the commit:"
    echo "  ${ignored_files}"
    echo "If you really want to commit, run:"
    echo "  git commit --no-verify"
    exit 1
fi
