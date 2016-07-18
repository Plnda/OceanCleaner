Gui = {}

function Gui:draw()
  
  local _, shouldDisplay = ImGui.Begin("Black Ocean Fisher", true, ImVec2(400, 300), -1.0, ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoResize)
  
  if(shouldDisplay) then

    -- draw menu
    self:drawMenu()
    
    if ImGui.CollapsingHeader("Force Action", "id_debug", true, true) then
      
      ImGui.Columns(1)
      
      SettingsGui.npcName = Bot.profile:getNPCNameList()
        
      changed,  SettingsGui.npcLocationIndex = ImGui.Combo("Select NPC", SettingsGui.npcLocationIndex, SettingsGui.npcName)
      
      ImGui.Columns(1)
    
      if ImGui.Button("Start Action") then
        
        Bot:forceState(SettingsGui.npcLocationIndex)

      end
    end
    
    if Bot.currentState.state ~= "" then
      ImGui.Text("Current State: " .. Bot.currentState.state.name)
    end
    
    if Bot.currentState.state ~= "" then
      ImGui.Text("Current Action: " .. Bot.currentState.state.action)
    end
  
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
        
        if ImGui.MenuItem("Save Settings", "") then
            Bot.profile:save()
        end
        
        if ImGui.MenuItem("Load Settings", "") then
            Bot.profile:load()
        end
        
        if ImGui.MenuItem("Edit Settings", "") then
            
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
