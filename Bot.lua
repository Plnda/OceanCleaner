Bot = {}
Bot.profile = Profile()
Bot.running = false
Bot.PathRecorder = PathRecorder:New(MyGraph())
Bot.pather = Pather:New(Bot.PathRecorder.Graph)
Bot.playerMoving = false
Bot.moveCheck = 0
Bot.moveIndex = 0
Bot.currentState = State()

-- Starts the bot
function Bot:start()
    
    self.running = true
    print("Bot has started")
end

-- Stops the bot
function Bot:stop()
    
      Bot.playerMoving = false
      
      self.pather:Stop()
      self.pather:Reset()
      
      self.running = false
      
      -- Reset the bot state
      Bot.currentState.state = ""
      
      Bot.moveCheck = 0
    
    print("Bot has stopped")
end

-- Pulse
function Bot:onPulse()
  
  self.pather:Pulse()
  
  if self.running then
    
    Bot:run()
    
    -- Run the current states pulse
    if Bot.currentState.state ~= "" then
      
        Bot.currentState.state:pulse()
    end
    
  end
  
  self:onPlayerMoveCheck()
  
end

function Bot:run()

  -- Start running to our fishing spot
  if Bot.currentState.state == "" then
    
      -- Try to get a rod from our inventory
      local rod = Game:getFishingRod()
      
      -- Try to see if we have a rod equiped
      if not rod then
        rod = GetSelfPlayer():GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)
      end
      
      -- Do we have a rod?
      if rod then
        
        -- Is our rod broken 
        if rod.EndurancePercent <= 20 then
          
          -- Do we have a rod equiped
          if GetSelfPlayer():GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND) then
            StateFishing():dequipRod()
          end
          
          -- Go and repair that sucker
          Bot.currentState.state = RepairState()  
          
        end
      end
      
      -- Do we have less or two inventory slots left?
      if Game:getFreeInventorySlots() <= 2 then
        
        -- Do we have something equipped ?
        if GetSelfPlayer():GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND) then
          StateFishing():dequipRod()
        end
        
        -- Go sell our inventory
        Bot.currentState.state = StateTradeManager()
        
      end
      
      if GetSelfPlayer().WeightPercent >= 90 then
        
        -- Do we have something equipped ?
        if GetSelfPlayer():GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND) then
          StateFishing():dequipRod()
        end
        
        Bot.currentState.state = WarehouseState()
    end
      
      -- None of the above apply so we can fish
      if Bot.currentState.state == "" then
        Bot.currentState.state = StateFishing()
      end
    
  end
  
  -- If we have a state we can run it
  if Bot.currentState.state ~= "" then
    Bot.currentState.state:run()
  end
 
end

function Bot:debugMove()
  
   -- Debug makes us run to the next npc in the list
  if not self.playerMoving then
    
    if self.moveIndex + 1 > #SettingsGui.npcKey then
      self.moveIndex = 1
    else
      self.moveIndex = self.moveIndex + 1
    end
    
    local key = SettingsGui.npcKey[Bot.moveIndex]
    
    local location = self.profile.locations[key]
    
    Bot:moveTo(location:getPosition())
    
  end
  
end

-- Moves the character to a destination
function Bot:moveTo(destination)

  if not Bot.playerMoving then
    
    Bot.pather.pathRecorder = Bot.pathRecorder
    Bot.pather:Reset()
    
    Bot.pather:PathTo(destination)
    
    Bot.playerMoving = true
  
  end 
end

-- Saves a location
function Bot:recordLocation(location)

  local npcs = GetNpcs()
        
  if table.length(npcs) > 0 then
    
    local TradeManagerNpc = npcs[1]

    location.name = TradeManagerNpc.Name
    location.position.x = TradeManagerNpc.Position.X
    location.position.y = TradeManagerNpc.Position.Y
    location.position.z = TradeManagerNpc.Position.Z
    
    print("Location " .. location:getName() .. " was saved")
    
  end
end

-- Checks if a user is within the destination NPC distance and stops moving
function Bot:onPlayerMoveCheck()
  
  if(Bot.playerMoving) then
    
    -- Are we not running atm
    if not Bot.pather.Running then
      
      Bot.moveCheck = Bot.moveCheck + 1
    end
    
    -- We should move but havent move for 20 checks
    if Bot.moveCheck > 20 then
      
      Bot.playerMoving = false
      
      self.pather:Stop()
      self.pather:Reset()
      
      Bot.moveCheck = 0
    end
    
    local distance = self.pather.Destination.Distance3DFromMe;
    
    if(distance < 150) then
      
      self.pather:Stop()
      self.pather:Reset()
      
      -- Run callback
      if Bot.currentState.state ~= "" and Bot.currentState.state.onLocation == false then
        Bot.currentState.state:onMovedToLocation()
      end
      
      Bot.playerMoving = false
      Bot.moveCheck = 0 
      
    end
  end
end

function Bot:forceState(index)
 
  local item = SettingsGui.npcName[index]
  local keys = item:split(":")
  local key = keys[1]
  local state = ""
  
  -- If we are moving we should stop!
  Bot.playerMoving = false

  Bot.pather:Stop()
  Bot.pather:Reset()

  Bot.moveCheck = 0
  
  -- Do we have something equipped ?
  if GetSelfPlayer():GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND) then
    StateFishing():dequipRod()
  end

  if key == "Warehouse" then
    state = WarehouseState()
  end
  
  if key == "Trader" then
    state = StateTradeManager()
  end
  
  if key == "Repairer" then
    state = RepairState()
  end
  
  if state ~= "" then
    Bot.currentState.state = state
  end
  
end


-- Renders the 3D positions of the recorded or loaded path
function Bot:onRender3D()

    local selfPlayer = GetSelfPlayer()
    local maxDistance = 20000

    Bot.PathRecorder:Pulse()

    if Bot.DrawPath and selfPlayer then
        local myPosition = MyNode(selfPlayer.Position.X, selfPlayer.Position.Y, selfPlayer.Position.Z)

        for k, v in pairs(Bot.profile.fishLocations) do
         
          if selfPlayer.Position:GetDistance3D(Vector3(v.position.x, v.position.y, v.position.z)) <= maxDistance then
             Renderer.Draw3DTrianglesList(GetInvertedTriangleList(v.position.x, v.position.y + 100, v.position.z, 100, 150, 0xAAFF0000, 0xAAFF00FF))
          end
        end
        

        for key, v in pairs(Bot.PathRecorder.Graph:GetNodes()) do
            if myPosition:GetDistance3D(v) <= maxDistance then
                Renderer.Draw3DTrianglesList(GetInvertedTriangleList(v.X, v.Y + 25, v.Z, 25, 38, 0xAAFF0000, 0xAAFF00FF))
            end
        end

        local linesList = { }

        for key, v in pairs(Bot.PathRecorder.Graph:GetConnectionsList()) do
            if v.FromNode ~= nil and v.ToNode ~= nil then
                if myPosition:GetDistance3D(v.FromNode) <= maxDistance and myPosition:GetDistance3D(v.ToNode) <= maxDistance then
                    table.insert(linesList, { v.ToNode.X, v.ToNode.Y + 20, v.ToNode.Z, 0xFFFFFFFF })
                    table.insert(linesList, { v.FromNode.X, v.FromNode.Y + 20, v.FromNode.Z, 0xFFFFFFFF })

                end
            end
        end

        if table.length(linesList) > 0 then
            Renderer.Draw3DLinesList(linesList)
        end

    end

end
