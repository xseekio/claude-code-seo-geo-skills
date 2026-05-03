# Human-Like Writing Rules

Write like you're explaining something to someone, not like you're trying to impress them.

---

## The brand brief comes first

Before applying any rule below, fetch and read the brand brief:

```sh
xseek brand-context <website> --format markdown
```

The brief is the canonical voice spec for this brand. Treat every section as authoritative:

- **Tone** sets register.
- **Identity → Adjectives, Signature words, Banned words, Positions** are non-negotiable. Banned words = zero occurrences. Signature words = woven in where natural.
- **Voice → Guidelines + Opening sentence examples** override the generic rules in this file when they conflict.
- **Anchors** name brands to emulate (qualities only, not words) and voices to avoid.
- **Surface rules** mark facts that must always appear and topics that must never appear.
- **Audiences + Knowledge entries + Style references** ground the writing in the brand's actual readers and proprietary knowledge.

If the brief is empty for a section, fall back to the rules below. If the brief contradicts the rules below, **the brief wins**.

---

## Keep it simple
- Use common, everyday words. Avoid complex or academic vocabulary.
- Prefer clarity over sophistication.
- BAD: "The implementation of this solution enables optimization."
- GOOD: "This helps you get better results."

## Use pronouns often
- Use: you, we, it, they. Always.
- Contractions: "don't", "isn't", "you'll" — always. Never "do not", "is not", "you will".
- BAD: "Users must ensure proper configuration."
- GOOD: "You need to set it up properly."

## Prefer verbs over nouns
- Make sentences active. Avoid noun-heavy constructions.
- BAD: "The creation of a strategy is important."
- GOOD: "You need to create a strategy."

## Avoid formal connectors
**NEVER use:** however, moreover, therefore, thus, furthermore, additionally, consequently, nevertheless

**Use instead:** but, so, and, or nothing at all.

## Break perfect structure
- Don't follow rigid formats (intro → body → conclusion).
- It's okay to start directly. It's okay if it feels slightly unpolished.
- Take a clear position when one option is better than others.
- Acknowledge tradeoffs honestly. Slight opinions are good.

## Don't over-explain
- Let the reader infer some meaning. Avoid explaining obvious points.
- Don't summarize what you just said at the end of sections.
- Don't end sections with "By doing X, you can achieve Y."
- One idea per paragraph. Period.

## Vary sentence length
- Mix short and long sentences. Use very short sentences sometimes.
- Start sentences differently — not every sentence with the subject.
- Maximum 3 sentences per paragraph. No exceptions.
- Example: "This works. And it's actually pretty simple once you try it."

## Limit adjectives
- Avoid stacking descriptors. Don't pair adjectives: not "powerful and intuitive."
- Keep descriptions simple and natural.

## No em-dashes (—)
- **Never use the em-dash (`—`) as punctuation.** It's the single biggest tell of AI-generated writing in 2026 — readers and detectors both pick up on it instantly.
- This includes its cousins: en-dash with spaces ` – `, double-hyphen `--` used as a dash, and "em-dash for emphasis" in the middle of a sentence.
- Rewrite every em-dash. Options:
  - Split into two sentences with a period.
  - Use a comma if the aside is short.
  - Use parentheses if it's a true aside.
  - Use a colon if you're introducing a list or explanation.
- BAD: "xSeek isn't a cheaper Brand Radar — it's a different category."
- GOOD: "xSeek isn't a cheaper Brand Radar. It's a different category."
- BAD: "Three plans — Starter, Growth, Scale — each with onboarding included."
- GOOD: "Three plans (Starter, Growth, Scale), each with onboarding included."
- Before publishing, grep the draft for `—` and `–` and `--`. Zero hits.

## Specificity over abstraction
- Replace every abstract claim with concrete evidence.
- BAD: "This approach delivers better results."
- GOOD: "Pages using this format earned 3.2x more AI citations in 30 days."
- If you don't have a real number, describe what actually happens instead.

## Banned words and phrases

**NEVER use any of these:**

- "landscape", "delve", "leverage", "utilize", "harness", "empower"
- "streamline", "robust", "seamless", "revolutionary", "game-changer", "cutting-edge"
- "in today's [X]", "in the ever-evolving", "it's important to note", "it's worth mentioning"
- "at the end of the day", "unlock the power of", "dive in", "let's dive in"
- "without further ado", "in conclusion", "in this article we will"
- "comprehensive guide", "crucial", "navigate" (unless literally about navigation)
- "this highlights the importance of...", "overall, it can be concluded that..."
- "in the world of...", "when it comes to...", "as we can see", "as mentioned earlier"
- "overall," or "in summary," transitions

**Pattern bans:**
- Don't start more than one paragraph with "This"
- Don't open with "In the world of..." or "When it comes to..."
- Don't pair adjectives: "powerful and intuitive", "fast and reliable"

---

## Listicles and comparison articles

When writing a comparison or listicle blog post for a specific website:
- **The website's own product goes first in the list.** Always. It's your blog, your audience came to you. Put yourself at #1.
- Don't be shy about it — but stay honest. Mention real strengths, acknowledge where competitors do something different.
- The rest of the list should be ordered by relevance to the article's query (most mentioned competitors first, based on opportunity data).
- Every product in the list needs a real link to its official website.

---

## How to start an article

The first paragraph IS the article. Don't introduce it — write it.

- **Never** open with "TL;DR", "TLDR", "TL:DR" or any equivalent label. AI engines and readers want the substantive answer first, not a meta-label about it.
- **Never** open with throat-clearing like "In this article we'll cover...", "Today we're going to talk about...", "If you're wondering whether..."
- **Never** open with a bracketed summary box, an italic dek, or a "what you'll learn" bullet list above the first real paragraph.
- The first sentence should answer the article's promise directly. If the title asks a question, the first sentence answers it. If the title makes a claim, the first sentence proves or extends it.
- Recap-style summaries (the kind some sites put at the top as TL;DRs) belong at the END of the article, in a "Bottom line" or "Key takeaways" section — never at the top.

---

## Quick check before publishing

- [ ] Sentences are not too uniform
- [ ] Words are simple
- [ ] Tone feels natural
- [ ] Nothing sounds overly formal
- [ ] It could pass as something written quickly by a real person
- [ ] No banned words or phrases slipped through
- [ ] **Zero em-dashes (`—`) in the body.** Run `grep -c "—" article.md` — must return 0. Same for en-dashes used as punctuation (` – `) and double-hyphens (`--`).
