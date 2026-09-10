import Thread3.Common

/-!
# Week 3 — Connectives and quantifiers

**In-session: §3.1–§3.7. Out-of-session: §3.8–§3.9.**

For each connective there is one tactic that *builds* a proof of it and one
that *uses* a proof of it. Learn the table and most of this week is mechanical.

* goal `P → Q`  : build with `intro`, use by application
* goal `P ∧ Q`  : build with `constructor` or `⟨_, _⟩`, use with `obtain ⟨h1, h2⟩ := h` (or `h.1`, `h.2`)
* goal `P ∨ Q`  : build with `left` / `right`, use with `rcases h with h1 | h2`
* goal `¬ P`    : build with `intro` (since `¬ P` *is* `P → False`), use by applying it
* goal `P ↔ Q`  : build with `constructor`, use with `rw [h]`, `h.mp`, `h.mpr`
* goal `∀ x, P x`: build with `intro`, use by application
* goal `∃ x, P x`: build with `use` or `refine ⟨_, ?_⟩`, use with `obtain ⟨x, hx⟩ := h`

`push Not` pushes negations inward through quantifiers and connectives
(in older material and in many AI agents' output this tactic is called
`push_neg`, which is deprecated on the pinned Mathlib revision — a small,
representative example of why the revision is pinned). `by_contra h` starts a
proof by contradiction.
-/

namespace Thread3.Week3

/-! ## 3.1 Conjunction -/

example (P Q : Prop) (hP : P) (hQ : Q) : P ∧ Q := by sorry

example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by sorry

example (P Q : Prop) (h : P ∧ Q) : P := by sorry

/-! ## 3.2 Disjunction -/

example (P Q : Prop) (hP : P) : P ∨ Q := by sorry

example (P Q : Prop) (h : P ∨ Q) : Q ∨ P := by sorry

example (P Q R : Prop) (h : P ∨ Q) (hPR : P → R) (hQR : Q → R) : R := by sorry

/-! ## 3.3 Negation -/

example (P : Prop) (hP : P) : ¬ ¬ P := by sorry

example (P Q : Prop) (hPQ : P → Q) (hnQ : ¬ Q) : ¬ P := by sorry

-- Try `push Not` first and look at what the goal becomes.
example : ¬ (∀ n : ℕ, n ≥ 1) := by sorry

example (P Q : Prop) : ¬ (P ∧ Q) ↔ (P → ¬ Q) := by sorry

/-! ## 3.4 Iff -/

example (n : ℕ) : n = 0 ↔ n + 1 = 1 := by sorry

example (P Q : Prop) (h : P ↔ Q) (hP : P) : Q := by sorry

/-! ## 3.5 Universal quantification -/

example : ∀ n : ℕ, n + 0 = n := by sorry

example : ∀ x : ℝ, x ^ 2 ≥ 0 := by sorry

example (f : ℕ → ℕ) (h : ∀ n : ℕ, f n = n) : f 3 = 3 := by sorry

/-! ## 3.6 Existential quantification -/

example : ∃ n : ℕ, n > 5 := by sorry

example : ∃ n : ℕ, 4 < n ∧ n < 6 := by sorry

example (h : ∃ n : ℕ, n > 5) : ∃ m : ℕ, m > 3 := by sorry

/-! ## 3.7 Nested quantifiers — the important part of this session

The two statements below differ only in the order of the quantifiers. One is
true and one is false. Prove the first and refute the second, and write one
sentence in the comment saying what each one says in English.

Reversing a quantifier order is the commonest way a formalisation ends up
saying something other than what was intended. Week 6 is entirely about this.
-/

-- English:
example : ∀ n : ℕ, ∃ m : ℕ, m > n := by sorry

-- English:
example : ¬ (∃ m : ℕ, ∀ n : ℕ, m > n) := by sorry

-- The shape you will meet in every analysis argument. `refine ⟨ε / 2, ?_, ?_⟩`
-- leaves two goals.
example : ∀ ε : ℝ, ε > 0 → ∃ δ : ℝ, δ > 0 ∧ δ < ε := by sorry

/-! ## 3.8 Injective and surjective

`Function.Injective f` unfolds to `∀ a b, f a = f b → a = b`, so it is proved
by `intro a b h`. `Function.Surjective f` unfolds to `∀ c, ∃ a, f a = c`.
-/

example : Function.Injective (fun n : ℕ => n + 1) := by sorry

example (f g : ℕ → ℕ) (hf : Function.Injective f) (hg : Function.Injective g) :
    Function.Injective (f ∘ g) := by sorry

example (f g : ℕ → ℕ) (hf : Function.Surjective f) (hg : Function.Surjective g) :
    Function.Surjective (f ∘ g) := by sorry

/-! ## 3.9 Out-of-session -/

example (P Q R : Prop) (h : P ∧ (Q ∨ R)) : (P ∧ Q) ∨ (P ∧ R) := by sorry

example (P Q : Prop) : ¬ (P ∨ Q) ↔ (¬ P ∧ ¬ Q) := by sorry

example : ∀ n : ℕ, ∃ m : ℕ, n = 2 * m ∨ n = 2 * m + 1 := by sorry

example : ∃ x : ℝ, x ^ 2 = 4 ∧ x < 0 := by sorry

example (f : ℝ → ℝ) (h : ∀ x : ℝ, f x = 2 * x + 1) : f 3 = 7 := by sorry

example : ¬ Function.Injective (fun n : ℕ => n * 0) := by sorry

end Thread3.Week3
