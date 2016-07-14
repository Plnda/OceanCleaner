Location = {}
Location.__index = Location

setmetatable(Location, { __call = function (cls, ...) return cls.new(...) end, })

function Location.new()

    local self = setmetatable({}, Location)

    self.position = { x = 0, y = 0, z = 0 }
    self.name = ""
    self.rotation = 0
end

-- Returns a vector3 of our position
function Location:getPosition()

    return Vector3(self.position.x, self.position.y, self.position.z)
end

-- Returns the name of the location
function Location:getName()

    return self.name
end

-- Returns the rotation on our position
function Location:getRotation()

    return self.rotation
end

-- Checks if we have a valid postition
function Location:hasPosition()

    return self.position.x ~= 0 and self.position.y ~= 0 and self.position.x ~= 0
end

