#!/usr/bin/env bash
# Builds Anthropic Skills-API-compatible .zip bundles for every skill in this
# repo. Each .md file becomes <name>.zip containing <name>/SKILL.md with the
# required YAML frontmatter at the top.
#
# Output structure (per Anthropic spec):
#   <name>.zip
#     └── <name>/
#         └── SKILL.md  (with --- frontmatter ---)
#
# Run from repo root: ./scripts/build-skill-zips.sh

set -euo pipefail
cd "$(dirname "$0")/.."

DIST=dist
rm -rf "$DIST"
mkdir -p "$DIST"

# name → frontmatter map. Descriptions kept under the 200-char limit.
declare_frontmatter() {
  case "$1" in
    add-keywords) cat <<EOF
---
name: add-keywords
description: Enrich an existing article with relevant SEO keywords from Google search data. Run this when a user wants to add keywords to an article.
---
EOF
    ;;
    aeo-audit) cat <<EOF
---
name: aeo-audit
description: Full AI visibility assessment. Run this when a user asks to audit their AI search presence or check AEO performance.
---
EOF
    ;;
    apply-comments) cat <<EOF
---
name: apply-comments
description: Apply unresolved comments on articles — read comments, apply changes, resolve them. Run this when articles have feedback to address.
---
EOF
    ;;
    fact-check) cat <<EOF
---
name: fact-check
description: Verify pricing, features, and claims in an article against official sources. Run this to validate competitor data before publishing.
---
EOF
    ;;
    find-opportunities) cat <<EOF
---
name: find-opportunities
description: Content gap finder for AI search. Run this when a user wants to find topics where competitors get cited by AI but they don't.
---
EOF
    ;;
    generate-article) cat <<EOF
---
name: generate-article
description: Generate an AI-optimized article from content gap data. Run this when a user wants to create new content targeting AI citations.
---
EOF
    ;;
    geo-methods) cat <<EOF
---
name: geo-methods
description: Princeton GEO optimization methods with examples and domain tips. Reference material — invoked by other skills, not directly.
---
EOF
    ;;
    optimize-page) cat <<EOF
---
name: optimize-page
description: AI visibility optimization for a specific URL. Run this when a user wants to improve a page's chances of being cited by AI.
---
EOF
    ;;
    publish-articles) cat <<EOF
---
name: publish-articles
description: Publish ready articles from xSeek Content Studio to your website. Run this when articles are reviewed and ready to go live.
---
EOF
    ;;
    rewrite-page) cat <<EOF
---
name: rewrite-page
description: Full AI-optimized content rewrite. Run this when a user wants to rewrite a page to improve AI search citations.
---
EOF
    ;;
    schedule-content-batch) cat <<EOF
---
name: schedule-content-batch
description: Schedule a monthly batch of articles from the action plan — picks top opportunities and queues article-generation routines across the month.
---
EOF
    ;;
    track-visibility) cat <<EOF
---
name: track-visibility
description: AI visibility snapshot. Run this when a user wants a quick overview of their brand's AI search presence.
---
EOF
    ;;
    weekly-report) cat <<EOF
---
name: weekly-report
description: Weekly AI visibility and SEO performance report. Run this when a user asks for a status update or weekly summary.
---
EOF
    ;;
    writing-rules) cat <<EOF
---
name: writing-rules
description: Human-like writing rules for AI content. Reference material — invoked by other skills, not directly.
---
EOF
    ;;
    *)
      echo "no frontmatter defined for: $1" >&2
      return 1
    ;;
  esac
}

count=0
for src in *.md; do
  name="${src%.md}"
  [ "$name" = "README" ] && continue

  pkg="$DIST/$name"
  mkdir -p "$pkg"

  {
    declare_frontmatter "$name"
    echo
    cat "$src"
  } > "$pkg/SKILL.md"

  ( cd "$DIST" && zip -qr "$name.zip" "$name" )
  rm -rf "$pkg"

  count=$((count + 1))
  echo "  ✓ $DIST/$name.zip"
done

echo
echo "Built $count skill zips in $DIST/"
