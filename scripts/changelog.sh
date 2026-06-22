#!/usr/bin/env bash
#
# Print the CHANGELOG.md section for a version, for use as GitHub release notes.
# Usage: scripts/changelog.sh 0.1.2   (a leading "v" is fine too)
#
# Example: gh release create v0.1.2 --notes "$(scripts/changelog.sh 0.1.2)"

set -euo pipefail
version="${1:?usage: changelog.sh <version>}"
version="${version#v}"

here="$(cd "$(dirname "$0")/.." && pwd)"
awk -v ver="$version" '
  $0 ~ ("^## \\[" ver "\\]") { grabbing = 1; next }
  grabbing && /^## \[/ { exit }
  grabbing {
    if ($0 ~ /[^[:space:]]/) seen = 1
    if (seen) lines[++n] = $0
  }
  END {
    while (n > 0 && lines[n] ~ /^[[:space:]]*$/) n--
    for (i = 1; i <= n; i++) print lines[i]
  }
' "$here/CHANGELOG.md"
