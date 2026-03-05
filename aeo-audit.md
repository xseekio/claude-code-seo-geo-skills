# AEO Audit — Full AI Visibility Assessment

Run a comprehensive audit of a website's AI Engine Optimization (AEO) health. This pulls data from multiple sources to build a prioritized action plan.

## Context for the agent

**AEO (AI Engine Optimization)** = optimizing content so AI models (ChatGPT, Claude, Perplexity) cite and recommend your brand. It's the AI equivalent of SEO.

**Key metrics to understand:**
- **Leaderboard rank**: Your brand's share of voice vs competitors across AI responses. Rank #1 = most mentioned.
- **AI citations (sources)**: URLs that AI models link as references. More citations = AI trusts your content.
- **AI bot visits**: How often GPTBot, ClaudeBot, etc. crawl your pages. Zero visits = content is invisible to AI.
- **GSC metrics**: Google Search Console data. Pages with high GSC impressions but low AI visits are optimization opportunities.
- **LLM web searches**: The actual search queries AI models run when answering prompts. These are the keywords to target.
- **Pages needing attention**: Pages where AI traffic dropped >20%. Urgent fixes.

## Steps

1. First, call `get_websites` to list all websites and let the user pick one (or use the first one).

2. Run these calls in parallel for the selected websiteId:
   - `get_leaderboard` with `lastDays: 30` — competitive position
   - `get_sitemap_pages` with `days: 30` — all pages with traffic
   - `get_pages_needing_attention` with `days: 30` — declining pages
   - `get_search_metrics` with `pageSize: 50, sortBy: 'impressions'` — top GSC pages
   - `get_prompt_web_searches` with `pageSize: 50` — LLM search queries
   - `get_sources` with `pageSize: 50, sortBy: 'citationCount'` — top cited URLs
   - `get_latest_ai_visits` with `pageSize: 50` — AI bot traffic

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
