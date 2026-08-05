# Templates: Section Structure Per Doc

Structure, header order, and level of detail below are derived from
`docs/requirements/`, `docs/design/`, and `docs/test-plans/` in this repo.
Write final content directly into each section — don't leave instructional
placeholder text in the delivered doc, and don't invent extra top-level
sections beyond what's listed.

Every doc's header block follows this shape:

```
# <Doc Type Full Name>: <Feature Name>

**Doc ID:** <see RULES.md doc-ID scheme>
**Feature:** <slug>
**Traces to:** <upstream doc IDs / REQ IDs, per doc below>
**Status:** Draft
**Last updated:** <today's date, YYYY-MM-DD>

---
```

## 1. Requirements Doc (REQ)

- **1. Overview** — 1-3 sentences: what the feature is, why it exists.
- **2. Source / Rationale** — who asked for this or why it exists. Always
  filled in, never implicit.
- **3. Requirements** — one `### REQ-XXX` subsection per atomic, testable
  behavior: **Description**, **Priority** (Must-have/Should-have/Could-have),
  **Acceptance Criteria** as a bulleted list of `AC-XXX-N` items, each one
  concrete input → expected output.
- **4. Out of Scope** — explicit bullet list of what's excluded, to prevent
  scope creep once design starts.
- **5. Traceability** — table `REQ ID | Design ref | Test ref | Code ref |
  Status`, every row `Status = Not started` at authoring time.

`Traces to` in the header: omit (REQ is the root document).

## 2. System Architecture Design Doc (SADD)

- **1. System Context** — what this feature talks to, what talks to it,
  what's outside its boundary.
- **2. Components** — table `Component | Responsibility`. If component and
  function are nearly the same thing at this scale, say so rather than
  inventing artificial subdivisions.
- **3. Architectural Decisions** — bulleted key decisions with the
  reasoning behind each (this is what future readers need most).
- **4. Non-Functional Constraints** — latency, portability, dependency
  constraints, etc., even if not stated as functional requirements.
- **5. Diagram** — apply the SADD row of the diagram rule in RULES.md.
- **6. Traceability** — table `REQ ID | Addressed by`.

`Traces to` in header: all REQ IDs from the REQ doc.

## 3. Interface Design Doc (IDD)

- **1. Overview** — every interface this feature exposes or consumes, one
  sentence on how many there are and what they are.
- **2..N. One subsection per interface** — external interfaces first, then
  internal function contracts, each with: **Type**, invocation/signature,
  **Inputs** (table: name/type/description/constraints), **Outputs**
  (success and error paths, each with channel/format/example), **Error
  behavior**, and versioning notes where relevant.
- **Second-to-last. Diagram** — apply the IDD row of the diagram rule in
  RULES.md.
- **Last. Traceability** — table `REQ ID | Interface(s) involved`.

`Traces to` in header: SADD doc ID + all REQ IDs.

## 4. Software Design Doc (SDD)

- **1. Overview** — one sentence noting this is the function-level design
  that `writing-plans` derives its task breakdown from.
- **2. Module/Function Breakdown** — one `### 2.N \`function_signature\``
  subsection per function named in the SADD/IDD: **Responsibility**,
  numbered **Logic** steps precise enough to implement directly from,
  **Decision log** for any judgment calls made while writing this doc, and
  **Data structures** used/introduced by this function.
- **3. Data Structures** — any shared data structures not already fully
  defined inline in section 2; state explicitly if none are needed.
- **4. Diagram** — apply the SDD row of the diagram rule in RULES.md. Name
  which function(s) got a flowchart and why the rest didn't.
- **5. Traceability** — table `REQ ID | Function(s)`.

`Traces to` in header: IDD doc ID + SADD doc ID + all REQ IDs.

## 5. Acceptance Test Plan (ATP)

- **1. Purpose** — one sentence: proves every AC in the REQ doc is met via
  full black-box invocation, not internal calls.
- **2. Test Cases** — table `Test ID | Traces to | Invocation | Expected
  output | Expected exit/result`, one row per AC in the REQ doc, zero gaps.
- **3. Out of Scope for This Plan** — what's deliberately not covered here
  (internal function behavior → unit plan; cross-component sequencing →
  integration plan).
- **4. Diagram** — apply the ATP row of the diagram rule in RULES.md
  (normally "None", with the one-sentence justification).
- **5. Traceability** — reference that section 2's `Traces to` column is
  the traceability; note that results are logged in a verification report
  elsewhere, not in this doc.

`Traces to` in header: REQ doc ID ("all acceptance criteria").

## 6. System Test Plan (STP)

- **1. Purpose** — proves end-to-end system behavior as described in the
  SADD, as a whole, not function-by-function.
- **2. Note on Overlap with the Acceptance Test Plan** — state explicitly,
  as a design observation (not an apology), how much this plan overlaps
  with acceptance at this feature's scale, and why.
- **3. Additive System-Level Test Cases** — table `Test ID | Scenario |
  Expected behavior`, covering only what's genuinely additive to the
  acceptance plan (process lifecycle, statelessness across invocations,
  input edge cases not already covered). Don't pad with restated acceptance
  cases.
- **4. Diagram** — apply the STP row of the diagram rule in RULES.md.
- **5. Traceability** — table `SADD ref | Test(s)`.

`Traces to` in header: SADD doc ID.

## 7. Integration Test Plan (ITP)

- **1. Purpose** — state plainly whether this feature has any real
  cross-component/cross-service boundary per the SADD. If not, say the plan
  is deliberately thin/empty and why — a recorded decision, not a gap. Note
  what future trigger (e.g. a new external integration) would turn this
  from `N/A` into a real plan.
- **2. Test Cases** — real cases if a boundary exists; otherwise "None at
  this time."
- **3. Diagram** — apply the ITP row of the diagram rule in RULES.md.
- **4. Traceability** — table `IDD ref | Status`, stating which other plan
  covers each interface instead, when this plan is empty.

`Traces to` in header: IDD doc ID. `Status` in header: `N/A — <one-line
reason>` when there's no cross-component boundary, `Draft` otherwise.
