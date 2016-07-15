Pyx.Scripting.CurrentScript:RegisterCallback("Pyx.OnScriptStart", function()

  print("Starting OceanCleaner") 
  
end)

Pyx.Scripting.CurrentScript:RegisterCallback("Pyx.OnScriptStop", function()
    
  print("Stopping OceanCleaner")    
  
end)

Pyx.Scripting.CurrentScript:RegisterCallback("ImGui.OnRender", function()
  
  Gui:draw()     
  SettingsGui:draw()
  
end)

Pyx.Scripting.CurrentScript:RegisterCallback("PyxBDO.OnPulse", function()
  
  Bot:onPulse()
  
end)

Pyx.Scripting.CurrentScript:RegisterCallback("PyxBDO.OnRender3D", function()
    
  Bot:onRender3D()
  
end)