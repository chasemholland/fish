--[[
    Generates a semi-random world.
]]

GenerateWorld = Class{}

function GenerateWorld:init()

    self.width = GAME_WIDTH -- 640
    self.height = GAME_HEIGHT -- 360

    self.timer = 0

    self.water = {}
    -- fill water table
    for y = GAME_HEIGHT / 2, GAME_HEIGHT, 16 do
        for x = 16, GAME_WIDTH - 32, 16 do
            table.insert(self.water, math.random(1, 2))
        end
    end

    self.ground = {}
    -- fill ground table
    for y = 48, GAME_HEIGHT / 2 - 16, 16 do
        for x = 32, GAME_WIDTH - 32, 16 do
            table.insert(self.ground, math.random(1, 2))
        end
    end

end

function GenerateWorld:update(dt)

    self:waterTimer(dt)

    if self.timer >= 1 then
        self.timer = 0
        self.water = {}
        for y = GAME_HEIGHT / 2, GAME_HEIGHT, 16 do
            for x = 16, GAME_WIDTH - 32, 16 do
                table.insert(self.water, math.random(1, 2))
            end
        end
    end

end

function GenerateWorld:waterTimer(dt)

    self.timer = self.timer + dt * 4

end

function GenerateWorld:render()

    -- ground
    local i = 1
    for y = 48, GAME_HEIGHT / 2 - 16, 16 do
        for x = 32, GAME_WIDTH - 32, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['ground'][self.ground[i]], x, y)
            i = i + 1
        end
    end

    -- water
    love.graphics.setColor(1, 1, 1, 240 / 255)
    local i = 1
    for y = GAME_HEIGHT / 2, GAME_HEIGHT, 16 do
        for x = 16, GAME_WIDTH - 32, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['water'][self.water[i]], x, y)
            i = i + 1
        end
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- top ground
    local i = 1
    for x = 16, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['ground'][self.ground[i]], x, y)
        i = i + 1
    end

    -- top edge
    local x = 0
    for i = 8, 4, -4 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][i], x, 0)
        x = GAME_WIDTH - 16
    end

    -- top edge bottom
    for x = 16, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][6], x, 16)
    end

    -- top edge corners
    local x = 0
    for i = 5, 7, 2 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][i], x, 16)
        x = GAME_WIDTH - 16
    end

    -- top walls
    for x = 16, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][TOP_WALL[1]], x, 32)
    end

    -- left walls
    for y = 48, GAME_HEIGHT - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][LEFT_WALL[1]], 0, y)
    end

    -- right walls
    for y = 48, GAME_HEIGHT - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][RIGHT_WALL[1]], GAME_WIDTH - 16, y)
    end

    -- bottom walls
    for x = 16, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][BOTTOM_WALL[1]], x, GAME_HEIGHT - 16)
    end

    -- waters edge
    for x = 32, GAME_WIDTH - 48, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][6], x, GAME_HEIGHT / 2 - 16) 
    end

    -- wall edge left
    for y = 64, GAME_HEIGHT / 2 - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][8], 16, y)
    end

    -- wall edge right
    for y = 64, GAME_HEIGHT / 2 - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][4], GAME_WIDTH - 32, y)
    end

    -- wall edge top
    for x = 32, GAME_WIDTH - 32, 16 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][2], x, 48)
    end

    -- middle wall edge top corners
    local x = 16
    for i = 1, 3, 2 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][i], x, 48)
        x = (GAME_WIDTH - 32)
    end

    -- middle wall edge bottom corners
    local x = 16
    for i = 5, 7, 2 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall_ground'][i], x, GAME_HEIGHT / 2 - 16)
        x = (GAME_WIDTH - 32)
    end

    -- set x
    local x = 0
    -- top corners
    for i = 1, 2 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][WALL_CORNER[i]], x, 32)
        x = (GAME_WIDTH - 16)
    end

    -- bottom corners
    local x = 0
    for i = 3, 4 do
        love.graphics.draw(SpriteSheet['ground'], Sprites['wall'][WALL_CORNER[i]], x, GAME_HEIGHT - 16)
        x = (GAME_WIDTH - 16)
    end

    -- path
    local i = 3
    for y = 96, 112, 16 do
        for x = 0, GAME_WIDTH, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['ground_path'][i], x, y)
        end
        i = 4
    end

    -- signs
    local i = 1
    for x = GAME_WIDTH - 48, 16, -(GAME_WIDTH - 64) do
        love.graphics.draw(SpriteSheet['ground'], Sprites['signs'][i], x, 128)
        i = i + 1
    end

    
end
