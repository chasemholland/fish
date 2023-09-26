Play = Class{__includes = Base}

function Play:init()

    -- set up world
    self.world = GenerateWorld()

    -- current world
    self.current_world = 'start'

    -- initialize a player
    self.player = Player()

    -- set up player state machine
    self.player.statemachine = SM {
        ['walk'] = function() return PlayerWalk(self.player) end,
        ['idle'] = function() return PlayerIdle(self.player) end,
        ['casting'] = function() return PlayerCasting(self.player) end,
        ['fishing'] = function() return PlayerFishing(self.player) end,
        ['shop'] = function() return PlayerShop(self.player) end,
        ['inventory'] = function() return PlayerInventory(self.player) end,
        ['achievement'] = function() return PlayerAchievement(self.player) end
    }
    self.player:changeState('idle')

end

function Play:update(dt)
    
    -- render currect area
    if self.player.area == 'start' and self.current_world == 'beach' then
        self.world = GenerateWorld()
        self.current_world = 'start'
    elseif self.player.area == 'start' and self.current_world == 'river' then
        self.world = GenerateWorld()
        self.current_world = 'start'
    elseif self.player.area == 'beach' and self.current_world == 'start' then
        self.world = GenerateBeach()
        self.current_world = 'beach'
    elseif self.player.area == 'river' and self.current_world == 'start' then
        self.world = GenerateRiver()
        self.current_world = 'river'
    end

    -- update the world
    self.world:update(dt)

    -- update the player
    self.player:update(dt)

    -- allow user to quit game
    if love.mouse.pressed(1) and mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= GAME_HEIGHT - 34 and mouseY <= GAME_HEIGHT - 2 then
        love.event:quit()
    end

end

function Play:render()

    -- render the world
    self.world:render()

    -- render the player
    self.player:render()

    if self.player.shopping then

        -- shop
        self:drawShop()

    elseif self.player.browsing_achievements then

        -- achievements
        self:drawAchievement()

    else

        -- tips on how to play
        self:drawIntro()

        -- reset color
        love.graphics.setColor(1, 1, 1, 1)

        -- player inventory
        for i = 1, 5 do
            love.graphics.draw(SpriteSheet['inventory'], Sprites['inventory'][1], (30 * 7) + (i * 30), GAME_HEIGHT - 31)
        end

        -- render cast power bar if casting
        if self.player.casting then
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.rectangle('fill', 16, GAME_HEIGHT - self.player.timer / 2, 8, self.player.timer / 2, 4)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle('line', 16, GAME_HEIGHT - self.player.cast_max / 2, 8, self.player.cast_max / 2, 6)
        end

        -- render fish caught in inventory
        if self.player.inventory['fish'][1] ~= nil then
            for i = 1, 5 do
                if self.player.inventory['fish'][i] ~= nil then
                    love.graphics.draw(SpriteSheet['fish'], Sprites['small_fish'][self.player.inventory['fish'][i]], (30 * 7) + (i * 30) + 7, GAME_HEIGHT - 24)
                end
            end
        end

        -- render quit button
        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['sm'])
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], GAME_WIDTH - 82, GAME_HEIGHT - 34)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf('QUIT', GAME_WIDTH - 76, GAME_HEIGHT - 30, 200)

        -- render money
        love.graphics.setColor(1, 215 / 255, 0, 1)
        love.graphics.printf('$' .. tostring(self.player.inventory['money']), 397, GAME_HEIGHT - 28, 150)

        -- render shop, sell, and achievement buttons
        love.graphics.setFont(Fonts['sm'])
        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], GAME_WIDTH - 82, 2)
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], GAME_WIDTH - 82, 36)
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][8], GAME_WIDTH - 46, 70)
        love.graphics.setColor(0, 1, 0, 180 / 255)
        love.graphics.printf('SELL', GAME_WIDTH - 76, 41, 100)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf('SHOP', GAME_WIDTH - 80, 7, 100)

    end
end

function Play:drawShop()

    -- shop background
    love.graphics.draw(SpriteSheet['shop_background'])
    love.graphics.setFont(Fonts['sm'])

    --[[
        basic hook
    ]]--
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][4], (GAME_WIDTH / 4) + 2, GAME_HEIGHT / 4 - 68)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][2], (GAME_WIDTH / 4) - 56, GAME_HEIGHT / 4 - 20)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('BASIC',(GAME_WIDTH / 4) - 26, GAME_HEIGHT / 4 - 10, 200)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf('OWNED',(GAME_WIDTH / 4) - 30, GAME_HEIGHT / 4 + 14, 200)
    --[[
        novice hook
    ]]--
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][5], (3 * (GAME_WIDTH / 4)) - 42, GAME_HEIGHT / 4 - 68)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][2], (3 * (GAME_WIDTH / 4)) - 100, GAME_HEIGHT / 4 - 20)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('NOVICE',(3 * (GAME_WIDTH / 4)) - 74, GAME_HEIGHT / 4 - 10, 200)
    love.graphics.setColor(0, 1, 0, 1)
    if self.player.inventory['owned_lure']['novice'] == false then
        love.graphics.printf('$2000',(3 * (GAME_WIDTH / 4)) - 70, GAME_HEIGHT / 4 + 14, 200)
    else
        love.graphics.printf('OWNED',(3 * (GAME_WIDTH / 4)) - 70, GAME_HEIGHT / 4 + 14, 200)
    end
    -- buy button
    if self.player.inventory['owned_lure']['novice'] == false then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (3 * (GAME_WIDTH / 4)) - 60, GAME_HEIGHT / 4 + 44)
        love.graphics.setColor(1, 215 / 255, 0, 1)
        love.graphics.printf("BUY",(3 * (GAME_WIDTH / 4)) - 48, GAME_HEIGHT / 4 + 48, 200)
    end
    --[[
        amatuer hook
    ]]--
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][6], (GAME_WIDTH / 4) + 2, GAME_HEIGHT / 2 + 20)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][2], (GAME_WIDTH / 4) - 56, GAME_HEIGHT / 2 + 68)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('AMATEUR',(GAME_WIDTH / 4) - 46, GAME_HEIGHT / 2 + 78, 200)
    love.graphics.setColor(0, 1, 0, 1)
    if self.player.inventory['owned_lure']['amateur'] == false then
        love.graphics.printf('$4000',(GAME_WIDTH / 4) - 30, GAME_HEIGHT / 2 + 102, 200)
    else
        love.graphics.printf('OWNED',(GAME_WIDTH / 4) - 30, GAME_HEIGHT / 2 + 102, 200)
    end
    -- buy button
    if self.player.inventory['owned_lure']['amateur'] == false then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (GAME_WIDTH / 4) - 16, GAME_HEIGHT / 2 + 132)
        love.graphics.setColor(1, 215 / 255, 0, 1)
        love.graphics.printf("BUY",(GAME_WIDTH / 4) - 4, GAME_HEIGHT / 2 + 136, 200)
    end
    --[[
        advanced hook
    ]]--
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][7], (3 * GAME_WIDTH / 4) - 42, GAME_HEIGHT / 2 + 20)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][2], (3 * GAME_WIDTH / 4) - 100, GAME_HEIGHT / 2 + 68)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('ADVANCED',(3 * GAME_WIDTH / 4) - 100, GAME_HEIGHT / 2 + 78, 200)
    love.graphics.setColor(0, 1, 0, 1)
    if self.player.inventory['owned_lure']['advanced'] == false then
        love.graphics.printf('$8000',(3 * GAME_WIDTH / 4) - 70, GAME_HEIGHT / 2 + 102, 200)
    else
        love.graphics.printf('OWNED',(3 * GAME_WIDTH / 4) - 70, GAME_HEIGHT / 2 + 102, 200)
    end
    -- buy button
    if self.player.inventory['owned_lure']['advanced'] == false then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (3 * (GAME_WIDTH / 4)) - 60, GAME_HEIGHT / 2 + 132)
        love.graphics.setColor(1, 215 / 255, 0, 1)
        love.graphics.printf("BUY",(3 * (GAME_WIDTH / 4)) - 48, GAME_HEIGHT / 2 + 136, 200)
    end


    -- exit button
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], 2, 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('EXIT', 7, 7, 200)
end

function Play:drawAchievement()

    -- background
    love.graphics.draw(SpriteSheet['shop_background'])
    love.graphics.setFont(Fonts['sm'])

    -- exit button
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], 2, 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('EXIT', 7, 7, 200)

    -- fish frames
    love.graphics.setColor(1, 1, 1, 1)
    local number = 1
    local caught = 0
    for row = 0, 3 do

        for column = 0, 3 do

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][3], GAME_WIDTH / 2 - 88 + (44 * row), GAME_HEIGHT / 4 - 26 + (48 * column))

            if self.player.inventory['caught'][number] == false then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.draw(SpriteSheet['fish'], Sprites['big_fish'][number], GAME_WIDTH / 2 - 82 + (44 * row), GAME_HEIGHT / 4 - 18 + (48 * column))
            else
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(SpriteSheet['fish'], Sprites['big_fish'][number], GAME_WIDTH / 2 - 82 + (44 * row), GAME_HEIGHT / 4 - 18 + (48 * column))
                -- number of different fish caught
                caught = caught + 1
            end

            -- increment fish being draw
            number = number + 1

        end
    end

    -- completion percentage
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(Fonts['sm'])
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][2], GAME_WIDTH / 2 - 80, GAME_HEIGHT / 4 - 16 + (48 * 4))

    if caught == 16 then
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.printf('100%', GAME_WIDTH / 2 - 30, GAME_HEIGHT / 4 - 10 + (48 * 4), 300)
    else
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf(tostring((math.floor((caught / 16) * 100))) .. '%', GAME_WIDTH / 2 - 30, GAME_HEIGHT / 4 - 10 + (48 * 4), 300)
    end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('COMPLETE', GAME_WIDTH / 2 - 74, GAME_HEIGHT / 4 + 20 + (48 * 4), 300)


end

function Play:drawIntro()

    -- how to move
    if self.player.tutorial[1] == false then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.25)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("USE  'W',  'A',  'S',  AND  'D'  TO  MOVE  AROUND.", 20, 10, 150, 'center')

    end

    -- how to cast
    if self.player.tutorial[2] == false and self.player.tutorial[1] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.42)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("HOLD  DOWN  LEFT  MOUSE  TO  CAST,  DURATION  HELD  DOWN  INCREASES  THE  CAST  DISTANCE.", 20, 10, 150, 'center')

    end

    -- how to reel in
    if self.player.tutorial[3] == false and self.player.tutorial[2] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.55)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("CLICKING  AND / OR  HOLDING  DOWN  RIGHT  MOUSE  MOVES  THE  REEL  POSITION,  OVERLAP  THE  REEL  AND  FISH  TO  REEL  THE  FISH  IN.", 20, 10, 150, 'center')

    end

    -- how and when to sell fish
    if self.player.tutorial[4] == false and self.player.tutorial[3] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.6)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("CAUGHT  FISH  ARE  STORED  IN  YOUR  INVENTORY  AT  THE  BOTTOM,  YOU  CAN  ONLY  HOLD  FIVE  FISH  AT  A  TIME.  CLICK  ON  THE  SELL  BUTTON  TO  SELL  YOUR  FISH.", 20, 10, 150, 'center')

    end

    -- what is in the shop
    if self.player.tutorial[5] == false and self.player.tutorial[4] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.46)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("PURCHASING  LURES  ALLOWS  YOU  TO  CATCH  NEW  FISH.  CLICK  ON  THE  SHOP  BUTTON  TO  CHECK  IT  OUT.", 20, 10, 150, 'center')

    end

    -- what are achievments
    if self.player.tutorial[6] == false and self.player.tutorial[5] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.54)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("THE  GOAL  OF  THE  GAME  IS  TO  CATCH  ONE  OF  EVERY  DIFFERENT  FISH.  CLICK  ON  THE  TROPHY  TO  SEE  YOUR  PROGRESS.", 20, 10, 150, 'center')

    end

end
