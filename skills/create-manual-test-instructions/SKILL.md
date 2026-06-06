---
name: create-manual-test-instructions
description: Turn a REQUIREMENTS document into a concise QA manual-test file a non-author can follow. Invoke manually only.
disable-model-invocation: true
---

# Create manual test instructions

Turn a refined requirements document into a concise QA manual-test file. Input: a `*.REQUIREMENTS.md`
produced by the Refine phase.

Read the requirements file (and, where needed for accurate navigation, the code it cites). Write the
manual-test file in the **same directory**, naming it by replacing `.REQUIREMENTS` with `.MANUAL-TEST`
(e.g. `FOO.REQUIREMENTS.md` → `FOO.MANUAL-TEST.md`).

The file must be followable by someone **unfamiliar with the ticket** — short but complete. Four parts:

1. **What changed** — 1–2 sentences: the feature and the user-visible difference.
2. **How to get there** — concrete navigation to the affected area (entry point, page/screen name, any
   prerequisite state).
3. **Before vs after** — how the area behaved before, how it should behave now.
4. **What to verify** — checklist of behaviors to confirm, including edge cases (empty values, multiple
   items, boundaries) where relevant.

Do not modify any source files; the only file you write is the manual-test document.

When done, state the manual-test file's **project-relative path**.
