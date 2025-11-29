#!/bin/bash

# ---
# description: |
#   Checks whether the branch name is well formatted.
#   Intended to be used as a pre-commit hook.
# ---

branch_pattern=""
branch_pattern+="^"
branch_pattern+="("
branch_pattern+="feature\/|"
branch_pattern+="bugfix\/|"
branch_pattern+="hotfix\/|"
branch_pattern+="release\/|"
branch_pattern+="dev\/|"
branch_pattern+="test\/|"
branch_pattern+="experimental\/|"
branch_pattern+="docs\/|"
branch_pattern+="\/\/\/"
branch_pattern+=")"
branch_pattern+="[a-z0-9_-]+$"
branch_pattern+="$"

if [ -n "${GITHUB_HEAD_REF}" ]; then
    branch_name="${GITHUB_HEAD_REF}"
else
    branch_name="$(git rev-parse --abbrev-ref HEAD)"
fi

if ! printf '%s\n' "${branch_name}" | grep -E -q "${branch_pattern}"; then
    echo "Branch name is not well formatted:"
    echo "  ${branch_name}"
    echo "Branch names should match the regexp:"
    echo "  ${branch_pattern}"
    echo "Please stick to this convention next time."
    exit 1
fi
