StateTradeManager = {}
StateTradeManager.__index = StateTradeManager
StateTradeManager.onLocation = false
StateTradeManager.name = "Trading State"
StateTradeManager.action = ""
StateTradeManager.timer = 0
StateTradeManager.whitelist = { 40218, 16026 }

setmetatable(StateTradeManager, { __call = function (cls, ...) return cls.new(...) end, })

function StateTradeManager.new()

  local self = setmetatable({}, StateTradeManager)
  
  StateTradeManager.onLocation = false
  StateTradeManager.action = ""
  return self
  
end

function StateTradeManager:run()
  
    StateTradeManager:moveToLocation()
end

-- Pulse function
function StateTradeManager:pulse()
  
  if StateTradeManager.onLocation then 
   
    if StateTradeManager.action == "" then
      
      StateTradeManager.action = "DIALOG_START"
        
      local trader = Bot.profile:getTrader()
      local npc = Game:getNPC(trader:getName())
      
      -- We have found our npc
      if npc then
        
        npc:InteractNpc()
        StateTradeManager.action = "DIALOG_TALKING"
        StateTradeManager.timer = Pyx.Win32.GetTickCount()
      end
      
    end
    
    if StateTradeManager.action == "DIALOG_TALKING" then
        
        if Pyx.Win32.GetTickCount() - StateTradeManager.timer > 2500 then
        
          BDOLua.Execute("HandleClickedFuncButton(getDialogButtonIndexByType(CppEnums.ContentsType.Contents_Shop))")
          
          StateTradeManager.action = "DIALOG_SELL"
          StateTradeManager.timer = Pyx.Win32.GetTickCount()
          
        end        
    end
    
    if StateTradeManager.action == "DIALOG_SELL" then
      if Pyx.Win32.GetTickCount() - StateTradeManager.timer > 2500 then
        
        TradeMarket.SellAll()
        StateTradeManager.timer = Pyx.Win32.GetTickCount()
        StateTradeManager.action = "DIALOG_CLOSE" 
      end
    end
    
    if StateTradeManager.action == "DIALOG_CLOSE" then
       
      if TradeMarket.IsTrading then
            TradeMarket.Close()
      end
      
      if Dialog.IsTalking then
          Dialog.ClickExit()
      end
        
      Bot.currentState.state = ""
    end

  end
end

-- state run
function StateTradeManager:run()
  
    StateTradeManager:moveToLocation()
end

-- This method needs to be called
function StateTradeManager:moveToLocation()
  
    local location = Bot.profile:getTrader()
    
    Bot:moveTo(location:getPosition())
end

function StateTradeManager:onMovedToLocation()
  
  StateTradeManager.onLocation = true
  
end