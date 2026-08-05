---
name: v-model-traceability
description: Owns the traceability matrix (docs/traceability/<slug>-matrix.md) and verification report (docs/verification/<slug>-verification-report.md) for a feature going through the V-model workflow — companion to v-model-design-docs. Pipeline position — superpowers:brainstorming → v-model-design-docs → superpowers:writing-plans → superpowers:test-driven-development → v-model-traceability gates → superpowers:verification-before-completion → superpowers:finishing-a-development-branch. Use whenever a REQ/SADD/IDD/SDD/test-plan doc is created or edited (to refresh matrix refs), whenever tests are actually run (to log real evidence), and — as a hard gate — immediately before superpowers:verification-before-completion or superpowers:finishing-a-development-branch would run: neither may proceed until this skill's checks pass.
---

# V-Model Traceability

**Pipeline position:** `superpowers:brainstorming` → `v-model-design-docs`
→ `superpowers:writing-plans` → `superpowers:test-driven-development` →
**v-model-traceability** gates → `superpowers:verification-before-completion`
→ `superpowers:finishing-a-development-branch`.

Keeps the traceability matrix and verification report honest, and blocks
two downstream skills until they are: `superpowers:verification-before-completion`
(no "verified" claim without logged evidence) and
`superpowers:finishing-a-development-branch` (no finishing with unverified
rows or undocumented design drift).

## Files this skill owns

| File | Path | Seeded from |
|---|---|---|
| Traceability matrix | `docs/traceability/<slug>-matrix.md` | REQ doc's requirement list |
| Verification report | `docs/verification/<slug>-verification-report.md` | ATP/STP/ITP/UTP test IDs |

See [TEMPLATES.md](TEMPLATES.md) for exact section structure (derived from
this repo's `temp-converter-matrix.md` and
`temp-converter-verification-report.md`). See [RULES.md](RULES.md) for
status semantics, what counts as "real evidence," and drift-resolution
rules — read it before marking anything `Verified`, don't guess.

## Workflow

1. **Initialize the matrix** as soon as a REQ doc exists: one block per
   `REQ-XXX`, all ref fields either filled in (if the source doc already
   exists) or marked `*pending*`, `Status: Not started`.
2. **Refresh the matrix** every time a SADD/IDD/SDD/test-plan doc is created
   or edited for this feature — update the relevant ref field(s) on every
   affected REQ block. Don't let refs go stale; a ref pointing at a section
   that no longer exists is worse than no ref.
3. **Seed the verification report** once ATP/STP/ITP/UTP exist: one table
   row per test ID, `Command run` / `Actual output` = `*pending*`,
   `Result` = `Not run`.
4. **Log real evidence, never assumed evidence.** When a test is actually
   run in this session, replace its row with the literal command, the
   literal output (or a faithful summary of long output), the real
   Pass/Fail result, and a timestamp. A row may only say `Pass` because it
   was just observed to pass — not because it "should" pass.
5. **Gate: before any verification claim** (`superpowers:verification-before-completion`),
   run `scripts/check-verification-report.sh <slug>`. If it fails, evidence
   is missing — go run the missing tests and log them. Do not claim
   anything is verified while it reports `*pending*` or `Not run` rows, or
   an unfilled Overall Verdict.
6. **Promote matrix status** only after evidence backs it up:
   `Not started` → `In progress` once design/implementation exists,
   `Verified` only once every test ID tied to that REQ shows `Pass` in the
   verification report. A single `Fail` anywhere in that REQ's test IDs
   means it stays `In progress`, not `Verified`.
7. **Fill the Doc/Diagram Drift Check** (verification report, last section)
   by actually comparing shipped code against SADD/IDD/SDD. Any divergence
   found must be resolved — either fix the code, or update the design doc
   (and bump its `Last updated` date) — before that row can read `Yes`.
   Never leave a row reading `No`.
8. **Gate: before finishing the branch** (`superpowers:finishing-a-development-branch`),
   run `scripts/check-finish-gate.sh <slug>`. It fails if any REQ row isn't
   `Verified`, any drift row still reads `No`, or evidence is missing per
   step 5. Do not finish the branch while it fails — go fix, verify, or
   update docs first.

## Gates

- **`superpowers:verification-before-completion`** — blocked by
  `scripts/check-verification-report.sh <slug>` (step 5).
- **`superpowers:finishing-a-development-branch`** — blocked by
  `scripts/check-finish-gate.sh <slug>` (step 8), which is the stricter
  superset: it re-runs the evidence check, then also requires every REQ row
  `Verified` and no unresolved drift.

Both scripts exit `0` to allow proceeding, `1` (with a list of what's
missing) to block it.
