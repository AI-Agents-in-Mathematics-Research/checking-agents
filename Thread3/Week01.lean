import Thread3.Common

/-!
# Week 1 — Terms, types, and the shape of a proof

**In-session: §1.1–§1.5. Out-of-session: §1.6.**

Everything in Lean is a term, and every term has a type. Propositions are
themselves types, and a proof of a proposition is a term of that type. That one
idea is the whole of this session.

Replace every `sorry` with a proof. A file with no `sorry` and no red squiggles
is finished; nothing else counts as finished.

Tactics available this week: `norm_num`, `rfl`, `exact`, `intro`, `simp`, `rw`.
-/

namespace Thread3.Week1

/-! ## 1.1 Everything has a type

Predict the answer *before* you look at the Infoview, then check.
-/

#check (2 : ℕ)
#check (2 : ℝ)
#check (2 + 2 = 4)
#check Nat
#check Prop
#check fun n : ℕ => n + 1
#check Nat.add_comm

-- Read this one carefully. What is being said?
#check (rfl : (2:ℕ) + 2 = 4)

/-! ## 1.2 Goals closed by computation

`norm_num` evaluates concrete numerical goals.
-/

example : (2:ℕ) + 2 = 4 := by sorry

example : (7 : ℝ) * 6 = 42 := by sorry

example : (2:ℕ) ^ 10 = 1024 := by sorry

example : (123 : ℤ) - 456 = -333 := by sorry

/-! ## 1.3 Using what is already in the context

If the goal is exactly a hypothesis, `exact` that hypothesis. If the goal is an
implication, `intro` first.
-/

example (h : (3:ℕ) < 5) : (3:ℕ) < 5 := by sorry

example (P : Prop) (hP : P) : P := by sorry

example (P Q : Prop) (hP : P) : Q → P := by sorry

example (P Q R : Prop) (hPQ : P → Q) (hQR : Q → R) : P → R := by sorry

/-! ## 1.4 `rfl` and the limits of definitional equality

One of the two goals below is closed by `rfl` and the other is not. Find out
which, and — this is the actual exercise — work out why. The definition of
`Nat.add` recurses on its *second* argument.
-/

example (n : ℕ) : n + 0 = n := by sorry

example (n : ℕ) : 0 + n = n := by sorry

/-! ## 1.5 Reading error messages

The three proofs below are broken. Each is commented out. For each one:

1. uncomment it,
2. read the error message and write down, in words, what Lean is telling you,
3. repair it.

You will spend more of this module reading error messages than writing tactics,
so it is worth being deliberate about it now.
-/

-- example (P Q : Prop) (hP : P) (hQ : Q) : Q := hP

-- example (n : ℕ) : 0 + n = n := rfl

-- example (P Q : Prop) (hP : P) : Q → P := by exact hP

-- Repaired versions:

example (P Q : Prop) (_hP : P) (hQ : Q) : Q := by sorry

example (n : ℕ) : 0 + n = n := by sorry

example (P Q : Prop) (hP : P) : Q → P := by sorry

/-! ## 1.6 Out-of-session

Do these before next week's session. The last two use `norm_num`'s primality
extension, which is worth knowing about early.
-/

example : (3:ℕ) * 37 = 111 := by sorry

example (x : ℝ) : x + 0 = x := by sorry

example (P : Prop) : P → P := by sorry

example (P Q : Prop) : P → (Q → P) := by sorry

example (P Q R : Prop) (h : P → Q → R) (hP : P) (hQ : Q) : R := by sorry

example (n : ℕ) (h : n = 7) : n + 1 = 8 := by sorry

example : Nat.Prime 17 := by sorry

example : ¬ Nat.Prime 91 := by sorry

end Thread3.Week1
