# Schedule Content Batch — Monthly Article Pipeline From the Action Plan

Pull the highest-signal opportunities from the action plan and schedule them as one-off article-generation routines spread across the month, so a steady drip of drafts lands in Content Studio without anyone having to remember to invoke `/generate-article`.

**Designed to run on the 2nd of every month** as a recurring meta-routine — see "Monthly autopilot" below.

**Usage:** `/schedule-content-batch website="<id-or-domain>"` (defaults plan one month of content)

**Direct usage example:** `/schedule-content-batch website="xseek.io" count=4 cadence=weekly start=tomorrow`

## When to use

- Quarterly content planning — pick the top 12 opportunities and queue 1/week for 3 months
- After a content audit reveals a backlog of viable opportunities you want to ship without daily babysitting
- Onboarding a new website where you want to seed Content Studio without a person sitting at the keyboard

Skip this skill for: one-off articles (use `/generate-article` directly), refreshing an existing article (use `/rewrite-page`), or pages without a tracked opportunity (this skill schedules from the action plan only).

## Inputs

| Param | Default | Notes |
|---|---|---|
| `website` | required | Website ID (UUID) or registered domain. Same value `xseek opportunities` accepts. |
| `count` | `auto` | How many opportunities to schedule. **Default `auto` matches your actual backlog** (eligible un-served opportunities), capped by the plan's `maxArticlesPerMonth`. So 4 backlog items → 4 articles; 20 → 20; 50 → capped at quota. Pass an explicit number to override. |
| `cadence` | `auto` | **Default `auto` derives from `count` ÷ remaining business days** so the batch fills the month evenly: 4 articles → ~1/week (Tue), 12 → ~3/week (Mon/Wed/Fri), 22 → daily Mon–Fri. Pass `daily` / `2x-weekly` / `weekly` / `biweekly` to force a fixed rhythm. |
| `pace` | `auto` | Cadence multiplier for `auto` mode. `slow` halves the rate (good for review-heavy teams), `fast` doubles it (good for content sprints), `auto` uses the natural even-spread. |
| `start` | tomorrow | First scheduled run date, ISO 8601 (`2026-05-06`). |
| `time` | `09:00` | Local time for each routine (24h). Use a low-traffic window so the desktop app pickup doesn't fight peak load. |
| `status` | `draft` | Status to push the generated article as. **Default is `draft` — articles never auto-publish.** |
| `dry-run` | `false` | Preview the schedule without creating routines. Set to `true` when sanity-checking. |

## Monthly autopilot — the recommended setup

The whole point of this skill is to remove the "remember to plan content" task from a human's head. Set it up once, forget it, review drafts as they trickle in. The pattern: a single recurring meta-routine fires this skill on the 2nd of every month, which then queues that month's individual article-generation routines.

**Why the 2nd?** It gives a one-day buffer after month rollover so the freshly-recomputed opportunity scores from the cron job (which runs on the 1st) are stable when the batch picks from them. Running on the 1st sometimes catches the opportunity table mid-recompute and you queue stale rankings.

**One-time setup** (the user runs this once in Claude Code):

```
/schedule create
  name="xseek-content-pipeline-<website-slug>"
  cron="0 9 2 * *"
  prompt="/schedule-content-batch website=\"<websiteId>\" status=draft"
```

That cron expression (`0 9 2 * *`) reads as: 09:00 local time, on the 2nd of every month. After this is in place, every month on the 2nd at 9 AM the pipeline:

1. Fires `/schedule-content-batch` with the saved params.
2. The skill pulls fresh opportunities and counts them (defaults to whatever the backlog is, capped by the plan's monthly article quota).
3. The skill computes the cadence to fill the rest of the month evenly:
   - 4 backlog items → 1 per week (Tuesdays)
   - 12 backlog items → 3 per week (Mon/Wed/Fri)
   - 20+ backlog items → daily Mon–Fri
4. Creates that many child routines, spaced across remaining business days.
5. Each child routine fires `/generate-article` and a draft lands in Content Studio.
6. You review drafts on whatever cadence makes sense for your team.

The whole point of the auto defaults: if your backlog is small, you don't get spammed; if it's large, you don't lose value to a fixed weekly cap.

**To pace yourself if drafts pile up unreviewed:**
```
/schedule update xseek-content-pipeline-<website-slug>
  prompt="/schedule-content-batch website=\"<websiteId>\" pace=slow status=draft"
```
`slow` halves the auto-cadence (e.g., daily becomes 3x-weekly), giving you more review breathing room.

**To run a content sprint** (cap doubled):
```
/schedule update xseek-content-pipeline-<website-slug>
  prompt="/schedule-content-batch website=\"<websiteId>\" pace=fast status=draft"
```

**To force a fixed cadence** (e.g., always exactly weekly regardless of backlog):
```
/schedule update xseek-content-pipeline-<website-slug>
  prompt="/schedule-content-batch website=\"<websiteId>\" cadence=weekly count=4 status=draft"
```

**To pause autopilot for a month** (e.g., over the holidays):
```
/schedule disable xseek-content-pipeline-<website-slug>
```

**To kill the pipeline entirely**:
```
/schedule delete xseek-content-pipeline-<website-slug>
```
(Existing in-flight child routines for the current month still fire — cancel them via the batch manifest, see "Cancelling a batch" below.)

## Defaults that matter

- **Articles ship as `draft`.** A human reviews + promotes. Never schedule with `status=ready` or `status=published` — automation that publishes without review is how a brand voice gets diluted.
- **One per week (cadence=weekly), Tuesday morning.** Tuesdays are the highest-engagement publishing day for B2B per HubSpot's 2025 research; queueing on Tuesday means drafts are ready Wednesday for review and Thursday for publish.
- **Skip already-served opportunities.** The skill cross-references `xseek articles list` and excludes any opportunity that already has a linked article.
- **Sort by signal score then business value.** `signalScore.score` (descending), then `businessValue` rank (critical → high → medium → low). Lowest priority items don't get scheduled.

## Steps

1. **Resolve `count` (auto-scales to backlog).** If the user didn't pass `count`:
   - Pull the eligible opportunity backlog (after the filters in step 3).
   - Pull the plan quota: `xseek articles usage --format json` → `max - used` for the current period.
   - `count = min(eligibleBacklog, remainingQuota)`. So 4 fresh opportunities → 4 articles; 20 → 20; 50 with a quota of 25 → 25.
   - **Edge case:** if backlog is 0, abort with a friendly message ("No new opportunities to schedule. Run `/find-opportunities` first.").

2. **Resolve `cadence` (auto-spreads across the month).** If the user didn't pass `cadence`:
   - Compute `remainingBusinessDays` between `start` and the end of the month (Mon–Fri only, excluding holidays from a hardcoded NA/EU list).
   - `articlesPerDay = count / remainingBusinessDays`, rounded:
     - `≤ 0.25` → `weekly` (1 per week, on Tuesday)
     - `0.25–0.5` → `2x-weekly` (Tue/Thu)
     - `0.5–0.75` → `3x-weekly` (Mon/Wed/Fri)
     - `> 0.75` → `daily` (Mon–Fri)
   - Apply `pace` multiplier last: `slow` shifts down one tier, `fast` shifts up one tier.

3. **Validate.** Push back if the resolved `count > 50` — worth a human gut-check before queueing a quarter+ of work. Push back if `count > remainingQuota` (shouldn't happen given step 1, but belt-and-suspenders for explicit overrides). Push back if `cadence=daily` was forced AND `count > 30` — likely overshoots quota or budget.

2. **Pull opportunities and articles in parallel.** All `--format json`:
   ```sh
   xseek opportunities <website> --format json
   xseek articles list <website> --pageSize 200 --format json
   ```

3. **Filter and rank.**
   - Drop opportunities where `requiresUpgrade: true` (the org isn't on a plan that surfaces them).
   - Drop opportunities with no `id` (unpersisted).
   - Drop opportunities whose `id` already appears as `opportunityId` on any article. Linked = already served.
   - Drop opportunities tagged `archetype: 'technical_block'` — they need a robots.txt fix, not an article.
   - Sort: `signalScore.score` desc, then `businessValue` rank, then `frequency` desc as tiebreaker.
   - Take top `count`.

4. **Compute the schedule.** From `start` and `cadence`, produce N dates:
   - `daily` → start, start+1, start+2, ...
   - `2x-weekly` → next Tue, next Thu, next Tue, ...
   - `weekly` → start, start+7, start+14, ...
   - `biweekly` → start, start+14, start+28, ...
   Skip weekends for `daily` (no one reviews drafts on Saturday).

5. **Print the plan.** Always show the user the full schedule before creating routines:
   ```
   #   DATE         TIME    QUERY                                                  SCORE
   1   2026-05-06   09:00   "best aeo tools 2026"                                  6/6
   2   2026-05-13   09:00   "how to track ai citations"                            5/6
   3   2026-05-20   09:00   "perplexity vs chatgpt for marketing"                  5/6
   ...
   ```
   If `dry-run=true`, stop here.

6. **Create one routine per opportunity** via the `schedule` skill (Claude Code's built-in routine manager). For each entry:
   ```
   /schedule create
     name="xseek-content-<slug-of-query>"
     when="<ISO date> <time>"
     repeat=once
     prompt="/generate-article query=\"<opp.query>\" websiteId=\"<websiteId>\" opportunityId=\"<opp.id>\""
   ```
   Note the prompt the routine fires is `/generate-article` — that skill already pushes as `draft` per our writing rules. The default surface area is preserved.

7. **Save the schedule manifest.** Append a `schedule-manifest.md` to `~/.xseek/content-batches/<batch-id>/` with the full list, routine IDs, and the original input params. Lets the user audit / cancel later.

8. **Print final summary** with batch ID, total routines created, date range, and the `xseek schedule list` command for inspection.

## Cancelling a batch

If priorities shift:
- `xseek schedule list` (or `/schedule list`) — find batch routines (named `xseek-content-*`)
- `/schedule delete <routine-id>` per routine, or
- Delete the batch manifest folder under `~/.xseek/content-batches/<batch-id>/` — this skill's companion `cancel-content-batch` (future) reads the manifest to bulk-cancel.

## Failure modes to flag

- **Article quota will run out.** If `count > monthly_quota`, warn before scheduling — later routines will hit `atLimit` and fail silently. Compute monthly_quota from `xseek articles usage`.
- **Same opportunity twice.** Dedup by `opportunityId` even if a query string repeats across persisted opportunities. Article PATCH upserts by slug; double-scheduling clobbers drafts.
- **Routine not picked up.** The `/schedule` skill fires the prompt in a remote agent context — confirm via `/schedule list` after creation that the routine is `enabled: true`. If a manifest entry exists but no live routine, mark the batch as partial in the summary.
- **Holidays.** This skill doesn't honor holidays. If you queue across a vacation week, drafts pile up unreviewed. Mention this in the summary if any scheduled date falls on a known statutory holiday (Dec 25, Jan 1, etc.).
- **Brand context churn.** If brand voice changes mid-batch, later articles reflect the new voice while earlier ones reflect the old. That's usually fine — `/generate-article` always re-fetches `xseek brand-context --format markdown` at run time.

## Why this skill exists

Generating one article at a time is the right unit of work — quality stays high, every draft is intentional. But content velocity matters too: shipping 1 strong article per week beats shipping 10 in one day and zero for the next month. This skill bridges those two truths by scheduling thoughtful single generations across a month instead of batching them into a single rushed session.

It's also the only safe place in the SEO/GEO skill set to use the `schedule` skill — every other skill is interactive (you tell it what to do, it does it once). This one is "set up the queue and walk away."

## Related skills

- `/generate-article` — what each routine fires.
- `/find-opportunities` — discover what to queue. Run before this skill if your action plan looks empty.
- `/publish-articles` — what you run after drafts have been reviewed.
- `/schedule` — Claude Code's built-in routine manager. This skill orchestrates calls to it.
