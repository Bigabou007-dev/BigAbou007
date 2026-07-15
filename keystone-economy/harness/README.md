# Keystone Load-Test Harness (plan)
> This is Business Idea #4 — your proprietary quality weapon. It runs entirely on the VPS, no gaming client needed, and it produces the benchmark numbers that become Keystone's marketing ("stable at 128 players, sub-0.5ms").

## Goal
Prove — with numbers competitors don't publish — that the economy engine holds up under real concurrency:
- per-resource CPU time (`resmon` ms) under N concurrent players
- server tick / scheduler health
- DB flush latency + zero lost writes under load
- **zero dupes** across a storm of concurrent buy/sell trades

## Approach
1. **Synthetic players** — inject bot "player units" server-side so no real GTA clients are needed.
   - Baseline tool: [FiveBoosts / Fivem-Fake-Players](https://github.com/FiveboostsDotNet/Fivem-Fake-Players) (open-source bridge; the simulation backend is a licensed service — verify terms/price before relying on it).
   - Or roll our own: spawn server-side peds + drive synthetic trade events (see `trade-storm.lua` plan below).
2. **Trade-storm generator** — a dev-only resource that fires K concurrent `keystone:requestTrade` events/sec across random commodities and asserts:
   - every trade is atomic (no negative balances, no item/money created or destroyed)
   - `SUM(ledger)` reconciles against net supply/demand deltas (dupe detector)
3. **Metrics capture** — poll `GetResourceKvpFloat`/`PerformanceHttp`/`resmon` output on an interval, write CSV, chart it.
4. **Regression gate** — CI step that fails the build if p95 trade latency or resmon ms regresses beyond a threshold.

## Next build step
- `trade-storm.lua` — the concurrent trade generator + reconciliation assertions
- `metrics.lua` — resmon/tick sampler → CSV
- a tiny plotting script (runs on the VPS) → benchmark PNGs for showcase pages

Nothing here needs a GPU or GTA client — it's pure server load. That's the whole point.
