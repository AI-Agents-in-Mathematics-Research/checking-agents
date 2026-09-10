# Thread 3 — How to Check Their Work

Lean 4 material for Thread 3 of **AI Agents for Mathematics Research**,
Department of Mathematics, University of York.

## Setting up

**In your browser, with nothing installed.** Click the green **Code** button at
the top of this page ▸ **Codespaces** ▸ **Create codespace on main**. Wait for
the terminal to say `Setup finished.`, then open `Thread3/Week01.lean` and wait
for the Infoview to appear on the right. Same VS Code, same Lean, same pinned
Mathlib as everyone else. Two rules: it stops after 30 minutes idle (your files
are kept), and you commit and push at the end of every session — a codespace is
not a backup.

**On your own machine.**

```bash
git clone <this repo> thread3
cd thread3
lake exe cache get      # downloads Mathlib pre-built — do not skip
code .                  # open the FOLDER, not a single file
```

Then open `Thread3/Week01.lean` and wait for the Infoview to appear. If you
have VS Code and Docker locally, "Reopen in Container" gives you the same
environment as the browser one, set up for you.

Full instructions for both routes, including what to do when it does not work,
are in
[`docs/pdf/Thread3_student_setup_guide.pdf`](docs/pdf/Thread3_student_setup_guide.pdf).

## What is here

```
Thread3/Week01.lean … Week06.lean   the exercises — yours to complete
Thread3/Week05Audit.lean            four agent-produced "proofs" to audit in week 5
Thread3/Common.lean                 the shared import surface — do not edit
Thread3/Solutions/                  model solutions, released week by week
docs/pdf/                           the worksheets and the setup guide
```

Each week's worksheet is in
[`docs/pdf/Thread3_student_worksheets_weeks1-6.pdf`](docs/pdf/Thread3_student_worksheets_weeks1-6.pdf).
Read the relevant week before the session.

Run `git pull` each week: exercises are added and corrected as the term goes on,
and solutions appear after each week's quiz.

## What counts as finished

**A file is finished when it contains no `sorry` and the Problems panel is
empty.** Not when it looks right, not when you understand the argument, and not
when an AI agent tells you it is correct.

Note that a `sorry` is a *warning*, not an error, so a file full of `sorry`
still "builds". "It builds" is therefore not the standard. This distinction is
the whole point of the thread, and it is the standard your project will be
marked against.

You can check your own work with the same script we use:

```bash
scripts/verify.sh
```

It builds every file and reports how many `sorry` remain in each. Read that
table, not the verdict line at the end: the script also enforces staff-side
invariants that do not apply to you, so it says `VERIFY FAILED` once you have
*finished* a week's exercises. A file of yours is done when its `sorry` count
is zero and it compiles.

## Pinned versions

| | |
|---|---|
| Lean | `leanprover/lean4:v4.30.0` (see `lean-toolchain`) |
| Mathlib | tag `v4.30.0`, revision `c5ea00351c28` |

**Do not edit `lean-toolchain` or `lakefile.toml`.** Mathlib renames things
continually, and the whole cohort is on one revision so that a lemma name that
works for you works for everyone.

This matters more than it sounds. Tutorials, forum answers and AI agents will
routinely suggest names and tactics from other revisions — `push_neg`, for
instance, is deprecated here in favour of `push Not`. When a suggestion does
not compile, a stale library snapshot is the first thing to suspect. Reading
the deprecation warning is faster than arguing with the agent.

## Getting help

In the session, ask a demonstrator. Outside it, post the **exact error text**
in the module forum — not a screenshot, not a description — together with the
output of `elan show` and `git log --oneline -1`. Anyone can then reproduce
your problem in a minute.
