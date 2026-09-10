import Thread3.Common

/-!
# Week 4 — Induction, recursion, and finding what already exists

**In-session: §4.1–§4.4. Out-of-session: §4.5.**

Two themes.

**Induction.** The tactic mirrors the mathematics closely:
```
induction n with
  | zero => ...
  | succ k ih => ...
```
so the difficulty is almost never in the tactic. It is in choosing the right
statement to induct on. If an induction will not close, suspect the statement
before you suspect yourself.

**Library search.** From this week onwards, assume anything standard is already
in Mathlib, and that finding it is the skill. In rough order of cost:

1. Guess the name. Mathlib names describe statements: `add_comm`,
   `mul_le_mul_left`, `List.length_append`, `Nat.succ_le_of_lt`.
2. `exact?` — looks for a single lemma that closes the goal.
3. `apply?` — looks for a lemma whose conclusion matches the goal.
4. `simp?` — reports which simp lemmas fired, often naming the one you wanted.
5. Loogle or LeanSearch — search by the *shape* of a statement rather than by
   name. Useful when you cannot guess any part of the name.

Reproving a library lemma from scratch is not a neutral choice: it makes your
development longer, more fragile and harder for anyone else to read.
-/

namespace Thread3.Week4

open Finset Nat

/-! ## 4.1 Induction on ℕ

The Gauss sum. Note the statement is phrased as `2 * ∑ ... = n * (n - 1)`
rather than with a division, because ℕ division truncates.
-/

theorem sum_first_n (n : ℕ) : 2 * (∑ i ∈ range n, i) = n * (n - 1) := by sorry

example (n : ℕ) : ∑ i ∈ range n, (2 * i + 1) = n ^ 2 := by sorry

example (n : ℕ) : 2 ^ n ≥ n + 1 := by sorry

/-! ## 4.2 A statement that resists induction because it is false

Try to prove `∀ n : ℕ, n ^ 2 ≤ 2 ^ n` by induction and watch it fail. Then work
out why: the statement is false somewhere. Find the counterexample, then state
and prove the corrected version (it appears again in week 5).
-/

example : ¬ (∀ n : ℕ, n ^ 2 ≤ 2 ^ n) := by sorry

/-! ## 4.3 Induction on lists

`List.length`, `List.reverse` and `++` are all defined by recursion, so
induction on lists works exactly as on ℕ:
```
induction l with
  | nil => ...
  | cons a t ih => ...
```
-/

example (l : List ℕ) : (l ++ []).length = l.length := by sorry

example (l₁ l₂ : List ℕ) : (l₁ ++ l₂).length = l₁.length + l₂.length := by sorry

example (l : List ℕ) : l.reverse.length = l.length := by sorry

/-! ## 4.4 Library search

Each of the following is a single existing lemma, or a one-line consequence of
one. **Find the lemma; do not reprove the statement.** Write the name you
found in the comment, so that next week you can compare your search results
with what an agent produces.
-/

-- name:
example (a b : ℕ) : a + b = b + a := by sorry

-- name:
example (l₁ l₂ : List ℕ) : (l₁ ++ l₂).length = l₁.length + l₂.length := by sorry

-- name:
example (x y : ℝ) (h : x < y) : ∃ z : ℝ, x < z ∧ z < y := by sorry

-- name:
example (n : ℕ) (hn : 2 ≤ n) : ∃ p : ℕ, p.Prime ∧ p ∣ n := by sorry

-- name:
example (s : Finset ℕ) (f : ℕ → ℕ) (h : ∀ i ∈ s, f i = 0) : ∑ i ∈ s, f i = 0 := by sorry

/-! ## 4.5 Out-of-session -/

example (n : ℕ) : ∑ i ∈ range n, (i + 1) = ∑ i ∈ range (n + 1), i := by sorry

example (n : ℕ) : 3 ∣ n ^ 3 + 2 * n := by sorry

example (l : List ℕ) : l.reverse.reverse = l := by sorry

example (n : ℕ) : (n + 1)! = (n + 1) * n ! := by sorry

example (n : ℕ) (h : 1 ≤ n) : n ! ≥ 1 := by sorry

example (a b c : ℕ) (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by sorry

end Thread3.Week4
