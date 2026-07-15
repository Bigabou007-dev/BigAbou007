Keystone = Keystone or {}
Keystone.Transactions = {}

--- Server-authoritative, atomic trade. This is the anti-dupe core.
--- The client NEVER tells us the price or moves items itself; the server
--- computes price, validates funds/inventory, and mutates state under lock.
---
--- @param src number player server id
--- @param commodityId string
--- @param qty number (> 0)
--- @param side 'buy'|'sell'
--- @return boolean ok, string|nil err, number|nil totalPrice
function Keystone.Transactions.trade(src, commodityId, qty, side)
  -- 1. Validate inputs (never trust the client).
  if type(qty) ~= 'number' or qty <= 0 or qty ~= math.floor(qty) then
    return false, 'invalid_qty'
  end
  local c = Keystone.State.get(commodityId)
  if not c then return false, 'unknown_commodity' end
  if side ~= 'buy' and side ~= 'sell' then return false, 'invalid_side' end

  -- 2. Price is computed server-side from live state — not passed in.
  local unit = Keystone.Pricing.compute(c.base, c.supply, c.demand)
  local gross = unit * qty
  local tax = math.floor(gross * Keystone.Config.sinks.salesTaxPct + 0.5)

  -- 3. Framework adapter moves all money/items server-side. Fail closed.
  local adapter = Keystone.Adapter
  if not adapter then return false, 'adapter_unavailable' end

  if side == 'buy' then
    local cost = gross
    -- Pre-checks BEFORE mutating anything (cheap, avoids refund churn).
    if not adapter.canAfford(src, cost) then return false, 'insufficient_funds' end
    if adapter.canCarry and not adapter.canCarry(src, commodityId, qty) then
      return false, 'cannot_carry'
    end
    -- 4. Atomic mutation: money out, item in. If the item grant fails, refund
    --    the money — so we can never create or destroy value (no dupe, no loss).
    if not adapter.takeMoney(src, cost) then return false, 'take_money_failed' end
    if not adapter.giveItem(src, commodityId, qty) then
      adapter.giveMoney(src, cost) -- refund
      return false, 'give_item_failed'
    end
  else -- sell
    if not adapter.hasItem(src, commodityId, qty) then return false, 'insufficient_items' end
    if not adapter.takeItem(src, commodityId, qty) then return false, 'take_item_failed' end
    local payout = gross - tax
    if not adapter.giveMoney(src, payout) then
      adapter.giveItem(src, commodityId, qty) -- refund the item
      return false, 'give_money_failed'
    end
  end

  -- 5. Update in-memory economy state + mark dirty (persisted on next flush).
  c.supply, c.demand = Keystone.Pricing.applyTrade(c.supply, c.demand, qty, side)
  c.price = Keystone.Pricing.compute(c.base, c.supply, c.demand)
  Keystone.State.touch(commodityId)

  -- 6. Audit log (append-only; the forensic trail that makes dupes detectable).
  Keystone.Transactions.log(src, commodityId, qty, side, unit, tax)

  return true, nil, gross
end

function Keystone.Transactions.log(src, commodityId, qty, side, unit, tax)
  -- Fire-and-forget insert; the append-only ledger is our dupe forensic trail.
  MySQL.insert([[
    INSERT INTO keystone_ledger (player_src, commodity, qty, side, unit_price, tax)
    VALUES (?, ?, ?, ?, ?, ?)
  ]], { src, commodityId, qty, side, unit, tax })
end
