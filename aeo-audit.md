# AEO Audit — Full AI Visibility Assessment

Run a comprehensive audit of a website's AI Engine Optimization (AEO) health. This pulls data from multiple sources to build a prioritized action plan.

## Context for the agent

**AEO (AI Engine Optimization)** = optimizing content so AI models (ChatGPT, Claude, Perplexity) cite and recommend your brand. It's the AI equivalent of SEO.

**GEO (Generative Engine Optimization)** = the research-backed framework. AI search engines don't rank pages — they **cite sources**. Princeton research identified 9 methods that increase citation rates (see optimize-page.md for the full table). When recommending fixes, reference these methods:
- Cite Sources (+40%), Statistics (+37%), Quotations (+30%), Authoritative Tone (+25%), Easy-to-Understand (+20%), Technical Terms (+18%), Unique Words (+15%), Fluency (+15-30%). Keyword Stuffing hurts (-10%).

**Key metrics to understand:**
- **Leaderboard rank**: Your brand's share of voice vs competitors across AI responses. Rank #1 = most mentioned.
- **AI citations (sources)**: URLs that AI models link as references. More citations = AI trusts your content.
- **AI bot visits**: How often GPTBot, ClaudeBot, etc. crawl your pages. Zero visits = content is invisible to AI.
- **GSC metrics**: Google Search Console data. Pages with high GSC impressions but low AI visits are optimization opportunities.
- **LLM web searches**: The actual search queries AI models run when answering prompts. These are the keywords to target.
- **Pages needing attention**: Pages where AI traffic dropped >20%. Urgent fixes.

## Prerequisites

The xSeek CLI must be installed and authenticated:
```sh
curl -fsSL https://cli.xseek.io/install.sh | sh
export XSEEK_API_KEY=your_api_key
```

## Steps

1. First, run `xseek websites --format json` to list all websites and let the user pick one (or use the first one).

2. Run these CLI calls in parallel for the selected website (use `--format json` on all):
   - `xseek leaderboard <website> --format json` — competitive position
   - `xseek sitemap-pages <website> --days 30 --format json` — all pages with traffic
   - `xseek sitemap-pages <website> --days 30 --filter attention --format json` — declining pages
   - `xseek search-metrics <website> --pageSize 50 --sortBy impressions --format json` — top GSC pages
   - `xseek web-searches <website> --pageSize 50 --format json` — LLM search queries
   - `xseek sources <website> --format json` — top cited URLs
   - `xseek ai-visits <website> --pageSize 50 --format json` — AI bot traffic

3. Analyze the data and produce a report with these sections:

### Report structure

**1. AI Visibility Score** (High / Medium / Low)
Based on: leaderboard position, number of AI citations for your domain, AI bot visit volume.

**2. Competitive Position**
Who's ahead of you on the leaderboard? By how much? Trend direction.

**3. Top Performing Content**
Pages with the most AI citations + AI bot visits. What makes these pages work.

**4. Urgent Fixes (Pages Needing Attention)**
Pages losing AI traffic. For each: URL, traffic drop %, likely cause, recommended action.

**5. Optimization Opportunities**
- Pages with high GSC traffic but zero AI citations (Google ranks it, AI ignores it)
- LLM search queries that don't match any existing content
- Competitor URLs getting cited that you could outrank

**6. Prioritized Action List**
Numbered list of specific actions, ordered by estimated impact. Each action should name the specific page URL and what to do.

Keep the report concise and actionable. No fluff.
