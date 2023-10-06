--[[
    Starting State
]]

Start = Class{__includes = Base}

function Start:init()

    -- player
    self.player = Player()

    -- skip tutorial
    self.skip = false

end

function Start:update(dt)

    -- allow user to quit
    if love.keyboard.pressed('escape') then
        love.event.quit()
    end

    -- check box to skip tutorial
    if love.mouse.pressed(1) and mouseX >= GAME_WIDTH / 2 - 120 and mouseX <= GAME_WIDTH / 2 - 104 
    and mouseY >= GAME_HEIGHT / 2 + 46 and mouseY <= GAME_HEIGHT / 2 + 62 then
        if not self.skip then
            self.skip = true
            for i = 1, 9 do
                self.player.tutorial[i] = true
            end
        else
            self.skip = false
            for i = 1, 9 do
                self.player.tutorial[i] = false
            end
        end
    end
 
    -- change to play state
    if love.keyboard.pressed('enter') or love.keyboard.pressed('return') then
        gameSM:change('play', {
            player = self.player
        })
    end

end

function Start:render()

    love.graphics.setColor(1, 1, 1, 1)
    -- render background
    for i = 2, 40, 2 do 
        if i == 2 then
            self:lures(0, 0)
        else
            self:lures(0, 32 * (i - 2))
        end
    end

    love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], GAME_WIDTH / 2 - 190, GAME_HEIGHT / 2 - 90)

    love.graphics.setFont(Fonts['md'])
    love.graphics.setColor(10 / 255, 40 / 255, 140 / 255, 1)
    love.graphics.printf("FISH-LANDIA", GAME_WIDTH / 2 - 184, GAME_HEIGHT / 2 - 64, 600)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(Fonts['sm'])
    love.graphics.printf("PRESS ENTER TO START!", GAME_WIDTH / 2 - 170, GAME_HEIGHT / 2 , 600)

    -- skip tutorial
    love.graphics.printf("SKIP TUTORIAL", GAME_WIDTH / 2 - 100, GAME_HEIGHT / 2 + 44, 600)
    if self.skip then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('fill', GAME_WIDTH / 2 - 120, GAME_HEIGHT / 2 + 46, 16, 16)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('line', GAME_WIDTH / 2 - 120, GAME_HEIGHT / 2 + 46, 16, 16)
    else
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('line', GAME_WIDTH / 2 - 120, GAME_HEIGHT / 2 + 46, 16, 16)
    end
    

end

-- get all the lures for the background
function Start:lures(x, y)

    local X = x
    local Y = y

    for i = 1, 20 do
        if i <= 4 then
            love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][i + 8], X, Y)
        elseif i >= 5 and i <= 8 then
            love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][i + 4], X, Y)
        elseif i >= 9 and i <= 12 then
            love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][i], X, Y)
        elseif i >= 13 and i <= 16 then
            love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][i - 4], X, Y)
        else
            love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][i - 8], X, Y)
        end
        X = X + 36
    end
end