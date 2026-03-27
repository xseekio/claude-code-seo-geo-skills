# Apply Comments — Review and Apply Comments on Articles

Fetch unresolved comments on an article, apply the requested changes to the content, and resolve the comments.

**Usage:**
- `/apply-comments` — picks the article with the most unresolved comments
- `/apply-comments <articleId>` — applies comments on a specific article

## Steps

### Phase 1: Find Articles with Comments

1. Run `xseek websites --format json` to get the website.

2. Run `xseek articles list <website> --format json` to get all articles.

3. For each article (or the specified one), run `xseek articles comments <website> <articleId> --format json` to get comments.

4. If no argument was provided, pick the article with the most unresolved comments. If no articles have unresolved comments, tell the user.

5. Show the user:
   - Article title
   - Number of unresolved comments
   - List each comment: the selected text + the comment

6. Ask the user: "Apply all comments, or pick specific ones?"

### Phase 2: Get Article Content

7. Run `xseek articles get <website> <articleId> --format json` to get the full markdown content.

### Phase 3: Apply Comments

8. For each unresolved comment:
   - Find the `selectedText` in the article markdown
   - Read the `comment` — understand what change is requested
   - Apply the change to the markdown content
   - If the comment is vague (e.g. "this needs work"), use your judgment to improve the section
   - If the comment contradicts another comment, ask the user

9. After applying all changes, show the user a diff summary:
   - Each comment → what was changed
   - Ask for confirmation before pushing

### Phase 4: Push and Resolve

10. Push the updated article:

```sh
xseek articles update <website> <articleId> --file /tmp/updated-article.md --format json
```

11. Resolve each applied comment:

```sh
xseek articles comments <website> <articleId> --resolve <commentId>
```

12. Show a summary:

```
Comments Applied
────────────────────────────
  ✓ "Add a statistic here" — added DataForSEO market size stat
  ✓ "Too vague, be specific" — rewrote with concrete example
  ✓ "Wrong pricing for Competitor X" — updated to $49/mo (verified)
  ✗ "Consider removing this section" — skipped (user chose to keep)

3 of 4 comments applied and resolved.
```
