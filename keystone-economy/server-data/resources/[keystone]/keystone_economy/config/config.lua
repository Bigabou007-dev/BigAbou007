Keystone = Keystone or {}

Keystone.Config = {
  -- Framework adapter: 'auto' detects a running framework, else falls back to
  -- the in-memory mock (for load-testing on a bare VPS with no framework).
  -- Force one with: 'qbox' | 'esx' | 'qbcore' | 'mock'.
  framework = 'auto',
  allowMockFallback = true,
  mock = { startingCash = 100000 },

  -- Persistence: how often (ms) to flush the in-memory hot state to MariaDB.
  -- The whole point is to NOT write per-tick. Batch + debounce.
  flushIntervalMs = 5000,

  -- Elastic pricing model. price = base * (demand/supply)^elasticity, clamped.
  pricing = {
    elasticity   = 0.5,   -- 0 = fixed price, 1 = fully elastic
    minMultiplier = 0.4,  -- price floor vs base
    maxMultiplier = 3.0,  -- price ceiling vs base
    reversionPerMin = 0.02, -- prices drift back toward equilibrium when idle
  },

  -- Money sinks: the "drain" that matches the faucet. Applied on transactions.
  sinks = {
    salesTaxPct   = 0.05, -- % skimmed on every player-shop sale (removed from supply)
    restockCostPct = 0.6, -- fraction of base price an owner pays to restock
  },

  -- Seed commodities. In v2 these become nodes in a supply chain graph.
  -- name, basePrice, initial supply/demand baselines.
  commodities = {
    { id = 'lettuce',  base = 12,  supply = 1000, demand = 1000 },
    { id = 'burger',   base = 45,  supply = 500,  demand = 800  },
    { id = 'cocaine',  base = 900, supply = 120,  demand = 400  },
  },

  debug = true,
}
