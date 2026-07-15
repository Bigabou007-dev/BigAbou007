Keystone = Keystone or {}

-- ============================================================================
-- PUBLIC API — this is the "become infrastructure" surface. Other business/
-- shop/job scripts consume prices and move money SAFELY through Keystone
-- instead of writing their own (dupe-prone) transaction code.
-- ============================================================================

--- Read the current server-authoritative price of a commodity.
exports('getPrice', function(commodityId)
  local c = Keystone.State.get(commodityId)
  return c and c.price or nil
end)

--- Read full market state for a commodity (price, supply, demand).
exports('getMarket', function(commodityId)
  local c = Keystone.State.get(commodityId)
  if not c then return nil end
  return { price = c.price, supply = c.supply, demand = c.demand, base = c.base }
end)

--- Execute an atomic, dupe-proof trade. Returns ok, err, total.
exports('trade', function(src, commodityId, qty, side)
  return Keystone.Transactions.trade(src, commodityId, qty, side)
end)

-- Client → server trade request. The client sends only intent; the server
-- decides everything. (Rate-limiting / cooldown to be added.)
RegisterNetEvent('keystone:requestTrade', function(commodityId, qty, side)
  local src = source
  local ok, err, total = Keystone.Transactions.trade(src, commodityId, qty, side)
  TriggerClientEvent('keystone:tradeResult', src, ok, err, total)
end)
