RepairState = {}
RepairState.__index = RepairState
RepairState.onLocation = false
RepairState.name = "Repair State"
RepairState.action = ""
RepairState.timer = 0


setmetatable(RepairState, { __call = function (cls, ...) return cls.new(...) end, })

function RepairState.new()

  local self = setmetatable({}, RepairState)
  
  RepairState.onLocation = false
  RepairState.action = ""
  RepairState.timer = 0
  return self
  
end

-- Pulse function
function RepairState:pulse()
  
    if RepairState.onLocation then 
    
      if RepairState.action == "" then
        if Pyx.Win32.GetTickCount() - RepairState.timer > 2500 then
          
          RepairState.action = "DIALOG_START"
          
          local repairer = Bot.profile:getRepairer()
          local npc = Game:getNPC(repairer:getName())
          
          -- We have found our npc
          if npc then
            
            npc:InteractNpc()
            RepairState.action = "DIALOG_TALKING"
            
          end
        end
      end
      
      if RepairState.action == "DIALOG_TALKING" then
        
        if Pyx.Win32.GetTickCount() - RepairState.timer > 2500 then
          
          --BDOLua.Execute("MessageBox.keyProcessEscape()")
          BDOLua.Execute("HandleClickedFuncButton(getDialogButtonIndexByType(CppEnums.ContentsType.Contents_Repair))")
          
          RepairState.action = "DIALOG_REPAIR"
          RepairState.timer = Pyx.Win32.GetTickCount()
          
        end        
      end
      
      if RepairState.action == "DIALOG_REPAIR" then
        
        if Pyx.Win32.GetTickCount() - RepairState.timer > 3500 then
          local lua = [[
            PaGlobal_Repair:messageBoxRepairAllInvenItem()
            PaGlobal_Repair:cursor_PosUpdate()
          ]]
          
          BDOLua.Execute(lua)
          
          RepairState.action = "DIALOG_CONFIRM"
          RepairState.timer = Pyx.Win32.GetTickCount()
        end
        
      end
      
      if RepairState.action == "DIALOG_CONFIRM" then
        
        if Pyx.Win32.GetTickCount() - RepairState.timer > 2500 then
          
          BDOLua.Execute("MessageBox.keyProcessEnter()")  
          RepairState.action = "DIALOG_REPAIRED"
          RepairState.timer = Pyx.Win32.GetTickCount()
        end
      end
      
      if RepairState.action == "DIALOG_REPAIRED" then
        
        if Pyx.Win32.GetTickCount() - RepairState.timer > 2500 then
      
          BDOLua.Execute("MessageBox.keyProcessEscape()")
          RepairState.timer = Pyx.Win32.GetTickCount()
          RepairState.action = "DIALOG_FLUSH"
        end
      end
    
      if RepairState.action == "DIALOG_FLUSH" then
         
        if Pyx.Win32.GetTickCount() - RepairState.timer > 1500 then
          
         BDOLua.Execute("HandleClickedBackButton()") 
         RepairState.timer = Pyx.Win32.GetTickCount()
         RepairState.action = "DIALOG_EXIT"

        end
      end
      
      if RepairState.action == "DIALOG_EXIT" then
        
        if Pyx.Win32.GetTickCount() - RepairState.timer > 1500 then
          
          Dialog.ClickExit()
          Bot.currentState.state = ""
        end
      end
    end
end

-- state run
function RepairState:run()
  
    RepairState:moveToLocation()
end

-- This method needs to be called
function RepairState:moveToLocation()
  
    local location = Bot.profile:getRepairer()
    
    Bot:moveTo(location:getPosition())
end

function RepairState:onMovedToLocation()
  print("test")
  RepairState.onLocation = true
  RepairState.timer = Pyx.Win32.GetTickCount()
end