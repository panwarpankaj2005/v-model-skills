---
name: v-model-design-docs
description: Generates the four V-model design documents (REQ, SADD, IDD, SDD) and their three matching test plans (acceptance, system, integration) for a new feature, after superpowers:brainstorming has produced an approved design. Pipeline position — superpowers:brainstorming → v-model-design-docs → superpowers:writing-plans → superpowers:test-driven-development → v-model-traceability gates → superpowers:verification-before-completion → superpowers:finishing-a-development-branch. Use when a brainstorm/design for a new feature has just been approved, when the user asks for requirements/SADD/IDD/SDD/test-plan docs, or immediately before superpowers:writing-plans would run for a new feature — writing-plans must not proceed until all seven documents exist for that feature.
---

# V-Model Design Docs

**Pipeline position:** `superpowers:brainstorming` → **v-model-design-docs**
→ `superpowers:writing-plans` → `superpowers:test-driven-development` →
`v-model-traceability` gates → `superpowers:verification-before-completion`
→ `superpowers:finishing-a-development-branch`.

Turns an approved brainstorm into the seven V-model artifacts this repo's
`docs/` tree expects, then gates `superpowers:writing-plans` until they all
exist.

## Quick start

Given a feature slug (kebab-case, e.g. `unit-selector`) and an approved
design from `superpowers:brainstorming`, produce these seven files:

| # | Doc | Path |
|---|-----|------|
| 1 | Requirements | `docs/requirements/<slug>-req.md` |
| 2 | System Architecture Design Doc | `docs/design/sadd/<slug>-sadd.md` |
| 3 | Interface Design Doc | `docs/design/idd/<slug>-idd.md` |
| 4 | Software Design Doc | `docs/design/sdd/<slug>-sdd.md` |
| 5 | Acceptance Test Plan | `docs/test-plans/acceptance/<slug>-acceptance-plan.md` |
| 6 | System Test Plan | `docs/test-plans/system/<slug>-system-plan.md` |
| 7 | Integration Test Plan | `docs/test-plans/integration/<slug>-integration-plan.md` |

See [TEMPLATES.md](TEMPLATES.md) for section-by-section structure of each
(derived from `docs/requirements/`, `docs/design/`, `docs/test-plans/` in
this repo — that's the canonical reference for headers and level of detail).
See [RULES.md](RULES.md) for the diagram-inclusion rule, doc-ID scheme, and
traceability conventions — read it before writing Section "Diagram" in any
doc, don't guess.

## Workflow

1. **Get the slug and the approved design.** Pull these from the
   brainstorming output already in context. Don't re-derive requirements
   from scratch — the brainstorm is the source of truth for scope.
2. **Assign doc IDs.** Run `scripts/next-doc-id.sh <PREFIX> <dir>` per doc
   type (prefixes and dirs are listed in RULES.md) so IDs increment
   correctly across existing docs instead of colliding on `-001`.
3. **Write REQ first**, in full, before touching any other doc — every
   other document traces back to it. Each requirement is one atomic,
   testable behavior with its own acceptance criteria (`AC-XXX-N`).
4. **Write SADD, then IDD, then SDD, in that order** — each is meant to
   reference the one before it (SADD's components → IDD's interfaces →
   SDD's functions). Apply the diagram rule from RULES.md at each step;
   don't default to including a diagram.
5. **Write the three test plans** (acceptance → system → integration, in
   that order) against the REQ/SADD/IDD you just wrote. Acceptance tests
   cover every AC with zero gaps. System tests state explicitly if they're
   mostly redundant with acceptance at this scale — don't pad with
   busywork cases to look thorough. Integration tests are legitimately
   `N/A`/empty when there's no cross-component boundary; say so explicitly
   rather than skipping the file.
6. **Fill every Traceability section** — REQ's stays "Not started" (that's
   correct at this stage; downstream docs fill it in over time), but every
   other doc's traceability table must be complete, not left as a
   placeholder.
7. **Run the gate check** before declaring done:
   `scripts/check-docs.sh <slug>`. If anything is missing, finish it — do
   not move on.

## Gate: blocks superpowers:writing-plans

`superpowers:writing-plans` must not run for a new feature until all seven
files above exist for that feature's slug. If you're about to invoke
`writing-plans` and haven't confirmed this, **stop and run**
`scripts/check-docs.sh <slug>` first:

- Exit code 0 (all seven present) → proceed to `writing-plans`.
- Exit code 1 (something missing) → run this skill to produce the missing
  doc(s); do not invoke `writing-plans` yet.

This applies even if some of the seven already exist from a partial run —
the check is on the full set, not on whether this skill was invoked at all.
