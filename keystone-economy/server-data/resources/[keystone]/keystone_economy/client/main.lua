-- Minimal client stub. The client is intentionally "dumb": it only sends
-- trade intent and renders results. All authority lives on the server.
-- A real NUI (React) shop UI comes later; this proves the round-trip.

RegisterNetEvent('keystone:tradeResult', function(ok, err, total)
  if ok then
    print(('[keystone] trade ok, total $%s'):format(total))
  else
    print(('[keystone] trade failed: %s'):format(err or 'unknown'))
  end
end)

-- Dev/test command: /ksbuy lettuce 5
RegisterCommand('ksbuy', function(_, args)
  local id, qty = args[1], tonumber(args[2] or '1')
  if id then TriggerServerEvent('keystone:requestTrade', id, qty, 'buy') end
end, false)

RegisterCommand('kssell', function(_, args)
  local id, qty = args[1], tonumber(args[2] or '1')
  if id then TriggerServerEvent('keystone:requestTrade', id, qty, 'sell') end
end, false)
