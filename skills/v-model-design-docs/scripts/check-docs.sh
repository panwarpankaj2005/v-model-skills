#!/usr/bin/env bash
# Gate check: verify all seven V-model design docs exist for a feature slug.
# This is the check superpowers:writing-plans must pass before it runs.
#
# Usage: check-docs.sh <slug>
#   slug  kebab-case feature slug, e.g. unit-selector
#
# Exit 0 and prints a checklist if all seven files exist.
# Exit 1 and lists what's missing otherwise.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <slug>" >&2
  exit 2
fi

slug="$1"

files=(
  "docs/requirements/${slug}-req.md"
  "docs/design/sadd/${slug}-sadd.md"
  "docs/design/idd/${slug}-idd.md"
  "docs/design/sdd/${slug}-sdd.md"
  "docs/test-plans/acceptance/${slug}-acceptance-plan.md"
  "docs/test-plans/system/${slug}-system-plan.md"
  "docs/test-plans/integration/${slug}-integration-plan.md"
)

missing=0
for f in "${files[@]}"; do
  if [ -f "$f" ]; then
    echo "OK    $f"
  else
    echo "MISSING $f"
    missing=1
  fi
done

if [ "$missing" -eq 1 ]; then
  echo ""
  echo "GATE: FAIL — do not run superpowers:writing-plans for '${slug}' yet."
  exit 1
else
  echo ""
  echo "GATE: PASS — all seven V-model docs present for '${slug}'."
  exit 0
fi
