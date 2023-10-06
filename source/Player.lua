--[[
    Player
]]

Player = Class{}

function Player:init(def)

    -- health
    self.health = 8

    -- getting hurt flag
    self.hurt = {
        ['hit'] = false,
        ['side'] = '',
        ['alpha'] = 255,
        ['shifted'] = false
    }

    -- slime kill count
    self.kills = 0

    -- money earned count
    self.money_earned = 0

    -- money gained
    self.money_gained = {
        ['value'] = 0,
        ['alpha'] = 255
    }

    -- caught fish count
    self.fish_count = 0

    -- lost fish count
    self.loss_count = 0

    -- scene to be generated
    self.area = 'start'

    -- coordinates
    self.x = GAME_WIDTH / 2 - 32
    self.y = 56

    -- direction
    self.direction = 'down'

    -- sprite frame
    self.frame = 8

    -- falg for if cast
    self.cast = false

    -- max cast strength
    self.cast_max = 160

    -- cast strength
    self.power = 0

    -- timer
    self.timer = 0

    -- player inventory
    self.inventory = {
        ['lure'] = 'basic',
        ['owned_lure'] = {
            ['basic'] = true,
            ['novice'] = false,
            ['amateur'] = false,
            ['advanced'] = false
        },
        ['money'] = 0,
        ['fish'] = {
            [1] = nil,
            [2] = nil,
            [3] = nil,
            [4] = nil,
            [5] = nil
        },
        ['caught'] = {
            [1] = false,
            [2] = false,
            [3] = false,
            [4] = false,
            [5] = false,
            [6] = false,
            [7] = false,
            [8] = false,
            [9] = false,
            [10] = false,
            [11] = false,
            [12] = false,
            [13] = false,
            [14] = false,
            [15] = false,
            [16] = false,
        }
    }

    -- start of game tutorial
    self.tutorial = {
        [1] = false,
        [2] = false,
        [3] = false,
        [4] = false,
        [5] = false,
        [6] = false,
        [7] = false,
        [8] = false,
        [9] = false
    }

    -- equiped item "pole" or "sword"
    self.equiped = 'pole'

    -- flag for if fish is hooked
    self.fish_on = false

    -- reel position when reeling in fish
    self.reel_position = self.cast_max - 32

    -- fish position when reeling in fish
    self.fish_position = 0

    -- how much the fish has been reeled in
    self.reel_in = 2

    -- flag used to determine if fish breaks away
    self.fish_breakaway = 1

    -- flag if new fish has been caught
    self.catch_new = false

    -- flag for if player in menus
    self.paused = false

    -- flag for shopping
    self.shopping = false

    -- flag for browsing achievments
    self.browsing_achievements = false

end

function Player:update(dt)

    -- update the state machine
    self.statemachine:update(dt)

    -- max out money at 999,999
    if self.inventory['money'] >= 999999 then
        self.inventory['money'] = 999999
    end

    -- timer visually see being hurt
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
        Timer.update(dt)
        if self.timer > 2 then
            self.hurt['hit'] = false
            self.hurt['shifted'] = false
            self.timer = 0
        end
    end

end

-- change the player state when called
function Player:changeState(name)
    self.statemachine:change(name)
end

function Player:hurtTimer(dt)

    self.timer = self.timer + dt * 4

end

function Player:render()

    if self.hurt['hit'] then
        love.graphics.setColor(1, 0, 0, self.hurt['alpha'] / 255)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.draw(SpriteSheet['fish'], Sprites['player'][self.frame], self.x, self.y)

    -- reset color
    love.graphics.setColor(1, 1, 1, 1)

    -- render fishing line
    if self.cast then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineWidth(1)
        if self.frame == PLAYER_FISH_LEFT then
            -- line
            love.graphics.line(self.x + POLE_TIP_LEFT[1], self.y + POLE_TIP_LEFT[2], (self.x + POLE_TIP_LEFT[1]) - self.power, self.y + 64)
            -- bobber
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][1], (self.x + POLE_TIP_LEFT[1]) - self.power - 4, self.y + 64)
        elseif self.frame == PLAYER_FISH_RIGHT then
            -- line
            love.graphics.line(self.x + POLE_TIP_RIGHT[1], self.y + POLE_TIP_RIGHT[2], (self.x + POLE_TIP_RIGHT[1]) + self.power, self.y + 64)
            -- bobber
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][1], (self.x + POLE_TIP_RIGHT[1]) + self.power - 4, self.y + 64)
        elseif self.frame == PLAYER_FISH_UP then
            -- line
            love.graphics.line(self.x + POLE_TIP_UP[1], self.y + POLE_TIP_UP[2], self.x + POLE_TIP_UP[1], (self.y + POLE_TIP_UP[2]) - self.power)
            -- bobber
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][1], self.x + POLE_TIP_UP[1] - 4, (self.y + POLE_TIP_UP[2]) - self.power)
            -- draw player last so pleyer is on top of the line and bobber
            love.graphics.draw(SpriteSheet['fish'], Sprites['player'][self.frame], self.x, self.y)
        elseif self.frame == PLAYER_FISH_DOWN then
            -- line
            love.graphics.line(self.x + POLE_TIP_DOWN[1], self.y + POLE_TIP_DOWN[2], self.x + 32, (self.y + POLE_TIP_DOWN[2]) + self.power)
            -- bobber
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][1], self.x + 32 - 4, (self.y + POLE_TIP_DOWN[2]) + self.power)
        end
    end

end

function Player:knockBack()

    if self.hurt['side'] == 'left' then
        if self.area == 'river' then
            if self.x + 32 <= GAME_WIDTH - 64 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + 16), y = math.floor(self.y - 8)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x + 16), y = math.floor(self.y + 8)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + (((GAME_WIDTH - 64) - self.x) / 2)), y = math.floor(self.y - 8)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = GAME_WIDTH - 64, y = math.floor(self.y + 8)}
                    })end)
            end
        elseif self.area == 'beach' then
            if self.x + 32 <= GAME_WIDTH / 2 - 32 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + 16), y = math.floor(self.y - 8)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x + 16), y = math.floor(self.y + 8)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x + (((GAME_WIDTH / 2 - 32) - self.x) / 2)), y = math.floor(self.y - 8)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = GAME_WIDTH / 2 - 32, y = math.floor(self.y + 8)}
                    })end)
            end
        end
    elseif self.hurt['side'] == 'right' then
        if self.area == 'river' then
            if self.x - 32 >= GAME_WIDTH / 2 - 16 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - 16), y = math.floor(self.y - 8)}
                }):finish(function ()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x - 16), y = math.floor(self.y + 8)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - ((self.x - (GAME_WIDTH / 2 - 16)) / 2)), y = math.floor(self.y - 8)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = GAME_WIDTH / 2 - 16, y = math.floor(self.y + 8)}
                    })end)
            end
        elseif self.area == 'beach' then
            if self.x - 32 >= 48 then
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - 16), y = math.floor(self.y - 8)}
                }):finish(function ()
                    Timer.tween(.1, {
                        [self] = {x = math.floor(self.x - 16), y = math.floor(self.y + 8)}
                    })end)
            else
                Timer.tween(.1, {
                    [self] = {x = math.floor(self.x - ((self.x - 48) / 2)), y = math.floor(self.y - 8)}
                }):finish(function()
                    Timer.tween(.1, {
                        [self] = {x = 48, y = math.floor(self.y + 8)}
                    })end)
            end
        end
    elseif self.hurt['side'] == 'top' then
        if self.area == 'river' then
            if self.y + 32 <= GAME_HEIGHT - 80 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y + 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = GAME_HEIGHT - 80}
                })
            end
        elseif self.area == 'beach' then
            if self.y + 32 <= GAME_HEIGHT - 72 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y + 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = GAME_HEIGHT - 72}
                })
            end
        end
    elseif self.hurt['side'] == 'bottom' then
        if self.area == 'river' then
            if self.y - 32 >= 0 then
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = math.floor(self.y - 32)}
                })
            else
                Timer.tween(.2, {
                    [self] = {x = math.floor(self.x), y = 0}
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