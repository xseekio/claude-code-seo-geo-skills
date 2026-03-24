# Find Opportunities — Content Gap Finder for AI Search

Discover content gaps: queries that AI models search for where you don't have content, and topics where competitors get cited but you don't.

## Context for the agent

**Content opportunities** come from three sources:
1. **LLM search queries you don't rank for** — AI models search for these terms when answering prompts, but your content doesn't appear. Writing content targeting these queries increases your chance of being cited.
2. **Competitor citations** — URLs from competitor domains that AI cites. If they're cited for a topic you also cover, your content may need improvement. If it's a topic you don't cover, it's a new content opportunity.
3. **GSC queries with no AI match** — Queries you rank for on Google that AI models never search for (or vice versa). The gap reveals where traditional SEO and AI optimization diverge.


## Steps

1. Run `xseek websites --format json` and let the user pick a website.

2. Run these CLI calls in parallel (use `--format json` on all):
   - `xseek opportunities <website> --format json` — Pre-computed content gaps with business value scoring
   - `xseek web-searches <website> --pageSize 100 --format json` — LLM search queries
   - `xseek search-queries <website> --pageSize 100 --sortBy impressions --format json` — top GSC queries
   - `xseek leaderboard <website> --format json` — competitive landscape
   - `xseek sources <website> --format json` — all cited URLs
   - `xseek sitemap-pages <website> --days 30 --format json` — your existing content with traffic

3. Analyze:

   **a) LLM Query Gap Analysis**
   - Group LLM web searches by topic/theme
   - For each topic cluster, check if any sitemap page covers it
   - Queries with no matching content = new content opportunities

   **b) Competitor Citation Analysis**
   - From sources, identify competitor domain URLs (not your domain)
   - Group by domain and topic
   - Highlight topics where competitors are cited but you have no content

   **c) GSC vs LLM Query Crossover**
   - Find GSC queries that overlap with LLM searches (you already rank for what AI searches)
   - Find GSC queries with NO LLM equivalent (Google traffic only)
   - Find LLM queries with NO GSC equivalent (AI-only opportunity)

4. **Keyword Research** — for the top 3-5 highest-value opportunities, run keyword research to enrich the content calendar:

```sh
xseek keywords <website> "<opportunity query 1>,<opportunity query 2>,<opportunity query 3>" --format json
```

This adds real Google search volume and related keywords to each opportunity, making the content calendar actionable with specific keyword targets.

5. Produce a report:

### Report structure

**Content Opportunity Report — [Website Name]**

**1. High-Impact LLM Query Gaps**
Queries AI models search for where you have no content. Grouped by topic. Each entry:
- Query cluster (3-5 related queries)
- Search volume signal (how many times seen)
- Business value: Critical/High/Medium/Low
- Suggested content angle
- **SEO data** (from SEO enrichment):
  - `matchedKeyword`: the highest-volume Google keyword mapped to this LLM query
  - `searchVolume`: monthly Google search volume for the matched keyword
  - `keywordDifficulty`: 0-100 KD score
  - `relatedKeywords`: all extracted keywords with their volume and KD — use these as target keywords when creating content

**2. Competitor Content You're Missing**
Competitor URLs getting cited, grouped by topic. For each:
- Competitor URL and domain
- Citation count
- Topic/angle they cover
- Whether you have competing content (yes/no)
- Suggested response (new page, update existing, or ignore)

**3. GSC-to-AI Crossover Analysis**
| Query | GSC Impressions | GSC Position | Found in LLM Searches | Gap Type |
Show top 20 most impactful.

**4. SEO Keyword Opportunities**
For each opportunity, the API returns `relatedKeywords` — real Google search keywords extracted from the LLM query via GPT-4o-mini. Present the top keywords per opportunity:

| LLM Query | Matched Keyword | Volume/mo | KD | Related Keywords |
|-----------|----------------|-----------|-----|-----------------|
| [LLM query] | [best match] | [volume] | [0-100] | [top 3-5 related] |

Note: Branded LLM queries (e.g. "alternatives to Scrunchai") will have branded keywords extracted (e.g. "scrunchai alternatives", "scrunchai vs competitors") alongside generic keywords. Both should be targeted in content.

**5. Recommended Content Calendar**
Prioritized list of 5-10 content pieces to create or update, ordered by combined AI visibility + organic search impact. Each entry:
- Title suggestion
- Target queries (both GSC and LLM)
- **Target keywords**: include the top `relatedKeywords` from the opportunity's SEO data — these are real Google keywords people search for
- Content type (blog post, FAQ page, comparison page, etc.)
- Why this will improve AI citations
- Estimated organic search opportunity (based on combined search volume of related keywords)
