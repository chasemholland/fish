--[[
    Enemies Walk
]]

EnemiesWalk = Class {__includes = Base}

function EnemiesWalk:init(enemy, player)

    -- enemy
    self.enemy = enemy

    -- player
    self.player = player

    -- walk timer
    self.timer = 0

    -- how long to move
    self.move = 0

    -- what direction to change
    self.change = math.random(1, 4)

end


function EnemiesWalk:update(dt)
    
    -- force dead entities to idle
    if self.enemy.dead or self.player.paused then
        self.enemy:changeState('idle')
    else
    
        -- play squish sound
        Sounds['squish']:play()

        -- enemy walk
        if self.move > 12 then
            if self.change == 1 then
                self.enemy.direction = 'up'
                self.enemy:changeState('idle')
            elseif self.change == 2 then
                self.enemy.direction = 'down'
                self.enemy:changeState('idle')
            elseif self.change == 3 then
                self.enemy.direction = 'left'
                self.enemy:changeState('idle')
            elseif self.change == 4 then
                self.enemy.direction = 'right'
                self.enemy:changeState('idle')
            end
        else
            if self.enemy.area == 'river' then
                self:changeAnimation(self.enemy.color, self.enemy.direction, dt)
                self:moveRiver(dt, self.enemy.direction)
                if self:checkPlayerCollision(self.enemy.direction, self.player) then
                    -- decrement player health
                    if self.player.health > 0 then
                        self.player.health = self.player.health - 1
                    end
                    -- play hurt sound
                    Sounds['hurt']:play()
                    -- set player to hurt
                    self.player.hurt['hit'] = true
                    -- force enemy to idle
                    self.enemy:changeState('idle')
                end
            elseif self.enemy.area == 'beach' then
                self:changeAnimation(self.enemy.color, self.enemy.direction, dt)
                self:moveBeach(dt, self.enemy.direction)
                if self:checkPlayerCollision(self.enemy.direction, self.player) then
                    -- decrement player health
                    if self.player.health > 0 then
                        self.player.health = self.player.health - 1
                    end
                    -- play hurt sound
                    Sounds['hurt']:play()
                    -- set player to hurt
                    self.player.hurt['hit'] = true
                    -- force enemy to idle
                    self.enemy:changeState('idle')
                end
            end
        end
    end
end

function EnemiesWalk:moveRiver(dt, direction)

    if direction == 'left' then
        if self:checkRiverCollision('left_wall') then
            self.enemy.x = GAME_WIDTH / 2
            self.enemy.direction = 'right'
            self.enemy:changeState('idle')
        else
            self.enemy.x = self.enemy.x - math.floor(ENEMIES_WALK_SPEED * dt)
        end
    elseif direction == 'right' then
        if self:checkRiverCollision('right_wall') then
            self.enemy.x = GAME_WIDTH - 48
            self.enemy.direction = 'left'
            self.enemy:changeState('idle')
        else
            self.enemy.x = self.enemy.x + math.floor(ENEMIES_WALK_SPEED * dt)
        end
    elseif direction == 'up' then
        if self:checkRiverCollision('top_wall') then
            self.enemy.y = 10
            self.enemy.direction = 'down'
            self.enemy:changeState('idle')
        else
            self.enemy.y = self.enemy.y - math.floor(ENEMIES_WALK_SPEED * dt)
        end
    elseif direction == 'down' then
        if self:checkRiverCollision('bottom_wall') then
            self.enemy.y = GAME_HEIGHT - 48
            self.enemy.direction = 'up'
            self.enemy:changeState('idle')
        else
            self.enemy.y = self.enemy.y + math.floor(ENEMIES_WALK_SPEED * dt)
        end
    end
end

function EnemiesWalk:moveBeach(dt, direction)

    if direction == 'left' then
        if self:checkBeachCollision('left_wall') then
            self.enemy.x = 64
            self.enemy.direction = 'right'
            self.enemy:changeState('idle')
        else
            self.enemy.x = self.enemy.x - math.floor(ENEMIES_WALK_SPEED * dt)
        end
    elseif direction == 'right' then
        if self:checkBeachCollision('right_wall') then
            self.enemy.x = GAME_WIDTH / 2 - 16
            self.enemy.direction = 'left'
            self.enemy:changeState('idle')
        else
            self.enemy.x = self.enemy.x + math.floor(ENEMIES_WALK_SPEED * dt)
        end
    elseif direction == 'up' then
        if self:checkBeachCollision('top_wall') then
            self.enemy.y = 0
            self.enemy.direction = 'down'
            self.enemy:changeState('idle')
        else
            self.enemy.y = self.enemy.y - math.floor(ENEMIES_WALK_SPEED * dt)
        end
    elseif direction == 'down' then
        if self:checkBeachCollision('bottom_wall') then
            self.enemy.y = GAME_HEIGHT - 36
            self.enemy.direction = 'up'
            self.enemy:changeState('idle')
        else
            self.enemy.y = self.enemy.y + math.floor(ENEMIES_WALK_SPEED * dt)
        end
    end
end

function EnemiesWalk:checkRiverCollision(surface)

    if surface == 'left_wall' then
        if self.enemy.x <= GAME_WIDTH / 2 then
            return true
        else
            return false
        end
    elseif surface == 'right_wall' then
        if self.enemy.x + 32 > GAME_WIDTH - 16 then
            return true
        else
            return false
        end
    elseif surface == 'top_wall' then
        if self.enemy.y <= 10 then
            return true
        else
            return false
        end
    elseif surface == 'bottom_wall' then
        if self.enemy.y + 32 >= GAME_HEIGHT - 16 then
            return true
        else
            return false
        end
    end
end

function EnemiesWalk:checkBeachCollision(surface)

    if surface == 'left_wall' then
        if self.enemy.x < 64 then
            return true
        else
            return false
        end
    elseif surface == 'right_wall' then
        if self.enemy.x >= GAME_WIDTH / 2 - 16 then
            return true
        else 
            return false
        end
    elseif surface == 'top_wall' then
        if self.enemy.y <= 0 then
            return true
        else
            return false
        end
    elseif surface == 'bottom_wall' then
        if self.enemy.y >= GAME_HEIGHT - 36 then
            return true
        else
            return false
        end
    end
end

function EnemiesWalk:checkPlayerCollision(direction, player)

    if direction == 'up' then
        if self.enemy.y <= self.player.y + 48 and self.enemy.y + 32 >= self.player.y + 80 and self.enemy.x + 16 >= self.player.x + 8 and self.enemy.x + 16 <= self.player.x + 56 then
            -- store value of direction player was hit
            self.player.hurt['side'] = 'bottom'
            return true
        else
            return false
        end
    elseif direction == 'down' then
        if self.enemy.y + 32 >= self.player.y + 32 and self.enemy.y <= self.player.y and self.enemy.x + 16 >= self.player.x + 8 and self.enemy.x + 16 <= self.player.x + 56 then 
            -- store value of direction player was hit
            self.player.hurt['side'] = 'top'
            return true
        else 
            return false
        end
    elseif direction == 'left' then
        if self.enemy.y + 16 >= self.player.y + 32 and self.enemy.y + 16 <= self.player.y + 64 and self.enemy.x <= self.player.x + 32 and self.enemy.x + 32 >= self.player.x + 64 then
            -- store value of direction player was hit
            self.player.hurt['side'] = 'right'
            return true
        else
            return false
        end
    elseif direction == 'right' then
        if self.enemy.y + 16 >= self.player.y + 32 and self.enemy.y + 16 <= self.player.y + 64 and self.enemy.x + 32 >= self.player.x + 32 and self.enemy.x <= self.player.x then
            -- store value of direction player was hit
            self.player.hurt['side'] = 'left'
            return true
        else
            return false
        end
    end

end

-- cycle through animations
function EnemiesWalk:changeAnimation(color, direction, dt)

    self.timer = self.timer + dt*12

    if self.timer > 1 then
        
        if direction == 'left' then
            if color == 1 then
                if self.enemy.frame == PURP_LEFT[1] then
                    self.enemy.frame = PURP_LEFT[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_LEFT[2] then
                    self.enemy.frame = PURP_LEFT[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_LEFT[3] then
                    self.enemy.frame = PURP_LEFT[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 2 then
                if self.enemy.frame == BLUE_LEFT[1] then
                    self.enemy.frame = BLUE_LEFT[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_LEFT[2] then
                    self.enemy.frame = BLUE_LEFT[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_LEFT[3] then
                    self.enemy.frame = BLUE_LEFT[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 3 then
                if self.enemy.frame == GREEN_LEFT[1] then
                    self.enemy.frame = GREEN_LEFT[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_LEFT[2] then
                    self.enemy.frame = GREEN_LEFT[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_LEFT[3] then
                    self.enemy.frame = GREEN_LEFT[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            end
        elseif direction == 'right' then
            if color == 1 then
                if self.enemy.frame == PURP_RIGHT[1] then
                    self.enemy.frame = PURP_RIGHT[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_RIGHT[2] then
                    self.enemy.frame = PURP_RIGHT[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_RIGHT[3] then
                    self.enemy.frame = PURP_RIGHT[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 2 then
                if self.enemy.frame == BLUE_RIGHT[1] then
                    self.enemy.frame = BLUE_RIGHT[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_RIGHT[2] then
                    self.enemy.frame = BLUE_RIGHT[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_RIGHT[3] then
                    self.enemy.frame = BLUE_RIGHT[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 3 then
                if self.enemy.frame == GREEN_RIGHT[1] then
                    self.enemy.frame = GREEN_RIGHT[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_RIGHT[2] then
                    self.enemy.frame = GREEN_RIGHT[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_RIGHT[3] then
                    self.enemy.frame = GREEN_RIGHT[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            end
        elseif direction == 'up' then
            if color == 1 then
                if self.enemy.frame == PURP_UP[1] then
                    self.enemy.frame = PURP_UP[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_UP[2] then
                    self.enemy.frame = PURP_UP[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_UP[3] then
                    self.enemy.frame = PURP_UP[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 2 then
                if self.enemy.frame == BLUE_UP[1] then
                    self.enemy.frame = BLUE_UP[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_UP[2] then
                    self.enemy.frame = BLUE_UP[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_UP[3] then
                    self.enemy.frame = BLUE_UP[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 3 then
                if self.enemy.frame == GREEN_UP[1] then
                    self.enemy.frame = GREEN_UP[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_UP[2] then
                    self.enemy.frame = GREEN_UP[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_UP[3] then
                    self.enemy.frame = GREEN_UP[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            end
        elseif direction == 'down' then
            if color == 1 then
                if self.enemy.frame == PURP_DOWN[1] then
                    self.enemy.frame = PURP_DOWN[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_DOWN[2] then
                    self.enemy.frame = PURP_DOWN[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == PURP_DOWN[3] then
                    self.enemy.frame = PURP_DOWN[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 2 then
                if self.enemy.frame == BLUE_DOWN[1] then
                    self.enemy.frame = BLUE_DOWN[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_DOWN[2] then
                    self.enemy.frame = BLUE_DOWN[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == BLUE_DOWN[3] then
                    self.enemy.frame = BLUE_DOWN[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            elseif color == 3 then
                if self.enemy.frame == GREEN_DOWN[1] then
                    self.enemy.frame = GREEN_DOWN[2]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_DOWN[2] then
                    self.enemy.frame = GREEN_DOWN[3]
                    self.move = self.move + 1
                    self.timer = 0
                elseif self.enemy.frame == GREEN_DOWN[3] then
                    self.enemy.frame = GREEN_DOWN[1]
                    self.move = self.move + 1
                    self.timer = 0
                end
            end
        end
    end
end
