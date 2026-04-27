# Rewrite Page — AI-Optimized Content Rewrite

Fetch a page, analyze its AI visibility gaps, and produce a full rewrite that's optimized for AI citation while sounding unmistakably human.

**Usage:** `/rewrite-page https://example.com/blog/my-article`


## Steps

1. Run `xseek websites --format json` to find the websiteId matching the URL domain.

2. Fetch the page content using a web fetch of the target URL to get the current HTML/text.

3. Run these CLI calls in parallel (use `--format json` on all):
   - `xseek search-queries <website> --url <target_url> --pageSize 50 --format json` — GSC queries driving traffic to this page
   - `xseek web-searches <website> --pageSize 100 --format json` — what LLMs actually search for
   - `xseek sources <website> --format json` — which pages AI currently cites
   - `xseek ai-visits <website> --search <url_path> --pageSize 20 --format json` — AI bot traffic to this page
   - `xseek brand-context <website> --format markdown` — full brand brief (tone, identity, voice, anchors, surface rules, audiences, knowledge, style samples). Use the rendered markdown as the canonical voice spec for the rewrite.

4. **Keyword Research** — based on the page topic and top GSC queries, run keyword research:

```sh
xseek keywords <website> "<page main topic>" --format json
```

Use the results to:
   - Find high-volume related keywords to weave into the rewrite headings and body
   - Identify keywords competitors rank for that the page is missing
   - Target low-KD keywords in the FAQ section for quick wins
   - Ensure the rewrite covers the full keyword cluster, not just the primary term

5. **Validate any products, tools, or companies mentioned in the original page:**
   - Fetch each product's official website (homepage or pricing page) using web fetch
   - Verify pricing: exact plan names, prices, billing terms. Never keep unverified pricing claims.
   - Verify features: confirm core feature claims match what the product actually offers
   - Check if products are still active (not sunset, acquired, or renamed)
   - Collect at least one canonical URL per product to link in the rewrite
   - If pricing isn't on the homepage, try `/pricing` or `/plans`
   - If a website is unreachable, use web search to find current info
   - **Rules:** Every product mentioned MUST get at least one outbound link. Never write pricing without verifying. If unverifiable, write "pricing on their website" with a link.

6. **Build the GSC keyword preservation list:**
   - From the GSC queries data (step 3), extract EVERY query this page currently ranks for
   - Sort by impressions (highest first) — these are the keywords driving organic traffic
   - Create a checklist of these keywords. The rewrite MUST preserve all of them.
   - For high-impression queries: ensure the exact phrase appears in the rewrite (in headings, body text, or FAQ)
   - For lower-impression queries: ensure at least a close semantic match exists
   - **CRITICAL: Do NOT remove, rephrase away, or dilute any GSC keyword the page currently ranks for.** Losing these keywords means losing existing Google traffic. The rewrite should strengthen keyword coverage, not weaken it.

7. **Apply the brand brief** — use every section of the markdown returned by `xseek brand-context` in step 3. Treat it as a single voice spec; missing sections are fine, present sections are non-negotiable.
   - **Tone** (`professional` | `conversational` | `technical` | `friendly`): set the register for the entire rewrite.
   - **Identity → Adjectives**: every paragraph of the rewrite should plausibly fit these words.
   - **Identity → Signature words**: weave them into headings, intros, and CTAs where they fit naturally.
   - **Identity → Banned words**: hard rule. Search the rewrite for each banned word before output. Zero occurrences allowed.
   - **Identity → Positions** ("what we stand for / what we reject"): reflect these opinions in the rewrite. Generic copy is a fail.
   - **Voice → Guidelines**: follow specific writing instructions (sentence length, jargon stance, formality).
   - **Voice → Opening sentence examples**: model the rhythm of the rewritten intro on these.
   - **Anchors → Brands we admire**: borrow the *qualities* (clarity, opinion, structure) — never copy their words.
   - **Anchors → Voices to avoid**: explicit anti-patterns. If the brand lists "generic SaaS marketing speak," the rewrite cannot read like that.
   - **Anchors → Own content URLs**: if listed, sample one to anchor your prose style on the brand's actual writing.
   - **Surface rules → Always surface**: include the listed claims/numbers/proof points whenever context allows.
   - **Surface rules → Never surface**: hard rule. Do not mention any topic, fact, or claim in this list.
   - **Audiences**: write for the audience whose topics this page best serves; address their language and decision drivers.
   - **Knowledge entries**: weave in company-specific facts, product details, and proprietary expertise.
   - **Style references (samples)**: match the structure, sentence length, vocabulary level, and personality of these full-length samples. Read them before rewriting the first paragraph.
   - If no brand brief is set, default to an authoritative, professional tone — but flag this in your output so the user knows the rewrite is generic.

8. Analyze the gaps:
   - Which LLM search queries are relevant to this page's topic but not addressed?
   - What GSC queries does the page rank for that could be answered more directly?
   - Is the page currently cited by AI? If not, why?
   - What structural issues exist (heading hierarchy, missing schema, etc.)?

9. Rewrite the page content following ALL of the rules below. Ensure every product/tool/company mentioned includes at least one link to its official website and has verified pricing/features. **Verify against the GSC keyword checklist from step 5 — every keyword must appear in the rewrite.**

10. Output the rewrite in clean markdown. At the end, include a **Changes Summary**, a **Product/Competitor Fact-Check** table, and a **GSC Keyword Preservation Audit**.

---

## GEO Methods + Human-Like Writing

**Before rewriting, read the full content of these two skills (installed via `xseek init`):**
- **`/writing-rules`** — human-like writing rules (tone, banned words, sentence structure)
- **`/geo-methods`** — all 9 Princeton GEO methods with examples, domain-specific tips, content structure for AI citation, and pre-publish checklist

Read both skills in full. Every sentence in the rewrite must pass both the human writing check and the GEO optimization check.

---

## SEO Rules

### Title and Meta
- Suggest an optimized H1 title (under 60 characters)
- Suggest a meta description (under 155 characters) that includes the primary query

### Internal Linking
- Suggest 2-3 internal links to other relevant pages on the same domain
- Link naturally within content, not in a "Related Articles" dump

### Schema Markup
- Recommend specific schema types: FAQPage, HowTo, Article, or BreadcrumbList
- Provide the FAQ content in a format ready for schema implementation

---

## Output Format

```markdown
# [Optimized H1 Title]

**Meta description:** [155 chars max]
**Recommended schema:** [FAQPage, Article, etc.]

[Full rewritten content here]

## FAQ

### [Question from LLM search query]?
[2-3 sentence answer]

### [Question from GSC query]?
[2-3 sentence answer]

[3-5 more FAQ entries]

---

## Changes Summary

| Change | GEO Method | Impact |
|--------|-----------|--------|
| Added 4 statistics with sources | Statistics Addition | +37% |
| Added FAQ section with 5 questions | Content Structure | +40% |
| Rewrote intro with answer-first format | Fluency + Structure | +15-30% |
| ... | ... | ... |

## Product/Competitor Fact-Check

| Product | Official URL | Pricing Verified | Features Confirmed | Notes |
|---------|-------------|-----------------|-------------------|-------|
| [Product] | [URL linked in article] | Yes/No | Yes/No | [Any discrepancies found] |

## GSC Keyword Preservation Audit

| GSC Query | Impressions | Position | Preserved in Rewrite | Location |
|-----------|------------|----------|---------------------|----------|
| [query] | X | X | Yes — exact match / Yes — semantic match | H2 title / paragraph X / FAQ #Y |
| [query] | X | X | Yes | ... |

**All GSC keywords preserved:** Yes/No (if No, list which were lost and why)

**LLM queries now addressed:** [list of queries from web-searches data that the rewrite targets]
**GSC queries reinforced:** [list of queries the page already ranks for that were strengthened]
```
