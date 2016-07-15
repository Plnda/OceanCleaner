
Gui = {}

function Gui:draw()
  
  local _, shouldDisplay = ImGui.Begin("Ocean Cleaner", true, ImVec2(500, 500), -1.0, ImGuiWindowFlags_MenuBar)
  
  if(shouldDisplay) then
    
    local selfPlayer = GetSelfPlayer()
    
    -- draw menu
    self:drawMenu()
    
    if ImGui.CollapsingHeader("Debug", "id_debug", true, true) then
      
      ImGui.Columns(2)
      
      -- Debug button
      if ImGui.Button("Save trader") then
        
        Bot:recordLocation(Bot.profile:getTrader())
        
      end
      
      ImGui.SameLine()
      
      if ImGui.Button("Move to trader") then
          
        local trade = Bot.profile:getTrader()
    
        print("Moving to " .. trade:getName())
    
        Bot:moveTo(trade:getPosition())

      end
    
      ImGui.NextColumn()
      
      if ImGui.Button("Save Settings") then
        
        Bot.profile:save()
      end
      
      ImGui.SameLine()
      
      if ImGui.Button("Load Settings") then
        
        Bot.profile:load()
        
      end
    
    end
    
    ImGui.Columns(1)
    ImGui.NextColumn()
  
  end

  ImGui.End()
end

function Gui:drawMenu()

  if ImGui.BeginMenuBar() then
    
		if ImGui.BeginMenu("Bot") then
      
      if ImGui.MenuItem("Start/Stop", "") then
        
        -- Are we running the bot ?
        if Bot.running then
          
          -- Stop the bot
          Bot:stop()
        else
        
          -- Start the bot
          Bot:start()
        end
          
      end
    ImGui.EndMenu()
    end
  
    if ImGui.BeginMenu("Settings") then
        
        if ImGui.MenuItem("Edit Locations", "") then
            
        end
        
        if ImGui.MenuItem("Edit Paths", "") then
            
            if not SettingsGui.visable then
              
              SettingsGui.visable = true
              
            else
              
              SettingsGui.visable = false
            end
        end
        
      ImGui.EndMenu()
      end
  
  ImGui.EndMenuBar()
  end
end
