# GEO/SEO Skills for Claude Code

AI-powered content optimization skills for [Claude Code](https://claude.ai/claude-code). Run AEO audits, optimize pages for AI search, track AI visibility, and find content gaps — from your terminal.

**Requires an [xSeek](https://www.xseek.io) account with an API key.** These skills use the [xSeek CLI](https://www.xseek.io/products/xseek-cli) to pull real data from your tracked websites — Google Search Console metrics, AI bot crawl logs, LLM web searches, brand mention tracking, and content opportunities. Sign up at [xseek.io](https://www.xseek.io/login), add a website, and generate an API key from Settings.

## What's Included

| Skill | Command | What It Does |
|-------|---------|-------------|
| **AEO Audit** | `/aeo-audit` | Full AI visibility assessment. Pulls leaderboard rank, declining pages, search metrics, LLM queries, and AI citations. Outputs a prioritized action list. |
| **Optimize Page** | `/optimize-page <url>` | Deep-dive on a single URL. Compares GSC queries vs LLM search queries, checks AI citations, runs keyword research. Outputs specific rewrite recommendations. |
| **Track Visibility** | `/track-visibility` | AI visibility snapshot. Leaderboard position, top cited pages, prompt coverage, AI bot activity. Run weekly to track progress. |
| **Find Opportunities** | `/find-opportunities` | Content gap finder. Uses pre-computed opportunities with ranking articles, competitor citations, and business value scoring. Cross-references with GSC data and LLM web searches. Outputs a content calendar. |
| **Rewrite Page** | `/rewrite-page <url>` | Fetches a page, analyzes AI visibility gaps, and produces a full rewrite applying Princeton GEO methods (+40% citations), humanization rules, and answer-first structure. Outputs publish-ready markdown with a changes summary. |
| **Generate Article** | `/generate-article [topic]` | Picks the highest-value content gap, fetches the top 3-5 competitor articles that AI currently cites, studies their structure, and writes a new article that beats them. Pushes to Content Studio automatically. Includes GEO scorecard and competitive analysis. |
| **Add Keywords** | `/add-keywords [url or articleId]` | Takes an existing article and enriches it with relevant SEO keywords from Google search data. Weaves keywords naturally into headings, body, and FAQ sections. |

## Quick Start

### 1. Install the xSeek CLI

```sh
curl -fsSL https://cli.xseek.io/install.sh | sh
```

### 2. Authenticate

Sign up at [xseek.io](https://www.xseek.io/login) and generate an API key from Settings.

```sh
xseek login your_api_key
```

### 3. Install the Skills

```sh
xseek init
```

### 4. Run a Skill

Open Claude Code and type:

```
/aeo-audit
/optimize-page https://yoursite.com/blog/my-article
/track-visibility
/find-opportunities
```

## What Data the Skills Access

The skills use the xSeek CLI to pull and cross-reference:

- **Google Search Console** — page metrics (impressions, clicks, CTR, position) and search queries per URL
- **AI Brand Mentions** — leaderboard rankings across ChatGPT, Claude, and Perplexity responses
- **LLM Web Searches** — the exact search queries AI models run behind the scenes when answering prompts
- **AI Citations** — URLs that AI models link as references in their responses
- **AI Bot Traffic** — GPTBot, ClaudeBot, PerplexityBot crawl logs per page
- **Content Opportunities** — Pre-computed content gaps where your site isn't cited, with competitor ranking articles, business value scoring, and suggested content types

## How It Works

```
You type /aeo-audit
    ↓
Claude reads the skill file (.claude/commands/aeo-audit.md)
    ↓
The skill tells Claude which xseek CLI commands to run and how to analyze results
    ↓
Claude runs xseek CLI commands (your API key, your data)
    ↓
You get a cross-referenced report with actionable recommendations
```

## CLI Commands Available

| Command | Description |
|---------|-------------|
| `xseek websites` | List tracked websites |
| `xseek leaderboard <website>` | Brand mention leaderboard |
| `xseek sources <website>` | AI citation sources |
| `xseek opportunities <website>` | Content gap opportunities |
| `xseek prompts <website>` | List monitoring prompts |
| `xseek prompt-runs <website> <id>` | Latest runs for a prompt |
| `xseek search-metrics <website>` | GSC page-level metrics |
| `xseek search-queries <website>` | GSC search queries |
| `xseek sitemap-pages <website>` | Sitemap pages with AI + GSC data |
| `xseek ai-visits <website>` | AI bot visit logs |
| `xseek web-searches <website>` | LLM web searches |
| `xseek keywords <website> "<topic>"` | Keyword research (volume, KD, related) |
| `xseek brand-context <website>` | Brand voice, tone, and knowledge base |
| `xseek articles list <website>` | List articles in Content Studio |
| `xseek articles push <website>` | Push a new article (stdin or `--file`) |
| `xseek articles get <website> <id>` | Get full article content |
| `xseek articles publish <website> <id> <url>` | Mark article as published with URL |
| `xseek scan robots <domain>` | Check AI bot access |
| `xseek generate llms-txt <domain>` | Generate LLMs.txt |

All commands support `--format json` for structured output.

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI
- [xSeek CLI](https://www.xseek.io/products/xseek-cli) installed with API key
- A website tracked in xSeek with Google Search Console connected

## What is AEO / GEO?

**AEO (AI Engine Optimization)** is optimizing content so AI models — ChatGPT, Claude, Perplexity, Gemini — cite and recommend your brand when users ask relevant questions. It's the AI search equivalent of SEO.

**GEO (Generative Engine Optimization)** is the research-backed framework behind it. AI search engines don't rank pages — they **cite sources**. Being cited is the new "ranking #1".

Key differences from traditional SEO:
- AI models pull from web searches they run internally, not just Google's index
- Citations (source URLs) matter more than rankings
- Structured, direct answers get cited more than long-form content
- Entity coverage (mentioning names, products, comparisons explicitly) drives mentions

### Princeton GEO Methods

The skills apply 9 research-backed optimization methods from Princeton's GEO research:

| Method | Visibility Boost |
|--------|-----------------|
| Cite Sources | +40% |
| Statistics Addition | +37% |
| Quotation Addition | +30% |
| Authoritative Tone | +25% |
| Easy-to-Understand | +20% |
| Technical Terms | +18% |
| Unique Words | +15% |
| Fluency Optimization | +15-30% |
| ~~Keyword Stuffing~~ | **-10%** |

The `/optimize-page` skill scores your content against each method and produces specific rewrite recommendations.

### Platform-Specific Optimization

Each AI engine has different ranking factors. The skills tailor recommendations per platform:

- **ChatGPT** — Branded domains cited 11% more. Fresh content (< 30 days) gets 3.2x more citations.
- **Perplexity** — FAQ Schema, PDF documents, and semantic relevance drive citations.
- **Claude** — Uses Brave Search (not Google). Prefers high factual density and structural clarity.
- **Google AI Overview** — E-E-A-T signals and structured data. Authoritative citations boost +132%.
- **Microsoft Copilot** — Requires Bing indexing. Page speed < 2s. Microsoft ecosystem presence helps.

## License

MIT

## Links

- [xSeek](https://www.xseek.io) — AI visibility tracking platform
- [xSeek CLI](https://www.xseek.io/products/xseek-cli) — CLI documentation
- [GEO/SEO Skills Landing Page](https://www.xseek.io/products/geo-seo-skills) — Product page
- [Claude Code](https://claude.ai/claude-code) — Anthropic's CLI for Claude
