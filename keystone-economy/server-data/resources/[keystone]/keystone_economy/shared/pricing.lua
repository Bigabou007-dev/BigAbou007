Keystone = Keystone or {}
Keystone.Pricing = {}

--- Pure function: compute a price from supply/demand. No side effects, no I/O.
--- This is the heart of "real price discovery" vs a config-set number.
--- @param base number base price at equilibrium (supply == demand)
--- @param supply number current available supply (> 0)
--- @param demand number current demand pressure (> 0)
--- @return number price
function Keystone.Pricing.compute(base, supply, demand)
  local cfg = Keystone.Config.pricing
  supply = math.max(supply, 1)
  demand = math.max(demand, 1)
  local ratio = demand / supply
  local mult = ratio ^ cfg.elasticity
  mult = math.max(cfg.minMultiplier, math.min(cfg.maxMultiplier, mult))
  return math.floor(base * mult + 0.5)
end

--- Apply a trade's effect on supply/demand (buy raises demand + drains supply).
--- Returns the mutated supply/demand so callers keep it in memory (no DB here).
function Keystone.Pricing.applyTrade(supply, demand, qty, side)
  if side == 'buy' then
    supply = supply - qty
    demand = demand + qty
  else -- sell
    supply = supply + qty
    demand = demand - qty
  end
  return math.max(supply, 1), math.max(demand, 1)
end
