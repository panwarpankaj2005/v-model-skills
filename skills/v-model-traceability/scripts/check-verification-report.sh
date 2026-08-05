#!/usr/bin/env bash
# Gate check: every row in the verification report has real, logged
# evidence (no placeholders). This is the check superpowers:verification-
# before-completion must pass before any "verified"/"tests pass" claim.
#
# Usage: check-verification-report.sh <slug>
#
# Exit 0 if every row is real evidence; exit 1 with a list of what's still
# a placeholder otherwise.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <slug>" >&2
  exit 2
fi

slug="$1"
report="docs/verification/${slug}-verification-report.md"

if [ ! -f "$report" ]; then
  echo "MISSING $report"
  echo ""
  echo "GATE: FAIL — verification report doesn't exist yet for '${slug}'."
  exit 1
fi

fail=0

pending_lines=$(grep -n '\*pending\*' "$report" || true)
if [ -n "$pending_lines" ]; then
  echo "Unlogged evidence (*pending* placeholders remain):"
  echo "$pending_lines"
  fail=1
fi

notrun_lines=$(grep -n '| Not run |' "$report" || true)
if [ -n "$notrun_lines" ]; then
  echo "Tests never run (Result column still says 'Not run'):"
  echo "$notrun_lines"
  fail=1
fi

if grep -q 'Not yet determined' "$report"; then
  echo "Overall Verdict (Section 6) has not been filled in yet."
  fail=1
fi

echo ""
if [ "$fail" -eq 1 ]; then
  echo "GATE: FAIL — do not claim verification for '${slug}' yet (superpowers:verification-before-completion)."
  exit 1
else
  echo "GATE: PASS — every row in ${report} has real logged evidence."
  exit 0
fi
