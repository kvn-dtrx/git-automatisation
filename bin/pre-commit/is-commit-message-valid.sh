#!/bin/bash

# ---
# description: >-
#   Checks whether the commit message is well formatted
# ---

# ---

# NOTE: Script is intended to be run as git pre-commit hook

# ---

TYPES=(
    "feat"
    "fix"
    "chore"
    "docs"
    "refactor"
    "style"
    "test"
    "wip"
    # "perf"
    # "ci"
    # "build"
    # "revert"
    # "security"
    # "ux"
    # "localization"
    # "meta"
)

TYPE_PATTERN="($(
    IFS="|"
    echo "${TYPES[*]}"
))"

# Full Conventional Commit regex
REGEX="^${TYPE_PATTERN}(\([a-zA-Z0-9_-]+\))?(!)?: .+"

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(head -n1 "$COMMIT_MSG_FILE")

if ! echo "${COMMIT_MSG}" | grep -Eq "${REGEX}"; then
    printf "%s\n" \
        "Invalid commit message format!" \
        "Commit message must follow Conventional Commits format:" \
        "  <type>(optional-scope)!: description" \
        "Allowed types are: ${TYPES[*]}" \
        >&2
    exit 1
fi
