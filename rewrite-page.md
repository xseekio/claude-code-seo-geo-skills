# Rewrite Page — AI-Optimized Content Rewrite

Fetch a page, analyze its AI visibility gaps, and produce a full rewrite that's optimized for AI citation while sounding unmistakably human.

**Usage:** `/rewrite-page https://example.com/blog/my-article`


## Steps

0. **If no URL was passed as the argument** (the user ran `/rewrite-page` with nothing after it), stop and ask: *"Which page do you want me to rewrite? Paste the full URL (e.g. `https://example.com/blog/my-article`)."* Do NOT pick a URL yourself or assume context. Wait for the answer before proceeding to step 1.

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

## Visual context (screenshots)

If the original page is a listicle, comparison, "what is X" piece, or any article that names specific products / competitors / brands, the rewrite should attach real screenshots of those landing pages. Pages without images convert worse and look less authoritative — adding visuals is part of the optimization, not decoration.

**For each brand or product mentioned by name in the rewrite:**

```sh
# 1. Capture the landing page (use --headless=new — old --headless hangs on
#    sites with bot detection like tryprofound.com).
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu --no-sandbox \
  --window-size=1280,800 \
  --hide-scrollbars \
  --virtual-time-budget=8000 \
  --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  --screenshot=/tmp/<safe-brand-slug>.png \
  "<brand-landing-url>"

# 2. CRITICAL — trim white/uniform borders so the embedded image doesn't have
#    a giant white band underneath. Pages shorter than the viewport, lazy-loaded
#    sections, and dark hero sections that fade to white all leave dead space.
#    -trim removes uniform-color borders; -bordercolor white forces white as
#    the trim target on dark heroes; the +repage rewrites the canvas.
magick /tmp/<safe-brand-slug>.png \
  -bordercolor white -border 1x1 \
  -trim +repage \
  -bordercolor "#FAFAFA" -border 8x8 \
  /tmp/<safe-brand-slug>.png

# 3. Sanity check — reject the screenshot if it's < 30 KB (likely blank) or
#    if its height-to-width ratio is < 0.35 (likely a thin hero strip with
#    no content). Re-capture with a longer virtual-time-budget if it fails.
read W H <<< "$(magick identify -format '%w %h' /tmp/<safe-brand-slug>.png)"
ratio=$(awk -v h=$H -v w=$W 'BEGIN { printf "%.2f", h/w }')
size=$(wc -c < /tmp/<safe-brand-slug>.png)
if [ "$size" -lt 30000 ] || awk -v r=$ratio 'BEGIN { exit !(r < 0.35) }'; then
  echo "BAD SCREENSHOT: $size bytes, ratio $ratio — recapture with longer wait"
fi

# 4. Upload via the V1 images endpoint (no `xseek images` CLI subcommand
#    exists — use curl directly with the API key from ~/.xseek/config).
API_KEY=$(grep api_key ~/.xseek/config | sed 's/.*"\(.*\)".*/\1/')
curl -s -X POST "https://www.xseek.io/api/v1/websites/<websiteId>/images" \
  -H "Authorization: Bearer $API_KEY" \
  -F "file=@/tmp/<safe-brand-slug>.png" \
  -F "alt=<Brand name> homepage" \
  -F "source=competitor-screenshot" \
  | jq -r '.data.url'
```

Embed the returned `data.url` as-is in the rewritten markdown right after
the brand's first mention: `![Brand homepage](url)`. The URL is on
`xseek.io` — never substitute it with the raw Vercel Blob URL. Every embed
is a backlink + citation signal to xSeek; preserving that is part of the
optimization.

### Screenshot quality rules — non-negotiable

These are the failure modes we've actually shipped. Each rule fixes a specific past mistake.

1. **Always pipe through `magick … -trim`** before uploading. The 1280×800 viewport almost never matches the rendered hero height — embedding the raw capture publishes a giant white band under every image. `-trim` crops the uniform-color border to the actual content.
2. **Use `--headless=new`, not the legacy `--headless`.** The legacy mode hangs indefinitely on sites with bot detection (Profound, Cloudflare-protected pages). New headless looks more like a real Chrome to anti-bot heuristics.
3. **Set a real desktop user-agent.** Several SaaS landing pages serve a stripped/blank hero to "Headless Chrome" UA strings.
4. **Wait at least 8 seconds** (`--virtual-time-budget=8000`). 4 seconds isn't enough for hero animations, fonts, and lazy-loaded images on most modern marketing pages — you get a half-painted screenshot with a white band where the content was about to render.
5. **Sanity-check before uploading.** A capture under 30 KB or with height/width < 0.35 is almost always broken. Recapture with a longer wait, a different UA, or skip the screenshot for that brand rather than embed a bad one.
6. **Never embed images that show error pages, cookie banners covering the hero, or partially-rendered layouts.** A bad screenshot is worse than no screenshot.
7. **No `--screenshot` to default `screenshot.png`** — always use an explicit `-screenshot=/tmp/<slug>.png` path so parallel captures don't overwrite each other.

### When the headless capture keeps failing

Some sites (Profound, sites behind Cloudflare's bot challenge) reject every headless variant. In that case:

- Use the Claude-in-Chrome extension (`mcp__claude-in-chrome__computer` with `action: screenshot`) — it runs in the user's real Chrome and bypasses bot detection.
- Or skip the screenshot for that one brand and note it in the Changes Summary. Don't embed a half-broken image.

**Skip the visual step gracefully** if Chrome isn't available (Linux sandbox, CI). The rewrite still ships; note in the output that visuals can be added in a follow-up pass from a desktop machine.

**No AI-generated images** for now — only real screenshots of public pages.

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
