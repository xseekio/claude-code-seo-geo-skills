#!/usr/bin/env bash
# Builds Anthropic Skills-API-compatible .zip bundles for every skill in this
# repo. Each zip ships a self-contained skill folder with:
#   <name>/
#     SKILL.md           — body with required YAML frontmatter (name, description)
#     USAGE.md           — xSeek CLI install + auth steps
#     references/        — referenced helper skills (writing-rules, geo-methods)
#                          bundled only when the skill body references them
#
# Run from repo root: ./scripts/build-skill-zips.sh

set -euo pipefail
cd "$(dirname "$0")/.."

DIST=dist
rm -rf "$DIST"
mkdir -p "$DIST"

# Per-skill metadata. Format:
#   name|description|argument-hint|references (space-separated, optional)
SKILLS=(
  "add-keywords|Enrich an existing article with relevant SEO keywords from Google search data. Run when adding keywords to an article in xSeek Content Studio.|[url or articleId]|"
  "aeo-audit|Full AI visibility (AEO) assessment for an xSeek-tracked website. Pulls leaderboard rank, declining pages, AI citations, and outputs a prioritized action list.||"
  "apply-comments|Apply unresolved comments on an xSeek Content Studio article — read comments, apply changes, resolve them.|[articleId]|"
  "fact-check|Verify pricing, features, and claims in an xSeek Content Studio article against official sources before publishing.|[url or articleId]|"
  "find-opportunities|Content gap finder for AI search using xSeek opportunities data. Surfaces topics where competitors get cited by AI but you don't.||"
  "generate-article|Generate an AI-optimized article from xSeek content gap data and push it to Content Studio. Beats top competitor articles AI currently cites.|[topic]|writing-rules geo-methods"
  "geo-methods|Princeton GEO optimization methods (KDD 2024) with examples and domain tips. Reference material — read by other skills, not invoked directly.||"
  "optimize-page|AI visibility optimization for a single URL using xSeek data. Compares GSC vs LLM queries, checks AI citations, outputs rewrite recommendations.|<url>|"
  "publish-articles|Publish ready articles from xSeek Content Studio to your website. Run when articles are reviewed and ready to go live.|[article title]|"
  "rewrite-page|Full AI-optimized rewrite of a page applying Princeton GEO methods. Pulls xSeek visibility gaps + outputs publish-ready markdown.|<url>|writing-rules geo-methods"
  "schedule-content-batch|Schedule a monthly batch of articles from the xSeek action plan — picks top opportunities and queues article-generation routines across the month.|[website count cadence]|"
  "track-visibility|AI visibility snapshot from xSeek — leaderboard, top cited pages, prompt coverage, AI bot activity. Run weekly to track progress.||"
  "weekly-report|Weekly AI visibility and SEO performance report from xSeek data. Run when a user asks for a status update or weekly summary.||"
  "writing-rules|Human-like writing rules for AI content generation. Reference material — read by other skills, not invoked directly.||"
)

# USAGE.md template — one shared file per skill explaining the xSeek dep.
USAGE_BODY='# Setup

This skill uses the [xSeek CLI](https://www.xseek.io/products/xseek-cli) to pull
real data from your tracked websites — opportunities, brand context, AI bot
crawl logs, GSC metrics, brand mention tracking.

## 1. Install the xSeek CLI

```sh
curl -fsSL https://cli.xseek.io/install.sh | sh
```

## 2. Authenticate

Sign up at [xseek.io](https://www.xseek.io/login) and generate an API key from
Settings → API keys. Then:

```sh
xseek login your_api_key
```

## 3. Verify

```sh
xseek websites
```

You should see the websites tracked under your organization.

## Alternative: xSeek MCP

If you prefer not to install the CLI, you can connect Claude to xSeek directly
via the remote MCP server at `https://www.xseek.io/api/mcp` — claude.ai walks
you through OAuth, no CLI install needed. This skill assumes the CLI is
available; for an MCP-only flow, swap any `xseek <subcommand>` invocation for
the equivalent `mcp__xseek__*` tool call.
'

count=0
for entry in "${SKILLS[@]}"; do
  IFS='|' read -r name description argument_hint refs <<< "$entry"
  src="${name}.md"
  if [ ! -f "$src" ]; then
    echo "  skip $name (no source $src)" >&2
    continue
  fi

  pkg="$DIST/$name"
  mkdir -p "$pkg"

  # SKILL.md = frontmatter + source body (source has no frontmatter)
  {
    echo "---"
    echo "name: $name"
    echo "description: $description"
    if [ -n "$argument_hint" ]; then
      echo "argument-hint: $argument_hint"
    fi
    echo "---"
    echo
    cat "$src"
  } > "$pkg/SKILL.md"

  # USAGE.md = shared install/auth doc
  printf '%s' "$USAGE_BODY" > "$pkg/USAGE.md"

  # References folder — only if this skill references other helpers
  if [ -n "$refs" ]; then
    mkdir -p "$pkg/references"
    for ref in $refs; do
      if [ -f "${ref}.md" ]; then
        cp "${ref}.md" "$pkg/references/${ref}.md"
      else
        echo "  warn: $name references missing ${ref}.md" >&2
      fi
    done
  fi

  ( cd "$DIST" && zip -qr "$name.zip" "$name" )
  rm -rf "$pkg"

  count=$((count + 1))
  echo "  ✓ $DIST/$name.zip"
done

echo
echo "Built $count skill zips in $DIST/"
