Profile = {}
Profile.__index = Profile

setmetatable(Profile, { __call = function (cls, ...) return cls.new(...) end, })

-- Constructor
function Profile.new()

    local self = setmetatable({}, Profile)

    -- Table with our possible locations
    self.locations = {
        
        trader = Location(),
        repairer = Location(),
        fisher = Location(),
        warehouse = Location()
    }

    self.name = ""

    -- Load debug values for now
    --self:debug()

    -- Check if all the settings are valid
    if self:verify() then
        print("[Profile] current values have been verified")
    else
        print("[Profile] current values are not valid")
    end
  
    return self
end

function Profile:save()
  
  local json = JSON:new()
  
  Pyx.FileSystem.WriteFile("\\Profiles\\profile.json", json:encode(self))
  Pyx.FileSystem.WriteFile("\\Profiles\\mesh.json", MyGraph.GetJSONFromGraph(Bot.PathRecorder.Graph))
  
end

function Profile:load()
    
  local json = JSON:new()
  
  local decoded = json:decode(Pyx.FileSystem.ReadFile("\\Profiles\\profile.json"))
  
  table.merge(Bot.profile, decoded)
  
  Bot.PathRecorder.Graph = MyGraph.LoadGraphFromJSON(Pyx.FileSystem.ReadFile("\\Profiles\\mesh.json"))
  Bot.pather.Graph = Bot.PathRecorder.Graph
end

-- Verifies if the current profile is valid
function Profile:verify()

    local valid = false

    for key, value in pairs(self.locations) do
        
        location = self.locations[key]
        
        valid = location:hasPosition()
    end

    return valid
end

--//
-- Getters
--//
function Profile:getFisher()

return self.locations["fisher"]
end

function Profile:getTrader()

    return self.locations["trader"]
end

function Profile:getRepairer()

return self.locations["repairer"]
end

function Profile:getWarehouse()

return self.locations["warehouse"]
end

--//
-- Debug
--//

-- Debug values
function Profile:debug()

    -- Setup our local fish location
    local fish = self:getFisher()

    fish.position.x = 100
    fish.position.y = 100
    fish.position.z = 100
    fish.position.rotation = 40

    fish.name = "Fishing Location"

    -- Setup our local repair location
    local repair = self:getRepairer()

    repair.position.x = 100
    repair.position.y = 100
    repair.position.z = 100

    repair.name = "John Doe"

    -- Setup our local trade location
    local trade = self:getTrader()

    trade.position.x = 100
    trade.position.y = 100
    trade.position.z = 100

    trade.name = "John Doe"

    -- Setup our local warehouse location
    local warehouse = self:getWarehouse()

    warehouse.position.x = 100
    warehouse.position.y = 100
    warehouse.position.z = 100

    repair.name = "John Doe"

    print("[Profile] Debug values have been loaded")

end