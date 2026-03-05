# Track Visibility — AI Visibility Snapshot

Generate a quick AI visibility snapshot: where you stand across AI search engines, what prompts mention you, and where you're missing citations.

## Context for the agent

**AI visibility** = how often and how prominently AI models recommend your brand when users ask relevant questions. It's measured through:
- **Brand mentions** in AI responses (leaderboard)
- **Source citations** — URLs AI links as references
- **AI bot crawl volume** — how actively AI models index your content
- **Prompt coverage** — what % of relevant prompts result in your brand being mentioned

## Steps

1. Call `get_websites` and let the user pick a website (or use the first one).

2. Run these calls in parallel:
   - `get_leaderboard` with `lastDays: 30`
   - `get_prompts` — list of monitoring prompts
   - `get_sources` with `pageSize: 30, sortBy: 'citationCount'`
   - `get_search_metrics` with `pageSize: 20, sortBy: 'impressions'`
   - `get_latest_ai_visits` with `pageSize: 20`

3. For the top 3 prompts (by most recent activity), call `get_latest_prompt_runs` to get the latest response.

4. Produce a visibility snapshot:

### Report structure

**AI Visibility Snapshot — [Website Name]**
**Date:** [today]

**Visibility Score:** [High/Medium/Low]
Derived from: leaderboard rank, citation count, bot visit volume.

**Leaderboard Position**
| Rank | Brand | Mentions |
Show top 5 + the user's brand position if not in top 5.

**Top Cited Pages**
Top 5 most-cited URLs from your domain, with citation counts.

**Citation Gaps**
URLs that AI bots visit frequently but aren't cited — these have untapped potential.

**Prompt Coverage**
For each prompt: name, latest model responses (brief), whether your brand was mentioned, sentiment.

**AI Bot Activity**
Total visits in last 30 days, breakdown by bot (GPTBot, ClaudeBot, PerplexityBot, etc.).

**GSC vs AI Performance**
Pages with highest GSC impressions that have zero or low AI citations — quick wins.

**Summary**
3-5 bullet points: what's working, what's not, top priority action.
