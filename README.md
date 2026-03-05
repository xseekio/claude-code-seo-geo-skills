# GEO/SEO Skills for Claude Code

AI-powered content optimization skills for [Claude Code](https://claude.ai/claude-code). Run AEO audits, optimize pages for AI search, track AI visibility, and find content gaps — from your terminal.

These skills connect to the [xSeek MCP server](https://www.xseek.io/products/xseek-aeo-mcp) to pull real data from Google Search Console, AI bot crawl logs, LLM web searches, and brand mention tracking.

## What's Included

| Skill | Command | What It Does |
|-------|---------|-------------|
| **AEO Audit** | `/aeo-audit` | Full AI visibility assessment. Pulls leaderboard rank, declining pages, search metrics, LLM queries, and AI citations. Outputs a prioritized action list. |
| **Optimize Page** | `/optimize-page <url>` | Deep-dive on a single URL. Compares GSC queries vs LLM search queries, checks AI citations, runs AEO Copilot. Outputs specific rewrite recommendations. |
| **Track Visibility** | `/track-visibility` | AI visibility snapshot. Leaderboard position, top cited pages, prompt coverage, AI bot activity. Run weekly to track progress. |
| **Find Opportunities** | `/find-opportunities` | Content gap finder. Cross-references LLM web searches, GSC data, and competitor citations. Finds queries where competitors rank but you don't. Outputs a content calendar. |

## Quick Start

### 1. Get an xSeek API Key

Sign up at [xseek.io](https://www.xseek.io/login) and generate an API key from Settings. Enable the `llm_queries:read` and `prompts:read` privileges.

### 2. Add the MCP Server

Add this to your project's `.claude/settings.json`:

```json
{
  "mcpServers": {
    "xSeek": {
      "url": "https://www.xseek.io/api/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

### 3. Install the Skills

```bash
git clone https://github.com/xseekio/claude-code-seo-geo-skills.git ~/.claude/skills/seo-geo
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

The skills use the xSeek MCP server (19 tools) to pull and cross-reference:

- **Google Search Console** — page metrics (impressions, clicks, CTR, position) and search queries per URL
- **AI Brand Mentions** — leaderboard rankings across ChatGPT, Claude, and Perplexity responses
- **LLM Web Searches** — the exact search queries AI models run behind the scenes when answering prompts
- **AI Citations** — URLs that AI models link as references in their responses
- **AI Bot Traffic** — GPTBot, ClaudeBot, PerplexityBot crawl logs per page
- **AEO Copilot** — AI-powered page analysis with structural and schema recommendations

## How It Works

```
You type /aeo-audit
    ↓
Claude reads the skill file (.claude/commands/aeo-audit.md)
    ↓
The skill tells Claude what MCP tools to call and how to analyze results
    ↓
Claude calls xSeek MCP server (your API key, your data)
    ↓
You get a cross-referenced report with actionable recommendations
```

## Requirements

- [Claude Code](https://claude.ai/claude-code) CLI
- [xSeek](https://www.xseek.io) account with API key
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
- [xSeek AEO MCP](https://www.xseek.io/products/xseek-aeo-mcp) — MCP server documentation
- [GEO/SEO Skills Landing Page](https://www.xseek.io/products/geo-seo-skills) — Product page
- [Claude Code](https://claude.ai/claude-code) — Anthropic's CLI for Claude
