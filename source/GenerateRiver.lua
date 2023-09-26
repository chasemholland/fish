--[[
    Generates a semi-random river.
]]

GenerateRiver = Class{}

function GenerateRiver:init()

    self.width = GAME_WIDTH -- 640
    self.height = GAME_HEIGHT -- 360

    self.timer = 0

    self.water = {}
    -- fill water table
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = 112, GAME_WIDTH / 2, 16 do
            table.insert(self.water, math.random(1, 2))
        end
    end

    self.ground = {}
    -- fill ground table
    for y = 16, GAME_HEIGHT - 32, 16 do
        for x = 16, 96, 16 do
            table.insert(self.ground, math.random(1, 2))
        end

        for x = GAME_WIDTH / 2, GAME_WIDTH - 32, 16 do
            table.insert(self.ground, math.random(1, 2))
        end
    end

end

function GenerateRiver:update(dt)

    self:waterTimer(dt)

    if self.timer >= 1 then
        self.timer = 0
        self.water = {}
        for y = 0, GAME_HEIGHT - 16, 16 do
            for x = 112, GAME_WIDTH / 2, 16 do
                table.insert(self.water, math.random(1, 2))
            end
        end
    end

end

function GenerateRiver:waterTimer(dt)

    self.timer = self.timer + dt * 4

end

function GenerateRiver:render()

    -- ground
    local i = 1
    for y = 16, GAME_HEIGHT - 32, 16 do
        for x = 16, 96, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['ground'][self.ground[i]], x, y)
            i = i + 1
        end
    end

    for y = 16, GAME_HEIGHT - 32, 16 do
        for x = GAME_WIDTH / 2, GAME_WIDTH - 32, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['ground'][self.ground[i]], x, y)
            i = i + 1
        end
    end

    -- water
    love.graphics.setColor(1, 1, 1, 240 / 255)
    local i = 1
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = 112, GAME_WIDTH / 2, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['water'][self.water[i]], x, y, (90 * math.pi/180))
            i = i + 1
        end
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- top edge
    for x = 16, 80, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][3], x, 0)
    end
    for x = GAME_WIDTH / 2, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][3], x, 0)
    end

    -- bottom edge
    for x = 16, 80, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][10], x, GAME_HEIGHT - 16)
    end
    for x = GAME_WIDTH / 2, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][10], x, GAME_HEIGHT - 16)
    end

    -- left and right edge
    for y = 16, GAME_HEIGHT - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][1], 0, y)
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][2], GAME_WIDTH - 16, y)
    end

    -- corners 6, 7, 13, 14
    local i = 6
    for y = 0, GAME_HEIGHT - 16, GAME_HEIGHT - 16 do
        for x = 0, GAME_WIDTH - 16, GAME_WIDTH - 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][i], x, y)
            i = i + 1
        end
        i = 13
    end

    -- path top
    for x = GAME_WIDTH / 2 + 32, GAME_WIDTH - 16, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['ground_path'][3], x, GAME_HEIGHT / 2 - 16)
    end

    -- path bottom
    for x = GAME_WIDTH / 2 + 32, GAME_WIDTH - 16, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['ground_path'][4], x, GAME_HEIGHT / 2)
    end

    -- path end
    local i = 1
    for y = GAME_HEIGHT / 2 - 16, GAME_HEIGHT / 2, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['ground_path'][i], GAME_WIDTH / 2 + 16, y)
        i = i + 1
    end

    -- sign
    love.graphics.draw(SpriteSheet['ground'], Sprites['signs'][3], GAME_WIDTH - 48, GAME_HEIGHT / 2 + 16)
end