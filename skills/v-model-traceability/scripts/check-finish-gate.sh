#!/usr/bin/env bash
# Gate check: everything superpowers:finishing-a-development-branch needs
# before it may run — evidence logged, every REQ row Verified, no
# unresolved SADD/IDD/SDD drift.
#
# Usage: check-finish-gate.sh <slug>
#
# Exit 0 if clear to finish; exit 1 with details of what's blocking otherwise.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <slug>" >&2
  exit 2
fi

slug="$1"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
matrix="docs/traceability/${slug}-matrix.md"
report="docs/verification/${slug}-verification-report.md"

fail=0

echo "--- Step 1: verification report evidence ---"
if ! "$here/check-verification-report.sh" "$slug"; then
  fail=1
fi

echo ""
echo "--- Step 2: traceability matrix status ---"
if [ ! -f "$matrix" ]; then
  echo "MISSING $matrix"
  fail=1
else
  summary_rows=$(awk '/Feature-Level Summary/{f=1} f && /^\| REQ-/{print}' "$matrix")
  if [ -z "$summary_rows" ]; then
    echo "No REQ rows found under 'Feature-Level Summary' — matrix may not be initialized."
    fail=1
  else
    unverified=$(echo "$summary_rows" | grep -v '| Verified |' || true)
    if [ -n "$unverified" ]; then
      echo "REQ rows not yet Verified:"
      echo "$unverified"
      fail=1
    else
      echo "All REQ rows read Verified:"
      echo "$summary_rows"
    fi
  fi
fi

echo ""
echo "--- Step 3: SADD/IDD/SDD drift check ---"
if [ -f "$report" ]; then
  drifted=$(awk '/Doc\/Diagram Drift Check/{f=1} f && /^\| (SADD|IDD|SDD)-/{print}' "$report" \
              | grep -E '\| No \|' || true)
  if [ -n "$drifted" ]; then
    echo "Unresolved drift (code no longer matches design doc):"
    echo "$drifted"
    fail=1
  else
    echo "No unresolved drift rows found."
  fi
else
  echo "MISSING $report — cannot check drift."
  fail=1
fi

echo ""
if [ "$fail" -eq 1 ]; then
  echo "GATE: FAIL — do not run superpowers:finishing-a-development-branch for '${slug}' yet."
  exit 1
else
  echo "GATE: PASS — '${slug}' may proceed to superpowers:finishing-a-development-branch."
  exit 0
fi
