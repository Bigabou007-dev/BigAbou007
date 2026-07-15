# CLAUDE.md — Keystone Economy Engine
> Grounding + doctrine for any AI agent (Claude Code / Fable / Cursor) working in this repo. Read this fully before writing code. It encodes non-negotiable invariants that keep the economy dupe-proof, performant, and balanced. Violating them is a bug even if it "works."

## What this project is
A server-authoritative, framework-agnostic **economy engine** for FiveM (GTA 5 / Cfx), and the **sensor** for an out-of-game economy-intelligence SaaS. It provides: dynamic supply/demand pricing, engineered money-sinks, a dupe-proof transaction ledger, and per-transaction telemetry. Other business/job/shop scripts plug into it via exports.

**Target stack:** Qbox (`qbx_core`) + the Overextended `ox` stack (`ox_lib`, `oxmysql`, `ox_inventory`, `ox_target`) first; ESX/QBCore via adapters. Lua 5.4 (`lua54 'yes'`). MariaDB via oxmysql.

## The doctrine (design philosophy — from EVE Online)
Design the economy as a **measured, closed system of flows**:
- **Every faucet is paired with a sink.** Money in must have a durable way out (tax, rent, repair, fuel, fees). No unbounded faucets.
- **Instrument everything from day one.** Every currency/item mutation emits a telemetry event. *You can't balance what you don't measure.*
- **Govern with negative feedback loops;** cap positive (rich-get-richer) loops.
- **Real price discovery** (supply/demand or order-matching), never static config prices as the primary market.
- **Never let money buy a shortcut around the core loop** (the Diablo III RMAH failure).
- **Police exploits, not player behavior** (laissez-faire — intervene only when code creates value from nothing).

## NON-NEGOTIABLE money-core invariants
These make the engine uncopyable by the "press E" crowd. Enforce them everywhere.

1. **Server-authoritative — never trust the client.** The client sends *intent* only (e.g. "buy 5 lettuce"). The server computes price, validates funds/inventory, and moves everything. Never accept a price, amount, or balance from the client. Never mutate money/items client-side. Use **OneSync + secured state bags** for synced state.
2. **Double-entry bookkeeping.** Every transfer debits one account and credits another. Money is **moved, never created or destroyed.** The sum of all balances + sinks must always reconcile. A mismatch is a dupe/loss bug — fail loud.
3. **Idempotency.** Every trade carries a unique id (idempotency key). Applying the same id twice must be a no-op. Defeats retry/replay double-spend.
4. **Append-only ledger / event sourcing.** Never destructively `UPDATE` a balance as the source of truth. Append an event; balances are a projection (fold) over the log. The ledger is the forensic trail — dupes must be detectable and replayable.
5. **Atomic with refund-on-failure.** Multi-step moves (money out → item in) either fully complete or fully revert. If a later step fails, refund the earlier one. Never leave a half-applied trade.
6. **Per-account serialization.** Process a given account's transactions on a single serialized path (actor-style) so concurrent trades can't race into a dupe.

## Performance invariants
- **In-memory hot state** for prices/orders/balances. Reads/writes hit RAM.
- **Batched, debounced, transactional write-behind** to MariaDB via oxmysql — **never per-tick DB writes.** Wrap multi-row flushes in a single `MySQL.transaction`.
- Use **oxmysql prepared statements + pooling.** Index the hot paths. Ledger tables are append-only + indexed by (account, time) and (commodity, time).
- Tune MariaDB: `innodb_buffer_pool_size` 50–70% RAM, `innodb_flush_log_at_trx_commit=2`.

## Telemetry (feeds the SaaS — do not skip)
Every successful transaction MUST emit a structured event (player, commodity, qty, side, unit price, tax/sink, timestamp, server id). This stream is the product's data moat. Keep it cheap (fire-and-forget insert / async emit); never let telemetry block the trade path.

## Forbidden patterns (reject these in review)
- Client-side balance/price/inventory mutation, or trusting any client-supplied amount/price.
- `UPDATE balance = balance + x` as the sole record of a transfer (no ledger, no double-entry).
- Per-tick or per-transaction synchronous DB writes on the hot path.
- Unbounded faucets or infinite fixed-price NPC buy/sell that destroys price discovery.
- Relying on Cfx **escrow** for security (it's bypassable) — keep valuable logic server-side instead.
- Any crypto/NFT/real-money-cashout monetization (violates Take-Two ToS).

## Repos to study (open-source, maintained — imitate their patterns)
- `overextended/ox_inventory` — server-authoritative, anti-dupe item state (the gold standard)
- `overextended/ox_core`, `ox_lib`, `oxmysql`; `Qbox-project/qbx_core`
- `tigerbeetle/tigerbeetle` — **the** reference for double-entry, idempotent, dupe-proof money handling (read its docs)
- `projectmesa/mesa` — Python agent-based modeling, to prototype the "living economy" offline before porting rules to Lua
- Docs: docs.fivem.net (natives, OneSync, state bags), overextended.dev, docs.qbox.re

## Load order (server.cfg)
`oxmysql` → `ox_lib` → framework (`qbx_core`) → `ox_target` → `ox_inventory` → `keystone_economy`

## Current architecture (this repo)
- `shared/pricing.lua` — pure elastic supply/demand price model (no I/O)
- `server/state.lua` — in-memory hot state
- `server/persistence.lua` — batched transactional flush
- `server/transactions.lua` — atomic, refund-safe trade path (**evolve toward full double-entry + idempotency keys + telemetry emit**)
- `server/adapters/` — framework adapters (interface + qbox + mock); mock runs on a bare VPS with no framework for load-testing
- `server/exports.lua` — public API (`getPrice`, `getMarket`, `trade`)
- `sql/schema.sql` — commodities + append-only ledger

## Known next steps
1. Add idempotency keys + double-entry accounts table to the ledger.
2. Emit telemetry events on every trade (the SaaS sensor).
3. Engineered sinks (tax/rent/fuel) sized against measured faucet output.
4. Load-test harness (`harness/`) — synthetic players + resmon capture + dupe reconciliation → published benchmarks.
5. ESX + QBCore adapters.

When in doubt, prefer correctness and the invariants above over speed of delivery. A fast dupe is worthless.
