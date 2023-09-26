--[[
    A state machine used to change game states.
]]

SM = Class{}

function SM:init(state)
    
    -- initialize an empty state with table full of expected empty functions
    self.emptySM = {
        enter = function() end,
        exit = function() end,
        update = function() end,
        render = function() end
    }

    -- initiaize state to a state or an empty table if not state
    self.state = state or {}

    -- initialize the current state to an empty state
    self.current_state = self.emptySM
end

-- function called to change between states
function SM:change(state, values_to_pass)

    -- make sure that the state changing to has been declared
    -- this will help make it easier to find bugs whenever SM:change is called
    assert(self.state[state])
    
    -- exit the current state
    self.current_state:exit()

    -- set the current state to the specified state
    self.current_state = self.state[state]()

    -- pass values if any into the enter function
    self.current_state:enter(values_to_pass)
end

-- update the state machine
function SM:update(dt)

    -- state machine will either continue to return if empty or update if state
    -- has been selected
    self.current_state:update(dt)
end

-- render all drawings
function SM:render()

    -- state machine will eaither just return or render drawings if in state
    self.current_state:render()
end