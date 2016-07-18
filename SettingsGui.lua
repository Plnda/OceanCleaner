SettingsGui = {}

SettingsGui.visable = false
SettingsGui.npcLocationIndex = 0
SettingsGui.npcKey = {"Trader","Repairer","Warehouse","Vendor"}
SettingsGui.npcName = {}

function SettingsGui:draw()
  
  if SettingsGui.visable then
    
    local _, shouldDisplay = ImGui.Begin("Settings", SettingsGui.visable, ImVec2(400, 400), -1.0)
  
    if(shouldDisplay) then
      
      local selfPlayer = GetSelfPlayer()
      
      if ImGui.CollapsingHeader("NPC Location Settings", "id_location_editor", true, true) then
          
          ImGui.Columns(1)
        
          SettingsGui.npcName = Bot.profile:getNPCNameList()
        
          changed,  SettingsGui.npcLocationIndex = ImGui.Combo("Select NPC", SettingsGui.npcLocationIndex, SettingsGui.npcName) 
        
          -- Get the nearest npc
          local npc = Game.getNearestNPC()
          
          ImGui.Text("Nearest NPC: " .. npc.Name, ImVec2(300, 20))
          ImGui.SameLine()
          
          -- Saves location of the current selected npc
          if ImGui.Button("Save Location", ImVec2(100, 20)) then
            
              if SettingsGui.npcLocationIndex == 0 then 
                
                return false
              end
              
              local item = SettingsGui.npcName[SettingsGui.npcLocationIndex]
              
              local keys = item:split(":")
              
              local key = keys[1]
              
              -- Find the location object
              local location = Bot.profile.locations[key]
              
              -- Record location
              Bot:recordLocation(location)
              
          end
      end
      
      if ImGui.CollapsingHeader("Fish Location", "id_settings_fish", true, true) then
  
        ImGui.Columns(1)
        
        location = Bot.profile.fishLocations[1]

        if ImGui.Button("Set Current Location", ImVec2(150, 20)) then
            
            -- Get player
            local selfPlayer = GetSelfPlayer()
            
            -- For now only one location is supported
            location.position.x = selfPlayer.Position.X
            location.position.y = selfPlayer.Position.Y
            location.position.z = selfPlayer.Position.Z
            location.rotation = selfPlayer.Rotation
                         
        end
        
        ImGui.SameLine()
        
        if location:hasPosition() then
          ImGui.Text("Current Location: " .. round(location.position.x) .. ", " .. round(location.position.y) .. ", " .. round(location.position.z), ImVec2(150, 20))

      else
        
          ImGui.Text("Current Location: None", ImVec2(150, 20))
        end
      end
      
      if ImGui.CollapsingHeader("Path Settings", "id_profile_editor_mesh", true, true) then
        
            ImGui.Columns(2)

            _, Bot.PathRecorder.Enabled = ImGui.Checkbox("Enable Pather##profile_enable_mesher", Bot.PathRecorder.Enabled)
            ImGui.NextColumn()

            _, Bot.DrawPath = ImGui.Checkbox("Draw Path##profile_draw_mesher", Bot.DrawPath)
            ImGui.NextColumn()
            
            ImGui.Columns(1)
            
            if ImGui.Button("Remove Nearby Node(s)") then
              
                Bot.PathRecorder.Graph:RemoveNodesConnectionsInRadius(selfPlayer.Position.X, selfPlayer.Position.Y, selfPlayer.Position.Z, Bot.PathRecorder.RemoveRadius)
            end
      end

    ImGui.End()
    end
  end

end
