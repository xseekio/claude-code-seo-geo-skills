# Rewrite Page — AI-Optimized Content Rewrite

Fetch a page, analyze its AI visibility gaps, and produce a full rewrite that's optimized for AI citation while sounding unmistakably human.

**Usage:** `/rewrite-page https://example.com/blog/my-article`


## Steps

1. Run `xseek websites --format json` to find the websiteId matching the URL domain.

2. Fetch the page content using a web fetch of the target URL to get the current HTML/text.

3. Run these CLI calls in parallel (use `--format json` on all):
   - `xseek analyze <website> <target_url>` — AEO Copilot structural analysis
   - `xseek search-queries <website> --url <target_url> --pageSize 50 --format json` — GSC queries driving traffic to this page
   - `xseek web-searches <website> --pageSize 100 --format json` — what LLMs actually search for
   - `xseek sources <website> --format json` — which pages AI currently cites
   - `xseek ai-visits <website> --search <url_path> --pageSize 20 --format json` — AI bot traffic to this page
   - `xseek brand-context <website> --format json` — brand voice, tone, and knowledge base

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

7. Analyze the gaps:
   - Which LLM search queries are relevant to this page's topic but not addressed?
   - What GSC queries does the page rank for that could be answered more directly?
   - Is the page currently cited by AI? If not, why?
   - What structural issues did the AEO Copilot flag?

8. Rewrite the page content following ALL of the rules below. Ensure every product/tool/company mentioned includes at least one link to its official website and has verified pricing/features. **Verify against the GSC keyword checklist from step 5 — every keyword must appear in the rewrite.**

9. Output the rewrite in clean markdown. At the end, include a **Changes Summary**, a **Product/Competitor Fact-Check** table, and a **GSC Keyword Preservation Audit**.

---

## GEO Optimization Rules (Princeton Research)

Apply these 8 methods. Each one increases AI citation probability:

### 1. Cite Sources (+40% visibility)
- Add 3-5 authoritative external references per article
- Link to primary research, official documentation, or recognized industry sources
- Format: "According to [Source], ..." or inline citations
- Prefer .edu, .gov, peer-reviewed, or recognized industry publications

### 2. Statistics Addition (+37% visibility)
- Add 3-5 specific data points with sources
- Use exact numbers, not vague claims: "37% increase" not "significant increase"
- Place statistics early in sections to hook readers and AI scanners
- Format numbers consistently: percentages, dollar amounts, timeframes

### 3. Quotation Addition (+30% visibility)
- Add 1-3 expert quotes with attribution
- Format: "Quote here," says [Name], [Title] at [Organization]
- Quotes should add credibility, not padding
- If no real quotes are available, reference documented expert statements from public sources

### 4. Authoritative Tone (+25% visibility)
- Write with confidence. No hedging: "This works" not "This might potentially work"
- Use active voice. Subject-verb-object.
- State conclusions before evidence, not the reverse

### 5. Easy-to-Understand (+20% visibility)
- Explain jargon on first use
- One idea per paragraph. Maximum 3 sentences per paragraph.
- Use analogies for complex concepts
- Reading level: smart 16-year-old should understand it

### 6. Technical Terms (+18% visibility)
- Include domain-specific terminology that experts search for
- Balance with plain-language explanations
- Use the exact terms that appear in LLM web searches from the data

### 7. Unique Words (+15% visibility)
- Increase vocabulary diversity. Don't repeat the same adjectives.
- Replace generic words with specific ones: "plummeted" not "decreased a lot"
- Avoid cliché phrases: no "game-changer", "revolutionary", "cutting-edge"

### 8. Fluency Optimization (+15-30% visibility)
- Every sentence should flow naturally into the next
- Vary sentence length: short punchy sentences mixed with longer explanatory ones
- Remove any sentence that doesn't add information

### NEVER: Keyword Stuffing (-10% visibility)
- Do not repeat the primary keyword more than 2-3 times
- Use semantic variations naturally
- If it reads like it was written for a search engine, rewrite it

---

## Content Structure for AI Citation

AI models extract and cite content with this structure:

### Answer-First Format
- Open every section with a direct answer to the question it addresses
- The first 1-2 sentences of each section should be self-contained and quotable
- AI models pull the opening sentence as the citation — make it count

### Heading Hierarchy
- One H1 (the title)
- H2 for major sections
- H3 for subsections
- Headings should be questions or contain the exact query people ask
- Use headings that match LLM web search queries from the data

### Scannable Structure
- Bullet points for lists of 3+ items
- Numbered lists for sequential steps
- Tables for comparison data (AI models love citing tables)
- Bold key terms on first appearance

### FAQ Section
- Add a FAQ section at the end with 3-5 questions
- Use exact questions from LLM web searches and GSC queries
- Each answer should be 2-3 sentences — complete and self-contained
- This content should be suitable for FAQPage schema markup

---

## Human-Like Writing Rules

**Read and apply all rules from [writing-rules.md](./writing-rules.md) before writing any content.** This is mandatory — every sentence must pass the writing rules check.

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
