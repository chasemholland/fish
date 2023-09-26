--[[
    Generates a semi-random beach.
]]

GenerateBeach = Class{}

function GenerateBeach:init()

    self.width = GAME_WIDTH -- 640
    self.height = GAME_HEIGHT -- 360

    self.timer = 0

    self.water = {}
    -- fill water table
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = GAME_WIDTH / 2 + 16, GAME_WIDTH - 16, 16 do
            table.insert(self.water, math.random(1, 2))
        end
    end

    self.ground = {}
    -- fill ground table
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = 64, GAME_WIDTH / 2, 16 do
            table.insert(self.ground, math.random(1, 2))
        end
    end

    self.top_edge = {}
    -- fill top edge
    for i = 1, 20 do
        table.insert(self.top_edge, math.random(23, 24))
    end

    self.bottom_edge = {}
    -- fill bottom edge
    for i = 1, 20 do
        table.insert(self.bottom_edge, math.random(21, 22))
    end

    self.right_edge = {}
    -- fill right edge
    for i = 1, 22 do
        table.insert(self.right_edge, math.random(25, 26))
    end

    self.grass = {}
    -- fill grass
    for i = 1, 66 do
        table.insert(self.grass, math.random(1, 2))
    end

    local top_corner = math.random(1, 2)
    if top_corner == 1 then
        self.top_corner = 15
    else
        self.top_corner = 19
    end

    local bottom_corner = math.random(1, 2)
    if bottom_corner == 1 then
        self.bottom_corner = 16
    else
        self.bottom_corner = 20
    end


end

function GenerateBeach:update(dt)

    self:waterTimer(dt)

    if self.timer >= 1 then
        self.timer = 0
        self.water = {}
        for y = 0, GAME_HEIGHT - 16, 16 do
            for x = GAME_WIDTH / 2 + 16, GAME_WIDTH - 16, 16 do
                table.insert(self.water, math.random(1, 2))
            end
        end
    end

end

function GenerateBeach:waterTimer(dt)

    self.timer = self.timer + dt * 4

end

function GenerateBeach:render()

    -- ground
    local i = 1
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = 64, GAME_WIDTH / 2, 16 do
            love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][self.ground[i]], x, y)
            i = i + 1
        end
    end

    -- water
    local i = 1
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = GAME_WIDTH / 2 + 16, GAME_WIDTH - 16, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['water'][self.water[i]], x, y)
            i = i + 1
        end
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- top edge
    local i = 1
    local x = 0
    for i = 1, 20 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][self.top_edge[i]], x, 0)
        i = i + 1
        x = x + 16
    end

    -- bottom edge
    local i = 1
    local x = 0
    for i = 1, 20 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][self.bottom_edge[i]], x, GAME_HEIGHT - 16)
        i = i + 1
        x = x + 16
    end

    -- right edge
    local i = 1
    local y = 0
    for i = 1, 22 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][self.right_edge[i]], GAME_WIDTH / 2, y)
        i = i + 1
        y = y + 16
    end

    -- top corner
    love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][self.top_corner], GAME_WIDTH / 2, 0)

    -- bottom corner
    love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][self.bottom_corner], GAME_WIDTH / 2, GAME_HEIGHT - 16)

    -- left walls
    for y = 0, GAME_HEIGHT - 16, 16 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][BEACH_WALL[1]], 48, y)
    end

    -- wall grass
    local i = 1
    for x = 0, 32, 16 do
        for y = 0, GAME_HEIGHT - 16, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['ground'][self.grass[i]], x, y)
            i = i + 1
        end
    end

    -- path top
    for x = 0, GAME_WIDTH / 2 - 32, 16 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][BEACH_PATH[3]], x, GAME_HEIGHT / 2 - 16)
    end

    -- path bottom
    for x = 0, GAME_WIDTH / 2 - 32, 16 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][BEACH_PATH[4]], x, GAME_HEIGHT / 2)
    end

    -- path end
    local i = 5
    for y = GAME_HEIGHT / 2 - 16, GAME_HEIGHT / 2, 16 do
        love.graphics.draw(SpriteSheet['beach'], Sprites['beach'][BEACH_PATH[i]], GAME_WIDTH / 2 - 16, y)
        i = 6
    end
    
end