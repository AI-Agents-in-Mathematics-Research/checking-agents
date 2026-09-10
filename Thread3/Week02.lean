import Thread3.Common

/-!
# Week 2 — Equational reasoning

**In-session: §2.1–§2.5. Out-of-session: §2.6.**

Five workhorse tactics, and the judgement of which one a goal needs:

* `rw [h]` — rewrite with an equation, left to right. `rw [← h]` reverses it;
  `rw [h] at h2` rewrites in a hypothesis instead of the goal.
* `ring` — any identity that holds in every commutative ring.
* `linarith` — linear arithmetic over an ordered field, using the hypotheses.
* `norm_num` — concrete numerical claims.
* `omega` — linear arithmetic over ℕ and ℤ, including truncated subtraction.

Reaching for the wrong one and reading the failure is instructive, so try the
plausible-but-wrong tactic at least once deliberately.
-/

namespace Thread3.Week2

/-! ## 2.1 Rewriting with a hypothesis -/

example (a b : ℕ) (h : a = b) : a + 1 = b + 1 := by sorry

example (a b c : ℕ) (h1 : a = b) (h2 : b = c) : a = c := by sorry

example (a b : ℕ) (h : a = b) : b + 1 = a + 1 := by sorry

example (a b : ℕ) (h1 : a = b) (h2 : a + 1 = 5) : b + 1 = 5 := by sorry

/-! ## 2.2 `ring` -/

example (a b : ℝ) : (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by sorry

example (a b : ℝ) : (a + b) * (a - b) = a ^ 2 - b ^ 2 := by sorry

example (x y z : ℝ) : x * (y + z) - x * y = x * z := by sorry

example (a : ℚ) : (a + 1) ^ 3 = a ^ 3 + 3 * a ^ 2 + 3 * a + 1 := by sorry

/-! ## 2.3 When `ring` fails

Uncomment the line below and try it. `ring` will fail. Before you try another
tactic, decide whether the goal is actually true. `ring_nf` displays the normal
form of each side, which usually settles it in one look.

The exercise is then to prove that the statement is false.
-/

-- example (a b : ℝ) : (a + b) ^ 2 = a ^ 2 + b ^ 2 := by ring

example : ¬ (∀ a b : ℝ, (a + b) ^ 2 = a ^ 2 + b ^ 2) := by sorry

/-! ## 2.4 `calc`

`ring` closes the first goal in one step. Write it as a `calc` chain anyway: a
`calc` block is the formal version of a displayed chain of equalities, and it
is what makes a long proof readable by a human.

Syntax:
```
calc a = b := by tac
  _ = c := by tac
```
-/

example (a b : ℝ) : (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by sorry

example (x : ℝ) (h : x = 3) : x ^ 2 + 1 = 10 := by sorry

/-! ## 2.5 `linarith` and friends -/

example (x y : ℝ) (h1 : x ≤ y) (h2 : y ≤ 3) : x ≤ 3 := by sorry

example (x : ℝ) (h : 2 * x + 1 < 7) : x < 3 := by sorry

example (x y : ℝ) (h1 : x + y = 10) (h2 : x - y = 2) : x = 6 := by sorry

-- Not linear. `positivity` is the specialist for goals of the form `0 ≤ e`.
example (x : ℝ) (_h : 0 ≤ x) : 0 ≤ x ^ 2 := by sorry

-- Also not linear. `nlinarith` accepts hints in square brackets; try
-- `nlinarith [sq_nonneg (x + 1)]`.
example (x : ℝ) : 0 ≤ x ^ 2 + 2 * x + 1 := by sorry

/-! ## 2.6 Out-of-session -/

example (a b c : ℝ) : (a + b + c) ^ 2 =
    a ^ 2 + b ^ 2 + c ^ 2 + 2 * a * b + 2 * a * c + 2 * b * c := by sorry

-- `field_simp` clears denominators once it knows they are non-zero.
example (x : ℝ) (h : x ≠ 0) : x / x = 1 := by sorry

example (a b : ℝ) (h : a = 2 * b) (hb : b = 3) : a = 6 := by sorry

example (x y : ℝ) (h1 : 3 * x + 2 * y = 12) (h2 : x - y = 1) : x = 14 / 5 := by sorry

example (n : ℕ) : (n + 1) ^ 2 = n ^ 2 + 2 * n + 1 := by sorry

example (n : ℕ) (h : 5 ≤ n) : 2 * n - 3 ≥ 7 := by sorry

-- Harder. Factorise first: `have h2 : (x - 2) * (x + 2) = 0 := by nlinarith`,
-- then use `mul_eq_zero`.
example (x : ℝ) (h : x ^ 2 = 4) (hx : 0 < x) : x = 2 := by sorry

end Thread3.Week2
