import Thread3.Common

/-!
# Week 5 — Agent-assisted formalisation

**In-session: Part A (25 min) then Part B (25 min). Out-of-session: Part C.**

This is the first session in which you use an AI agent on the Lean development.
From here on it is a permitted and expected tool. What changes is that you now
need a standard for accepting its output.

## The protocol

1. **State the goal yourself.** Write the Lean statement by hand before asking
   for anything. If you let the agent write the statement, you have delegated
   the part that matters.
2. **Ask for a proof of that exact statement.** Give it the imports and the
   Mathlib version.
3. **Compile.** Never read a proof to decide whether it is correct; that is
   what the compiler is for.
4. **Feed back the error, verbatim.** Do not paraphrase and do not summarise.
   The error text contains the elaborated types, which is the information the
   agent needs.
5. **Stop after three failed rounds** and work out yourself what the obstacle
   is. Agents loop on the same wrong idea; you will not get out of the loop by
   asking again.
6. **Accept only after the acceptance check below.**

## The acceptance check

A proof is finished when all four hold:

* the file builds with no errors;
* `#print axioms thm` reports no `sorryAx` — this catches a `sorry` anywhere
  in the dependency tree, including in a helper lemma you did not read;
* nothing in the file says `sorry`, `admit`, `native_decide`, or adds an
  `axiom`;
* **the statement is the one you meant.** Read it once more, out loud, against
  the informal claim.

The fourth is the one that fails in practice, and it is the subject of week 6.

## Part A — proving with agent assistance

Prove these with an agent, following the protocol. Keep a note of which
succeeded first time, which needed error feedback, and which the agent got
wrong in a way you had to fix yourself. You will need that note for §5 of the
project brief.
-/

namespace Thread3.Week5

example (n : ℕ) : n % 2 = 0 ∨ n % 2 = 1 := by sorry

example (a b : ℤ) (h : a ∣ b) : a ∣ 3 * b := by sorry

example (x : ℝ) (hx : 0 ≤ x) : Real.sqrt x ^ 2 = x := by sorry

example (n : ℕ) : ∑ i ∈ Finset.range n, (2 * i + 1) = n ^ 2 := by sorry

example (s : Finset ℕ) : s.card = 0 ↔ s = ∅ := by sorry

-- Harder. Agents often produce a `simp`-only attempt that fails on this one.
example (a b : ℝ) (ha : 0 < a) (hb : 0 < b) : 2 ≤ a / b + b / a := by sorry

-- Harder. True, but the induction needs a base case at 4 rather than 0, which
-- agents routinely miss on the first attempt. You met the counterexample for
-- small `n` in week 4.
example (n : ℕ) (hn : 4 ≤ n) : n ^ 2 ≤ 2 ^ n := by sorry

/-! ## Part B — the audit

Open `Thread3/Week05Audit.lean`. It contains four declarations, each produced
by an agent asked to prove the claim in the comment above it. All four compile.
Exactly one is an honest proof of the stated claim.

For each, record a verdict and, where it fails, the precise defect. Then write
one sentence on which of the four checks in the acceptance list above would
have caught it.

Do this before opening the solutions.

## Part C — out-of-session

Take one of the following and produce a complete, `sorry`-free development with
agent assistance. Submit the Lean file together with a short log: what you
asked, what came back, what you had to fix.

1. The sum of the first `n` cubes is `(n * (n + 1) / 2) ^ 2`. State it in a way
   that avoids ℕ division.
2. `√2` is irrational. Mathlib has this; state it yourself first, then find the
   library version and compare it with what your agent produced.
3. For every `n ≥ 1`, `∑ i ∈ range n, 1 / ((i + 1) * (i + 2)) = n / (n + 1)`
   over ℝ. Watch the casts.
4. A statement of your own choosing from a Stage 2 module. Bring it to the
   week 6 session, where you will check whether your formalisation is faithful.
-/

end Thread3.Week5
