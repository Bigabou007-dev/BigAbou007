Keystone = Keystone or {}

-- In-memory mock adapter. Lets Keystone run and be load-tested on a bare VPS
-- with NO framework (no ESX/Qbox/ox) installed. Never auto-selected — only
-- used when Config.framework = 'mock' or allowMockFallback kicks in.
--
-- Every player starts with Config.mock.startingCash and an empty virtual
-- inventory tracked in RAM. This is enough to exercise the full transaction
-- path (funds check, atomic move, refund-on-failure) under the trade-storm
-- harness without a single real game client.

Keystone.registerAdapter('mock', {
  detect = function() return false end,  -- explicit only

  build = function()
    local wallet = {}   -- src -> cash
    local bag = {}      -- src -> { [item] = count }
    local start = (Keystone.Config.mock and Keystone.Config.mock.startingCash) or 100000

    local function cash(src)
      if wallet[src] == nil then wallet[src] = start end
      return wallet[src]
    end
    local function inv(src)
      bag[src] = bag[src] or {}
      return bag[src]
    end

    return {
      canAfford = function(src, amount) return cash(src) >= amount end,
      takeMoney = function(src, amount)
        if cash(src) < amount then return false end
        wallet[src] = cash(src) - amount
        return true
      end,
      giveMoney = function(src, amount)
        wallet[src] = cash(src) + amount
        return true
      end,
      canCarry = function() return true end,
      hasItem = function(src, item, qty) return (inv(src)[item] or 0) >= qty end,
      takeItem = function(src, item, qty)
        local have = inv(src)[item] or 0
        if have < qty then return false end
        inv(src)[item] = have - qty
        return true
      end,
      giveItem = function(src, item, qty)
        inv(src)[item] = (inv(src)[item] or 0) + qty
        return true
      end,
    }
  end,
})
