import Thread3.Common

/-!
# Week 5, Part B — Four submitted "proofs" to audit

Each of the four declarations below was produced by an AI agent that was asked
to prove the claim stated in the comment above it. **Every one of them
compiles.** Exactly one of them is an honest proof of the stated claim.

Your job is to decide, for each, whether the file constitutes a proof of what
the comment says — and to say precisely what is wrong when it does not.

Useful:

* `#print axioms name` — reports the axioms a declaration depends on.
  A dependence on `sorryAx` means the proof has a hole somewhere in its
  dependency tree, however far away.
* Read the *statement*, not the proof. Most defects are in the statement.
* Instantiate at concrete values and see whether the claim still says
  anything.

Do not look at `Thread3/Solutions/Week05.lean` until you have written down a
verdict for all four.
-/

namespace Thread3.Week5.Audit

/-! ## Submission 1

CLAIM: every natural number is either even or odd.
-/

private theorem mod_two_cases (n : ℕ) : n % 2 = 0 ∨ n % 2 = 1 := by
  sorry

theorem submission1 (n : ℕ) : ∃ m : ℕ, n = 2 * m ∨ n = 2 * m + 1 := by
  refine ⟨n / 2, ?_⟩
  rcases mod_two_cases n with h | h
  · left; omega
  · right; omega

/-! ## Submission 2

CLAIM: for every natural number n there is a prime number larger than n.
-/

theorem submission2 : ∀ n : ℕ, ∃ p : ℕ, Nat.Prime p → n < p := by
  intro n
  exact ⟨4, fun hp => absurd hp (by norm_num)⟩

/-! ## Submission 3

CLAIM: if a real number has negative square then it equals 42.
(The agent was asked to prove this as a "sanity check" on its abilities.)
-/

theorem submission3 (x : ℝ) (h : x ^ 2 < 0) : x = 42 := by
  nlinarith [sq_nonneg x]

/-! ## Submission 4

CLAIM: for all natural numbers a and b, if b ≤ a then (a - b) + b = a.
-/

theorem submission4 (a b : ℕ) (h : b ≤ a) : a - b + b = a := by
  omega

end Thread3.Week5.Audit
