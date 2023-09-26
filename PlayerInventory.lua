--[[
    Player inventory state.
]]
PlayerInventory = Class{__includes = Base}

function PlayerInventory:init(player)

    -- player
    self.player = player

    -- flag for browsing inventory
    self.player.browsing_inventory = true

end

function PlayerInventory:update(dt)

    if love.keyboard.pressed('tab') then
        self.player.browsing_inventory = false
        self.player:changeState('idle')
    end

end