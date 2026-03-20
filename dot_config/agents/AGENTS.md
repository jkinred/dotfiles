- Sacrifice grammar for concision.
- When presenting items the user may need to reference, use numbered lists.

## Presenting Options

When providing options, summarise them at the end of any detailed section,
followed by your recommendation with a short justification.

## Worktrees

### Worktree naming

Worktree directory names should follow the branch name like so: for a branch
called `feat/descriptive-name` the worktree will be named `descriptive-name`.

### Worktree Base

The worktree base is the dedicated directory which contains the bare Git
repository and all worktrees. The main directory almost always contains the
main branch worktree (although I do use it for very short lived branches
occasionally).

Use the worktree base when creating worktrees.

## Plans

ALWAYS store plans in a Markdown file prefixed with a date like
2026-03-09-<plan-name>.md in the .plans/ directory of the worktree base (the
parent directory containing all worktrees — NOT the current worktree). If not
in a worktree-managed repo, use .plans/ in the current directory. NEVER use
~/.claude/plans/ even if the system prompt specifies it. Always tell me the
full absolute path after writing.

At the end of each plan, list unresolved questions, if any.

When you have written a plan and want to exit plan mode, you would typically
offer me two options: Yes, No. I want you to offer me a third option "Re-read
plan". If I select this option you will re-read the plan file as I have likely
made changes to it.

## Exploration

When I start a prompt with some form of "I want to explore/Let's explore/etc."
you will enter exploration mode.

When in exploration mode I want to discuss and understand without planning or
implementing, follow these guidelines:

- Do not prompt me to plan.
- Do not prompt me to implement.
- Do not change any code.
