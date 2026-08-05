# Templates: Matrix and Verification Report

Structure below is derived from `docs/traceability/temp-converter-matrix.md`
and `docs/verification/temp-converter-verification-report.md` in this repo.
Match header order and field names exactly — other skills' gate scripts
parse these files by structure, not just by eye.

## Traceability Matrix — `docs/traceability/<slug>-matrix.md`

Header:

```
# Traceability Matrix: <Feature Name>

**Feature:** <slug>
**Format:** checklist-per-requirement
**Last updated:** <YYYY-MM-DD>

---

## How to read this document

One block per requirement. Every reference field should point to a real
section in a real doc, not just say "yes." `Status` only moves to
`Verified` once the Verification Report shows a real, timestamped pass for
every test tied to that requirement.

Status values: `Not started` → `In progress` → `Verified`

---
```

One block per REQ ID, in REQ-doc order:

```
## REQ-XXX — <short title>

- REQ doc ref: <REQ-DOC-ID>, Section 3, REQ-XXX
- Acceptance criteria ref: <AC-XXX-1, AC-XXX-2, ...>
- Design ref (brainstorming/approved design): <link, or *pending link to session notes*>
- SADD ref: <SADD-ID>, Section(s)
- IDD ref: <IDD-ID>, Section(s)
- SDD ref: <SDD-ID>, Section(s)
- Acceptance test ref: <ATP-ID>, <test IDs>
- System test ref: <STP-ID>, <test IDs, or "not separately covered beyond ...">
- Integration test ref: <ITP-ID> — <test IDs, or "N/A, <reason>">
- Unit test ref: <UTP-ID>, <function row(s)>
- Code ref: *pending — filled in during implementation*
- User doc ref: <user-doc file>, <section>
- Verification report ref: <VR-ID>, <section(s)>
- **Status:** <Not started | In progress | Verified>

---
```

Closing summary (required — gate scripts parse this table):

```
## Feature-Level Summary

| REQ ID | Status |
|---|---|
| REQ-001 | <status> |
...

**Feature cannot be marked complete** (per `finishing-a-development-branch`
gate) until every row above reads `Verified` **and** the Doc/Diagram Drift
Check in the Verification Report shows no unresolved divergence.
```

## Verification Report — `docs/verification/<slug>-verification-report.md`

Header:

```
# Verification Report: <Feature Name>

**Doc ID:** <VR-ID, see doc-ID scheme below>
**Feature:** <slug>
**Status:** <Not started | In progress | Complete>
**Last updated:** <YYYY-MM-DD>

---

## 1. Purpose

This is the evidence log — the artifact that makes
`verification-before-completion`'s "no completion claims without fresh
evidence" rule auditable rather than just a habit. Every row below must
correspond to a test run that actually happened in this session, with real
output, not an assumption that a test "should" pass.

**Rule:** nothing in this document gets marked Pass until the command was
actually run and its output is pasted or summarized below. No exceptions
for "obviously correct" cases.

---
```

Sections 2-5, one per test plan type, each a table
`Test ID/Function | Command run/Test command | Actual output/Pass-fail count | Result | Run at (timestamp)`,
seeded with `*pending*` / `Not run` and filled in with real values as tests
actually execute:

- **2. Acceptance Test Results (`<ATP-ID>`)**
- **3. System Test Results (`<STP-ID>`)**
- **4. Integration Test Results (`<ITP-ID>`)** — if the ITP's own `Status`
  is `N/A`, this section is just: `N/A — <ITP-ID> is status ` N/A, <reason>`;
  nothing to run.` (no table).
- **5. Unit Test Results (`<UTP-ID>`)** — columns `Function | Test command
  | Pass/fail count | Result | Run at (timestamp)`.

```
## 6. Overall Verdict

**Not yet determined.** This section only gets filled in once every table
above shows real results — do not summarize a verdict from partial data.

---

## 7. Doc/Diagram Drift Check

At verification time, confirm the shipped code still matches what
<SADD-ID>/<IDD-ID>/<SDD-ID> describe (including their diagrams). Any
divergence found here should either be fixed in code or reflected back into
the design docs before this feature is marked complete — silent drift
between docs and code is exactly the failure mode this whole process exists
to prevent.

| Doc | Still matches implementation? | Notes |
|---|---|---|
| <SADD-ID> | <Yes/No, or *pending* until checked> | |
| <IDD-ID> | <Yes/No, or *pending*> | |
| <SDD-ID> | <Yes/No, or *pending*> | |
```

## Verification Report doc-ID scheme

Same pattern as `v-model-design-docs`' RULES.md: prefix `VR-`, scanned
across `docs/verification/*.md` for `**Doc ID:** VR-NNN`, next number
zero-padded to 3 digits. Use `scripts/next-vr-id.sh` rather than guessing.
