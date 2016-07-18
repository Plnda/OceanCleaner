Game = {}

function Game:getNearestNPC()
  
  local npcs = GetNpcs()
  
  return npcs[1]
  
end

function Game:getNPC(name)
  
  local npcs = GetNpcs()
  
  -- Loop over the NPC names
  for k, v in pairs(npcs) do
    
    -- Did we find our npc
    if(v.Name == name) then
      
      return v
    end
  end
end

function Game:getFreeInventorySlots()
    
    return GetSelfPlayer().Inventory.FreeSlots
end

function Game:getInventory()
    
    local selfPlayer = GetSelfPlayer()
    
    local items = selfPlayer.Inventory.Items
    
    table.sort(items, function(a, b) return a.Endurance < b.Endurance end)
    
    return items
end

function Game:getFishingRod()
  
  local items = Game:getInventory()
  local rod
  
  for k, v in pairs(items) do
    
      if v.ItemEnchantStaticStatus.IsFishingRod then
        rod = v
      end
  end
  
  return rod
  
end