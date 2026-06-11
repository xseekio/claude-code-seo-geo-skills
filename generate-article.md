# Generate Article — AI-Optimized Article from Opportunity Data

Generate a new article targeting a content gap where your site isn't cited by AI. Analyzes the top-ranking competitor articles that ARE getting cited, studies their structure and content patterns, and writes something better.

**Usage:**
- `/generate-article` — picks the highest-value opportunity automatically
- `/generate-article <topic or query>` — targets a specific topic

The article is pushed to Content Studio as a **draft** via `xseek articles push`. The user can review it in the dashboard, then mark it as ready or published when they're satisfied.


## Steps

### Phase 1: Find the Right Opportunity

**0. If `opportunityId="<uuid>"` was passed in the prompt, use that ID exactly. No fuzzy matching, no "I think the user meant…", no creating a duplicate. Jump straight to step 4 (extract keywords from this exact opportunity row). When you push the article in Phase 4, you MUST pass `--opportunity-id "<the-same-uuid>"` to `xseek articles push`. This is non-negotiable: the dashboard handed you an exact ID, and the only acceptable behavior is to honor it.**

The `opportunityId` is the source of truth for which opportunity this article addresses. Do not call `xseek opportunities` to "find a better match". Skip the discovery, fetch the row, write the article, push it back wired to the same ID.

1. Run `xseek websites --format json` to get the website.

2. Run these in parallel (use `--format json` on all):
   - `xseek opportunities <website> --format json` — pre-computed content gaps with business value
   - `xseek web-searches <website> --pageSize 100 --format json` — LLM search queries
   - `xseek sources <website> --format json` — currently cited URLs
   - `xseek search-queries <website> --pageSize 100 --sortBy impressions --format json` — GSC queries
   - `xseek brand-context <website> --format markdown` — full brand brief (tone, identity, voice, anchors, surface rules, audiences, knowledge, style samples). ALWAYS fetch this — settings can change between runs. Use the rendered markdown as the canonical voice spec for the whole article.

3. If `opportunityId` was passed (step 0), the opportunity row is already chosen — skip this step. Otherwise: if the user provided a topic/query, find the matching opportunity. If neither, pick the highest business-value opportunity (critical > high > medium) with the most frequency.

3b. **Differentiate from existing articles (MANDATORY).** The prompt may include a list titled "This website ALREADY has the following articles (title — primary keyword)". If it doesn't, fetch it yourself: `xseek articles list <website> --format json`. Then enforce all three rules for the article you're about to write:
   - **Distinct angle**: if the opportunity overlaps an existing article's topic, narrow to a specific audience, region, use case or question none of them answers. Never write another variation of an existing piece.
   - **Different primary keyword**: your `--keyword-term` must differ from every existing article's keywords. If your best candidate is taken, use the next-best from the research.
   - **Varied format**: don't default to another "Top N" listicle with the same names. Rotate formats — cost guide, how-to, head-to-head comparison of two options, regional deep-dive, FAQ-led answer page — picking whichever best matches the query intent.

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

**CRITICAL — `--keyword-term` MUST come from this research output, not from your imagination, the article title, or the opportunity query.**

When you push the article in Phase 4, the `--keyword-term` flag must be the exact string of one of the keywords returned by `xseek keywords` above (with a non-zero search volume). Picking a phrase off the title or slug ("which tool best", "tool best optimization") leaves the article linked to a keyword with no volume data, which displays as a broken Target Keywords card on the dashboard.

The right keyword is the one with the highest search volume that semantically matches the article's primary intent. Copy its `keyword` field verbatim. If multiple are tied, prefer the one with lower KD.

**Also pass `--keywords` with the FULL target list.** The article targets a primary keyword plus the secondary terms you placed in H2s, FAQ questions and body copy. Push them all (comma-separated, primary first, max 10) so the dashboard's Target Keywords card shows the real keyword plan instead of a single term. Same rule as `--keyword-term`: every keyword in the list must be a verbatim string from the research output (`xseek keywords`, the opportunity's `relatedKeywords`, or GSC queries) — never invented.

10. **Apply the brand brief** — use every section of the markdown returned by `xseek brand-context` in step 2. Treat it as a single voice spec; missing sections are fine, present sections are non-negotiable.
   - **Tone** (`professional` | `conversational` | `technical` | `friendly`): set the register for the entire article.
   - **Identity → Adjectives**: every paragraph should plausibly fit these words. If the brand says "direct, warm, expert," the article cannot read as "playful, edgy, casual."
   - **Identity → Signature words**: weave them into headings, intros, and CTAs where they fit naturally. Don't shoehorn — but don't ignore them either.
   - **Identity → Banned words**: hard rule. Search the draft for each banned word before output. Zero occurrences allowed.
   - **Identity → Positions** ("what we stand for / what we reject"): these are opinions the brand holds. Reflect them — the article should feel like it could only have come from this brand, not a generic competitor.
   - **Voice → Guidelines**: follow specific writing instructions (sentence length, jargon stance, formality).
   - **Voice → Opening sentence examples**: model the rhythm of the intro paragraph on these.
   - **Anchors → Brands we admire**: borrow the *qualities* of these brands (clarity, opinion, structure) — never copy their words.
   - **Anchors → Voices to avoid**: explicit anti-patterns. If the brand lists "generic SaaS marketing speak," your draft cannot read like that.
   - **Anchors → Own content URLs**: if listed, fetch one of these pages to anchor your prose style on the brand's actual writing.
   - **Surface rules → Always surface**: include the listed claims/numbers/proof points whenever the article context allows.
   - **Surface rules → Never surface**: hard rule. Do not mention any topic, fact, or claim in this list.
   - **Audiences**: each audience has a name + description + topics. Write for the audience whose topics this article best serves; address their language and decision drivers.
   - **Knowledge entries**: weave in company-specific facts, product details, and proprietary expertise. This is information the brand wants highlighted.
   - **Style references (samples)**: match the structure, sentence length, vocabulary level, and personality of these full-length samples. Read them before writing the first paragraph.
   - If no brand brief is set, default to an authoritative, professional tone — but flag this in your output so the user knows the article is generic.

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
- **Sources & References section (MANDATORY, last H2 after the FAQ)**: 3-8 authoritative sources actually used in the article, each as a markdown link with a short note on what it backs (e.g. `- [Statistics Canada — job vacancies Q1 2026](https://...) — vacancy data cited in the intro`). An article with zero verifiable sources does not pass review.
- **Inline source links (MANDATORY)**: every specific statistic, price, study result, date-sensitive fact, or quote from a named person carries an inline markdown link to its source at first mention — readers must be able to click and verify on the spot. Product mentions link to the product; DATA links to where the data comes from. This applies to every format (listicle, how-to, cost guide, comparison) — not just product lists.

#### GEO Methods + Human-Like Writing

**Before writing, read the full content of these two skills (installed via `xseek init`):**
- **`/writing-rules`** — human-like writing rules (tone, banned words, sentence structure)
- **`/geo-methods`** — all 9 Princeton GEO methods with examples, domain-specific tips, and pre-publish checklist

Read both skills in full. Every sentence must pass both the human writing check and the GEO optimization check.

#### Phase 3b: Add visual context (screenshots of competitor landing pages)

**Articles without images convert worse and look less authoritative.** For listicles, comparisons, and any article where you mention a specific product, brand, or competitor by name, attach a real screenshot of that brand's landing page or product page so the reader instantly knows what's being talked about. This is not decoration — it's a comprehension aid.

**When to add an image (use judgment, don't force it):**
- Listicle entries — every numbered/listed product or competitor gets a homepage screenshot near its mention
- Side-by-side comparisons — both products' hero sections
- A "what does X look like" question in an FAQ — a screenshot of X
- The user's own brand mentioned for the first time in a self-referential article — their own hero or product page

**Skip images when:**
- The article is a strategic essay or opinion piece (visuals dilute the authority)
- The brand has no public landing page (private SaaS, internal tools)
- Image bandwidth is a real concern (long article, mobile-first audience)

**How to capture and upload (no `xseek images` CLI subcommand exists — POST directly to the V1 images endpoint):**

For each brand/product you decide to feature visually:

```sh
# 1. Capture with headless Chrome. Use --headless=new (legacy --headless hangs
#    on bot-protected sites like tryprofound.com). Set a real desktop UA — some
#    SaaS sites serve a stripped/blank hero to "Headless Chrome". 8s budget gives
#    hero animations and lazy-loaded sections time to paint.
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu --no-sandbox \
  --window-size=1280,800 \
  --hide-scrollbars \
  --virtual-time-budget=8000 \
  --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  --screenshot=/tmp/<safe-brand-slug>.png \
  "<brand-landing-url>"

# 2. CRITICAL — trim white/uniform borders. The 1280×800 viewport rarely matches
#    the actual hero height; without this step every embedded image ships with
#    a giant white band underneath. -trim crops uniform-color borders to the
#    real content; the 8px frame keeps a subtle padding.
magick /tmp/<safe-brand-slug>.png \
  -bordercolor white -border 1x1 \
  -trim +repage \
  -bordercolor "#FAFAFA" -border 8x8 \
  /tmp/<safe-brand-slug>.png

# 3. Sanity check. Reject and recapture if size < 30 KB (likely blank page) or
#    height/width ratio < 0.35 (likely a thin hero strip with nothing below).
read W H <<< "$(magick identify -format '%w %h' /tmp/<safe-brand-slug>.png)"
ratio=$(awk -v h=$H -v w=$W 'BEGIN { printf "%.2f", h/w }')
size=$(wc -c < /tmp/<safe-brand-slug>.png)
if [ "$size" -lt 30000 ] || awk -v r=$ratio 'BEGIN { exit !(r < 0.35) }'; then
  echo "BAD SCREENSHOT — recapture with longer wait or skip this brand"
fi

# 4. Upload to xSeek's V1 images endpoint. The API key sits in ~/.xseek/config.
API_KEY=$(grep api_key ~/.xseek/config | sed 's/.*"\(.*\)".*/\1/')
curl -s -X POST "https://www.xseek.io/api/v1/websites/<websiteId>/images" \
  -H "Authorization: Bearer $API_KEY" \
  -F "file=@/tmp/<safe-brand-slug>.png" \
  -F "alt=<Brand name> homepage" \
  -F "source=competitor-screenshot" \
  | jq -r '.data.url'
```

The endpoint returns JSON `{ data: { url, ... } }` — this URL is **on `xseek.io`** (e.g.
`https://www.xseek.io/images/abc-123/stripe-homepage.png`). Always embed the
`data.url` value as-is. Never extract the underlying Vercel Blob URL or
rewrite to a different host.

**Screenshot quality rules — non-negotiable:**

1. **Always pipe through `magick … -trim`** before uploading. Past articles shipped with white bands under every image because the raw 1280×800 viewport included empty space below the hero.
2. **Use `--headless=new`, not legacy `--headless`.** Legacy mode hangs indefinitely on Cloudflare-protected and bot-detection sites.
3. **Set a real desktop user-agent** — several marketing pages serve blank heroes to the default Headless Chrome UA.
4. **Wait 8 seconds minimum** (`--virtual-time-budget=8000`). 4s gets you half-painted heroes.
5. **Sanity-check size and ratio** before uploading. A capture under 30 KB or with h/w < 0.35 is almost always broken.
6. **Never embed cookie banners, error pages, or partially-rendered layouts.** Skip the screenshot rather than ship a bad one.
7. **Always use an explicit `--screenshot=/tmp/<slug>.png`** path so parallel captures don't overwrite each other on the default `screenshot.png`.
8. **Fallback when headless keeps failing**: use the `mcp__claude-in-chrome__computer` extension (runs in the user's real Chrome and bypasses bot detection), or skip that brand and note it.

**Why xseek.io URLs matter:** every published article that embeds an
xseek.io image URL is a structural backlink + AI-citation signal to xSeek.
This compounds across every article we help ship. Swapping to a direct
blob URL would break this moat.

```markdown
## 1. Stripe

![Stripe homepage](https://www.xseek.io/images/abc-123/stripe-homepage.png)

Stripe is the payments infrastructure...
```

**Fallback if Chrome isn't available** (Linux sandboxes, CI, etc.):
- Skip the screenshot step rather than failing the article
- Note in the output: "Visual placeholders skipped — re-run from the desktop to attach screenshots"
- The article still ships; visuals get added in a refresh pass

**Do not generate AI images.** Only screenshots of real, publicly accessible pages. We can revisit AI-generated visuals in a future skill update.

### Phase 4: Push to Content Studio

10. **Ask the user** before pushing: "Do you want to push this as a **draft** (review first) or **ready** (ready to publish)?"
   - If the user says draft or doesn't specify → use `--status draft`
   - If the user says ready or publish → use `--status ready`
   - Default to `draft` if unsure

11. Save the article markdown to a temporary file and push it to Content Studio.

   **CRITICAL — the file must contain BODY ONLY:**
   - **NO H1 title** (passed via `--title`)
   - **NO metadata block** (no `**Meta description:**`, `**Target queries:**`, `**Target keywords:**`, `**Recommended schema:**`, `**Estimated word count:**` lines — meta description is passed via `--meta-description`)
   - **NO leading `---` separator**
   - Start the file at the first prose paragraph of the article. Include H2/H3 sections, FAQ, competitive analysis, etc. — everything except the title and the metadata block.

   The metadata block from the Phase 5 output template is for your reasoning/display only — it does NOT belong inside the published article on the live site.

```sh
cat > /tmp/article.md << 'ARTICLE'
[Article BODY only — first prose paragraph, then H2/H3 sections, FAQ, etc.
 NO title, NO metadata block, NO leading `---`.]
ARTICLE

# Push to Content Studio (--status draft or --status ready based on user choice).
# CRITICAL: when `opportunityId` was passed in the original prompt (step 0),
# you MUST include `--opportunity-id "<same-uuid>"` here. The exact same UUID,
# no substitutions. This is what wires the published article back to the
# action plan so the opportunity gets marked done. Skipping it leaves the
# opportunity hanging as "still to ship" and the dashboard will surface
# duplicates.
xseek articles push <website> --title "[H1 title]" --meta-description "[meta description]" --status draft --opportunity-id "<uuid-from-prompt>" --keyword-term "[primary keyword]" --keywords "[primary keyword], [secondary 1], [secondary 2], ..." --file /tmp/article.md --format json
```

12. Confirm the article was created successfully — display the article ID and status.

13. If the push fails (e.g. auth error), display the error and output the article markdown directly so the user doesn't lose it.

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
