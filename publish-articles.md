# Publish Articles — Publish Ready Articles to Your Website

Fetch articles from Content Studio that are ready to publish, publish them to your website, and update their status in xSeek.

**Usage:**
- `/publish-articles` — lists all ready articles and publishes them all
- `/publish-articles <article title>` — publishes a specific article by name

## Steps

### Phase 1: Get Ready Articles

1. Run `xseek websites --format json` to get the website.

2. Run `xseek articles list <website> --status ready --format json` to get all articles with status `ready`.

3. If no articles are ready:
   - Tell the user "No articles ready to publish. Use /generate-article to create content, then mark articles as ready in Content Studio."
   - Stop.

4. If the user provided an article name, find the matching article from the list (fuzzy match on title). If no match, show the available ready articles and ask.

5. If no specific article was requested, show all ready articles:
   - Title, quality score, date created
   - Ask: "Publish all X articles, or pick specific ones?"

### Phase 2: Get Article Content

6. For each article to publish, run `xseek articles get <website> <articleId> --format json` to get the full content.

7. For each article, display:
   - Title
   - Quality score
   - Word count (count from contentMarkdown)
   - Meta description
   - A preview of the first 200 characters

8. Ask the user to confirm: "Ready to publish these X articles?"

### Phase 3: Publish

9. For each article, the user needs to provide the published URL. Ask: "Where will this article be published? Enter the full URL (e.g. https://yourblog.com/blog/article-slug)"

   - If the user provides a base URL pattern (e.g. "https://myblog.com/blog/"), auto-generate URLs from the article slug
   - If the user says "same pattern" or similar, reuse the pattern from the previous article

10. The publishing process depends on the user's setup:
    - If the user has a CMS with an API (WordPress, Ghost, etc.), help them publish directly using web fetch or available tools
    - If the user publishes manually, output the full markdown content for each article so they can copy-paste
    - If the user uses a static site generator (Next.js, Hugo, etc.), save the markdown files to the right directory

11. After each article is published (or the user confirms it's live), update xSeek:

```sh
xseek articles update <website> <articleId> --status published
```

And set the published URL:

```sh
xseek articles publish <website> <articleId> <published-url>
```

### Phase 4: Confirm

12. After all articles are processed, show a summary:

```
Published Articles Summary
──────────────────────────────────
  ✓ "Why Attio Is the Best CRM" → https://blog.attio.com/best-crm-2026
  ✓ "10 Salesforce Alternatives" → https://blog.attio.com/salesforce-alternatives
  ✗ "AI CRMs Changing B2B" — skipped (user chose not to publish)

2 of 3 articles published.
```

13. Remind the user: "Published articles will now appear in Page Analytics. Check back in a few days to see AI citation and search performance data."
