#!/bin/bash

# ---
# description: |
#   Checks whether output cells of all iPy notebooks are cleared.
#   Intended to be used as a git pre-commit hook.
# ---

failed=0

echo "Notebook with uncleared output cells:"

while IFS="" read -r -d "" notebook; do
    if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "$notebook")" ]; then
        echo "  ${notebook}"
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
done < <(
    git diff --name-only --cached |
        grep -z '\.ipynb$' ||
        true
)

if [ "${failed}" -gt 0 ]; then
    echo "Some notebooks have uncleared output cells."
    echo "If you really want to commit, run:"
    echo "  git commit --no-verify"
    exit 1
else
    echo "None! No notebook with uncleared output cells found."
fi
