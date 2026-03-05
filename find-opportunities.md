# Find Opportunities — Content Gap Finder for AI Search

Discover content gaps: queries that AI models search for where you don't have content, and topics where competitors get cited but you don't.

## Context for the agent

**Content opportunities** come from three sources:
1. **LLM search queries you don't rank for** — AI models search for these terms when answering prompts, but your content doesn't appear. Writing content targeting these queries increases your chance of being cited.
2. **Competitor citations** — URLs from competitor domains that AI cites. If they're cited for a topic you also cover, your content may need improvement. If it's a topic you don't cover, it's a new content opportunity.
3. **GSC queries with no AI match** — Queries you rank for on Google that AI models never search for (or vice versa). The gap reveals where traditional SEO and AI optimization diverge.

## Steps

1. Call `get_websites` and let the user pick a website.

2. Run these calls in parallel:
   - `get_prompt_web_searches` with `pageSize: 100` — LLM search queries
   - `get_search_queries` with `pageSize: 100, sortBy: 'impressions'` — top GSC queries
   - `get_leaderboard` with `lastDays: 30` — competitive landscape
   - `get_sources` with `pageSize: 100, sortBy: 'citationCount'` — all cited URLs
   - `get_sitemap_pages` with `days: 30` — your existing content with traffic

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

4. Produce a report:

### Report structure

**Content Opportunity Report — [Website Name]**

**1. High-Impact LLM Query Gaps**
Queries AI models search for where you have no content. Grouped by topic. Each entry:
- Query cluster (3-5 related queries)
- Search volume signal (how many times seen)
- Suggested content angle
- Priority: High/Medium/Low

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

**4. Recommended Content Calendar**
Prioritized list of 5-10 content pieces to create or update, ordered by estimated AI visibility impact. Each entry:
- Title suggestion
- Target queries (both GSC and LLM)
- Content type (blog post, FAQ page, comparison page, etc.)
- Why this will improve AI citations
