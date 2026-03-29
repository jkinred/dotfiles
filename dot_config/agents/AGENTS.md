# ~/.config/agents/AGENTS.md
#
# This file is the single source of truth for agent
# instructions. It is symlinked to tool-specific paths:
# - ~/.claude/CLAUDE.md
# - ~/.codex/AGENTS.md
#
# All references to "AGENTS.md" in this file refer to this
# file regardless of which symlink path was used to read it.

# Global Agent Instructions

## Communication

- Sacrifice grammar for concision.
- When presenting items I may need to reference, use numbered
  lists.

### Presenting Options

When providing options, summarise them at the end of any
detailed section, followed by your recommendation with a
short justification.

## Exploration Mode

When I start a prompt with some form of "I want to
explore/Let's explore/etc.", enter exploration mode:

- Do not prompt me to plan.
- Do not prompt me to implement.
- Do not change any code.

## Worktrees

### Naming

Branch `feat/descriptive-name` → worktree directory
`descriptive-name`.

### Worktree Base

The worktree base is the dedicated directory containing the
bare Git repository and all worktrees. The main directory
almost always contains the main branch worktree (occasionally
used for very short-lived branches).

Use the worktree base when creating worktrees.

## Plans

Store plans in:
`~/.local/share/agents/<repo-name>/plans/`

Filename format: `<YYYY-MM-DD>-<plan-name>.md`

Rules:

1. Always tell me the full absolute path after writing.
2. List unresolved questions at the end of each plan.
3. When exiting plan mode, offer three options: Yes, No,
   Re-read plan. "Re-read plan" means I have edited the
   file and you should re-read it before proceeding.

## Progress

Store progress files in:
`~/.local/share/agents/<repo-name>/progress/progress.txt`

Format: plain text, append-only. Each entry:

```
## <YYYY-MM-DD> <session summary>
- What was done.
- What state things are in.
- What remains, if anything.
```

Do not remove or rewrite previous entries.

## Session Lifecycle

### Blocking Gates

Do NOT proceed past these points without meeting the gate
condition. These are blocking requirements.

- **Phase 2 → Phase 3**: WAIT for the user to choose
  plan/implement/explore. Do NOT call Write, Edit, or Bash
  with code until the user has explicitly chosen an option.
- **Phase 3 start**: PRINT the execution checklist before
  any code. Do NOT call Write, Edit, or Bash with code
  until the checklist is printed.

### Phase 1 — Session Start

1. Read the progress file from
   `~/.local/share/agents/<repo-name>/progress/`.
2. Run `git log --oneline -10` to understand recent
   activity.
3. If a plan exists for the current work, read it.
4. If the task involves running the app, verify the dev
   environment.

### Phase 2 — Planning

Do NOT proceed past Phase 2 until the user has chosen an
option. This is a blocking requirement.

After completing Phase 1, ask how to proceed. Offer these
options:

1. Create a plan first.
2. Go straight to implementation.
3. Let's explore/discuss first.

If I choose option 1 or if the agent proposes a plan
in-context, ask whether I want the plan persisted to a file.

Planning guidelines:

- Survey relevant code before planning if unfamiliar with
  the package. Use judgment.
- Plans should include: key decisions, task breakdown, and
  API sketches. Not full implementation detail.
- Scope the plan to one or many sessions based on
  complexity.
- Follow the plan file conventions in the Plans section
  above.

### Phase 3 — Execution

BEFORE writing any code, you MUST output this checklist.
Do NOT call Write, Edit, or Bash with code until this
checklist is printed. This is a blocking requirement.

```
- [ ] Progress file: <path>
- [ ] Plan file: <path> (or "no plan")
- [ ] First task: <description>
```

Execution rules:

- If a plan exists, work through it one task at a time.
- Offer to commit after each logical unit with a
  conventional commit message. Do not commit without
  approval.
- Run unit tests after each change.
- Run integration tests at the end of the session.
- If stuck, attempt a fix within a reasonable token budget
  before asking me.

### Phase 4 — Session End

- If work remains, update the plan file marking
  completed/remaining tasks. Use judgment.
- If work was done, update the progress file.
- If work is incomplete and uncommitted changes exist, ask
  me whether to commit as WIP, revert, or stage with a
  note.
