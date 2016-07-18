State = {}
State.__index = State

setmetatable(State, { __call = function (cls, ...) return cls.new(...) end, })

-- Constructor
function State.new()

    local self = setmetatable({}, State)

    return self
end

State.state = ""
State.callback = ""