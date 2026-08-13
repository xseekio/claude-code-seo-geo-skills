<!-- Generated from the xSeek app repo (skills/). Do not edit here: changes are overwritten on the next publish. -->

# Screenshots: capturing landing pages and embedding them

Reference material for `/generate-article` and `/rewrite-page`. These are the
only screenshot rules. If another skill tells you something different about
capturing pages, this file wins and the other skill is out of date.

## How to capture: one API call, no browser

xSeek captures the page server-side. You POST a URL, you get back a hosted image
URL ready to embed. This works identically on a laptop and inside the hosted
article agent, which has no browser and never will.

```sh
# Env var first (the hosted agent sets XSEEK_API_KEY and has no config file),
# then ~/.xseek/config (a laptop that ran `xseek login`).
API_KEY="${XSEEK_API_KEY:-$(grep api_key ~/.xseek/config 2>/dev/null | sed 's/.*"\(.*\)".*/\1/')}"
if [ -z "$API_KEY" ]; then
  echo "no xSeek API key available; skipping all screenshots" >&2
fi

curl -s -X POST "https://www.xseek.io/api/v1/websites/<websiteId>/images" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
        "url": "<brand-landing-url>",
        "alt": "<Brand name> homepage",
        "source": "competitor-screenshot"
      }' \
  | jq -r '.data.url'
```

Returns `{ data: { url, ... } }`. Embed `data.url` exactly as returned. It is a
`www.xseek.io/images/...` URL.

Optional fields: `"fullPage": true` for a whole-page capture (rarely right
inline), and `"delaySeconds": 5` when a hero animates in late.

A failed capture returns HTTP 502 with `{ "captured": false }`. That is not an
error you retry forever: capture once, retry once at most with `delaySeconds`,
then record the skip and keep writing.

**An empty key is not a failed capture.** If `API_KEY` is empty the endpoint
returns 401 for every brand, and the "capture failed, keep writing" rule would
quietly turn one auth problem into a page full of legitimate-looking skips. If
you get a 401, stop capturing, record `skipReason: "no API key"` on every named
brand, and say so in your final output. Do not report the article as complete
with silent skips.

**Never launch a browser.** No `/Applications/Google Chrome.app/...`, no
`--headless`, no Playwright, no Puppeteer, no `magick` post-processing. Those
instructions used to be in these skills. They only ever worked on one laptop,
there is no browser and no ImageMagick in the hosted agent, and every article
generated there silently landed with zero images. The API is the only path.

**Never rewrite the host.** Do not extract the underlying blob URL, do not
hotlink the brand's own CDN asset, do not swap in an image found on the page.
Only a `www.xseek.io/images/...` URL counts as a capture: it is the only URL
whose lifetime we control, so it is the only one that will still resolve in a
year.

## When to capture: the coverage contract

**Count first, then capture.** Before writing the visual pass, list every brand,
product, or company the article names as an entry: a numbered listicle item, a
column in a comparison, a named section heading. That list is N.

**Attempt a capture for all N. Not "most", not "the important ones", all of
them.** Then report the result for all N (see Reporting below).

This is the rule the previous version of these instructions got wrong. It put
"every listed product gets a screenshot" underneath a heading that said "use
judgment, don't force it", and the judgment swallowed the rule. Two entries
illustrated out of six looks identical to six out of six in the finished
markdown, which is why the count and the report below are not optional.

Also capture, outside the count:

- Both products' hero sections in a side-by-side comparison.
- The subject of a "what does X look like" FAQ answer.
- The client's own hero or product page, the first time a self-referential
  article names them.

### The only reasons to skip

A skip is legitimate when, and only when:

1. **The brand has no public landing page** (private SaaS, internal tool, a
   product sold only through a reseller).
2. **The capture came back unusable** and a retry did not fix it (see below).
3. **The brand brief forbids naming competitors** (typical B2C and marketplace
   clients). Then you are not naming them at all, so there is nothing to
   capture, and the count N is zero.
4. **The article is a strategic essay or opinion piece** with no product entries.

Article length is not a reason. Mobile readers are not a reason. Bandwidth is
not a reason. Those were escape hatches in the old instructions that applied to
every listicle ever written, which is how they came to apply to all of them.

## Quality: a 200 does not mean a usable image

Captures come back valid, correctly sized, and still ruined. One capture of a
customer's marketing site returned a clean 57 KB JPEG with "confirm you're not a
bot" printed across the H1.

Check what came back before you embed it. If you can view the image, view it. If
you cannot, treat these as unusable and skip rather than embed:

- The response was not 201, or `data.url` is missing.
- A cookie wall, consent banner, captcha, or anti-bot overlay covers the hero.
- An error page, a login wall, or a half-painted layout.

One retry with `"delaySeconds": 5` is worth it for a half-painted capture. It is
not worth it for a captcha, which will still be there.

**A missing image costs nothing. A customer's own site shown defaced costs their
trust.** When in doubt, skip and record the reason.

## Alt text

Say what the image actually is. A homepage capture is "Stripe homepage", not
"Stripe's payment dashboard showing real-time revenue". You captured a landing
page, so describe a landing page. Alt text that describes something the image
does not show is a false claim in the accessibility layer, and it becomes the
image filename in the URL we serve.

## Embedding

Place the image directly under the heading for that entry, before the prose:

```markdown
## 1. Stripe

![Stripe homepage](https://www.xseek.io/images/abc-123/stripe-homepage.jpg)

Stripe is the payments infrastructure...
```

One capture per brand you actually name as an entry. Do not illustrate brands
the article only mentions in passing.

## Product images (B2C, own-catalog articles)

When the brand brief has a `## Products to recommend` section, the article
recommends the client's OWN products by name. Those get a picture of the
product, not a capture of the page it sits on.

The ladder, in order. Stop at the first rung that produces an image.

**1. The catalog image.** `xseek products <website> --<field> <value>` prints an
`image:` line under any product that has one. That URL is the photo the client
chose for their own catalog, already framed and already theirs. Embed it
directly. Do not route it through the images API: it is their CDN, their asset,
and copying it would just make a stale duplicate.

```markdown
### [Chalet Le Bouleau](https://client.com/chalets/le-bouleau)

![Chalet Le Bouleau](https://client-cdn.com/photos/bouleau-01.jpg)
```

**2. The page's own product image.** No `image:` line means the catalog has no
photo for that row. Ask the API to pull one from the product page:

```sh
curl -s -X POST "https://www.xseek.io/api/v1/websites/<websiteId>/images" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "url": "<product-page-url>", "mode": "product", "alt": "<Product name>" }' \
  | jq -r '.data.url'
```

`mode: "product"` reads the page's JSON-LD `Product.image` first, then
`og:image` / `twitter:image`, validates that what comes back is really an image
(right content type, big enough to not be a tracking pixel or a sprite), and
only then stores it. If none of that works it falls back to a screenshot of the
page automatically, so one call covers rungs 2 and 3.

**3. A screenshot**, which the same call already did for you.

**Why the order.** A B2C product page captured at 1440x900 is mostly navigation,
cookie bar and footer, with the product itself a thumbnail somewhere in the
middle. The merchant's own photo is the thing the reader wants to see. The
capture is the floor, not the default.

**Verify before you embed.** `mode: "product"` validates the bytes, not the
meaning. A site with no per-product metadata often returns the same site-wide
og:image for every page, so six products come back with six copies of the
company logo. If several products resolve to the same URL, that is what
happened: use the screenshot for those instead, or skip the image and say so.

Report product images in `visuals` exactly like brand captures: one row per
product you name, with `skipReason` on the ones with no usable image.

## Reporting: send the coverage record

When you push the article, include a `visuals` array with **one entry per named
brand, including every brand you did not capture**. Send it on the same POST or
PATCH that carries the content.

```json
{
  "title": "...",
  "contentMarkdown": "...",
  "visuals": [
    { "name": "xSeek",    "url": "https://www.xseek.io",   "screenshot": "https://www.xseek.io/images/4646.../xseek-homepage.jpg" },
    { "name": "AthenaHQ", "url": "https://athenahq.ai",    "screenshot": "https://www.xseek.io/images/e1b8.../athenahq-homepage.jpg" },
    { "name": "Profound", "url": "https://tryprofound.com", "screenshot": null, "skipReason": "capture returned 502 twice" },
    { "name": "Peec AI",  "url": "https://peec.ai",        "screenshot": null, "skipReason": "captcha covering the hero" }
  ]
}
```

The response echoes `data.visualCoverage` as `{ named, captured, missing, rate }`.
Read it. If `named` is lower than the number of entries in your article, you
under-reported: send the missing rows in a PATCH before you report done.

The rows with `screenshot: null` are the point of this payload. Without them,
an article with two captures and six entries is indistinguishable from one where
four captures legitimately failed, and nobody can tell whether the rule is
working or being ignored. A recorded skip is a complete answer. A silent one is
not.

Only `www.xseek.io/images/...` URLs are stored as captures. Anything else is
recorded as missing, with the value kept as the reason.
