StateFishing = {}
StateFishing.__index = StateFishing
StateFishing.name = "Fishing State"
StateFishing.onLocation = false
StateFishing.action = ""
StateFishing.timer = 0
StateFishing.whitelist = { 40218, 16026 }

setmetatable(StateFishing, { __call = function (cls, ...) return cls.new(...) end, })

function StateFishing.new()

  local self = setmetatable({}, StateFishing)
  
  StateFishing.onLocation = false
  StateFishing.action = ""
  return self
  
end

-- state run

function StateFishing:run()
  
    StateFishing:moveToLocation()
end

-- Pulse function
function StateFishing:pulse()
  
  -- We are on location
  if StateFishing.onLocation then 
    
    if StateFishing.action == "" then
      
      StateFishing.action = "EQUIPING_ROD"
      StateFishing:equipRod()
      StateFishing.timer = Pyx.Win32.GetTickCount()
    end
    
    if StateFishing.action == "ROD_EQUIPPED" then
      
      -- Wait for 1.5 seconds
      if Pyx.Win32.GetTickCount() - StateFishing.timer > 1500 then
      StateFishing.timer = 0
      StateFishing.action = "START_FISHING"
      StateFishing:castRod()
      
      StateFishing.timer = Pyx.Win32.GetTickCount()
  
      end
    end
    
    if StateFishing.action == "WAITING_FISH" then
      
        if GetSelfPlayer().CurrentActionName == "FISHING_HOOK_ING" then
          Keybindings.HoldByActionId(KEYBINDING_ACTION_JUMP, 500)
          StateFishing.action = "HOOK_FISH"
          StateFishing.timer = Pyx.Win32.GetTickCount()
        end
    end
    
    if StateFishing.action == "HOOK_FISH" then
        
        if Pyx.Win32.GetTickCount() - StateFishing.timer > 3500 then
          
          BDOLua.Execute("getSelfPlayer():get():SetMiniGameResult(11)")
          StateFishing.timer = Pyx.Win32.GetTickCount()
          StateFishing.action = "HOOK_FISH_MINIGAME"
        end
        
        
    end
    
    if StateFishing.action == "HOOK_FISH_MINIGAME" then
      
        if Pyx.Win32.GetTickCount() - StateFishing.timer > 3500 then
          StateFishing.timer = 0
          BDOLua.Execute("getSelfPlayer():get():SetMiniGameResult(2)")
          StateFishing.action = "LOOTING"
          StateFishing.timer = Pyx.Win32.GetTickCount()
        end
    end
    
    if StateFishing.action == "LOOTING" then
        
        if  Pyx.Win32.GetTickCount() - StateFishing.timer > 1500 then
          
          StateFishing:lootContainer()
          StateFishing.action = ""
          StateFishing.timer = Pyx.Win32.GetTickCount()
          
          -- State has finished we should inform our bot that it can do the state cycle again
          Bot.currentState.state = ""
          StateFishing.action = ""
        
        end
    end

  end
end

function StateFishing:castRod()
  
  -- Current Fishing Location
  local location = Bot.profile.fishLocations[1]
  
  -- Rotate to the fishing spot
  GetSelfPlayer():SetRotation(location:getRotation())
  
  -- Start fishing
  Keybindings.HoldByActionId(KEYBINDING_ACTION_JUMP, 500)
  
  StateFishing.action = "WAITING_FISH"
end

function StateFishing:lootContainer()
    
    if Looting.IsLooting then 
      
      local numLoots = Looting.ItemCount
      
      -- Loop over the loot we have 
      for i=0,numLoots-1 do 
          
          local shouldTake = false
          local loot = Looting.GetItemByIndex(i)
          
          -- Loop over our whitlist
          for _, v in pairs(StateFishing.whitelist) do
            
            -- We have a whitelist match
            if v == loot.ItemEnchantStaticStatus.ItemId then
              shouldTake = true
            end
          end
          
          -- Increase our caught 
          Bot.statistics.totalCaught = Bot.statistics.totalCaught + 1
          
          -- Loop over the quality
          if loot.ItemEnchantStaticStatus.Grade ~= 0 and loot.ItemEnchantStaticStatus.Grade ~= 1 then
            shouldTake = true
          end
          
          if shouldTake then
            Bot.statistics:addLoot(loot)
            Looting.Take(i)
          else
            Bot.statistics:addTrash()
          end
          
      end

    end
end

-- This method needs to be called
function StateFishing:moveToLocation()
  
    local location = Bot.profile.fishLocations[1]
    
    Bot:moveTo(location:getPosition())
end

function StateFishing:onMovedToLocation()
  
  StateFishing.onLocation = true
  
end

-- Equips a rod
function StateFishing:equipRod()

  local rod = Game:getFishingRod()
  
  if rod then
    rod:UseItem()
  end
  
  if GetSelfPlayer():GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND) then
    StateFishing.action = "ROD_EQUIPPED"
  else
    StateFishing.action = ""
  end
  
end

-- Dequips a rod
function StateFishing:dequipRod()
  
  local selfPlayer = GetSelfPlayer()
  selfPlayer:UnequipItem(INVENTORY_SLOT_RIGHT_HAND)
end