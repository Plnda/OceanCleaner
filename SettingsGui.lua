SettingsGui = {}

SettingsGui.visable = false

function SettingsGui:draw()
  
  if SettingsGui.visable then
    
    local _, shouldDisplay = ImGui.Begin("Paths", SettingsGui.visable, ImVec2(500, 500), -1.0)
  
    if(shouldDisplay) then
      
      if ImGui.CollapsingHeader("Record Path", "id_profile_editor_mesh", true, true) then
            ImGui.Columns(2)

            _, Bot.PathRecorder.Enabled = ImGui.Checkbox("Enable Pather##profile_enable_mesher", Bot.PathRecorder.Enabled)
            ImGui.NextColumn()

            _, Bot.DrawPath = ImGui.Checkbox("Draw Path##profile_draw_mesher", Bot.DrawPath)
            ImGui.NextColumn()
            _, Bot.PathRecorder.SnapToNode = ImGui.Checkbox("Snap to Node##profile_snaptonode", Bot.PathRecorder.SnapToNode)
            --            ImGui.SameLine();
            --            _, ProfileEditor.OneWay = ImGui.Checkbox("One Way##profile_oneway", ProfileEditor.OneWay)
            ImGui.Columns(1)
            if ImGui.Button("Remove Nodes") then
                Bot.PathRecorder.Graph:RemoveNodesConnectionsInRadius(selfPlayer.Position.X, selfPlayer.Position.Y, selfPlayer.Position.Z, Bot.PathRecorder.RemoveRadius)
            end
            ImGui.Text("")
            _, Bot.PathRecorder.RemoveRadius = ImGui.SliderInt("Remove Radius##profile_remove_redius", Bot.PathRecorder.RemoveRadius, 100, 1000)
            _, Bot.PathRecorder.SnapDistance = ImGui.SliderInt("Snap Distance##profile_snap_Dist", Bot.PathRecorder.RemoveRadius, 100, 800)

      end
    
    ImGui.End()
    end
    
    
  end

end
