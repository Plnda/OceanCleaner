Statistics = {}
Statistics.__index = Statistics

Statistics.loot = {}
Statistics.totalCaught = 0

setmetatable(Statistics, { __call = function (cls, ...) return cls.new(...) end, })

function Statistics.new()

    local self = setmetatable({}, Statistics)
    
    self.totalCaught = 0
    return self
end

function Statistics:getList()
  
  local list = {}
  local idx = 1
  
  for key, value in pairs(Statistics.loot) do
       
      local percentage = round(tonumber(tonumber(value) / tonumber(self.totalCaught) * 100))
      
      list[idx] = key .. ": " .. value .. " (" .. percentage ..  "%)"
      
      idx = idx + 1
  end
  
  return list
end

function Statistics:addTrash()
  
  if Statistics.loot["Trash"] then
    Statistics.loot["Trash"] = Statistics.loot["Trash"] + 1
  else
    Statistics.loot["Trash"] = 1
  end
  
end

function Statistics:addLoot(loot)
  
  local name = loot.ItemEnchantStaticStatus.Name
  
  local found = false
  
  -- Moray and Grunts act strange
  if loot.ItemEnchantStaticStatus.ItemId == 8329 then
    name = "Moray"
  end
  
  -- Moray and Grunts act strange
  if loot.ItemEnchantStaticStatus.ItemId == 8261 then 
    name = "Grunt"
  end
  
  -- Loop over our loot table
  for key, value in pairs(Statistics.loot) do
  
    -- Do we have it stored ?
    if key == name then
      
      found = true   
      Statistics.loot[key] = Statistics.loot[key] + 1
    end
  end
  
  -- Create a new record
  if not found then
    
    Statistics.loot[name] = 1
    
  end
  
end