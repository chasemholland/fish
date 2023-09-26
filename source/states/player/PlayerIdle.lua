--[[
    Player idle state.
]]
PlayerIdle = Class{__includes = Base}

function PlayerIdle:init(player)

    -- player
    self.player = player

    -- change state timer for input
    self.timer = 0

end

function PlayerIdle:update(dt)

    -- get the current idle direction frame
    if self.player.direction == 'left' then
        self.player.frame = PLAYER_IDLE_LEFT
    elseif self.player.direction == 'right' then
        self.player.frame = PLAYER_IDLE_RIGHT
    elseif self.player.direction == 'up' then
        self.player.frame = PLAYER_IDLE_UP
    elseif self.player.direction == 'down' then
        self.player.frame = PLAYER_IDLE_DOWN
    end

    -- check for user input and switch to walking state
    if love.keyboard.isDown('a') or love.keyboard.isDown('d') or 
    love.keyboard.isDown('w') or love.keyboard.isDown('s') then
        self.player:changeState('walk')
    end

    -- enter shop if button pressed
    if love.mouse.pressed(1) and mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= 2 and mouseY <= 34 then
        -- pass the fifth tutorial
        if self.player.tutorial[5] == false then
            self.player.tutorial[5] = true
        end
        self.player.shopping = true
        self.player:changeState('shop')
    -- sell fish if button pressed
    elseif love.mouse.pressed(1) and mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= 36 and mouseY <= 68 then
        self:sellFish()
    -- see achievements
    elseif love.mouse.pressed(1) and mouseX >= GAME_WIDTH - 46 and mouseX <= GAME_WIDTH - 2 and mouseY >= 70 and mouseY <= 118 then
        -- pass the sixth and final tutorial
        if self.player.tutorial[6] == false then
            self.player.tutorial[6] = true
        end
        self.player:changeState('achievement')
    -- begin casting if holding left mouse button down
    elseif love.mouse.isDown(1) and mouseX < GAME_WIDTH - 82 and mouseY < 68 and self.timer > 1 then
        -- pass the second tutorial
        if self.player.tutorial[2] == false then
            self.player.tutorial[2] = true
        end
        self.player.casting = true
        self.player:changeState('casting')
    elseif love.mouse.isDown(1) and mouseY > 68 and self.timer > 1 then
        -- pass the second tutorial
        if self.player.tutorial[2] == false then
            self.player.tutorial[2] = true
        end
        self.player.casting = true
        self.player:changeState('casting')
    end

    -- open inventory
    if love.keyboard.pressed('tab') and not self.player.browsing then
        self.player:changeState('inventory')
    end

    -- timer only called on init, used to not allow casting when changing to idle from a different state
    if self.timer <= 1 then
        self:changeTimer(dt)
    end

end

function PlayerIdle:sellFish()

    -- pass the fourth tutorial
    if self.player.tutorial[4] == false then
        self.player.tutorial[4] = true
    end

    for i = 1, 5 do
        if self.player.inventory['fish'][i] ~= nil then
            if self.player.inventory['fish'][i] >= 1 and self.player.inventory['fish'][i] <= 4 then
                self.player.inventory['money'] = self.player.inventory['money'] + 100
                self.player.inventory['fish'][i] = nil
            elseif self.player.inventory['fish'][i] >= 5 and self.player.inventory['fish'][i] <= 8 then
                self.player.inventory['money'] = self.player.inventory['money'] + 200
                self.player.inventory['fish'][i] = nil
            elseif self.player.inventory['fish'][i] >= 9 and self.player.inventory['fish'][i] <= 12 then
                self.player.inventory['money'] = self.player.inventory['money'] + 300
                self.player.inventory['fish'][i] = nil
            elseif self.player.inventory['fish'][i] >= 13 and self.player.inventory['fish'][i] <= 16 then 
                self.player.inventory['money'] = self.player.inventory['money'] + 400
                self.player.inventory['fish'][i] = nil
            end
        end
    end
end

function PlayerIdle:changeTimer(dt)

    self.timer = self.timer + dt * 4

end