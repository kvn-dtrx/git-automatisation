#!/usr/bin/env sh

# ---
# description: |
#   Uploads a filtered version of a repository for public use.
#   The `.pubignore` file of the repository serves as blacklist.
# ---

set -o errexit
set -o nounset

PUBIGNORE_NAME=".pubignore"
REPO_PRIV_URL="https://github.com/kvn-dtrx/xperiments"
REPO_PUB_SUFFIX="-pub"
REFERENCE="pub-mirror"

repo_pub_url="${REPO_PRIV_URL}${REPO_PUB_SUFFIX}"

repo_tmp_dir=$(mktemp -d -t repo-to-mirror.XXX)

git clone \
    --branch main \
    --single-branch \
    "${REPO_PRIV_URL}" \
    "${repo_tmp_dir}"

(
    cd "${repo_tmp_dir}" ||
        {
            echo "Failed to enter temporary directory"
            exit 1
        }

    if ! git ls-tree -r --name-only HEAD | grep -q "${PUBIGNORE_NAME}"; then
        echo "No ${PUBIGNORE_NAME} file present!"
        exit 0
    fi

    # Retains only file that are not (`--invert-paths`) listed in the pubignore file.
    git filter-repo \
        --force \
        --invert-paths \
        --paths-from-file "${PUBIGNORE_NAME}"

    # Retains all files but not (`--invert-paths`) the pubignore file.
    git filter-repo \
        --force \
        --invert-paths \
        --path "${PUBIGNORE_NAME}"

    if ! gh repo view "${repo_pub_url}" >/dev/null 2>&1; then
        gh repo create "${repo_pub_url}" --public
    fi

    git remote add "${REFERENCE}" "${repo_pub_url}"

    git push --mirror "${REFERENCE}"

)

rm -rf "${repo_tmp_dir}"
