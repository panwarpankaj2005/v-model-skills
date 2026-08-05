# Rules: Diagrams, Doc IDs, Traceability

## Diagram rule

**Default is no diagram.** Only include one when the relationship it shows
would take more than a sentence to describe in prose. Per doc type:

| Doc | When to include | When to omit |
|---|---|---|
| SADD | `flowchart`/component diagram, only if there are ≥2 components with non-obvious relationships (e.g. real network/process/IPC boundaries) | Single-process or trivially-linear component list → write **"Diagram omitted — trivial architecture"** plus one sentence pointing at the IDD's sequence diagram for the actual flow. This is the common case for small features. |
| IDD | `sequenceDiagram`, only if an interaction flow has **more than one call** (e.g. validate → convert → format, or a branch between success/error paths) | A single request/response with no intermediate calls → state the one-call flow in prose instead. |
| SDD | `flowchart TD`, only for functions with **real branching logic** (≥2 conditional decision points) | Linear functions (no branching, or a single if/else already fully covered by numbered prose steps) get no diagram — say so explicitly ("no branching beyond X, doesn't need a flowchart") so it reads as a decision, not an oversight. |
| Acceptance Test Plan | Essentially never | A table of invocation → expected output is already the clearest form; a diagram would just re-encode it with less precision. |
| System Test Plan | Optional state diagram, only if the feature has meaningful states/transitions beyond start→process→exit | Stateless/one-shot features → omit, one sentence why. |
| Integration Test Plan | Never when the plan is `N/A`/empty | If the feature later grows a real cross-component boundary, that's when this plan gets both real test cases and a diagram. |

Every "Diagram" section — even when the diagram is omitted — must contain a
one-to-two sentence justification, not just the word "None". The
justification is what makes the omission a reviewable decision instead of a
gap.

## Doc ID scheme

Each doc type has its own sequential counter, independent of the others,
scanned across all existing docs of that type in the repo (not per-feature —
the second feature's REQ doc is `REQ-DOC-002`, not `REQ-DOC-001` again).

| Doc | ID prefix | Directory to scan |
|---|---|---|
| Requirements | `REQ-DOC-` | `docs/requirements/` |
| SADD | `SADD-` | `docs/design/sadd/` |
| IDD | `IDD-` | `docs/design/idd/` |
| SDD | `SDD-` | `docs/design/sdd/` |
| Acceptance Test Plan | `ATP-` | `docs/test-plans/acceptance/` |
| System Test Plan | `STP-` | `docs/test-plans/system/` |
| Integration Test Plan | `ITP-` | `docs/test-plans/integration/` |

Use `scripts/next-doc-id.sh <prefix> <dir>` to compute the next number
(zero-padded to 3 digits) rather than eyeballing it — it's a one-line grep,
but getting it wrong means a duplicate ID silently aliasing two documents.

## Traceability conventions

- **REQ's own traceability table** stays "Not started" in every ref column
  at authoring time — it's filled in retroactively as design/test/code refs
  land, not by this skill.
- **SADD's traceability table**: REQ ID → which component(s) address it.
- **IDD's traceability table**: REQ ID → which interface(s) are involved.
- **SDD's traceability table**: REQ ID → which function(s) implement it.
- **Acceptance Test Plan's traceability**: implicit via the `Traces to`
  column on each test row — every AC in the REQ doc must appear exactly
  once. Zero gaps is the bar; a missing AC means an untested requirement.
- **System Test Plan's traceability**: SADD section/component → which
  system test(s) cover it.
- **Integration Test Plan's traceability**: IDD interface → covered by
  (acceptance plan / unit plan / this plan), stating which, even when this
  plan itself is empty.

Every `Doc ID`/`Traces to` header field must be filled in with real IDs
(not left as `TBD`) before the doc counts as done for the gate check.
