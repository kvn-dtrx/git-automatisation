#!/usr/bin/env sh

# ---
# description: |
#   Derives a one-commit version of a repository with GitHub origin path
#   and pushes it to GitHub.
# ---

set -o errexit
set -o nounset

SRC_REPO="${1}"
PUB_SUFFIX="_pub"

tmp_dir="$(mktemp -d)"
# tmp_dir="${HOME}/Downloads/foo"
rm -rf "${tmp_dir}"

[ -n "${SRC_REPO}" ] || {
    echo "First argument not provided" >&2
    exit 1
}

git clone "${SRC_REPO}" "${tmp_dir}"

cd "${tmp_dir}"

src_origin_url="$(
    git -C "${SRC_REPO}" remote get-url origin
)"
src_repo_name="$(basename -s .git "${src_origin_url}")"
default_branch="main"
username="$(
    echo "${src_origin_url}" |
        gsed -E 's#.*github\.com[:/](.+?)/.*#\1#'
)"
target_repo_name="${src_repo_name}${PUB_SUFFIX}"
target_url="git@github.com:${username}/${target_repo_name}.git"

# Extracts the tree SHA of the commit.
tree_sha="$(
    git rev-parse "origin/${default_branch}^{tree}"
)"

# Creates a new commit with that tree and no parent.
commit_msg="init: Create Clean Snapshot @ $(gdate "+%Y-%m-%dT%H:%M:%S")"
new_commit_sha="$(
    echo "${commit_msg}" |
        git commit-tree "${tree_sha}"
)"

# Lets main branch point to this new commit.
# Since we are on ${default_branch}, git demands detaching first.
git checkout --detach
git branch -f "${default_branch}" "${new_commit_sha}"
git switch "${default_branch}"

git remote set-url origin "${target_url}"

# Checks if origin really was changed as we will force push!
current_origin_url="$(git remote get-url origin)"
[ "${current_origin_url}" = "${target_url}" ] || {
    echo "Remote origin URL mismatch." >&2
    echo "Expected:" >&2
    echo "  ${target_url}" >&2
    echo "Actual:" >&2
    echo "  ${current_origin_url}" >&2
    echo "Aborting to avoid accidental force-push to wrong remote." >&2
    exit 1
}

if ! gh repo view "${username}/${target_repo_name}" > /dev/null 2>&1; then
    gh repo create "${username}/${target_repo_name}" --public
fi

git push --force origin "${default_branch}"
