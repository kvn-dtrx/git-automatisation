# shellcheck shell=bash

# ---
# description:
# ---

# ---

# Checks whether the script is executed as root.
[ "$(id -u)" -ne 0 ] && {
    echo "***** Run this script as root *****"
    exit 1
}

# ---

# Triggers exit if a command has a non-zero code.
set -o errexit # or set -e
# NOTE: Of course, failed conditionals of if or while clauses are not affected.
# NOTE: The POSIX standard does not prescribe how `errexit` shall behave for
# non-zero exit codes from process substitutions; to be on the safe side,
# append `|| exit 1`.

# ---

# Triggers exit if an unset variable is read.
set -o nounset # or set -u
# NOTE: Empty variables are not unset!

# ---

# Sets the exit code of a pipe to the first non-zero code of a constituent
# if present;
set -o pipefail
# NOTE: By default, the exit code of a pipe equals the exit code of
# its last constituent.
# NOTE: This option is not POSIX-compliant.

# ---

# NOTE: The command `set -o` lists all available option
# plus their current values

# ---

# We now assume that `errexit` and `nounset` are true.

# Switches to parent directory of the current script.
# NOTE: realpath is not POSIX-compliant.
script_path="$(realpath "${0}")" || exit 1
script_dir="$(dirname "${script_path}")"
cd "${script_dir}"

# ---

# Switches to the repository root the script is subordinate to.
repodir="$(git rev-parse --show-toplevel)" || exit 1
cd "${repodir}"

# ---

# Provides current directory as argument if no arguments are given
set -- "${@:-.}"

# ---

# Finds all (including symlinked) files that are not subordinate
# to a hidden directory.
find -L "${@}" \
    \( -type d -path "*/.*" -prune \) -o \
    \( -type f -print \)

# ---
