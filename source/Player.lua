--[[
    Player
]]

Player = Class{}

function Player:init(def)

    -- scene to be generated
    self.area = 'start'

    -- coordinates
    self.x = GAME_WIDTH / 2 - 32
    self.y = 56

    -- direction
    self.direction = 'down'

    -- sprite frame
    self.frame = 8

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
        [6] = false
    }

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

    -- flag for if in the shop
    self.shopping = false

    -- flag for if in inventory -- WIP ---
    self.browsing_inventory = false

    -- flag for if in achievements
    self.browsing_achievements = false

    -- flag if new fish has been caught
    self.catch_new = false

end

function Player:update(dt)

    -- update the state machine
    self.statemachine:update(dt)

    -- max out money at 999,999
    if self.inventory['money'] >= 999999 then
        self.inventory['money'] = 999999
    end

end

-- change the player state when called
function Player:changeState(name)
    self.statemachine:change(name)
end

function Player:render()

    love.graphics.draw(SpriteSheet['fish'], Sprites['player'][self.frame], self.x, self.y)

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

    -- render fishing mechanic
    if self.fish_on then
        -- background
        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.rectangle('fill', 16, GAME_HEIGHT - self.cast_max , 20, self.cast_max, 4)
        -- reel
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle('fill', 16, GAME_HEIGHT - self.reel_position - 32, 20, 32, 4)
        -- fish
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(SpriteSheet['fish'], Sprites['small_fish'][2], 18, GAME_HEIGHT - self.fish_position - 16)
        -- outine
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('line', 16, GAME_HEIGHT - self.cast_max, 20, self.cast_max, 4)

        -- reel in progress
        -- outine
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('line', 38, GAME_HEIGHT - CATCH, 10, CATCH, 4)
        -- reel_in
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle('fill', 38, GAME_HEIGHT - self.reel_in, 10, self.reel_in, 4)

        -- breakaway progress
        -- outine
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('line', 50, GAME_HEIGHT - BREAK, 10, BREAK, 4)
        -- reel_in
        love.graphics.setColor((self.fish_breakaway * 2)/255, 100/255, 10/255, 1)
        love.graphics.rectangle('fill', 50, GAME_HEIGHT - self.fish_breakaway, 10, self.fish_breakaway, 4)

        -- reset color
        love.graphics.setColor(1, 1, 1, 1)

    end
end
