---
name: fresh-eyes-review
description: Fresh-eyes review of a changeset — spawn a fresh-context agent over the uncommitted changes by default, or any branch, commit, or diff named as input, to catch regressions and correctness issues and report grounded findings back to the session.
license: MIT
metadata:
  author: Francesco Borzì
  version: "0.1"
---

# Fresh-eyes review

A context that produced a change reads its intent, not its text, so same-context review misses what
a fresh reader would catch. The fix is procedural: a reviewer whose context holds only the
artifacts.

## Workflow

1. **Resolve the inputs.** The changeset: the uncommitted git changes by default, or whatever the
   invocation names instead — a branch, a commit, a diff range, a draft vs its original. Alongside
   it, a short statement of what the change is supposed to achieve, when one exists (the task as
   stated, a PR or ticket description); when this session authored the change, never include the
   session's own reasoning, plan, or messages — leaked rationale recreates the blindness the fresh
   context exists to remove. Done when changeset and intent are pinned down and free of authoring
   context.
2. **Spawn one fresh-context reviewer** (a subagent or equivalent isolated session) with those
   inputs, free to read any surrounding project material — except, when this session authored the
   change, session-authored files that are not part of it (plans, notes, scratch), whose paths the
   spawn instructions must list, since a fresh context cannot tell them apart. Its mandate, unless
   the invocation redirects it (e.g. security only): regressions and correctness, including
   contradictions with surrounding code, rules, or docs; ambiguities a reader without context
   would trip on; and, when an intent statement was given, whether the change does what it says.
   Tough but grounded, aimed at mistakes that matter: every finding names its location and a
   concrete failure scenario; style nits, speculation, and padding are out of scope, and zero
   findings is a valid outcome. If the harness cannot isolate a context, fall back to an
   adversarial pass over the same inputs in the main session. Done when an isolated reviewer has
   returned its findings, or the fallback pass ran and its result is flagged as same-context
   (weaker).
3. **Report back.** Relay every finding intact — location and failure scenario included; add the
   session's own assessment when useful, but never silently drop or soften a finding. What to do
   with the findings is the caller's decision, not this skill's. Done when every reviewer finding
   appears in the report.
