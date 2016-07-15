Bot = {}
Bot.profile = Profile()
Bot.running = false
Bot.PathRecorder = PathRecorder:New(MyGraph())
Bot.pather = Pather:New(Bot.PathRecorder.Graph)
Bot.playerMoving = false
Bot.moveCheck = 0

-- Starts the bot
function Bot:start()
    
    self.running = true
    print("Bot has started")
end

-- Stops the bot
function Bot:stop()
    
    self.running = false
    print("Bot has stopped")
end

-- Pulse
function Bot:onPulse()
  
  self.pather:Pulse()
  
  self:onPlayerMoveCheck()
  
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
    
    if(distance < 190) then
      
      self.pather:Stop()
      self.pather:Reset()
      
      Bot.playerMoving = false
    end
  end
end


-- Renders the 3D positions of the recorded or loaded path
function Bot:onRender3D()

    local selfPlayer = GetSelfPlayer()
    local maxDistance = 20000
    local selfPlayer = GetSelfPlayer()

    Bot.PathRecorder:Pulse()

    if Bot.DrawPath and selfPlayer then
        local myPosition = MyNode(selfPlayer.Position.X, selfPlayer.Position.Y, selfPlayer.Position.Z)

        --for k, v in pairs(Bot.CurrentProfile.Hotspots) do
        --    if selfPlayer.Position:GetDistance3D(Vector3(v.X,v.Y,v.Z)) <= maxDistance then
        --        Renderer.Draw3DTrianglesList(GetInvertedTriangleList(v.X, v.Y + 100, v.Z, 100, 150, 0xAAFF0000, 0xAAFF00FF))
        --    end
        --end

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
