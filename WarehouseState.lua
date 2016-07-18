WarehouseState = {}
WarehouseState.__index = WarehouseState
WarehouseState.name = "Warehouse State"
WarehouseState.onLocation = false
WarehouseState.action = ""
WarehouseState.timer = 0


setmetatable(WarehouseState, { __call = function (cls, ...) return cls.new(...) end, })

function WarehouseState.new()

  local self = setmetatable({}, WarehouseState)
  
  WarehouseState.onLocation = false
  WarehouseState.action = ""
  return self
  
end

function WarehouseState:run()
  
    WarehouseState:moveToLocation()
end

-- Pulse function
function WarehouseState:pulse()
  
  local warehouse = Bot.profile:getWarehouse()
  local npc = Game:getNPC(warehouse:getName())
  
  if WarehouseState.onLocation then 
    
     if WarehouseState.action == "" then
      
      WarehouseState.action = "DIALOG_START"
      
      -- We have found our npc
      if npc then
        
        npc:InteractNpc()
        StateTradeManager.action = "DIALOG_TALKING"
        StateTradeManager.timer = Pyx.Win32.GetTickCount()
      end
      
    end
    
    if StateTradeManager.action == "DIALOG_TALKING" then
        
        if Pyx.Win32.GetTickCount() - StateTradeManager.timer > 2500 then
        
          BDOLua.Execute("Warehouse_OpenPanelFromDialog()")
          
          StateTradeManager.action = "DIALOG_STORE"
          StateTradeManager.timer = Pyx.Win32.GetTickCount()
          
        end        
    end
    
    if StateTradeManager.action == "DIALOG_STORE" then
        
      if Pyx.Win32.GetTickCount() - StateTradeManager.timer > 2500 then
      
          local toDeposit = GetSelfPlayer().Inventory.Money - 10000
          
          if toDeposit > 0 then
              GetSelfPlayer():WarehousePushMoney(npc, toDeposit)
          end
        
        StateTradeManager.action = "DIALOG_EXIT"
        StateTradeManager.timer = Pyx.Win32.GetTickCount()
        
      end        
    end
    
    if StateTradeManager.action == "DIALOG_EXIT" then
        
      if Pyx.Win32.GetTickCount() - StateTradeManager.timer > 2500 then
        
        Dialog.ClickExit()
  
        StateTradeManager.timer = Pyx.Win32.GetTickCount()
        Bot.currentState.state = ""
        
      end        
    end
  end
end

-- This method needs to be called
function WarehouseState:moveToLocation()
  
    local location = Bot.profile:getWarehouse()
    
    Bot:moveTo(location:getPosition())
end

function WarehouseState:onMovedToLocation()
  
  WarehouseState.onLocation = true
  
end