Keystone = Keystone or {}

-- Bootstrap: load state from config/DB, start the flush + reversion loops.
AddEventHandler('onResourceStart', function(res)
  if res ~= GetCurrentResourceName() then return end

  Keystone.State.load()

  -- Resolve which framework moves money/items. Without one, trades fail closed.
  local active = Keystone.resolveAdapter()
  if active then
    print('[keystone] framework adapter: ' .. active)
  else
    print('[keystone] WARNING: no adapter active — trades will fail. '
      .. "Install qbx_core, or set Config.framework = 'mock' for dev/load-test.")
  end

  -- Batched persistence loop — the reason we don't write per-transaction.
  CreateThread(function()
    while true do
      Wait(Keystone.Config.flushIntervalMs)
      Keystone.Persistence.flush()
    end
  end)

  -- Price reversion loop — idle prices drift back toward equilibrium so a
  -- single spike doesn't permanently distort the market.
  CreateThread(function()
    while true do
      Wait(60000)
      local rate = Keystone.Config.pricing.reversionPerMin
      for id, c in pairs(Keystone.State.commodities) do
        local eq = (c.supply + c.demand) / 2
        c.supply = c.supply + (eq - c.supply) * rate
        c.demand = c.demand + (eq - c.demand) * rate
        c.price = Keystone.Pricing.compute(c.base, c.supply, c.demand)
        Keystone.State.touch(id)
      end
    end
  end)

  if Keystone.Config.debug then
    print('[keystone] economy engine started with '
      .. #Keystone.Config.commodities .. ' commodities')
  end
end)

-- Never lose state on restart/shutdown.
AddEventHandler('onResourceStop', function(res)
  if res ~= GetCurrentResourceName() then return end
  Keystone.Persistence.flushOnStop()
end)
