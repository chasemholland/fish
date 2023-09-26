--[[
    Player walking state.
]]
PlayerWalk = Class{__includes = Base}

function PlayerWalk:init(player)

    -- player
    self.player = player

    -- player direction
    self.direction = self.player.direction

    -- animation timer
    self.timer = 0

    -- transition to another area
    self.transition = false
    self.transition_direction = ''

end

function PlayerWalk:update(dt)

    if self.transition == false then
        -- get user input for movement
        if love.keyboard.isDown('a') then
            self.player.direction = 'left'
            -- pass the first tutorial
            if self.player.tutorial[1] == false then
                self.player.tutorial[1] = true
            end
        elseif love.keyboard.isDown('d') then
            self.player.direction = 'right'
            -- pass the first tutorial
            if self.player.tutorial[1] == false then
                self.player.tutorial[1] = true
            end
        elseif love.keyboard.isDown('w') then
            self.player.direction = 'up'
            -- pass the first tutorial
            if self.player.tutorial[1] == false then
                self.player.tutorial[1] = true
            end
        elseif love.keyboard.isDown('s') then
            self.player.direction = 'down'
            -- pass the first tutorial
            if self.player.tutorial[1] == false then
                self.player.tutorial[1] = true
            end
        else
            self.player:changeState('idle')
        end

        -- player animation
        self:changeAnimation(self.player.direction, dt)

        -- player movement
        if self.player.area == 'start' then
            self:walkStart(dt, self.player.direction)
        elseif self.player.area == 'beach' then
            self:walkBeach(dt, self.player.direction)
        end

        -- set the direction frame when key is first down
        if self.player.direction ~= self.direction then
            self:getFrame()
        end

    -- if player transitioning
    else
        if self.transition_direction == 'left' then
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
            -- player animation
            self:changeAnimation(self.player.direction, dt)
            if self.player.x + 32 <= 0 then
                self.player.area = 'river'
                self.transition = false
            end
        elseif self.transition_direction == 'rigt' then
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
            -- player animation
            self:changeAnimation(self.player.direction, dt)
            if self.player.x + 32 >= GAME_WIDTH then
                self.player.area = 'beach'
                self.transition = false
            end
        end
    end
end

-- make the player move
function PlayerWalk:walkStart(dt, direction)

    if direction == 'left' then
        if self:checkCollision('left_wall') then
            self.player.x = 0
        elseif self:checkTransition('left_wall') then
            self.transition = true
            self.transition_direction = 'left'
        else
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        end
    elseif direction == 'right' then
        if self:checkCollision('right_wall') then
            self.player.x = GAME_WIDTH - 64
        elseif self:checkTransition('right_wall') then
            self.transition = true
            self.transition_direction = 'right'
        else
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        end
    elseif direction == 'up' then
        if self:checkCollision('top_wall') then
            self.player.y = 0
        else
            self.player.y = self.player.y - PLAYER_WALK_SPEED * dt
        end
    elseif direction == 'down' then
        if self:checkCollision('water') then
            self.player.y = WATER_TOP - 64
        else
            self.player.y = self.player.y + PLAYER_WALK_SPEED * dt
        end
    end

end

-- make the player move
function PlayerWalk:walkBeach(dt, direction)

    if direction == 'left' then
        if self:checkBeachCollision('left_wall') then
            self.player.x = 48
        else
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        end
    elseif direction == 'right' then
        if self:checkBeachCollision('right_wall') then
            self.player.x = GAME_WIDTH / 2 - 32
        else
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        end
    elseif direction == 'up' then
        if self:checkBeachCollision('top_wall') then
            self.player.y = 0
        else
            self.player.y = self.player.y - PLAYER_WALK_SPEED * dt
        end
    elseif direction == 'down' then
        if self:checkBeachCollision('water') then
            self.player.y = GAME_HEIGHT - 72
        else
            self.player.y = self.player.y + PLAYER_WALK_SPEED * dt
        end
    end

end

-- check collision with water
function PlayerWalk:checkCollision(surface)
    
    if surface == 'left_wall' then
        if self.player.y + 56 < 96 then
            if self.player.x + 16 <= 16 then
                return true
            else
                return false
            end
        elseif self.player.y + 56 > 128 then
            if self.player.x + 16 <= 16 then
                return true
            else
                return false
            end
        else
            return false
        end
    elseif surface == 'right_wall' then
        if self.player.y + 56 < 96 then
            if self.player.x + 48 >= GAME_WIDTH - 16 then
                return true
            else
                return false
            end
        elseif self.player.y + 56 > 128 then
            if self.player.x + 48 >= GAME_WIDTH - 16 then
                return true
            else
                return false
            end
        else 
            return false
        end
    elseif surface == 'top_wall' then
        if self.player.y + 32 <= 32 then
            return true
        else
            return false
        end
    elseif surface == 'water' then
        if self.player.y + 64 >= WATER_TOP then
            return true
        else
            return false
        end
    end

end

function PlayerWalk:checkTransition(surface)

    if surface == 'left_wall' then
        if self.player.x + 16 <= 16 then
            if self.player.y + 56 > 96 and self.player.y + 56 < 128 then
                return true
            else
                return false
            end
        else
            return false
        end
    elseif surface == 'right_wall' then
        if self.player.x + 48 >= GAME_WIDTH - 16 then
            if self.player.y + 56 > 96 and self.player.y + 56 < 128 then
                return true
            else
                return false
            end
        end
    end
end

-- check collision with water
function PlayerWalk:checkBeachCollision(surface)
    
    if surface == 'left_wall' then
        if self.player.y + 56 < GAME_HEIGHT - 16 then
            if self.player.x + 16 <= 64 then
                return true
            else
                return false
            end
        elseif self.player.y + 56 > GAME_HEIGHT + 16 then
            if self.player.x + 16 <= 64 then
                return true
            else
                return false
            end
        else
            return false
        end
    elseif surface == 'right_wall' then
        if self.player.x + 48 >= GAME_WIDTH / 2 + 16 then
            return true
        else 
            return false
        end
    elseif surface == 'top_wall' then
        if self.player.y + 32 <= 32 then
            return true
        else
            return false
        end
    elseif surface == 'water' then
        if self.player.y + 64 >= GAME_HEIGHT - 8 then
            return true
        else
            return false
        end
    end

end

function checkBeachTransition(surface)

    if surface == 'left_wall' then
        if self.player.x + 16 <= 64 then
            return true
        else
            return false
        end
    end
end

-- get the current direction frame
function PlayerWalk:getFrame()

    if self.player.direction == 'left' then
        self.player.frame = PLAYER_IDLE_LEFT
    elseif self.player.direction == 'right' then
        self.player.frame = PLAYER_IDLE_RIGHT
    elseif self.player.direction == 'up' then
        self.player.frame = PLAYER_IDLE_UP
    elseif self.player.direction == 'down' then
        self.player.frame = PLAYER_IDLE_DOWN
    end

    self.direction = self.player.direction
end

-- cycle through animations
function PlayerWalk:changeAnimation(direction, dt)
    self.timer = self.timer + dt*6

    if self.timer > 1 then
        if direction == 'left' then
            if self.player.frame == 9 then
                self.player.frame = 10
                self.timer = 0
            elseif self.player.frame == 10 then
                self.player.frame = 11
                self.timer = 0
            elseif self.player.frame == 11 then
                self.player.frame = 12
                self.timer = 0
            elseif self.player.frame == 12 then
                self.player.frame = 9
                self.timer = 0
            end
        elseif direction == 'right' then
            if self.player.frame == 13 then
                self.player.frame = 14
                self.timer = 0
            elseif self.player.frame == 14 then
                self.player.frame = 15
                self.timer = 0
            elseif self.player.frame == 15 then
                self.player.frame = 16
                self.timer = 0
            elseif self.player.frame == 16 then
                self.player.frame = 13
                self.timer = 0
            end
        elseif direction == 'up' then
            if self.player.frame == 1 then
                self.player.frame = 2
                self.timer = 0
            elseif self.player.frame == 2 then
                self.player.frame = 3
                self.timer = 0
            elseif self.player.frame == 3 then
                self.player.frame = 4
                self.timer = 0
            elseif self.player.frame == 4 then
                self.player.frame = 1
                self.timer = 0
            end
        elseif direction == 'down' then
            if self.player.frame == 5 then
                self.player.frame = 6
                self.timer = 0
            elseif self.player.frame == 6 then
                self.player.frame = 7
                self.timer = 0
            elseif self.player.frame == 7 then
                self.player.frame = 8
                self.timer = 0
            elseif self.player.frame == 8 then
                self.player.frame = 5
                self.timer = 0
            end
        end
    end

end