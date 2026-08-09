#!/usr/bin/env bash

# ---
# description: >-
#   Checks whether the push operation targets a protected branch
# ---

# ---

# NOTE: Script is intended to be run as git pre-push hook

# ---

protected_branches=(
    main
    master
    untouchable
    infallible
)

current_branch="$(git rev-parse --abbrev-ref HEAD)"

for protected_branch in "${protected_branches[@]}"; do
    if [ "${current_branch}" = "${protected_branch}" ]; then
        printf \
            "Push to %s is very like not what you want!\n" "${current_branch}" \
            >&2
        exit 1
    fi
done
