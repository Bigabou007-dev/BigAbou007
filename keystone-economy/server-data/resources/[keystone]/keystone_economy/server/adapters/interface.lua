Keystone = Keystone or {}

-- ============================================================================
-- FRAMEWORK ADAPTER INTERFACE
-- Keystone's core is framework-agnostic. Every adapter must implement this
-- exact contract so transactions.lua never needs to know which framework is
-- installed. Money and items are ALWAYS moved through the adapter, server-side.
--
-- Contract (all return values are authoritative booleans unless noted):
--   canAfford(src, amount)        -> bool   does the player have >= amount cash
--   takeMoney(src, amount)        -> bool   remove cash; false if it couldn't
--   giveMoney(src, amount)        -> bool   add cash (used for payouts + refunds)
--   canCarry(src, item, qty)      -> bool   inventory has room (optional; nil = skip)
--   hasItem(src, item, qty)       -> bool   player holds >= qty of item
--   takeItem(src, item, qty)      -> bool   remove items
--   giveItem(src, item, qty)      -> bool   add items
-- ============================================================================

Keystone.Adapter = nil       -- the resolved, active adapter (set on start)
Keystone._adapters = {}      -- name -> { detect = fn, build = fn }

--- Register an adapter implementation.
--- @param name string  e.g. 'qbox', 'esx', 'qbcore', 'mock'
--- @param def table    { detect = function()->bool, build = function()->table }
function Keystone.registerAdapter(name, def)
  Keystone._adapters[name] = def
end

--- Resolve the active adapter from config preference, else auto-detect,
--- else fall back to the in-memory mock (for dev/load-testing without a
--- framework installed). Returns the chosen adapter name, or nil.
function Keystone.resolveAdapter()
  local pref = Keystone.Config.framework

  if pref and pref ~= 'auto' then
    local def = Keystone._adapters[pref]
    if def then Keystone.Adapter = def.build() return pref end
    print(('[keystone] configured framework "%s" not registered'):format(pref))
  end

  -- auto-detect a real framework (never auto-selects mock)
  for name, def in pairs(Keystone._adapters) do
    if name ~= 'mock' and def.detect and def.detect() then
      Keystone.Adapter = def.build()
      return name
    end
  end

  -- dev/load-test fallback
  if Keystone.Config.allowMockFallback and Keystone._adapters.mock then
    Keystone.Adapter = Keystone._adapters.mock.build()
    return 'mock'
  end

  return nil
end
