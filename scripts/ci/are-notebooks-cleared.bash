#!/bin/bash

# ---
# description: |
#   Checks whether output cells of all iPy notebooks are cleared.
#   Intended to be used as a GitHub workflow run on pull requests.
# ---

failed=0

if [[ -z "${BASE_SHA:-}" || -z "${HEAD_SHA:-}" ]]; then
    echo "BASE_SHA and HEAD_SHA must be set."
    echo "Perhaps the script is not run in the context of a pull request?"
    exit 1
fi

echo "Notebook with uncleared output cells:"

while IFS="" read -r -d "" notebook; do
    if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "$notebook")" ]; then
        echo "  ${notebook}"
        failed=1
    fi
    # It must be ensured that the while loop runs in the main shell,
    # otherwise changes to the failed variable would be restricted to subshells!.
done < <(
    git diff --name-only --diff-filter=AM -z "${BASE_SHA}" "${HEAD_SHA}" |
        grep -z '\.ipynb$' || true
)

if [ "${failed}" -gt 0 ]; then
    echo "Some notebooks have uncleared output cells."
    echo "Please check if this is intended."
    exit 1
else
    echo "None! No notebook with uncleared output cells found."
fi
