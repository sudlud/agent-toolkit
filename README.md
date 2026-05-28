# agent-toolkit

My own toolkit for AI Agentic Coding

## Rules

This is a collection of project-agnostic rules I use in all of my projects, I apply them at user level rather than per-project.

Each file in [`rules/`](rules) is a single, self-contained behavioral rule.

### Install for Claude Code

Claude Code auto-loads every `*.md` under `~/.claude/rules/` at the start of each session
([docs](https://code.claude.com/docs/en/memory)).

You can (A) either symlink this repo's `rules/` into that location so changes here apply everywhere automatically:

```sh
# A) No existing ~/.claude/rules — link the whole directory.
#    New rules added to this repo are then picked up automatically.
git clone git@github.com:FrancescoBorzi/agent-toolkit.git && cd agent-toolkit
ln -s "$(pwd)/rules" ~/.claude/rules
```

Or (B) manually pick and choose specific rules to link if you already have some rules in place.

```sh
# B) ~/.claude/rules already exists — link only the rules you want instead.
git clone git@github.com:FrancescoBorzi/agent-toolkit.git && cd agent-toolkit
ln -s "$(pwd)/rules/git-read-only-by-default.md" ~/.claude/rules/
ln -s "$(pwd)/rules/no-nonsense-comments.md"     ~/.claude/rules/
ln -s "$(pwd)/rules/self-contained-docs.md"      ~/.claude/rules/
```

Start a new session and run `/context` to confirm the rules are loaded. Rules apply at the
user level (all projects); to scope them to one project, symlink into that repo's `.claude/rules/` instead.

## Skills

Collection of skills I use in multiple projects. Each lives in its own directory under [`skills/`](skills)
with a `SKILL.md` describing the trigger, allowed tools, and steps.

They can be installed via [skills.sh](https://skills.sh/):

```sh
npx skills add FrancescoBorzi/agent-toolkit
```

### run-nx-checks

Runs `nx format`, `lint`, `test`, and `build` against affected projects (or a specific one) and
applies only mechanical, unambiguous fixes — lint auto-fixes, missing imports, obvious type
errors — asking before touching anything judgment-laden. Accepts an optional CPU count and
project name as arguments. See [`skills/run-nx-checks/SKILL.md`](skills/run-nx-checks/SKILL.md).
