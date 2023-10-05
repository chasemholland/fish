--[[
    Player achievement state.
]]
PlayerAchievement = Class{__includes = Base}

function PlayerAchievement:init(player)

    -- player
    self.player = player

end

function PlayerAchievement:update(dt)

    -- press escape to exit shop
    if love.mouse.pressed(1) and mouseX >= 2 and mouseX <= 82 and mouseY >= 2 and mouseY <= 34 then
        self.player.browsing_achievements = false
        self.player.paused = false
        self.player:changeState('idle')
    end

end