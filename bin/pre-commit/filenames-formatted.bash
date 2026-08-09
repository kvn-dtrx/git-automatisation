#!/usr/bin/env /bash

# ---
# description: >-
#   Checks whether names of committed files fulfill the following
#   formatting rules: - No whitespace. - No uppercase characters. Intended
#   to be used as a pre-commit hook
# ---

# ---

failed=0

while IFS="" read -r file; do
    # Check for whitespace in the filename
    printf "%s\n" "${file}" | grep -E -q "[[:space:]]|[A-Z]" && {
        printf "%s\n" \
            "File name with white spaces or uppercase characters found:" \
            "  ${file}" \
            >&2
        failed=1
    }
done < <(git diff --name-only origin/main HEAD)

if [ "${failed}" -ne 0 ]; then
    printf "Commit aborted.\n" >&2
    exit 1
fi
