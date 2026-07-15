Keystone = Keystone or {}
Keystone.Persistence = {}

--- Batched, debounced flush of dirty in-memory state to MariaDB.
--- Called on a timer (Config.flushIntervalMs), NOT per transaction.
--- Uses a single transaction so a crash mid-flush can't half-write.
function Keystone.Persistence.flush()
  if not Keystone.State.dirty then return end

  local queries = {}
  for id, c in pairs(Keystone.State.commodities) do
    if c.dirty then
      queries[#queries + 1] = {
        query = [[
          INSERT INTO keystone_commodities (id, base, supply, demand, price)
          VALUES (?, ?, ?, ?, ?)
          ON DUPLICATE KEY UPDATE supply = VALUES(supply),
                                   demand = VALUES(demand),
                                   price  = VALUES(price)
        ]],
        values = { id, c.base, c.supply, c.demand, c.price },
      }
      c.dirty = false
    end
  end

  if #queries == 0 then Keystone.State.dirty = false; return end

  -- oxmysql transaction: all-or-nothing.
  MySQL.transaction(queries, function(ok)
    if ok then
      Keystone.State.dirty = false
    else
      -- Re-mark dirty so we retry next tick; never lose writes silently.
      Keystone.State.dirty = true
      if Keystone.Config.debug then
        print('[keystone] flush FAILED, will retry next interval')
      end
    end
  end)
end

--- On shutdown, do one final synchronous-ish flush so nothing is lost.
function Keystone.Persistence.flushOnStop()
  Keystone.Persistence.flush()
end
