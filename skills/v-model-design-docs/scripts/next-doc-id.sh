#!/usr/bin/env bash
# Compute the next sequential doc ID number for a given doc-type prefix.
#
# Usage: next-doc-id.sh <PREFIX> <dir>
#   PREFIX  e.g. REQ-DOC-, SADD-, IDD-, SDD-, ATP-, STP-, ITP-
#   dir     directory to scan for existing docs of that type
#
# Scans every *.md file in <dir> for a line like:
#   **Doc ID:** REQ-DOC-003
# and prints the next number, zero-padded to 3 digits (e.g. 004).
# If no existing docs are found, prints 001.

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <PREFIX> <dir>" >&2
  exit 2
fi

prefix="$1"
dir="$2"

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
done < <(grep -ohE "\\*\\*Doc ID:\\*\\* ${prefix}[0-9]+" "$dir"/*.md 2>/dev/null \
            | grep -oE "[0-9]+$" || true)

next=$((max + 1))
printf "%03d\n" "$next"
