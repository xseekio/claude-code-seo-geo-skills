# Weekly Report — AI Visibility & SEO Performance

Generate a weekly performance report for a website covering AI traffic trends, brand position, SEO performance, and content opportunities.

**Usage:**
- `/weekly-report` — report for the default website
- `/weekly-report <website>` — report for a specific website (domain or ID)

## Prerequisites

The xSeek CLI must be installed and authenticated:
```sh
curl -fsSL https://cli.xseek.io/install.sh | sh
xseek login your_api_key
```

## Steps

### Step 1: Gather all data

1. Run `xseek websites --format json` to resolve the website.

2. Run ALL of these in parallel (`--format json` on all):
   - `xseek sitemap-pages <website> --days 7 --format json` — 7-day page performance
   - `xseek sitemap-pages <website> --days 30 --format json` — 30-day page performance (for comparison)
   - `xseek leaderboard <website> --format json` — brand mention rankings
   - `xseek search-queries <website> --pageSize 30 --sortBy impressions --format json` — top GSC queries
   - `xseek search-metrics <website> --pageSize 30 --sortBy impressions --format json` — top GSC pages
   - `xseek sources <website> --format json` — top cited sources
   - `xseek opportunities <website> --format json` — content gaps
   - `xseek ai-visits <website> --pageSize 50 --format json` — recent AI bot visits
   - `xseek web-searches <website> --pageSize 50 --format json` — recent LLM web searches

### Step 2: Analyze and produce the report

Process the data and output a structured report with these sections:

#### Section 1: Brand Position

From the leaderboard data:
- Current rank and mention count
- Top 5 competitors with their counts
- Gap between you and #1

#### Section 2: AI Traffic Overview (7-day)

From sitemap-pages (7 days):
- Total AI visits across all pages
- Compare with 30-day data to estimate weekly average
- Number of pages receiving AI traffic

#### Section 3: Top Growing Pages

From sitemap-pages (7 days), sorted by `aiTrend` descending:
- Top 10 pages with biggest positive AI traffic trend
- Show: path, AI visits, trend %, GSC impressions

#### Section 4: Pages Needing Attention

From sitemap-pages (7 days):
- Pages with negative AI traffic trend (biggest drops first)
- Pages with high GSC impressions but 0 clicks (CTR problem)
- Pages with high GSC impressions but low AI visits (AI gap)

#### Section 5: SEO Performance

From search-queries and search-metrics:
- Top 10 GSC queries by impressions
- Top pages by clicks
- Any queries with high impressions but position > 10 (opportunity to improve)

#### Section 6: AI Citation Sources

From sources data:
- Top 10 most-cited URLs from your domain
- Top 5 competitor domains getting cited

#### Section 7: Content Opportunities

From opportunities data:
- Top 5 highest-value opportunities (critical first, then by frequency)
- For each: the query, business value, frequency, top competitors, suggested content type

#### Section 8: LLM Activity

From web-searches:
- What queries LLMs are searching for related to your site
- Which AI models are most active
- Any new/trending search patterns

### Step 3: Output format

Output the report in this format:

```markdown
# Weekly AI Visibility Report — [Website Name]
**Period:** [date range]
**Generated:** [today's date]

---

## Brand Position

**Rank: #[X]** with [N] mentions
| Rank | Brand | Mentions |
|------|-------|----------|
| #1 | [name] | [count] |
| ... | ... | ... |
| #[yours] | **[your brand]** | **[count]** |

Gap to #1: [N] mentions

---

## AI Traffic (7-day snapshot)

- **Total AI visits:** [N] across [N] pages
- **30-day weekly average:** ~[N] visits/week
- **Trend:** [up/down X% vs average]

---

## Top Growing Pages

| Page | AI Visits (7d) | Trend | GSC Impressions |
|------|---------------|-------|-----------------|
| [path] | [N] | +[X]% | [N] |

---

## Pages Needing Attention

### Dropping AI traffic
| Page | AI Visits | Trend | Action |
|------|----------|-------|--------|
| [path] | [N] | -[X]% | Review content freshness |

### High impressions, no clicks (CTR problem)
| Page | GSC Impressions | Clicks | CTR |
|------|----------------|--------|-----|
| [path] | [N] | 0 | 0% |

### High GSC, low AI (AI gap)
| Page | GSC Impressions | AI Visits | Gap |
|------|----------------|----------|-----|
| [path] | [N] | [N] | Content may not be AI-optimized |

---

## SEO Performance

### Top queries
| Query | Impressions | Position | Clicks |
|-------|------------|----------|--------|
| [query] | [N] | [X] | [N] |

### Ranking opportunities (high impressions, position > 10)
| Query | Impressions | Position | Potential |
|-------|------------|----------|-----------|
| [query] | [N] | [X] | Move to page 1 |

---

## AI Citation Sources

### Your most-cited pages
| URL | Citations |
|-----|----------|
| [url] | [N] |

### Top competitor domains in citations
| Domain | Citations |
|--------|----------|
| [domain] | [N] |

---

## Content Opportunities

| Priority | Query | Value | Frequency | Type | Top Competitor |
|----------|-------|-------|-----------|------|---------------|
| 1 | [query] | CRITICAL | [N]x | [type] | [name] ([count]) |

---

## LLM Search Activity

- **Total web searches tracked:** [N]
- **Most active models:** [model1], [model2]
- **Recent trending queries:**
  - [query] ([model])
  - [query] ([model])

---

## Recommended Actions This Week

Based on the data above, list 3-5 specific actions:
1. **[Action]** — [why, based on which data point]
2. **[Action]** — [why]
3. **[Action]** — [why]
```

### Important notes

- Use real numbers from the data. Don't round excessively — show exact counts.
- For the "Recommended Actions" section, be specific. Don't say "optimize content." Say "rewrite /docs/xyz to add FAQ schema — it has 57K GSC impressions but 0 clicks."
- If a page has high AI traffic but low GSC traffic, note it as an AI-first win.
- If a page has high GSC traffic but low AI traffic, suggest AEO optimization.
- Keep the tone direct and actionable. This is a working document, not a presentation.
