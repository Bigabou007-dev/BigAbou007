# The FiveM / GTA B2B Playbook — Tools, Market, Edge & Separate Business Plans
**Compiled July 15, 2026 · Research-backed (4 parallel research agents + adversarial fact-check pass). Figures marked [cited] appeared in a source; [est] are estimates/unaudited; [unverified] could not be page-confirmed. FiveM economics are opaque — treat all earnings numbers as order-of-magnitude, not audited.**

> **Framing reality (from the prior market analysis):** GTA 6 ships **Nov 19, 2026, console-only, no announced mod/server support**, and Take-Two spent 2026 *killing* every independent GTA multiplayer platform (alt:V, RAGE:MP) — leaving FiveM, which they own, as the sole survivor. **There is no GTA 6 shovel market to sell into yet, and it may never be an *open* one.** So this playbook is about **building position in FiveM/GTA 5 now** (a Rockstar-owned monopoly at peak attention) so you're an established, trusted incumbent if/when a GTA 6 Creator Platform opens. Every dollar here is earned on GTA 5 today; GTA 6 hype only pumps GTA 5 RP demand in the meantime.

---

## PART 0 — THE EDGE DOCTRINE (read this first)

You asked the only question that matters: *with coding agents, anyone can build the same scripts — so what's my actual advantage?* The research answers it bluntly.

### What is NOT a moat (commoditized or dying)
| Thing | Why it's weak |
|---|---|
| "I generate scripts with AI" | RPForger openly admits it's *Claude Sonnet 4.5 + a 12k-word prompt*. A **free** Claude skill (`fivem-dev`) already fetches live Cfx natives and approximates the paid generators. Frontier model + free skill = table stakes by mid-2027. |
| The code / features themselves | AI collapses production cost. Any feature is cloned in days. |
| Escrow / encryption | A **losing arms race.** Public decrypt POC on GitHub (`zickzackhd/FivemEscrowPOC`); "decrypt-then-decompile" tools sell for ~$5/mo on leak sites (vag.gg, fivevault.net). Server-side scripts are especially exposed. |

### What IS a moat (survives AI commoditization) — ranked
| Advantage | Durability | Why it holds |
|---|---|---|
| **Support & maintenance reliability** (fast Discord, framework-update cadence) | **Very durable** | Labor + trust, not code. Competitors underinvest because it's unglamorous and doesn't scale. You *cannot pirate a support relationship.* |
| **Becoming infrastructure** (own a free, depended-on resource, like `ox_lib`) | **Highest, but rarest** | Adoption + compatibility lock-in. Every "requires yourlib" line is free marketing. Standards-setting power. |
| **Owned audience** (your storefront/Discord/YouTube, not a rented marketplace slot) | **Durable** | You control distribution; JG Scripts grew to Top Partner **with zero paid ads** via YouTube+SEO+an owned Tebex-headless store. |
| **Niche reputation** ("the reliable X creator") | **Durable** | Trust compounds over years; JG won by being *the* dependable option in one neglected category. |
| **Proprietary QA / load-test harness** (prove "0.00ms @ 100 players") | **Durable + uniquely yours** | The #1 confirmed **toolchain gap** — no standard functional/load testing exists. Hard to build (natives need a live client/server) = defensible. This is *your* DevOps edge. |
| **Server-side licensing design** (keep valuable logic phoning home) | Moderate | A design choice, not a secret. Beats encryption: a leaked copy is non-functional/unsupported. |
| **Cfx "verified/approved" Marketplace status** | Moderate | Real institutional-trust signal, but platform-granted and dilutable. |

### The doctrine in one sentence
> **AI is the fuel, not the moat.** The engine you build around it is: *AI-fed production (speed) → gated by a proprietary load-test + validation harness (quality nobody can copy) → shipped under a trusted brand with obsessive support (reputation) → anchored by a free resource everyone depends on (distribution chokepoint) → protected by server-side logic (not encryption).* Anyone can buy fuel. Almost nobody builds that specific engine, because it needs a systems engineer **and** a marketer **and** patience — which is your profile.

---

## PART 1 — BEST TOOLS (the reference stack, 2026)

### Core runtime & frameworks
| Tool | Role | Notes |
|---|---|---|
| **FXServer (artifacts)** | The server binary | Download versioned "artifact" from runtime.fivem.net. **txAdmin ships inside it** — no separate install. |
| **txAdmin** | Server admin/deploy panel | First launch → setup wizard at `http://localhost:40120`; link Cfx account, pick a recipe. |
| **Qbox (`qbx_core`)** | Modern RP framework | Community fork of QBCore by ex-QBCore devs; modular, Lua 5.4, backwards-compat with QBCore resources. **The rising standard.** |
| **ESX Legacy** | Largest install base | Old but huge; still worth cross-framework support. |
| **QBCore** | Legacy popular framework | **Development stalled**; energy moved to Qbox. Support it, don't build on it. |
| **Overextended "ox" stack** | The convergence layer | `ox_lib` (shared lib, load-order critical), `oxmysql` (the DB standard), `ox_inventory`, `ox_target`, `ox_core` (standalone framework). **Target this for cross-framework reach.** |

> **Strategic pick:** build against **`ox_lib` + `oxmysql`** and advertise **"ESX / QBCore / Qbox compatible."** That spans all three markets from one codebase.

### Languages, UI, database
| Tool | Role |
|---|---|
| **CfxLua (Lua 5.4)** | Primary scripting runtime. Set `lua54 'yes'` in manifest (5.3 deprecated ~June 2025). |
| **TypeScriptToLua (tstl)** | Optional type-safe Lua via `tsconfig.json`. Template: `Z3rio/fivem-tstolua`. |
| **React + Vite + Tailwind (NUI)** | In-game UIs render in an embedded CEF browser. Boilerplate: `project-error/fivem-react-boilerplate-lua`. Remember the `files { 'dist/**/*' }` manifest block or the UI is blank. |
| **MariaDB 10.6+** + **oxmysql** | Standard DB. Connection string via oxmysql; frameworks ship `.sql` schemas. |

### Dev / AI / QA tooling
| Tool | Role |
|---|---|
| **Claude Code + `fivem-dev` skill** (`melihbozkurt10/fivem-dev-plugin`) | Free skill that auto-loads for QBox/QBCore/ESX and live-fetches Cfx natives — kills the hallucinated-native problem. Your baseline AI factory. |
| **VS Code + Lua Language Server** | Editor + intellisense. |
| **FiveBoosts** (`FiveboostsDotNet/Fivem-Fake-Players`) | Injects synthetic "player units" for load/stress testing. The seed for your QA harness (§Business #4). |
| **Git + GitHub** | You already live here. Private repos per resource. |
| **CodeWalker + Blender + Sollumz** | MLO/3D pipeline (only if you do Business #2). |

### Distribution & commerce
| Channel | Notes |
|---|---|
| **Tebex** | The mandatory, Rockstar-endorsed payment rail. Escrow + delivery + licensing. Use the **Headless API** to build an owned-brand store (higher conversion — JG confirmed). |
| **Cfx Marketplace** (launched Jan 2026) | Official, Rockstar-authorized, **application + per-asset review (~2–4 weeks)**, in-client storefront. Revenue share **undisclosed** (varies by tier; anyone quoting a % is guessing). Confers institutional trust. |
| **Cfx forum [RELEASE] threads** | Canonical launch venue; free release + strong showcase video = name recognition funnel. |
| **Discord + YouTube** | Support hub + the organic discovery engine (devlogs/showcases). |

---

## PART 2 — WHAT'S SELLING (the market map)

### Price bands [cited]
- **Scripts:** utility ~$5 · mid **$20–30** · premium single **$40–65** (Quasar Inventory ~€65, Smartphone ~€79). The **escrow-vs-open-source 2× tier is standard** (e.g. Wasabi Ambulance **$49.99 escrowed / $99.99 unlocked**).
- **MLOs:** **$15–40** single interior · large bundles up to **$389** on Cfx Marketplace.
- **Vehicle packs:** $120–195 (⚠️ often dubious licensing — avoid).
- **Clothing/EUP:** small $8–10, big packs ~$85.

### The model is shifting to subscriptions
JG+ (~£25/mo), Lation, Wasabi, and Gabz (MLOs, subscription-only ~€15/mo) all run "all my stuff, one monthly price." Recurring revenue is the direction of travel — plan for it.

### Saturated vs. underserved
- **Oversaturated (only enter if best-in-class):** HUDs, garages, basic jobs, phones, drug scripts, generic inventory, admin menus, anticheat.
- **Underserved / high-demand gaps [cited/est]:** **player-owned business & player-driven economy systems** (repeatedly named the #1 gap), advanced interaction/social mechanics (beyond "press-E-and-wait"), specialized immersive systems (yacht/motorhome ownership).

### The three complaints that ARE your opening (buyers say this constantly)
1. **Performance** — bloated scripts; "0.00ms idle" is a headline selling point.
2. **Shallow design** — "99% of scripts are press-E-and-wait." Depth wins.
3. **Support & maintenance** — slow responses, scripts that break on framework updates.

> **The pattern:** the *money* is in saturated categories; the *opening* is being demonstrably better on performance + depth + support — ideally in the higher-value **player-economy** lane where competition is thin.

### Earnings reality [est — unaudited, heavy survivorship bias]
Steep power law. Hobby long tail earns little; full-timers commonly cited **~$2k–$10k+/mo**; a subscription example is 200 subs × $25 ≈ **$5k/mo**; custom projects **$500–5,000+**; top-tier (JG/Quasar/rcore class) "five-to-six figures annually." JG Scripts took **~3 years** to reach Top Partner. This is a compounding grind, not a lottery.

---

## PART 3 — THE BUSINESS IDEAS (each a separate plan)

### 🟢 Business #1 — The Script Studio  *(RECOMMENDED PRIMARY)*
**Thesis:** Sell premium, performance-obsessed scripts in one neglected niche. AI-accelerated production; moat from a proprietary load-test harness + obsessive support + an owned audience.
**Why it fits you:** it's *code* (your wheelhouse), it's solo/passive-leaning, and it needs zero community management — you sell to server owners, you don't run a server.
**Market:** mid $20–30 → premium $40–65 → subscription at catalog scale. Target the **player-owned economy** lane.
**The edge (what competitors can't copy):**
- A **load-tested performance guarantee** ("benchmarked stable at 100+ players, X ms") backed by your harness (Business #4). Nobody else can prove this.
- **Depth** over press-E filler. Design a genuinely engaging mechanic.
- **Cross-framework** (ox_lib/oxmysql → ESX+QBCore+Qbox) from one codebase.
- **Support cadence** — you answer tickets fast and update on framework churn.
- A **config UI** (like JG's Configurator) — a UX investment AI code-gen doesn't replicate.
**To-do:**
- [ ] Pick ONE niche in the player-economy lane (validate demand on forums/Discord first).
- [ ] Stand up the dev environment (Part 4 checklist).
- [ ] Build the minimal load-test harness (Business #4) *in parallel* — it's your quality gate.
- [ ] Ship **one flagship** script (~2 weeks polish, like JG's first). Server-side critical logic.
- [ ] Release: Cfx forum thread + showcase video + Tebex listing + Discord.
- [ ] Ship a web **config generator** for it.
- [ ] Iterate to 3–4 resources, then launch an "all-access" **subscription**.
- [ ] Apply to Cfx Marketplace once you have a portfolio.
**Verdict:** ✅ The strongest verified path. Slow-compounding (reputation takes months–years) but real, solo-viable, and every asset here transfers to a GTA 6 Creator Platform on day one.

---

### 🟡 Business #2 — The MLO / Environment Studio
**Thesis:** Sell optimized custom interiors/maps. The high skill barrier is the moat.
**Market:** $15–40 single, up to $389 bundles; Gabz proves a ~€15/mo subscription model.
**The edge:** the **Blender + Sollumz + CodeWalker** pipeline (collision meshes, LODs, portals/occlusion) is a genuine craft. **AI 3D does NOT save you** — Meshy/Tripo/Rodin output bad-topology glb/fbx with none of the GTA-native formats; every mesh still needs a full manual conversion pass. That barrier = less saturation for *good* MLOs.
**To-do:** learn the pipeline → build one flagship interior in the police/hospital/business lane → optimize obsessively → release with a cinematic showcase → subscription at catalog scale.
**Verdict:** ⚠️ Real and less saturated, but requires a **3D-art skill you'd build from scratch** — slow, and not your wheelhouse. Pursue only if you *want* the craft. **Not recommended as your primary.** Better as a later add-on (hire/partner with a 3D artist once #1 funds it).

---

### 🟡 Business #3 — The AI Dev-Tool (grounded, not generic)
**Thesis:** NOT another text-to-Lua chatbot (commoditized dead-end). A **grounded, validated** generator/reviewer whose corpus + linter measurably beats generic models on "does it actually run," with project-aware editing that becomes a server's system-of-record.
**Market:** crowded — RPForger, **SwisserAI** (the leader; bundles grounding+validation+multi-asset+API), IntelliScripts, fivem-ai, PixelPilot. Thin moats everywhere.
**The edge (the only defensible angles, per a16z/VC analysis):**
- **Proprietary grounding/validation corpus** — the data your product *causes to exist* (real bug fixes, real native/export validations, real load-test outcomes from Business #1 & #4).
- **Workflow lock-in** — project-aware editing of a live server's resource tree over time.
- **Owned distribution** — bundle it with your brand/marketplace.
**To-do:** build the grounding corpus + validation linter **for yourself first** (you need it for #1 anyway) → only productize if it's genuinely better *and* you own a distribution channel.
**Verdict:** ⚠️ As a standalone SaaS, **weak** — commoditized, a free skill already exists, and a frontier-model update can wipe a thin wrapper overnight. **BUT** the underlying grounding+validation tech is your **internal weapon** for Business #1. Build it as infrastructure, not as the product. Revisit productizing only after #1 gives you proprietary data and an audience.

---

### 🟢 Business #4 — The QA / Load-Testing Harness  *(build this regardless)*
**Thesis:** The clearest confirmed **toolchain gap** — FiveM has *no* standard functional/load-testing culture. QA is all manual (join with the client, click around, watch resmon). Build the harness that automates it.
**Market:** no real competitor (FiveBoosts = stress only, no correctness testing). Small direct B2B market (other creators, large servers) + your own internal use.
**The edge:** it's a **hard problem** (natives need a running client/server; can't easily headless) — which is exactly why it's unfilled and defensible. Pure systems engineering = your strength.
**To-do:** FXServer test-harness → inject synthetic players (fork FiveBoosts) → capture per-resource `resmon` ms + tick under load → assert regressions in CI → gate every Business #1 release on it.
**Verdict:** ✅ Primarily your **internal quality weapon** — it's what lets #1 make a performance claim no competitor can match. As a *standalone* product the market is small but competition is near-zero; you could later sell access ("performance certification"). Build the internal version now.

---

### 🔵 Business #5 — The Infrastructure Play (own a dependency)
**Thesis:** Ship a **free, open, excellent** utility resource that becomes a depended-on standard — the way `ox_lib`/`oxmysql` did — then monetize the halo (premium add-ons, custom work, trust).
**Market:** winner-take-most. Overextended currently owns the standard ("powers 30,000+ communities").
**The edge:** adoption + compatibility lock-in; every dependent script markets you for free; standards-setting power; huge switching costs once servers build on you.
**To-do:** find a genuine gap in/adjacent to the ox ecosystem → build it free + MIT + obsessively maintained → let your *paid* scripts depend on it → convert the trust into premium sales.
**Verdict:** 🔵 Highest leverage, **hardest and slowest**, winner-take-most. Don't start here. **Layer it under Business #1 over 12–18 months** — ship a small free lib your paid catalog uses, and grow it into a standard.

---

### 🟠 Business #6 — DevOps / Performance Consulting
**Thesis:** High-ticket optimization for large servers — DB/query tuning, Redis caching, resmon debugging, reverse-proxy/DDoS hardening. Directly your background.
**Market:** 100+ player servers have real perf pain; **$500–5,000+ per project** [est].
**The edge:** scarce skill; your DevOps résumé is the credential. Fast cash with no inventory.
**To-do:** package a fixed-scope "server performance audit" offer → find clients via forum/Discord/Marketplace-adjacent networks → productize findings into repeatable playbooks.
**Verdict:** 🟠 Real money and B2B (not community management) — **but it's client work**: deadlines, calls, dealing with people, which you said you want to avoid. Best used as **early cash flow** to fund Business #1, then taper. Don't let it become a job.

---

### 🔴 Business #7 — Game Server Hosting (GSP)
**Thesis (from the original playbook):** automated Pterodactyl/Pelican + WHMCS provisioning on Ryzen bare metal.
**Verdict:** 🔴 **Don't — at least not now.** The prior research killed this: commoditized (thin margins, incumbents pivot day one), capital-intensive, support-heavy, and — for GTA 6 — the product literally *cannot exist for years*. GTA 5 hosting is a crowded knife-fight entirely dependent on a platform Take-Two owns and polices. Skip it. If you ever revisit, only after a GTA 6 platform exists *and* permits third-party hosting (it may be fully Rockstar-hosted, Roblox-style).

---

## PART 4 — ENVIRONMENT SETUP CHECKLIST (do this first)

**Hardware/OS:** a Windows machine with **GTA V installed** (you need the client to test) + either a local FXServer or a cheap Linux VPS for the server.

- [ ] Install **GTA V** + FiveM client on your dev Windows box.
- [ ] Download the recommended **FXServer artifact**; extract to `C:\FXServer\server`, create sibling `txData`.
- [ ] Run `FXServer.exe` → complete the **txAdmin wizard** at `localhost:40120` → link Cfx account → pick the CFX Default recipe.
- [ ] Install **MariaDB 10.6+**; create a dev database.
- [ ] Add **oxmysql** + set the connection string; import framework `.sql`.
- [ ] Install **Qbox (`qbx_core`)** + the **ox stack** (`ox_lib`, `oxmysql`, `ox_inventory`, `ox_target`). `ensure` in correct load order.
- [ ] Editor: **VS Code** + Lua Language Server (+ TypeScriptToLua if you want types).
- [ ] NUI: clone `project-error/fivem-react-boilerplate-lua` (React+Vite+Tailwind).
- [ ] AI factory: **Claude Code** + install the free **`fivem-dev`** skill.
- [ ] QA seed: clone **FiveBoosts** fake-players; wire a resmon-capture script (→ Business #4).
- [ ] Commerce: create **Tebex** + **Cfx** accounts; reserve a brand name; stand up a **Discord** and a **YouTube** channel.
- [ ] Repo hygiene: private GitHub repo per resource; keep valuable logic **server-side**.

---

## PART 5 — RECOMMENDED SEQUENCE

1. **Weeks 0–2 — Foundation.** Environment setup (Part 4). Build the minimal **load-test harness** (#4). Validate a **player-economy niche** on forums/Discord.
2. **Weeks 2–6 — First flagship.** Ship one excellent, load-tested, cross-framework script (#1) with a config UI and a showcase video. Server-side licensing.
3. **Weeks 6–16 — Flywheel.** Devlogs → SEO → Discord. Ship resources #2–#4. Start responsive support as a *feature*. Apply to Cfx Marketplace.
4. **Optional early cash:** take 1–2 **performance-consulting** gigs (#6) to fund the above — don't let it become full-time.
5. **Month 4+ — Recurring + moat-deepening.** Launch an all-access **subscription**. Extract a small **free library** your paid scripts depend on (#5 seed). Decide whether the grounding/validation tech (#3) is worth productizing.
6. **GTA 6 watch (tripwires — re-plan immediately on any):** PC version announced · Rockstar Creator Platform opens applications · any official GTA 6 UGC/RP statement · Cfx PLA/monetization changes. Your FiveM catalog + reputation is the day-one entry ticket.

### What NOT to do
- ❌ Don't build a generic AI script generator as the product (commoditized; free skill exists).
- ❌ Don't buy servers / start a GSP for GTA 6 (can't exist for years; commoditized for GTA 5).
- ❌ Don't rely on escrow for security — keep valuable logic server-side; compete on updates/support/reputation.
- ❌ Don't touch crypto/NFT/sponsorship monetization anywhere near GTA (explicitly banned + enforced).
- ❌ Don't lead with MLOs unless you want to become a 3D artist.
- ❌ Don't bet timing on Nov 19, 2026 — Rockstar has already slipped twice.

---

## Sourcing note
Built from 4 parallel research agents (toolchain, market/prices, AI-competitor scan, operational/moat realities), cross-checked against Cfx docs, GitHub, Tebex's JG Scripts spotlight, PC Gamer, and VC moat analysis (a16z/nfx). Many creator sites (JG, Quasar, Codesign, Cfx forum/support) block automated fetching, so some specifics rely on search-indexed snippets — consistent across queries but not fully page-verified. **All earnings figures are self-reported/marketing-sourced with survivorship bias. The Cfx Marketplace revenue-share % is genuinely undisclosed.** Verify Marketplace ToS + the Jan-12-2026 Platform License Agreement directly before committing a business model.
