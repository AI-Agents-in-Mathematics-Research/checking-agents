# Thread 3 — How to Check Their Work

Lean 4 material for Thread 3 of **AI Agents for Mathematics Research**,
Department of Mathematics, University of York.

## Setting up

### First, take your own copy

You cannot push to this repository. Everything below happens in **your** copy,
so make it before you do anything else.

Click **Fork** at the top right of this page, then **Create fork**, leaving the
name and the settings as they are. You now have
`your-username/checking-agents`. Every instruction from here on means *your*
fork, not this page.

Your fork is public, as this repository is. Anyone can see your work in
progress, and nobody is assessed on what a half-finished file looked like on a
Tuesday — but do not keep anything in it you would not want read.

### Then, one of these two

**In your browser, with nothing installed.** On **your fork**, click the green
**Code** button ▸ **Codespaces** ▸ **Create codespace on main**. The first
launch downloads a ready-made environment with Lean and a pre-built Mathlib
already in it, so it takes a few minutes; later ones are quick. Wait for the terminal to say `Setup finished.`,
then open `Thread3/Week01.lean` and wait for the Infoview to appear on the
right. Same VS Code, same Lean, same pinned Mathlib as everyone else. Two
rules: it stops after 30 minutes idle (your files are kept), and you commit and
push at the end of every session — a codespace is not a backup.

Codespaces is free on your own account up to a monthly allowance, and this
thread needs roughly a third of it. Sign up for the **GitHub Student Developer
Pack**, which raises that allowance by half again, and delete codespaces you
have finished with — the storage is the part you are most likely to run out of.

**On your own machine.**

```bash
git clone https://github.com/YOUR-USERNAME/checking-agents.git thread3
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

## Getting each week's updates

Exercises are corrected and added as the term goes on, and each week's model
solutions appear after that week's quiz. Those changes land in the **original**
repository, not in your fork, so you have to bring them across. Once a week:

1. On your fork's page on GitHub, click **Sync fork** ▸ **Update branch**.
2. In your codespace or your local checkout, `git pull`.

If you prefer the command line, do it once:

```bash
git remote add upstream https://github.com/AI-Agents-in-Mathematics-Research/checking-agents.git
```

and thereafter `git pull upstream main`.

If git reports a conflict because you have edited a file that also changed
upstream, stop and ask a demonstrator. Do not force anything: your work is on
the losing side of most of the obvious commands.

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
