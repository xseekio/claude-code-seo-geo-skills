# Add Keywords — Enrich an Article with SEO Keywords

Take an existing article (from Content Studio or a URL) and enrich it with relevant SEO keywords using real Google search data. Keywords are woven naturally into headings, body text, and FAQ sections without changing the article's meaning or tone.

**Usage:**
- `/add-keywords` — picks the most recent article from Content Studio
- `/add-keywords <url>` — enriches an article at a specific URL
- `/add-keywords <articleId>` — enriches a specific Content Studio article

## Steps

### Phase 1: Get the Article

1. Run `xseek websites --format json` to get the website.

2. Get the article content:
   - If the user provided a URL, fetch the page content using web fetch
   - If the user provided an article ID, run `xseek articles get <website> <articleId> --format json`
   - If no argument, run `xseek articles list <website> --format json` and pick the most recent article with status `ready`, then `xseek articles get <website> <articleId> --format json`

3. Identify the article's primary topic from the title and first paragraph.

### Phase 2: Research Keywords

4. Run keyword research for the article's topic:

```sh
xseek keywords <website> "<article primary topic>" --format json
```

5. From the results, build a keyword target list:
   - **Primary keyword**: highest volume, reasonable KD (< 60 if possible)
   - **Secondary keywords**: 5-10 related keywords sorted by volume
   - **Long-tail keywords**: 3-5 lower-volume, lower-KD keywords for FAQ and subsections
   - Skip keywords already present in the article (check exact and close matches)

6. Present the keyword plan to the user:
   - Primary keyword + volume + KD
   - Secondary keywords to add
   - Long-tail keywords for FAQ
   - Ask for confirmation before modifying the article

### Phase 3: Add Keywords

7. Modify the article to incorporate the keywords naturally:

**Where to add keywords:**
- **H1 title**: Include the primary keyword if it fits naturally (don't force it)
- **H2/H3 headings**: Use secondary keywords as heading text where they match the section topic
- **First paragraph**: Ensure the primary keyword appears in the opening 2-3 sentences
- **Body text**: Weave secondary keywords into existing paragraphs — rephrase sentences to include them, don't just append
- **FAQ section**: Add or update FAQ questions using long-tail keywords as the question stems
- **Meta description**: Include the primary keyword

**Rules:**
- Never keyword-stuff — each keyword should appear 1-3 times max
- Maintain the article's existing tone and voice
- Don't change the article's meaning or structure significantly
- Rephrase existing sentences to include keywords rather than adding new filler sentences
- If a keyword doesn't fit naturally anywhere, skip it
- Keep paragraphs short (2-3 sentences max)
- Every keyword insertion should read naturally to a human

### Phase 4: Output

8. Output the enriched article in clean markdown.

9. At the end, include a **Keywords Added** summary:

```markdown
## Keywords Added

| Keyword | Volume/mo | KD | Added To |
|---------|-----------|-----|----------|
| [primary keyword] | [volume] | [KD] | H1, first paragraph, body |
| [secondary keyword] | [volume] | [KD] | H2 heading, paragraph 3 |
| [long-tail keyword] | [volume] | [KD] | FAQ #2 |

**Primary keyword density:** X mentions
**Total keywords added:** X new keywords woven into the article
**Keywords skipped:** [list of keywords that didn't fit naturally]
```

10. If the article came from Content Studio, push the updated version:

```sh
xseek articles push <website> --title "<article title>" --file /tmp/enriched-article.md --format json
```

Or if updating an existing article via the API, use PATCH.
