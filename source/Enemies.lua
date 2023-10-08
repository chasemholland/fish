--[[
    Enemies
]]

Enemies = Class {}

function Enemies:init()

    -- coordinates
    self.x = 0
    self.y = 0

    -- color
    self.color = math.random(1, 3)

    -- direction 
    local direction = math.random(1, 4)
    self.direction = ENEMY_DIRECTION[direction]

    -- frame
    self.frame = self:getFrame()

    -- health
    self.health = self.color * 2

    -- area
    self.area = ''

    -- dead or alive
    self.dead = false

    -- idle flag when player in start area
    self.waiting = true

    -- getting hurt flag
    self.hurt = {
        ['hit'] = false,
        ['side'] = '',
        ['alpha'] = 255,
        ['shifted'] = false
    }

    -- hurt timer
    self.timer = 0

end

function Enemies:update(dt)

    -- update the state machine
    self.statemachine:update(dt)

    -- visually see enemies being hurt
    if self.hurt['hit'] then
        self:hurtTimer(dt)
        Timer.tween(.25, {
            [self.hurt] = {alpha = 100}
        }):finish(function ()
            Timer.tween(.25, {
                [self.hurt] = {alpha = 255}
            })end)
        if not self.hurt['shifted'] then
            self:knockBack()
            self.hurt['shifted'] = true
        end
        if self.timer > 2 then
            self.hurt['hit'] = false
            self.hurt['shifted'] = false
            self.timer = 0
        end
    end

end

-- change the enemies state when called
function Enemies:changeState(name)
    self.statemachine:change(name)
end

function Enemies:render()

    -- render enemy
    if not self.dead and not self.waiting then
        if self.hurt['hit'] then
            love.graphics.setColor(1, 1, 1, self.hurt['alpha'] / 255)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.draw(SpriteSheet['enemies'], Sprites['enemies'][self.frame], self.x, self.y)
        -- reset color
        love.graphics.setColor(1, 1, 1, 1)
    end

end

function Enemies:getFrame()

    if self.color == 1 then
        if self.direction == 'up' then
            return PURP_IDLE_UP
        elseif self.direction == 'down' then
            return PURP_IDLE_DOWN
        elseif self.direction == 'left' then
            return PURP_IDLE_LEFT
        elseif self.direction == 'right' then
            return PURP_IDLE_RIGHT
        end
    elseif self.color == 2 then
        if self.direction == 'up' then
            return BLUE_IDLE_UP
        elseif self.direction == 'down' then
            return BLUE_IDLE_DOWN
        elseif self.direction == 'left' then
            return BLUE_IDLE_LEFT
        elseif self.direction == 'right' then
            return BLUE_IDLE_RIGHT
        end
    elseif self.color == 3 then
        if self.direction == 'up' then
            return GREEN_IDLE_UP
        elseif self.direction == 'down' then
            return GREEN_IDLE_DOWN
        elseif self.direction == 'left' then
            return GREEN_IDLE_LEFT
        elseif self.direction == 'right' then
            return GREEN_IDLE_RIGHT
        end
    end

end

function Enemies:hurtTimer(dt)

    self.timer = self.timer + dt * 4

end

function Enemies:knockBack()

    if self.hurt['side'] == 'left' then
        if self.area == 'river' then
            if self.x + 32 <= GAME_WIDTH - 64 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + 16), y = math.floor(self.y - 16)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x + 16), y = math.floor(self.y + 16)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + (((GAME_WIDTH - 64) - self.x) / 2)), y = math.floor(self.y - 16)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = GAME_WIDTH - 64, y = math.floor(self.y + 16)}
                    })end)
            end
        elseif self.area == 'beach' then
            if self.x + 32 <= GAME_WIDTH / 2 - 16 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + 16), y = math.floor(self.y - 16)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x + 16), y = math.floor(self.y + 16)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + (((GAME_WIDTH / 2 - 16) - self.x) / 2)), y = math.floor(self.y - 16)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = GAME_WIDTH / 2 - 16, y = math.floor(self.y + 16)}
                    })end)
            end
        end
    elseif self.hurt['side'] == 'right' then
        if self.area == 'river' then
            if self.x - 32 >= GAME_WIDTH / 2 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - 16), y = math.floor(self.y - 16)}
                }):finish(function ()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x - 16), y = math.floor(self.y + 16)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - ((self.x - (GAME_WIDTH / 2)) / 2)), y = math.floor(self.y - 16)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = GAME_WIDTH / 2, y = math.floor(self.y + 16)}
                    })end)
            end
        elseif self.area == 'beach' then
            if self.x - 32 >= 96 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - 16), y = math.floor(self.y - 16)}
                }):finish(function ()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x - 16), y = math.floor(self.y + 16)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - ((self.x - 48) / 2)), y = math.floor(self.y - 16)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = 96, y = math.floor(self.y + 16)}
                    })end)
            end
        end
    elseif self.hurt['side'] == 'top' then
        if self.area == 'river' then
            if self.y + 32 <= GAME_HEIGHT - 48 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y + 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = GAME_HEIGHT - 48}
                })
            end
        elseif self.area == 'beach' then
            if self.y + 32 <= GAME_HEIGHT - 36 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y + 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = GAME_HEIGHT - 36}
                })
            end
        end
    elseif self.hurt['side'] == 'bottom' then
        if self.area == 'river' then
            if self.y - 32 >= 10 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y - 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = 10}
                })
            end
        elseif self.area == 'beach' then
            if self.y - 32 >= 0 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y - 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = 0}
                })
            end
        end
    end
end