--[[
    Game Over State
]]

GameOver = Class {__includes = Base}

function GameOver:init()

end

function GameOver:enter(params)

    -- time in game
    self.time = {
        [1] = math.floor(params.time),
        [2] = string.format('%02.f', math.floor(params.time/3600)),
        [3] = string.format('%02.f', math.floor((params.time/60) - (math.floor(params.time/3600) * 60))),
        [4] = string.format('%02.f', math.floor(params.time - (math.floor(params.time/3600) * 3600) - (math.floor((params.time/60) - (math.floor(params.time/3600) * 60)) * 60)))
    } 

    -- total money earned
    self.money = params.money

    -- total fish caught
    self.caught = params.caught

    -- total fish lost
    self.lost = params.lost

    -- total kills
    self.kills = params.kills

    -- completion percentage
    self.completion = params.completion

    -- water timer
    self.timer = 0

    -- water tiles
    self.water = {}
    -- fill water table
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x = 0, GAME_WIDTH - 16, 16 do
            table.insert(self.water, math.random(1, 2))
        end
    end

end

function GameOver:update(dt)

    if love.keyboard.pressed('enter') or love.keyboard.pressed('return') then
        gameSM:change('start')
    end

    self:waterTimer(dt)

    if self.timer >= 1 then
        self.timer = 0
        self.water = {}
        for y = 0, GAME_HEIGHT - 16, 16 do
            for x = 0, GAME_WIDTH - 16, 16 do
                table.insert(self.water, math.random(1, 2))
            end
        end
    end

end

function GameOver:waterTimer(dt)

    self.timer = self.timer + dt * 4

end

function GameOver:render()

    -- render water background
    love.graphics.setColor(1, 1, 1, 1)
    local i = 1
    for y = 0, GAME_HEIGHT - 16, 16 do
        for x =  0, GAME_WIDTH - 16, 16 do
            love.graphics.draw(SpriteSheet['ground'], Sprites['water'][self.water[i]], x, y)
            i = i + 1
        end
    end

    -- render game over text box
    love.graphics.setColor(1, 1, 1, 80 / 255)
    love.graphics.rectangle('fill', 4, 4, GAME_WIDTH - 8, 96)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', 4, 4, GAME_WIDTH - 8, 96, 4)

    -- render game over text
    love.graphics.setFont(Fonts['x-lg'])
    love.graphics.printf("GAME OVER", -4, 10, 800)

    -- render stats box
    love.graphics.setColor(1, 1, 1, 80 / 255)
    love.graphics.rectangle('fill', 4, 108, GAME_WIDTH - 8, GAME_HEIGHT - 112)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', 4, 108, GAME_WIDTH - 8, GAME_HEIGHT - 112, 4)

    -- render stats names
    love.graphics.setFont(Fonts['sm'])
    love.graphics.printf("TIME  IN  GAME:", 32, 112, 400)
    love.graphics.printf("MONEY  EARNED:", 32, 176, 400)
    love.graphics.printf("COMPLETION:", 32, 240, 400)
    love.graphics.printf("FISH  CAUGHT:", GAME_WIDTH / 2, 112, 400)
    love.graphics.printf("FISH  LOST:", GAME_WIDTH / 2, 176, 400)
    love.graphics.printf("SLIME  KILLS:", GAME_WIDTH / 2, 240, 400)


    -- render stats
    love.graphics.setColor(10 / 255, 40 / 255, 140 / 255, 1)
    love.graphics.printf(tostring(self.time[2]) .. ':' .. tostring(self.time[3]) .. ':' .. tostring(self.time[4]), 48, 144, 400)
    love.graphics.printf('$' .. tostring(self.money), 48, 208, 400)
    love.graphics.printf(tostring(self.completion) .. '%', 48, 272, 400)
    love.graphics.printf(tostring(self.caught), GAME_WIDTH / 2 + 16, 144, 400)
    love.graphics.printf(tostring(self.lost), GAME_WIDTH / 2 + 16, 208, 400)
    love.graphics.printf(tostring(self.kills), GAME_WIDTH / 2 + 16, 272, 400)

    -- render que to restart
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("PRESS  ENTER  TO  RESTART  OR  PRESS  ESCAPE  TO  QUIT", 116, 300, 400, 'center')

end