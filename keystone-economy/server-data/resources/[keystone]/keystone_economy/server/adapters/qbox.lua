Keystone = Keystone or {}

-- Qbox (qbx_core) + ox_inventory adapter — the modern default target.
--
-- NOTE ON API SURFACE: Qbox has been migrating some player methods between
-- `player.Functions.*` (QBCore-compatible) and dedicated exports across
-- versions. The money calls below use the widely-compatible Functions API.
-- Verify against YOUR installed qbx_core version; if money calls fail, swap
-- to the qbx_core money exports — that's the only line likely to need a tweak.

local OX = 'ox_inventory'

local function getPlayer(src)
  return exports.qbx_core:GetPlayer(src)
end

Keystone.registerAdapter('qbox', {
  detect = function()
    return GetResourceState('qbx_core') == 'started'
  end,

  build = function()
    return {
      canAfford = function(src, amount)
        local p = getPlayer(src)
        if not p then return false end
        return (p.PlayerData.money.cash or 0) >= amount
      end,

      takeMoney = function(src, amount)
        local p = getPlayer(src)
        if not p then return false end
        return p.Functions.RemoveMoney('cash', amount, 'keystone-trade') and true or false
      end,

      giveMoney = function(src, amount)
        local p = getPlayer(src)
        if not p then return false end
        return p.Functions.AddMoney('cash', amount, 'keystone-trade') and true or false
      end,

      canCarry = function(src, item, qty)
        return exports[OX]:CanCarryItem(src, item, qty) and true or false
      end,

      hasItem = function(src, item, qty)
        return (exports[OX]:GetItemCount(src, item) or 0) >= qty
      end,

      takeItem = function(src, item, qty)
        return exports[OX]:RemoveItem(src, item, qty) and true or false
      end,

      giveItem = function(src, item, qty)
        -- ox_inventory:AddItem returns success, response
        local ok = exports[OX]:AddItem(src, item, qty)
        return ok and true or false
      end,
    }
  end,
})
