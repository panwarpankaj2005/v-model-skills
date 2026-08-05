# Rules: Status, Evidence, and Drift

## Matrix status semantics

Three values only, and status only ever moves forward (never re-marked
`Not started` once work has begun — a regression gets a new note, not a
rollback of history):

- **Not started** — default at matrix creation; no design or test refs
  filled in beyond what already exists upstream.
- **In progress** — design and/or code exists for this REQ, but at least
  one tied test ID has no logged `Pass` yet in the verification report.
- **Verified** — every test ID referenced in this REQ's block (acceptance,
  system, integration-if-applicable, unit) shows `Result: Pass` in the
  verification report, with real command/output/timestamp, not placeholders.

A REQ whose only applicable tests are legitimately N/A (e.g. integration
tests for a single-component feature) still needs every *other* referenced
test ID to be a logged `Pass` before it can read `Verified` — N/A categories
don't get skipped, they just contribute nothing to block on.

## What counts as real evidence

A verification-report row is real evidence only if all of these hold:

- `Command run` is the literal command actually executed, not a
  description of what would be run.
- `Actual output` is the literal output (or a faithful, non-cherry-picked
  summary if very long) — not "should output X" or "expected: X".
- `Result` is `Pass` or `Fail`, never `Not run` or blank.
- `Run at` has a real timestamp from this session.

If any of these is missing or is a placeholder (`*pending*`, `Not run`,
`TBD`), the row is not evidence yet — `scripts/check-verification-report.sh`
treats the whole report as incomplete until every row clears this bar.

A `Fail` result is legitimate evidence — it's real, it just doesn't clear
the bar for marking that REQ's matrix row `Verified` (see above). Don't
"fix" a `Fail` row by deleting it; leave the record and add a new row (or
update `Run at`) once a fix is verified to actually pass.

## Overall Verdict (verification report, Section 6)

Only fill this in once every table above it is fully populated with real
results. It must state, in one or two sentences, whether the feature as a
whole passed verification — not a restatement of "some tests passed."

## Drift resolution (verification report, last section)

At verification time, compare the shipped code against what SADD/IDD/SDD
currently describe (including their diagrams and stated decisions):

- **Yes** — code still matches the doc as written. Fine as-is.
- **No** — a real divergence exists. This is not an acceptable end state:
  before the row can change to `Yes`, either
  1. fix the code to match the doc, or
  2. update the doc (and bump its `Last updated` field) to describe what
     the code actually does, with a `Notes` entry explaining what changed
     and why.

  Whichever path is taken, re-check the row afterward and flip it to `Yes`
  with a one-line note of what was resolved. A row is never left at `No`
  going into `finishing-a-development-branch` — `scripts/check-finish-gate.sh`
  treats any lingering `No` as a hard failure, on the theory that undocumented
  drift between design and code is exactly the failure mode this whole
  process exists to catch.

## When the matrix or report don't exist yet

If `docs/traceability/<slug>-matrix.md` or
`docs/verification/<slug>-verification-report.md` don't exist when a gate
script runs, that's a hard failure too (not a pass-by-default) — seed them
per the Workflow in SKILL.md before re-running the gate.
