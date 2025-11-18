#!/usr/bin/env bash

# ---
# description: |
#   Strips all files from the repository that
#   are not listed in the `.pubignore` file.
# ---

# NOTE: As git does not track renames, older directory and file
# names must also be listed in the `.pubignore` file in order to
# fully remove them from the repository history.

set -o errexit
set -o nounset

PUBIGNORE_NAME=".pubignore"
REPO_PUB_SUFFIX="-pub"

repo_src_path="$(git rev-parse --show-toplevel)"
repo_tar_path="${repo_src_path}${REPO_PUB_SUFFIX}"
pubignore_path="${repo_src_path}/${PUBIGNORE_NAME}"

rm -rf "${repo_tar_path}"
git clone "${repo_src_path}" "${repo_tar_path}"
cd "${repo_tar_path}" ||
    exit 1

# Checks whether file exists in HEAD; grep fails when no results are found.
if ! git ls-tree -r --name-only HEAD | grep -q "${PUBIGNORE_NAME}"; then
    echo "No ${PUBIGNORE_NAME} file present!"
    exit 0
fi

# Retains only file that are not (`--invert-paths`) listed in the pubignore file.
git filter-repo \
    --invert-paths \
    --force \
    --paths-from-file "${pubignore_path}"

# Retains all files but not (`--invert-paths`) the pubignore file.
git filter-repo \
    --invert-paths \
    --force \
    --path "${pubignore_path}"
