---
name: latex-math-writing
description: Helper skill for writing LaTeX math in Obsidian notes. Use for inline and block math across calculus, linear algebra, probability and statistics, discrete mathematics, and common data-structure/algorithm notation. This skill only standardizes math notation; it does not choose the note shape or write the whole note by itself.
---

# LaTeX Math Writing

## Role

This is a helper skill for mathematical notation in Obsidian Markdown.

It standardizes LaTeX for:

- inline formulas;
- block formulas;
- matrices and determinants;
- calculus;
- linear algebra;
- probability and statistics;
- discrete mathematics;
- data structures and algorithms.

It must not become the primary note-writing skill.

Primary note shape is still chosen by `ROUTER` and one of:

- `note-linear-achievement`;
- `note-conclusion-evidence`;
- `note-operation-manual`.

## Core Rules

1. Use LaTeX for mathematical expressions by default.
2. Use `$...$` for short inline math.
3. Use `$$...$$` for standalone formulas, derivations, matrices, determinants, recurrences, and equation systems.
4. Keep Chinese explanation outside LaTeX.
5. Prefer readable formulas over clever compact formulas.
6. Do not invent math claims; only format notation.

## Inline Math

Use inline math for short symbols and formulas:

```markdown
当 $\det(A) \ne 0$ 时，矩阵 $A$ 可逆。
```

Good inline examples:

```latex
$x \in S$
$O(n \log n)$
$P(A \mid B)$
$A \in \mathbb{R}^{m \times n}$
```

## Block Math

Use block math for important formulas:

```markdown
$$
\det\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}
= ad - bc
$$
```

Do not hide long formulas inside prose.

## Calculus

Common templates:

```latex
\lim_{x \to a} f(x)
\frac{d}{dx} f(x)
f'(x)
\frac{\partial f}{\partial x}
\int_a^b f(x)\,dx
\sum_{i=1}^{n} a_i
\prod_{i=1}^{n} a_i
```

Example:

```markdown
$$
\frac{d}{dx}x^n = nx^{n-1}
$$
```

Use `\,dx` for integrals.

## Linear Algebra

Common templates:

```latex
\mathbf{v}
A \in \mathbb{R}^{m \times n}
A^T
A^{-1}
\operatorname{rank}(A)
\det(A)
\lambda_i
\|x\|_2
```

Matrix:

```markdown
$$
A = \begin{pmatrix}
1 & 2 & 3 \\
0 & 1 & 4 \\
5 & 6 & 0
\end{pmatrix}
$$
```

Determinant:

```markdown
$$
\det(A)=\begin{vmatrix}
1 & 2 \\
3 & 4
\end{vmatrix}=1\cdot4-2\cdot3=-2
$$
```

Use `pmatrix` for matrices and `vmatrix` for determinants.

## Probability And Statistics

Common templates:

```latex
P(A)
P(A \mid B)
X \sim \mathcal{N}(\mu, \sigma^2)
\mathbb{E}[X]
\operatorname{Var}(X)
\operatorname{Cov}(X,Y)
\bar{x}
\hat{\theta}
```

Examples:

```markdown
$$
P(A \mid B)=\frac{P(B \mid A)P(A)}{P(B)}
$$
```

```markdown
$$
\operatorname{Var}(X)=\mathbb{E}[X^2]-\mathbb{E}[X]^2
$$
```

## Discrete Mathematics

Common templates:

```latex
x \in A
A \subseteq B
A \cup B
A \cap B
A \setminus B
\emptyset
\forall x \in A
\exists x \in A
p \Rightarrow q
p \Leftrightarrow q
\neg p
p \land q
p \lor q
```

Combinatorics:

```markdown
$$
\binom{n}{k}=\frac{n!}{k!(n-k)!}
$$
```

Graph theory:

```latex
G=(V,E)
\deg(v)
|V|
|E|
```

## Data Structures And Algorithms

Complexity:

```latex
O(1)
O(\log n)
O(n)
O(n\log n)
O(n^2)
\Theta(n)
\Omega(n)
```

Recurrence:

```markdown
$$
T(n)=2T\left(\frac{n}{2}\right)+O(n)
$$
```

DP:

```markdown
$$
dp[i]=\min_{0\le j<i}\{dp[j]+cost(j,i)\}
$$
```

Use `\operatorname{}` for named functions: `\operatorname{rank}`, `\operatorname{Var}`, `\operatorname{dist}`, `\operatorname{lca}`.

## Obsidian Rules

- Prefer `$...$` for inline math.
- Prefer `$$...$$` for block math.
- Do not use bare `[` and `]` lines as math delimiters; Obsidian does not treat them as display math.
- Do not write `# [` before formulas; `#` is Markdown heading syntax, not LaTeX.
- Do not use plain parentheses such as `(d_n)` or `(\Delta)` for formulas that should render; use `$d_n$` and `$\Delta$`.
- When splitting equations across lines, keep relation operators such as `=`, `\approx`, `\propto`, or `\in`; do not leave the left-hand side and right-hand side as unrelated stacked lines.
- Keep Mermaid diagrams and LaTeX formulas separate.
- Avoid block formulas inside Markdown tables.
- In tables, use short inline math such as `$O(n\log n)$`.
- Put long formulas below the table under a heading.

## Review Checklist

Before finishing a math-heavy note, check:

- inline formulas use `$...$`;
- important formulas use `$$...$$`;
- matrices use `pmatrix`;
- determinants use `vmatrix` or `\det(A)`;
- named operators use `\operatorname{}`;
- complexity notation is formatted as math;
- formulas are readable in Obsidian Markdown.
