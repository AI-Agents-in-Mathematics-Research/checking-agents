import Thread3.Common

/-!
# Week 6 — The specification problem

**In-session: §6.1–§6.5. Out-of-session: §6.6–§6.7.**

A complete, machine-checked proof of the wrong statement is worth nothing, and
nothing in the toolchain will warn you. Lean guarantees that your proof follows
from your statement. It offers no guarantee whatever that your statement means
what you intended. That gap is where AI-assisted formalisation goes wrong, and
closing it is not automatable — it is the mathematician's job.

## Five techniques that detect a mismatch

1. **Instantiate.** Put concrete values in. `#eval`, `decide`, `norm_num`.
2. **Try to satisfy the hypotheses.** If you cannot, the theorem is vacuous
   and proves nothing.
3. **Prove the negation of the intended claim.** If that succeeds, the
   formalisation was not faithful.
4. **Check the degenerate cases.** Zero, empty, negative, `≤` versus `<`.
5. **Unfold the definitions.** Lean's functions are total. `Nat` subtraction
   truncates, `Nat` division rounds, `x / 0 = 0`, and `Real.sqrt` of a negative
   number is `0`. None of these is the mathematical operation you learned.

For each item below: decide whether the formalisation is faithful to the
informal statement. If it is, prove it. If it is not, *prove that* — by
refuting it, by showing it is vacuous, or by stating the intended version and
showing the two differ.
-/

namespace Thread6 -- deliberately not `Week6`; see §6.7

/-! ## 6.1 Truncated subtraction

INFORMAL: for all natural numbers a and b, (a − b) + b = a.
-/

example : ¬ (∀ a b : ℕ, a - b + b = a) := by sorry

-- State and prove the repaired version.
example (a b : ℕ) (h : b ≤ a) : a - b + b = a := by sorry

-- And over ℤ, where no hypothesis is needed. Choosing the type is part of the
-- specification.
example (a b : ℤ) : a - b + b = a := by sorry

/-! ## 6.2 Division

INFORMAL: for all reals a and b, (a / b) * b = a.
-/

example : ¬ (∀ a b : ℝ, a / b * b = a) := by sorry

example (a b : ℝ) (hb : b ≠ 0) : a / b * b = a := by sorry

/-! ## 6.3 A total function that is not the mathematical one

INFORMAL: the square of the square root of x is x.

`Real.sqrt_eq_zero_of_nonpos` is the relevant fact about the definition.
-/

example : ¬ (∀ x : ℝ, Real.sqrt x ^ 2 = x) := by sorry

example (x : ℝ) (hx : 0 ≤ x) : Real.sqrt x ^ 2 = x := by sorry

/-! ## 6.4 Vacuous hypotheses

INFORMAL: every prime number strictly between 24 and 28 is even.

The statement below is true and provable. Prove it — `interval_cases p` will
do the work — and then explain in one sentence why having proved it tells you
nothing. Then prove the diagnostic: that the hypotheses cannot be satisfied.

This is the pattern to watch for when an agent reports success on something you
expected to be hard.
-/

example (p : ℕ) (hp : Nat.Prime p) (h1 : 24 < p) (h2 : p < 28) : p % 2 = 0 := by sorry

example : ¬ ∃ p : ℕ, Nat.Prime p ∧ 24 < p ∧ p < 28 := by sorry

/-! ## 6.5 Quantifier order

Two definitions. They differ only in whether `x` is bound before or after `δ`.
One is continuity at every point; the other is uniform continuity.

Say which is which. Then prove that one implies the other, and state (you need
not prove) a function witnessing that the converse fails.
-/

def ContinuousAtAllPoints (f : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, ∀ ε > 0, ∃ δ > 0, ∀ y : ℝ, |y - x| < δ → |f y - f x| < ε

def UniformlyCont (f : ℝ → ℝ) : Prop :=
  ∀ ε > 0, ∃ δ > 0, ∀ x y : ℝ, |y - x| < δ → |f y - f x| < ε

theorem uniform_imp_pointwise (f : ℝ → ℝ) (h : UniformlyCont f) :
    ContinuousAtAllPoints f := by sorry

-- A sanity check that the definitions are satisfiable at all. A definition that
-- nothing satisfies is a specification bug, and this is how you find out.
theorem id_uniformly_cont : UniformlyCont (fun x : ℝ => x) := by sorry

/-! ## 6.6 Out-of-session

INFORMAL: n is even. Two candidate formalisations — are they equivalent?
-/

example (n : ℕ) : n % 2 = 0 ↔ ∃ m : ℕ, n = 2 * m := by sorry

-- INFORMAL: every prime is odd.
example : ¬ (∀ p : ℕ, Nat.Prime p → p % 2 = 1) := by sorry

example (p : ℕ) (hp : Nat.Prime p) (h2 : 2 < p) : p % 2 = 1 := by sorry

-- INFORMAL: the maximum of two naturals is at least each of them.
example (a b : ℕ) : a ≤ max a b ∧ b ≤ max a b := by sorry

-- INFORMAL: every non-empty finite set of naturals has a least element.
-- Is the non-emptiness hypothesis doing real work? Say why.
example (s : Finset ℕ) (hs : s.Nonempty) : ∃ m ∈ s, ∀ n ∈ s, m ≤ n := by sorry

-- INFORMAL: if a divides b and b divides a then a = b.
example : ¬ (∀ a b : ℤ, a ∣ b → b ∣ a → a = b) := by sorry

example (a b : ℕ) (hab : a ∣ b) (hba : b ∣ a) : a = b := by sorry

-- INFORMAL: a sum of squares is zero only if every term is.
example (x y : ℝ) (h : x ^ 2 + y ^ 2 = 0) : x = 0 ∧ y = 0 := by sorry

/-! ## 6.7 The one to bring to the session

INFORMAL: for every ε > 0 there is a natural number n with 1/n < ε.

The formalisation below is provable in one line. Prove it, then explain why it
is not a formalisation of the informal claim. Then state and prove the version
you meant.

(Also: this file's namespace is `Thread6`, not `Thread3.Week6`. Everything
still compiles. A namespace is not part of a specification — but a `def` you
did not notice shadowing a Mathlib one is, so check what your names refer to.)
-/

example : ∀ ε : ℝ, ε > 0 → ∃ n : ℕ, 1 / (n : ℝ) < ε := by sorry

example : ∀ ε : ℝ, ε > 0 → ∃ n : ℕ, 0 < n ∧ 1 / (n : ℝ) < ε := by sorry

end Thread6
