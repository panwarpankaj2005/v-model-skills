# v-model-skills

A small Claude Code plugin that layers V-model process gates — requirements
capture, SADD/IDD/SDD generation, and traceability enforcement — on top of
[Superpowers](https://github.com/obra/superpowers). It does not modify
Superpowers; it depends on it being installed separately.

## Requirements

Install Superpowers first:

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

Then install this plugin the same way, pointing at wherever you host this
repo (see "Publishing" below), or load it locally while iterating (see
"Local development").

## Skills in this plugin

- **`v-model-design-docs`** — runs after `brainstorming` produces an
  approved design. Generates a Requirements doc (REQ), System Architecture
  Design Document (SADD), Interface Design Document (IDD), Software Design
  Document (SDD), and matching Acceptance/System/Integration test plans.
  Gates `writing-plans` until all of these exist.
- **`v-model-traceability`** — owns the traceability matrix and
  verification report for each feature. Gates `verification-before-completion`
  and `finishing-a-development-branch` until every requirement row is
  `Verified` with real, logged test evidence, and until design docs show no
  unresolved drift from the implementation.

Intended skill ordering:

```
brainstorming (+ REQ extraction)
  → v-model-design-docs
  → writing-plans
  → test-driven-development
  → v-model-traceability gates
  → verification-before-completion
  → finishing-a-development-branch
```

## IMPORTANT — replace the placeholder skill files

The two `SKILL.md` files in `skills/` in this scaffold are **drafts**,
written from the spec discussed in chat — they are a starting point, not
the final version. The authoritative versions are whatever `skill-creator`
actually generated for you inside your `temp-converter` Claude Code
session in Step 5. Before using this plugin for real:

1. Open the `SKILL.md` files `skill-creator` generated in your
   `temp-converter` repo (check `.claude/skills/v-model-design-docs/` and
   `.claude/skills/v-model-traceability/`, or wherever it reported saving
   them).
2. Replace the corresponding placeholder files in this repo's `skills/`
   folder with that real content (or diff them and merge — the drafts here
   may still be useful as a cross-check).
3. Commit.

## Local development

While iterating, you don't need to publish anywhere — point Claude Code at
this folder directly as a local plugin source, or symlink/copy the
`skills/` subfolders into your project's own `.claude/skills/` directory.

## Reference example this plugin was built from

The `v-model-design-docs` and `v-model-traceability` skills were originally
scaffolded using the temperature-converter demo project's hand-authored
docs (REQ, SADD, IDD, SDD, test plans, traceability matrix) as the worked
example `skill-creator` generalized from.
