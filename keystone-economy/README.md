# Keystone Economy Engine
> Working title — rename freely. A server-authoritative, framework-agnostic supply/demand pricing + supply-chain engine for FiveM, with dupe-proof atomic transactions and published performance benchmarks.

**Status:** v0 skeleton. This is a runnable scaffold (the resource loads, the DB schema applies, the exports API is stubbed) — the real pricing engine is the next build step.

## Why this exists
FiveM economy scripts are flooded but shallow: fake config prices, isolated businesses, and dupe/lag from naive transactions. Keystone is the **backbone** other business/job/shop scripts plug into — real price discovery, interconnected supply chains, and atomic dupe-proof transactions, engineered to hold 128 players.

## What runs where (no gaming PC needed)
- **This whole stack runs headless on your Linux VPS** — FXServer + MariaDB via Docker. No GTA files, no GPU.
- You only need a Windows/GPU FiveM **client** for final in-world QA and recording showcases (rent hourly GPU or use Shadow PC; see `../FLAGSHIP-DECISION.md`).

## Quick start (on your VPS)
```bash
git clone <this-repo> && cd keystone-economy
cp .env.example .env          # set DB password + a Cfx license key (keymaster.fivem.net)
./setup.sh                    # pulls images, applies schema, starts FXServer + MariaDB
docker compose logs -f fxserver
```
- txAdmin: `http://<vps-ip>:40120` (complete the wizard once, link your Cfx account)
- Game connect (from a client later): `connect <vps-ip>:30120`

Open firewall: TCP/UDP **30120** (game), TCP **40120** (txAdmin).

## Architecture (the part that matters)
The reason naive economy scripts tank servers is per-tick DB writes on a write-heavy hot path. Keystone's design:
- **In-memory hot state** for prices/orders/balances (`server/state.lua`)
- **Debounced, batched, transactional** persistence to MariaDB via **oxmysql** (`server/persistence.lua`)
- **Server-authoritative atomic transactions** — validate inventory before/after, wrap money moves in a DB transaction (`server/transactions.lua`) → dupe-proof by design
- **Elastic supply/demand pricing** driven by real player buy/sell (`shared/pricing.lua`)
- **Thin framework adapters** — standalone core, Qbox/ox first, ESX/QBCore later (`server/adapters/`)
- **Exports API** so other scripts consume prices + move money safely (`server/exports.lua`)

## Layout
```
keystone-economy/
├─ docker-compose.yml         # FXServer + MariaDB
├─ .env.example
├─ setup.sh
├─ server-data/
│  ├─ server.cfg              # FXServer config (ensures resources)
│  └─ resources/[keystone]/keystone_economy/
│     ├─ fxmanifest.lua
│     ├─ config/config.lua
│     ├─ shared/pricing.lua   # elastic price model (stub)
│     ├─ server/main.lua      # bootstrap + tick loop
│     ├─ server/state.lua     # in-memory hot state
│     ├─ server/persistence.lua  # batched writes
│     ├─ server/transactions.lua # atomic, dupe-proof money moves
│     ├─ server/exports.lua   # public API
│     └─ client/main.lua      # minimal NUI hook (later)
└─ harness/
   └─ README.md               # load-test plan (synthetic players + resmon capture)
```

## Roadmap
- **v1** — pricing engine + money-sink hooks + anti-dupe transactions + exports API + benchmarks
- **v2** — cross-business supply-chain interconnection (farm → processor → retailer)
- **v3** — owner macro dashboards + economy observability

See `../FLAGSHIP-DECISION.md` for the full rationale and market data.
