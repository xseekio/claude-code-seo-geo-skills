# Optimize Page — AI Visibility Optimization for a Specific URL

Analyze a single page and produce specific rewrite recommendations to improve its AI visibility.

**Usage:** Provide a URL as the argument: `/optimize-page https://example.com/blog/my-article`

## Context for the agent

**What "optimize for AI visibility" means concretely:**
- AI models cite pages that directly answer questions with clear, structured content
- They prefer pages with strong entity coverage (names, products, comparisons mentioned explicitly)
- Schema markup (FAQ, HowTo, Article) helps AI extract structured answers
- Pages that rank for queries AI models actually search for get cited more often
- Short, scannable sections with clear headings > long walls of text

## Steps

1. Call `get_websites` to find the websiteId. Match the URL domain to the right website.

2. Run these calls in parallel:
   - `get_search_queries_for_page` with the URL — what GSC queries drive traffic to this page
   - `get_prompt_web_searches` with `pageSize: 100` — what queries LLMs search for
   - `get_sources` with `search` set to the URL domain — which of your pages AI cites
   - `get_latest_ai_visits` with `searchQuery` set to the URL path — AI bot traffic to this page
   - `analyse_api` with the websiteId and URL — AEO Copilot analysis

3. Cross-reference the data:
   - **GSC queries vs LLM queries**: Find queries where this page ranks on Google but AI models search for different terms. These are keyword gaps.
   - **Citation check**: Is this page currently cited by AI? How often vs competitor pages on the same topic?
   - **Bot access check**: Are AI bots actually visiting this page? If not, check robots.txt.

4. Produce a report:

### Report structure

**Page:** [URL]
**Current AI Citation Status:** Cited / Not cited (with count if cited)
**AI Bot Visits:** [count] visits in last 30 days
**GSC Performance:** [impressions] impressions, position [avg position]

**GSC Queries This Page Ranks For:**
Top 10 queries with impressions and position.

**LLM Search Queries (Gaps):**
Queries that AI models search for that are relevant to this page's topic but the page doesn't rank for or explicitly address.

**AEO Copilot Recommendations:**
Summary of the analysis results.

**Specific Rewrite Recommendations:**
1. [Concrete change] — e.g., "Add a FAQ section answering: [specific LLM query]"
2. [Concrete change] — e.g., "Add schema markup for [type]"
3. [Concrete change] — e.g., "Explicitly mention [competitor name] in comparison section"
...

Each recommendation should be specific enough that a content writer can act on it without further research.
