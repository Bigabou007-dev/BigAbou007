Keystone = Keystone or {}

--- In-memory hot state. This is why Keystone stays fast under load:
--- reads/writes hit RAM, not the DB. Persistence.lua flushes it in batches.
Keystone.State = {
  commodities = {},   -- [id] = { base, supply, demand, price, dirty = bool }
  dirty = false,      -- set true whenever anything changes; cleared on flush
}

function Keystone.State.load()
  for _, c in ipairs(Keystone.Config.commodities) do
    Keystone.State.commodities[c.id] = {
      base = c.base,
      supply = c.supply,
      demand = c.demand,
      price = Keystone.Pricing.compute(c.base, c.supply, c.demand),
      dirty = false,
    }
  end
end

function Keystone.State.get(id)
  return Keystone.State.commodities[id]
end

--- Mark a commodity (and the world) dirty so the next flush persists it.
function Keystone.State.touch(id)
  local c = Keystone.State.commodities[id]
  if c then c.dirty = true end
  Keystone.State.dirty = true
end
