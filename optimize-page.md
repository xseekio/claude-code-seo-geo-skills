# Optimize Page — AI Visibility Optimization for a Specific URL

Analyze a single page and produce specific rewrite recommendations to improve its AI visibility.

**Usage:** Provide a URL as the argument: `/optimize-page https://example.com/blog/my-article`

## Context for the agent

**GEO = Generative Engine Optimization.** AI search engines don't rank pages — they **cite sources**. Being cited is the new "ranking #1".

**What "optimize for AI visibility" means concretely:**
- AI models cite pages that directly answer questions with clear, structured content
- They prefer pages with strong entity coverage (names, products, comparisons mentioned explicitly)
- Schema markup (FAQ, HowTo, Article) helps AI extract structured answers
- Pages that rank for queries AI models actually search for get cited more often
- Short, scannable sections with clear headings > long walls of text

### Princeton GEO Methods (9 research-backed techniques)

When writing rewrite recommendations, evaluate the page against these methods and suggest specific improvements:

| Method | Visibility Boost | How to Apply |
|--------|-----------------|--------------|
| **Cite Sources** | +40% | Add authoritative citations and references |
| **Statistics Addition** | +37% | Include specific numbers and data points |
| **Quotation Addition** | +30% | Add expert quotes with attribution |
| **Authoritative Tone** | +25% | Use confident, expert language |
| **Easy-to-Understand** | +20% | Simplify complex concepts |
| **Technical Terms** | +18% | Include domain-specific terminology |
| **Unique Words** | +15% | Increase vocabulary diversity |
| **Fluency Optimization** | +15-30% | Improve readability and flow |
| ~~Keyword Stuffing~~ | **-10%** | **AVOID — hurts visibility** |

**Best combination:** Fluency + Statistics = Maximum boost.

### Content Structure for AI Citation
- **Answer-first format**: Direct answer at the top of each section
- Clear H1 > H2 > H3 hierarchy
- Bullet points and numbered lists for scannability
- Tables for comparison data
- Short paragraphs (2-3 sentences max)
- **FAQPage schema** adds +40% AI visibility

### Platform-Specific Factors

**ChatGPT:** Branded domains cited 11% more. Content updated within 30 days gets 3.2x more citations. 350K+ referring domains = 8.4 avg citations.

**Perplexity:** Allow PerplexityBot in robots.txt. FAQ Schema drives higher citation rates. PDF documents prioritized. Semantic relevance over keywords.

**Claude:** Uses Brave Search (not Google) — ensure Brave indexing. Prefers high factual density and structural clarity.

**Google AI Overview:** E-E-A-T signals critical. Structured data required. Authoritative citations boost visibility +132%.

**Microsoft Copilot:** Requires Bing indexing. Microsoft ecosystem presence helps (LinkedIn, GitHub). Page speed < 2 seconds.

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

**GEO Method Scorecard:**
Rate the page against each Princeton method (Pass / Needs Work / Missing):
| Method | Status | Notes |
| Cite Sources | ? | Are there authoritative references? |
| Statistics | ? | Specific numbers and data points? |
| Quotations | ? | Expert quotes with attribution? |
| Authoritative Tone | ? | Confident expert language? |
| Easy-to-Understand | ? | Accessible to a broad audience? |
| Technical Terms | ? | Domain-specific terminology present? |
| Unique Words | ? | Vocabulary diversity? |
| Fluency | ? | Readable, natural flow? |
| Keyword Stuffing | ? | Should be "Not Present" (good) |

**Specific Rewrite Recommendations:**
1. [Concrete change] — e.g., "Add a FAQ section answering: [specific LLM query]"
2. [Concrete change] — e.g., "Add schema markup for [type]"
3. [Concrete change] — e.g., "Explicitly mention [competitor name] in comparison section"
4. [Concrete change] — e.g., "Add 2-3 statistics with sources to boost GEO score (+37%)"
5. [Concrete change] — e.g., "Add expert quote with attribution (+30% visibility)"
...

Each recommendation should be specific enough that a content writer can act on it without further research. Reference which Princeton GEO method each recommendation improves.
