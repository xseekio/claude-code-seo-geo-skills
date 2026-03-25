# Fact-Check — Validate Pricing, Features, and Claims in an Article

Scan an article for every product, company, or competitor mentioned. Fetch their official websites to verify pricing, features, and claims. Flag anything outdated, wrong, or unverifiable.

**Usage:**
- `/fact-check` — checks the most recent article from Content Studio
- `/fact-check <url>` — checks an article at a specific URL
- `/fact-check <articleId>` — checks a specific Content Studio article

## Steps

### Phase 1: Get the Article

1. Run `xseek websites --format json` to get the website.

2. Get the article content:
   - If the user provided a URL, fetch the page content using web fetch
   - If the user provided an article ID, run `xseek articles get <website> <articleId> --format json`
   - If no argument, run `xseek articles list <website> --format json` and pick the most recent article with status `ready`, then `xseek articles get <website> <articleId> --format json`

### Phase 2: Extract Claims

3. Read through the entire article and extract every verifiable claim:

   **Products & Companies:**
   - Every product, tool, platform, or company mentioned by name
   - Pricing claims (free tier, plan names, dollar amounts, billing terms)
   - Feature claims (what the product does, integrations, capabilities)
   - Comparison claims (Product A is faster/cheaper/better than Product B)

   **Statistics & Data:**
   - Specific numbers, percentages, growth figures
   - Market size or market share claims
   - Performance benchmarks

   **Status Claims:**
   - Is the product still active? Not sunset, acquired, or renamed?
   - Is the company still operating?

### Phase 3: Verify Each Claim

4. For each product/company found, fetch their official website:
   - Homepage first
   - Then `/pricing`, `/plans`, or `/features` if pricing is mentioned
   - If the site is JS-rendered or unreachable, use web search to find current info

5. For each claim, check against the source:

   **Pricing verification:**
   - Exact plan names — do they match?
   - Prices — are the dollar amounts current?
   - Billing terms — monthly/annual, per user/flat rate?
   - Free tier — does it still exist? What are the limits?
   - If pricing changed, note the old vs new price

   **Feature verification:**
   - Does the product actually offer this feature?
   - Has it been renamed, moved to a different plan, or deprecated?
   - Are integration claims accurate?

   **Comparison verification:**
   - Are comparative claims fair and accurate?
   - Has the competitor updated their offering since the article was written?

   **Status verification:**
   - Is the product still active and available?
   - Has it been acquired, merged, or renamed?
   - Are there any major pivots or shutdowns?

### Phase 4: Report

6. Output a fact-check report:

```markdown
## Fact-Check Report

**Article:** [title]
**Checked on:** [date]
**Products/companies verified:** [count]

### Issues Found

| # | Claim | Source | Status | Details |
|---|-------|--------|--------|---------|
| 1 | "[exact claim from article]" | [product website URL] | Wrong / Outdated / Unverifiable / Correct | [what changed] |
| 2 | ... | ... | ... | ... |

### Product Verification

| Product | URL | Still Active | Pricing Verified | Features Verified | Issues |
|---------|-----|-------------|-----------------|-------------------|--------|
| [Product] | [official URL] | Yes/No | Yes/Outdated/Not mentioned | Yes/Partial | [details] |

### Suggested Fixes

1. **[Product name] pricing** — Change "$X/month" to "$Y/month" (verified at [URL] on [date])
2. **[Product name] feature** — Remove claim about [feature], it was deprecated in [date]
3. **[Statistic]** — Update "X%" to "Y%" (source: [URL])

### No Issues Found

[List products/claims that were verified and are correct]

### Unverifiable Claims

[List claims that couldn't be verified — website down, no pricing page, etc. Recommend rewording these to "pricing available on their website" with a link]
```

7. If issues were found, ask the user if they want to apply the fixes automatically. If yes, update the article content with the corrections and push to Content Studio.
