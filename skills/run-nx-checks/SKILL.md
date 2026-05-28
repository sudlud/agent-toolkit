---
name: run-nx-checks
description: Run nx format, lint, test, and build on affected or specified projects, then fix unambiguous failures
context: fork
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
license: MIT
metadata:
  author: Francesco Borzì
  version: '1.0'
---

# Run Nx Checks

Run format, lint, test, build. Fix unambiguous failures. Ask on anything judgment-laden.

## Arguments

`$ARGUMENTS` — optional, space-separated: `[cpuCount] [projectName]`.
Number token → `cpuCount`. Non-number token → `projectName`.
Default `cpuCount` = `nproc - 4` (min 1). Default project scope = affected.

## Workspace

Run nx commands from wherever `nx.json` lives in this repo (commonly the root; in some repos a subdirectory).

## Fix rule (applies to lint, test, build)

- Apply only mechanical/unambiguous fixes: lint auto-fix output, missing imports/types, obvious type errors, test expectations that mirror a clear code change.
- Ask the user — don't guess — for anything judgment-laden: test failure that could be a real bug vs. an outdated assertion, errors pointing at unrelated areas, pre-existing failures unrelated to recent work, anything where multiple plausible fixes exist.
- Keep changes minimal and scoped to the failure. No drive-by refactors.
- After fixing, re-run the check. Repeat until clean or you need to ask.

## Steps

1. `npx nx format:write`
2. Lint — `npx nx affected -t lint --parallel=$cpuCount --fix` (or `npx nx lint $projectName --parallel=$cpuCount --fix`).
3. Test — `npx nx affected -t test --parallel=$cpuCount` (or `npx nx test $projectName --parallel=$cpuCount`).
4. Build — `npx nx affected -t build --parallel=$cpuCount` (or `npx nx build $projectName --parallel=$cpuCount`).

Apply the fix rule on any failure in steps 2–4.
