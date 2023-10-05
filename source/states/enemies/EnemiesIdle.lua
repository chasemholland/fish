--[[
    Enemies idle state.
]]
EnemiesIdle = Class{__includes = Base}

function EnemiesIdle:init(enemy)

    -- enemy
    self.enemy = enemy

    -- move timer
    self.timer = 0

end

function EnemiesIdle:update(dt)

    -- check if player in enemy area and enemy is alive
    if self.enemy.area ~= 'start' and not self.enemy.dead and not self.enemy.waiting then
        -- get the current idle direction frame
        if self.timer < 1 then
            self:moveTimer(dt)
            if self.enemy.direction == 'left' then
                if self.enemy.color == 1 then
                    self.enemy.frame = PURP_IDLE_LEFT
                elseif self.enemy.color == 2 then
                    self.enemy.frame = BLUE_IDLE_LEFT
                elseif self.enemy.color == 3 then
                    self.enemy.frame = GREEN_IDLE_LEFT
                end
            elseif self.enemy.direction == 'right' then
                if self.enemy.color == 1 then
                    self.enemy.frame = PURP_IDLE_RIGHT
                elseif self.enemy.color == 2 then
                    self.enemy.frame = BLUE_IDLE_RIGHT
                elseif self.enemy.color == 3 then
                    self.enemy.frame = GREEN_IDLE_RIGHT
                end
            elseif self.enemy.direction == 'up' then
                if self.enemy.color == 1 then
                    self.enemy.frame = PURP_IDLE_UP
                elseif self.enemy.color == 2 then
                    self.enemy.frame = BLUE_IDLE_UP
                elseif self.enemy.color == 3 then
                    self.enemy.frame = GREEN_IDLE_UP
                end
            elseif self.enemy.direction == 'down' then
                if self.enemy.color == 1 then
                    self.enemy.frame = PURP_IDLE_DOWN
                elseif self.enemy.color == 2 then
                    self.enemy.frame = BLUE_IDLE_DOWN
                elseif self.enemy.color == 3 then
                    self.enemy.frame = GREEN_IDLE_DOWN
                end
            end
        -- trigger movement
        else
            self.enemy:changeState('walk')
        end
    end


end

function EnemiesIdle:moveTimer(dt)

    self.timer = self.timer + dt

end