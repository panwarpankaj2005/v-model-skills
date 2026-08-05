#!/usr/bin/env bash
# Compute the next sequential Verification Report doc ID (VR-NNN).
#
# Usage: next-vr-id.sh [dir]
#   dir  directory to scan (default: docs/verification)
#
# Scans every *.md file in <dir> for a line like:
#   **Doc ID:** VR-003
# and prints the next number, zero-padded to 3 digits. Prints 001 if none found.

set -euo pipefail

dir="${1:-docs/verification}"

if [ ! -d "$dir" ]; then
  echo "001"
  exit 0
fi

max=0
while IFS= read -r num; do
  num=$((10#$num))
  if [ "$num" -gt "$max" ]; then
    max=$num
  fi
done < <(grep -ohE '\*\*Doc ID:\*\* VR-[0-9]+' "$dir"/*.md 2>/dev/null \
            | grep -oE '[0-9]+$' || true)

next=$((max + 1))
printf "%03d\n" "$next"
