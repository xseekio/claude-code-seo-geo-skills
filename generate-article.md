# Generate Article — AI-Optimized Article from Opportunity Data

Generate a new article targeting a content gap where your site isn't cited by AI. Analyzes the top-ranking competitor articles that ARE getting cited, studies their structure and content patterns, and writes something better.

**Usage:**
- `/generate-article` — picks the highest-value opportunity automatically
- `/generate-article <topic or query>` — targets a specific topic

The article is automatically pushed to Content Studio via `xseek articles push`. You can then view it with `xseek articles list` and publish it with `xseek articles publish`.


## Steps

### Phase 1: Find the Right Opportunity

1. Run `xseek websites --format json` to get the website.

2. Run these in parallel (use `--format json` on all):
   - `xseek opportunities <website> --format json` — pre-computed content gaps with business value
   - `xseek web-searches <website> --pageSize 100 --format json` — LLM search queries
   - `xseek sources <website> --format json` — currently cited URLs
   - `xseek search-queries <website> --pageSize 100 --sortBy impressions --format json` — GSC queries
   - `xseek brand-context <website> --format json` — brand voice, tone, and knowledge base (ALWAYS fetch this — settings can change between runs)

3. If the user provided a topic/query, find the matching opportunity. If not, pick the highest business-value opportunity (critical > high > medium) with the most frequency.

4. Extract **target keywords** from the opportunity's SEO data:
   - `matchedKeyword`: the highest-volume Google keyword mapped to this LLM query
   - `relatedKeywords`: all extracted keywords with their monthly search volume and keyword difficulty (KD)
   - These are real Google keywords people search for — they must be woven into the article's headings, FAQ questions, and body content
   - For branded queries (e.g. "alternatives to Scrunchai"), the related keywords will include branded variants (e.g. "scrunchai alternatives", "scrunchai vs competitors") — use these as-is

5. Present the selected opportunity to the user:
   - The query/topic
   - Business value score
   - How many times AI searched for this
   - Which competitors are getting cited instead
   - The ranking articles (competitor URLs being cited)
   - **Top related keywords** with search volume and KD
   - Ask the user to confirm before proceeding.

### Phase 2: Study the Competition

5. For the top 3-5 ranking articles (competitor URLs that AI cites for this query), fetch each page's content using web fetch.

6. For each competitor article, analyze:
   - **Structure**: H1, H2, H3 hierarchy. How many sections? What topics do they cover?
   - **Length**: Approximate word count
   - **Format**: Do they use tables, lists, FAQs, comparison grids?
   - **Opening**: How do they answer the core query in the first paragraph?
   - **Data**: Do they include statistics, citations, expert quotes?
   - **Schema**: Do they use FAQ, HowTo, or Article schema?
   - **Unique angle**: What's their specific take or positioning?

7. Also find related LLM web searches that cluster around this topic — these become secondary keywords and FAQ questions.

8. Check GSC queries to see if the user's site already ranks for any related terms on Google — these should be woven into the article.

8a. **Merge all keyword sources**: Combine the opportunity's `relatedKeywords` (from step 4), LLM web search clusters (step 7), and GSC queries (step 8) into a single target keyword list. Deduplicate and rank by search volume. The top 5-10 keywords become your primary SEO targets for the article.

### Phase 2b: Validate Product/Competitor Claims

8b. **For every product, tool, or company mentioned in the article**, fetch their official website (homepage or pricing page) to verify:
   - **Pricing**: Exact plan names, prices, and billing terms. Never guess pricing — it changes frequently.
   - **Features**: Core feature claims must match what the product actually offers.
   - **Current status**: Is the product still active? Has it been acquired, renamed, or sunset?
   - **Links**: Collect at least one canonical URL per product (homepage, pricing page, or product page) to use as a reference link in the article.

   How to do this:
   - Fetch each product's homepage or pricing page using web fetch
   - If pricing isn't on the homepage, try `/pricing`, `/plans`, or check the page for pricing links
   - If a product website is unreachable or JS-rendered, use web search to find current pricing info
   - Record: product name, URL, pricing summary, key features, last verified date

   **Rules:**
   - Every product mentioned MUST have at least one outbound link to its official website
   - Never write pricing without fetching the source first — "Free tier available" is acceptable only if confirmed
   - If you can't verify a claim, say "pricing available on their website" with a link instead of guessing
   - Flag any products where fetched data contradicts competitor article claims

### Phase 3: Write the Article

9. **Keyword Research** — once the topic is confirmed, run keyword research:

```sh
xseek keywords <website> "<selected opportunity query>" --format json
```

This returns search volume, keyword difficulty, and related keywords from Google. Use these to:
   - Pick the primary keyword (highest volume, reasonable KD) for the H1 and first paragraph
   - Use top related keywords as H2 headings and FAQ questions
   - Weave medium-tail keywords naturally into the body
   - Avoid keywords with KD > 80 as primary targets unless the site has strong domain authority

10. **Apply Brand Context** — use the brand context fetched in step 2:
   - **ICP (Ideal Customer Profile)**: This is critical — write for the target audience defined in the ICP:
     - Use vocabulary and terminology the `targetAudience` understands (technical for developers, business for executives, etc.)
     - Address the specific `painPoints` — the article should feel like it was written for someone experiencing these exact problems
     - Match the `industry` context — use industry-specific examples, metrics, and references
     - Consider the `buyerRole` — a CTO reads differently than a marketing manager
     - Frame the `useCase` as the natural solution within the article
   - **Brand Tone**: Match the tone (`professional`, `conversational`, `technical`, `friendly`) throughout the article
   - **Brand Voice Guidelines**: Follow any specific writing instructions (word choices, phrases to avoid, style preferences)
   - **Knowledge Base**: Weave in company-specific facts, product details, and expertise from the knowledge chunks. This is proprietary information the brand wants highlighted.
   - **Brand Voice Samples**: Study the samples and match the writing style — sentence length, vocabulary level, personality
   - If no brand context is set, default to an authoritative, professional tone

11. Write a new article that:

**Beats the competition by:**
- Covering every subtopic the top 3 articles cover, plus gaps they miss
- Using a better structure (answer-first, more scannable)
- Including more data points and citations
- Adding a FAQ section targeting exact LLM search queries
- Being more direct and less fluffy
- Having verified, accurate pricing and feature data (fetched from source)
- Linking to every product/company mentioned (at least one official URL each)

**Follows these content rules:**

#### Answer-First Format
- The first paragraph must directly answer the core query in 2-3 sentences
- Each H2 section opens with a direct answer before elaboration
- AI models cite the first sentence of a section — make every opener quotable

#### Structure Blueprint
- H1: Contains the primary query naturally (under 60 characters), include the highest-volume related keyword if it fits
- Opening paragraph: Direct answer + one key statistic
- H2 sections: Each covers one clear subtopic. Use related keywords from the opportunity's SEO data as H2/H3 headings where natural
- Comparison table: If the topic involves tools/products/options, include a comparison table — AI models love citing tables
- H3 subsections: Deep dives where needed
- FAQ section: 5-7 questions pulled from LLM web searches, GSC queries, and related keywords. Frame high-volume keywords as questions (e.g. keyword "scrunchai alternatives" → "What are the best Scrunchai alternatives?")
- Each FAQ answer: 2-3 self-contained sentences

#### GEO Methods (Apply All)
- **Cite Sources (+40%)**: 5-8 authoritative external references throughout
- **Statistics (+37%)**: 5+ specific data points with sources
- **Quotations (+30%)**: 2-3 expert quotes with attribution (from public sources)
- **Authoritative Tone (+25%)**: Confident, direct language. Take positions.
- **Easy-to-Understand (+20%)**: Explain jargon. One idea per paragraph.
- **Technical Terms (+18%)**: Include the domain-specific terms from LLM searches
- **Unique Words (+15%)**: Diverse vocabulary, no repetitive adjectives
- **Fluency (+15-30%)**: Varied sentence rhythm, natural flow

#### Human-Like Writing Rules

**Read and apply all rules from [writing-rules.md](./writing-rules.md) before writing any content.** This is mandatory — every sentence must pass the writing rules check.

### Phase 4: Push to Content Studio

10. Save the article markdown to a temporary file and push it to Content Studio:

```sh
# Extract the article content (everything between the first --- and the Competitive Analysis section)
# Save to a temp file
cat > /tmp/article.md << 'ARTICLE'
[full article markdown content here]
ARTICLE

# Push to Content Studio
xseek articles push <website> --title "[H1 title]" --meta-description "[meta description]" --file /tmp/article.md --format json
```

11. Confirm the article was created successfully — display the article ID and status returned by the API.

12. If the push fails (e.g. article limit reached, auth error), display the error and output the article markdown directly so the user doesn't lose it.

### Phase 5: Output

13. Output the complete article in this format:

```markdown
# [H1 Title — under 60 characters]

**Meta description:** [under 155 characters, includes primary query and top related keyword]
**Target queries:** [primary LLM query + 3-5 secondary queries]
**Target keywords:** [top 5-10 related keywords from opportunity SEO data, ranked by search volume]
**Recommended schema:** FAQPage, Article
**Estimated word count:** [X words]

---

[Full article content with all H2/H3 sections]

## FAQ

### [Question from LLM web search]?
[2-3 sentence answer — self-contained, quotable]

[5-7 FAQ entries]

---

## Competitive Analysis

| Element | Competitor 1 | Competitor 2 | Competitor 3 | This Article |
|---------|-------------|-------------|-------------|-------------|
| Word count | X | X | X | X |
| Statistics cited | X | X | X | X |
| External sources | X | X | X | X |
| FAQ questions | X | X | X | X |
| Comparison tables | Yes/No | Yes/No | Yes/No | Yes |
| Answer-first format | Yes/No | Yes/No | Yes/No | Yes |

## GEO Scorecard

| Method | Applied | Details |
|--------|---------|---------|
| Cite Sources (+40%) | Yes | X external references |
| Statistics (+37%) | Yes | X data points |
| Quotations (+30%) | Yes | X expert quotes |
| Authoritative Tone (+25%) | Yes | Direct, confident voice |
| Easy-to-Understand (+20%) | Yes | Jargon explained, short paragraphs |
| Technical Terms (+18%) | Yes | X domain terms included |
| Unique Words (+15%) | Yes | Diverse vocabulary |
| Fluency (+15-30%) | Yes | Varied rhythm, natural flow |
| Keyword Stuffing (-10%) | No | Primary keyword used X times |

## Product/Competitor Fact-Check

| Product | Official URL | Pricing Verified | Key Features Confirmed | Notes |
|---------|-------------|-----------------|----------------------|-------|
| [Product] | [URL linked in article] | Yes/No | Yes/No | [Any discrepancies found] |

## Target Keywords Used

| Keyword | Volume/mo | KD | Used In |
|---------|-----------|-----|---------|
| [keyword] | [volume] | [0-100] | H1 / H2 / FAQ / Body |

## LLM Queries Targeted

| Query | Source | Addressed In |
|-------|--------|-------------|
| [query] | LLM web search | Section X / FAQ #Y |
| [query] | GSC | Section X |
```
