# YouTube Thumbnail — xSeek Branded 1280×720

Generate a polished YouTube thumbnail for an xSeek video using the "tech chaleureuse" brand system. Output is an HTML file the user opens in a browser and screenshots — no image binaries, no external service. Predictable, version-controlled, and on-brand.

**Usage:** `/youtube-thumbnail title="If AI doesn't mention you, [you don't exist.]" eyebrow="Why your traffic keeps dropping"`

## When to use

- New YouTube video promo (homepage hero embed, organic discovery, ads)
- Refreshing an existing thumbnail because metrics dropped
- Producing thumbnail variants for A/B testing (copy stays the same, headline angle changes)

Skip this skill for: in-app images, social-card OG images (different dimensions and brand surface — those use the existing `/og/` PNGs).

## Inputs

| Param | Required | Notes |
|---|---|---|
| `title` | yes | Two-line headline. Wrap the **highlighted phrase in `[ ]`** — it goes in the blue square. Example: `"Stop guessing. [Get cited by AI.]"` |
| `eyebrow` | yes | Tiny mono pill, top-right. Pain-first hook. Example: `"Why your traffic keeps dropping"` |
| `kicker` | optional | Mono uppercase line above headline with `→` arrow. Defaults to `"The new rule of search"` |
| `slug` | optional | Filename slug. Defaults to a slug derived from the title. |
| `output` | optional | Output path. Defaults to `~/Downloads/xseek_youtube_thumbnail_<slug>.html` |

## Title rules — Roxane voice

The thumbnail title is the most expensive copy in the entire xSeek funnel. It runs in YouTube's feed against everything. Write it like Roxane (xSeek's strategic direction):

**Do:**
- Speak directly to the viewer ("you")
- Lead with pain or a punch line
- Be falsifiable / concrete
- Match one of the 5 key messages from `business/MESSAGING.md` and `CLAUDE.md`:
  1. *"Si les AI ne parlent pas de toi, tu n'existes pas. Point."*
  2. *"Le search a changé. On ne clique plus, on demande aux AI."*
  3. *"La visibilité dans les AI, c'est maintenant."*
  4. *"Comprendre ne suffit pas. Il faut passer à l'acte."*
  5. *"Tu n'as pas besoin d'être un expert technique."*

**Don't:**
- Write descriptive / journalistic headlines (`"The New Search Reality"`, `"How AI Changed SEO"`)
- Use third-person or observational tone
- Repeat what's already in the eyebrow
- Use `font-serif` or `italic`
- Use jargon (AEO, GEO, SEO acronyms in the title — the eyebrow can take them)

**Tested working titles for xSeek:**
- *"If AI doesn't mention you, [you don't exist.]"* — pain-first, brutal, scroll-stopping
- *"Stop guessing. [Get cited by AI.]"* — brand punch line, on-site embed
- *"Your customers stopped Googling."* — concrete, opens curiosity loop
- *"AI is your new homepage."* — strong frame, short

## Brand tokens (must use exactly)

| Token | Value | Where |
|---|---|---|
| `--bg-warm` | `#F5F1EA` | Thumbnail background (the canvas itself) |
| `--ink` | `#1C1F2A` | Body text, default headline color |
| `--ink-3` | `#6b7080` | Muted text (eyebrow text color) |
| `--ch-accent` | `#2F5BFF` | Blue square highlight, kicker, eyebrow dot, decorative glow |
| Outer page | `#ffffff` | Surrounding white so the screenshot boundary is obvious |

Fonts:
- `Inter` for body + headline
- `JetBrains Mono` for eyebrow + kicker + AI engine pills

## Layout (1280×720)

```
┌─────────────────────────────────────────────────────────────┐
│  [xSeek logo, ~170px tall]              [• EYEBROW PILL]   │
│                                                             │
│                                                             │
│  → THE NEW RULE OF SEARCH                                  │
│  If AI doesn't mention you,                                 │
│  ┌──────────────────────────┐                               │
│  │  you don't exist.        │  ← blue square highlight     │
│  └──────────────────────────┘                               │
│                                                             │
│  [ChatGPT] [Perplexity] [Gemini] [Claude]                  │
└─────────────────────────────────────────────────────────────┘
                                            ░░ blue glow ░░
```

Concrete rules:
- Outer body padding 40px, white background, soft shadow on the thumb so the 1280×720 boundary is obvious for screenshotting.
- `.thumb` is `position: relative; padding: 56px 64px;` flex column, space-between.
- Logo: `<img src="file:///Users/marcolivierbouch/projects/aiseotracker/public/xseek_logo.png" height="170">`. **Always use the real PNG, never a CSS-generated mark.**
- Eyebrow pill: white bg, 1px ink-10% border, rounded-full, mono uppercase 12px, 0.10em tracking, ink-3 text, brand-blue dot with 4px halo.
- Kicker: mono uppercase 14px, 0.12em tracking, brand-blue, with a short right-arrow SVG.
- Headline `<h1>`: 80px, font-weight 600, line-height 1.02, letter-spacing -0.035em. **The full first phrase must fit on one line.** Drop font-size before splitting it across two visual lines. Test in the browser.
- Blue square: `background: #2F5BFF; color: #fff; padding: 0.06em 0.14em 0.22em; border-radius: 12px; line-height: 1; display: inline-block;` — extra bottom padding wraps the y/g descenders cleanly.
- AI engine pills: white bg, 1px ink-08% border, real SVG logos from `/logos/` at 16px. Anthropic logo needs `filter: invert(1)` only on dark backgrounds (not here).
- Soft blue radial glow bottom-right (`opacity 0.20`, 640px) + subtle dot grain (`24px` repeat at 6% ink) so the beige doesn't read as flat.

## Steps

1. **Validate the title.** If it doesn't pass the Roxane rules above, push back before generating: explain which rule fails and propose 2–3 alternates. Don't just ship a weak title.

2. **Slug the filename.** From the title, strip punctuation, lowercase, hyphenate. Cap at 60 chars. Example: `"If AI doesn't mention you, [you don't exist.]"` → `if-ai-doesnt-mention-you-you-dont-exist`.

3. **Write the HTML** to `~/Downloads/xseek_youtube_thumbnail_<slug>.html` using the template at the bottom of this skill. Substitute `{TITLE_BEFORE_HIGHLIGHT}`, `{TITLE_HIGHLIGHT}`, `{EYEBROW}`, `{KICKER}`.

4. **Open the file** in the user's default browser:
   ```sh
   open ~/Downloads/xseek_youtube_thumbnail_<slug>.html
   ```

5. **Verify the layout** — tell the user how to inspect it visually:
   - The first line of the headline (before the blue square) must fit on **one line**. If it wraps, drop the font-size by 8–12px and re-render.
   - The blue square must wrap any descenders (y, g, p, q) cleanly.
   - AI engine pill logos must all render — if any are missing, check the `file://` paths.

6. **Export at 4K (3840×2160)** — YouTube's recommended thumbnail resolution. Cmd+Shift+4 produces blurry, downsized output; do not rely on it. Always render via headless Chrome at `--force-device-scale-factor=3` and crop the white frame:

   ```sh
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
     --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
     --window-size=1360,800 \
     --force-device-scale-factor=3 \
     --screenshot=/Users/<user>/Downloads/xseek_youtube_thumbnail_<slug>_3x.png \
     "file:///Users/<user>/Downloads/xseek_youtube_thumbnail_<slug>.html"

   magick /Users/<user>/Downloads/xseek_youtube_thumbnail_<slug>_3x.png \
     -crop 3840x2160+120+120 +repage \
     -quality 92 -strip -interlace Plane \
     -sampling-factor 4:4:4 \
     /Users/<user>/Downloads/xseek_youtube_thumbnail_<slug>.jpg
   ```

   Notes on the flags:
   - `--force-device-scale-factor=3` paints at retina 3x → cropping `120 = 40 * 3` removes the outer white padding cleanly.
   - `-sampling-factor 4:4:4` keeps full chroma so the solid blue highlight square doesn't get fringed JPG artifacts (default 4:2:0 destroys saturated edges).
   - `-quality 92 -strip -interlace Plane` → ~300–500KB at 4K, well under YouTube's 2MB mobile cap (50MB desktop cap).

   YouTube's best-practice spec (April 2026):
   - Resolution: 3840×2160, 16:9, min width 640px
   - Format: JPG / PNG / GIF
   - Size: ≤2MB on mobile uploads, ≤50MB on desktop
   - For podcast playlists use 1:1 instead — different layout, not handled by this skill.

## Failure modes to watch for

- **Logo path wrong on different machines.** The template hardcodes `file:///Users/marcolivierbouch/...`. Adapt to the current `$HOME` if running for a different user.
- **First headline line wraps.** Always reduce font-size before splitting. Two-line layout (regular + blue square) is the canonical shape.
- **AI engine logos break.** Some Claude Code sandboxes block `file://` SVG imports. Fall back to inline SVGs from `aiseotracker/public/logos/` if the browser shows broken images.
- **Title carries an em-dash or curly quote** that breaks the visual rhythm. Strip to plain ASCII inside the blue square.
- **Color print disabled.** Tell the user to enable "Background graphics" in print dialog if they're saving as PDF, or the beige + ink + blue won't render.

## Template — full HTML

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>xSeek — {TITLE_PLAIN}</title>
<style>
  @page { size: 1280px 720px; margin: 0; }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  html { width: 100%; min-height: 100%; }
  body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    background: #ffffff;
    color: #1C1F2A;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px;
  }
  .thumb {
    position: relative;
    width: 1280px;
    height: 720px;
    padding: 56px 64px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    overflow: hidden;
    background: #F5F1EA;
    box-shadow: 0 0 0 1px rgba(28,31,42,0.08), 0 30px 80px -40px rgba(28,31,42,0.18);
    flex-shrink: 0;
  }
  .glow {
    position: absolute; right: -160px; bottom: -180px;
    width: 640px; height: 640px; border-radius: 50%;
    background: radial-gradient(circle, rgba(47,91,255,0.20) 0%, transparent 60%);
    pointer-events: none;
  }
  .grain {
    position: absolute; inset: 0; opacity: 0.35; pointer-events: none;
    background-image: radial-gradient(rgba(28,31,42,0.06) 1px, transparent 1px);
    background-size: 24px 24px;
  }
  .row-top { display: flex; justify-content: space-between; align-items: center; position: relative; z-index: 2; }
  .brand img { height: 170px; width: auto; display: block; }
  .eyebrow-pill {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 9px 14px; background: #fff;
    border: 1px solid rgba(28,31,42,0.10); border-radius: 999px;
    font-family: 'JetBrains Mono', ui-monospace, monospace;
    font-size: 12px; text-transform: uppercase; letter-spacing: 0.10em; color: #6b7080;
  }
  .eyebrow-pill .dot {
    width: 8px; height: 8px; border-radius: 50%;
    background: #2F5BFF; box-shadow: 0 0 0 4px rgba(47,91,255,0.15);
  }
  .headline-block { position: relative; z-index: 2; }
  .kicker {
    display: inline-flex; align-items: center; gap: 10px;
    font-family: 'JetBrains Mono', ui-monospace, monospace;
    font-size: 14px; letter-spacing: 0.12em; text-transform: uppercase;
    color: #2F5BFF; font-weight: 600; margin-bottom: 22px;
  }
  .kicker svg { width: 16px; height: 16px; }
  h1 {
    font-size: 80px; line-height: 1.02; font-weight: 600;
    letter-spacing: -0.035em; margin: 0; max-width: 1180px;
  }
  h1 .accent {
    background: #2F5BFF; color: #fff;
    padding: 0.06em 0.14em 0.22em; border-radius: 12px;
    display: inline-block; line-height: 1;
  }
  .row-bottom { display: flex; justify-content: space-between; align-items: flex-end; position: relative; z-index: 2; }
  .engines {
    display: flex; align-items: center; gap: 14px;
    font-family: 'JetBrains Mono', ui-monospace, monospace;
    font-size: 13px; color: #3a3f4d; letter-spacing: -0.005em;
  }
  .engine {
    display: inline-flex; align-items: center; gap: 7px;
    padding: 7px 12px; border-radius: 8px;
    background: #fff; border: 1px solid rgba(28,31,42,0.08);
  }
  .engine img { width: 16px; height: 16px; }
</style>
</head>
<body>
<div class="thumb">
  <div class="glow"></div>
  <div class="grain"></div>
  <div class="row-top">
    <div class="brand">
      <img src="file:///Users/marcolivierbouch/projects/aiseotracker/public/xseek_logo.png" alt="xSeek">
    </div>
    <div class="eyebrow-pill">
      <span class="dot"></span>
      {EYEBROW}
    </div>
  </div>
  <div class="headline-block">
    <div class="kicker">
      <svg viewBox="0 0 24 24" fill="none" stroke="#2F5BFF" stroke-width="2.5" stroke-linecap="round">
        <path d="M5 12h14M13 6l6 6-6 6"/>
      </svg>
      {KICKER}
    </div>
    <h1>
      {TITLE_BEFORE_HIGHLIGHT}<br/>
      <span class="accent">{TITLE_HIGHLIGHT}</span>
    </h1>
  </div>
  <div class="row-bottom">
    <div class="engines">
      <span class="engine"><img src="file:///Users/marcolivierbouch/projects/aiseotracker/public/logos/openai.svg" alt="">ChatGPT</span>
      <span class="engine"><img src="file:///Users/marcolivierbouch/projects/aiseotracker/public/logos/perplexity.svg" alt="">Perplexity</span>
      <span class="engine"><img src="file:///Users/marcolivierbouch/projects/aiseotracker/public/logos/gemini.svg" alt="">Gemini</span>
      <span class="engine"><img src="file:///Users/marcolivierbouch/projects/aiseotracker/public/logos/anthropic.svg" alt="">Claude</span>
    </div>
  </div>
</div>
</body>
</html>
```

## Variants worth supporting later (not now)

- **Dark variant** (charcoal background, beige + blue accents) — for organic YouTube discovery where a darker thumb stands out more in the feed. Same layout, swap `--bg-warm` background with `--ink`, invert text colors, add `filter: invert(1)` on the dark engine logos (Anthropic, xAI).
- **FR variant** — same layout, French copy. Title and eyebrow swap; kicker becomes `"La nouvelle règle du search"`; AI engine names stay (they're brands, not translatable).
- **Tall card** for Shorts/Reels (1080×1920) — different layout, single centered line, logo top-center, accent block dominates the canvas.
