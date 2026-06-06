---
name: create-implementation-plan
description: Turn a refined requirements document into a structured implementation PLAN.md a fresh session can execute. Planning only — decides the "how", not the "what". Invoke manually only.
disable-model-invocation: true
license: MIT
metadata:
  author: Francesco Borzì
  version: "1.0"
---

# Create Implementation Plan

**Planning only** — no code changes, no execution. You produce one document: an implementation plan that is the contract for a later execution session.

This is the **"how", not the "what"**. The "what" was settled in an earlier refinement step and lives in the requirements document you're given; do not redefine scope. But you **must flag** any gap, ambiguity, or inconsistency you find in the requirements — surface it, never paper over it.

## Golden rule

**Never guess — ask.** With one limit: never ask what the code can answer. Anything resolvable by reading the codebase, resolve by reading the codebase. Only questions the code cannot settle go to the user.

## Steps

1. **Read the requirements document** the user references (e.g. a `*.REQUIREMENTS.md`). If the path is ambiguous, ask.

2. **Verify against the actual codebase.** Open the files the requirements cite and confirm the prior-art references still hold. Note anything that has shifted since the requirements were written. If the requirements gate implementation on missing data or upstream work, verify that gate independently — stale gating claims are a common failure mode and easily inflate into a plan's first step when the data is in fact already addressable.

3. **Grill the user to validate every branch decision.** Interview relentlessly until you reach shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one at a time. Rules:
   - One question at a time.
   - Every question carries your recommended answer.
   - If a question can be answered by exploring the codebase, explore instead of asking.
   - Cover every gap, ambiguity, or inconsistency surfaced in step 2.

   This turns loose requirements into validated ones before any plan is written.

4. **Decide the order of operations.** The requirements are unordered. Impose a sequence that avoids broken intermediate states (data model before its consumers, code before its tests). Track dependencies between steps.

5. **Write the plan** (below) — only once everything above is resolved.

## The original ticket

Don't read the original ticket on your own initiative. The requirements document is the contract; re-deriving the "what" from the ticket wastes tokens and bypasses the refinement that already validated it. If the requirements are incomplete, surface the gap to the user (golden rule) — don't silently fill it from the ticket. The user may point you to it; that's their call, not yours.

## Plan file

The output must be ready for a **fresh session** that reads **only the plan file** and starts implementing — it will not read the requirements document or the ticket. This is the single most important constraint. Anything the execution session needs (acceptance criteria, prior-art citations, file paths, naming/string conventions, type signatures, override notes) must appear in the plan itself. Repetition from the requirements is intentional: the plan is the contract, not a diff against the requirements.

Create the file in the **same directory as the requirements document**, named by replacing `.REQUIREMENTS` with `.PLAN` (e.g. `FOO.REQUIREMENTS.md` → `FOO.PLAN.md`). If the input doesn't follow that convention, append `.PLAN` before `.md`.

Structure — four parts:

1. **Summary** — 1–3 sentences: what this plan implements and the overall shape of the change (which areas are touched).
2. **Conventions and overrides** — two distinct kinds of cross-cutting context:
   - **Conventions**: rules that apply across all steps — naming patterns, user-facing string rules, the testing approach (what to test, following existing test conventions in the codebase). Copy from the requirements verbatim where applicable.
   - **Overrides**: one-time corrections where the requirements deliberately diverge from a default or prior assumption. Each entry: what was assumed, what the actual requirement is, and why. The execution session applies each only where it fits.
3. **Steps** — ordered implementation steps. Each is concrete enough to act on but doesn't dictate every line. Each step has:
   - **What** — a short imperative.
   - **Where** — concrete file paths and identifiers.
   - **How** — the approach in prose. Reuse decisions go here, with `path:line-range` citations for prior art.
   - **Snippet** — *only* when prose is genuinely more ambiguous than code (a non-obvious type signature, a tricky nested structure, an unfamiliar call shape). Default to omitting; keep under ~10 lines.
   - **Depends on** — earlier step numbers this one requires, if any.

   Each step is self-contained — readable without scrolling back. No "as in step 2" without restating what step 2 did. Step 1 must never be discovery work ("find the field names", "explore where this lives") — discovery already happened in the steps above. A small deterministic sanity check of a known fact is fine; open-ended investigation is not.
4. **Acceptance criteria** — flat checklist the implementation must satisfy, copied from the requirements' AC section. If unnumbered, number them (`AC-1`, …). Each references the step number(s) that satisfy it (e.g. "AC-3 → steps 4, 7"). Note any AC that needs manual verification only. The execution session uses this as its done-check.

The plan is mid-level: the execution session still makes tactical choices (variable names, exact error strings, whether to extract a helper). The plan makes the decisions that span files or depend on knowing the codebase (which utility to reuse, what order to change things in, what new types to introduce).

## Boundaries

- Do **not** modify any source files. The only file you write is the plan.
- Do **not** start implementing.
- Do **not** read the original ticket on your own initiative (see above).
- Write the plan to disk only after every open question is resolved.

When done, state that the plan is ready and give its **project-relative path** (relative to the current working directory — never absolute). Then tell the user that a **fresh execution session** should pick it up: a new session reading only the plan file, implementing it, then running whatever validation the project uses (lint, tests, build).
