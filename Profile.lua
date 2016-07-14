Profile = {}
Profile.__index = Location

setmetatable(Profile, { __call = function (cls, ...) return cls.new(...) end, })

-- Constructor
function Profile.new()

    local self = setmetatable({}, Location)

    -- Table with our possible locations
    self.locations = {
        
        trade = Location(),
        repair = Location(),
        fish = Location(),
        warehouse = Location()
    }

    self.name = ""

    -- Load debug values for now
    self.debug()

    -- Check if all the settings are valid
    if self.verify() then
        print("[Profile] current values have been verified")
    else
        print("[Profile] current values are not valid")
    end

end

-- Verifies if the current profile is valid
function Profile:verify()

    local valid = false

    for _,v in self.locations do
        valid = v.hasPosition()
    end

    return valid
end

--//
-- Getters
--//
function Profile:getFisher()

return self.locations["fish"]
end

function Profile:getTrader()

    return self.locations["trader"]
end

function Profile:getRepairer()

return self.locations["repair"]
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
    local fish = self.getFisher()

    fish.position.x = 100
    fish.position.y = 100
    fish.position.z = 100
    fish.position.rotation = 40

    fish.name = "Fishing Location"

    -- Setup our local repair location
    local repair = self.getRepairer()

    repair.position.x = 100
    repair.position.y = 100
    repair.position.z = 100

    repair.name = "John Doe"

    -- Setup our local trade location
    local trade = self.getTrader()

    trade.position.x = 100
    trade.position.y = 100
    trade.position.z = 100

    repair.name = "John Doe"

    -- Setup our local warehouse location
    local warehouse = self.getWarehouse()

    warehouse.position.x = 100
    warehouse.position.y = 100
    warehouse.position.z = 100

    repair.name = "John Doe"

    print("[Profile] Debug values have been loaded")

end