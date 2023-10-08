Play = Class{__includes = Base}

function Play:init()

end

function Play:enter(params)

    -- set up world
    self.world = GenerateWorld()

    -- current world
    self.current_world = 'start'

    -- initialize a player
    self.player = params.player

    -- initialize enemies
    self.enemies = {}
    for i = 1, math.random(8, 10) do
        table.insert(self.enemies, Enemies())
        -- set up enemies state machine
        self.enemies[i].statemachine = SM {
            ['walk'] = function() return EnemiesWalk(self.enemies[i], self.player) end,
            ['idle'] = function() return EnemiesIdle(self.enemies[i]) end
        }
        self.enemies[i]:changeState('idle')
    end

    -- set up player state machine
    self.player.statemachine = SM {
        ['walk'] = function() return PlayerWalk(self.player) end,
        ['idle'] = function() return PlayerIdle(self.player) end,
        ['casting'] = function() return PlayerCasting(self.player) end,
        ['fishing'] = function() return PlayerFishing(self.player) end,
        ['fight'] = function() return PlayerFight(self.player, self.enemies) end,
        ['shop'] = function() return PlayerShop(self.player) end,
        ['inventory'] = function() return PlayerInventory(self.player) end,
        ['achievement'] = function() return PlayerAchievement(self.player) end
    }
    self.player:changeState('idle')

    -- flag to check for correct lure
    self.check_lure = false

    -- timer for how long to diplay usage message
    self.timer = 0

    -- how long to display new fish message
    self.catch_timer = 0

    -- timer to trigger night time
    self.night_timer = CYCLE / 2

    -- night flag
    self.night = false

    -- only spawn on area enter
    self.spawned = false

    -- timer to spawn more enemies
    self.spawn_timer = 0

    -- time in game
    self.game_time = 0

    -- completion check
    self.completion = 0

end

function Play:update(dt)

    -- keep track of time played
    self:gameTimer(dt)

    -- increment the day cycle
    if self.night_timer >= 1 then
        self:nightTimer(dt)
    elseif not self.night then
        self.night = true
        self.night_timer = CYCLE
    elseif self.night then
        self.night = false
        self.night_timer = CYCLE
    end

    -- check if enemies have been spawned
    if self.current_world == 'river' and self.night and not self.spawned then
        for i = 1, #self.enemies do
            self.enemies[i].area = self.current_world
            self.enemies[i].x = math.random(GAME_WIDTH / 2, GAME_WIDTH - 66)
            self.enemies[i].y = math.random(10, GAME_HEIGHT - 48)
            self.enemies[i].waiting = false
            self.enemies[i]:changeState('walk')
        end
        self.spawned = true
    elseif self.current_world == 'beach' and self.night and not self.spawned then
        for i = 1, #self.enemies do
            self.enemies[i].area = self.current_world
            self.enemies[i].x = math.random(96, GAME_WIDTH / 2 - 16)
            self.enemies[i].y = math.random(0, GAME_HEIGHT - 36)
            self.enemies[i].waiting = false
            self.enemies[i]:changeState('walk')
        end
        self.spawned = true
    elseif self.current_world == 'start' or not self.night then
        for i = 1, #self.enemies do
            self.enemies[i].x = 0
            self.enemies[i].y = 0
            self.enemies[i].waiting = true
            self.enemies[i]:changeState('idle')
        end
        self.spawned = false
    end

    -- randomly generate more enemies at night
    if self.current_world == 'river' and self.night then
        if self.spawn_timer > 10 then
            local current_count = #self.enemies
            for i = 1, math.random(3, 6) do
                table.insert(self.enemies, Enemies())
                -- set up enemies state machine
                self.enemies[i + current_count].statemachine = SM {
                    ['walk'] = function() return EnemiesWalk(self.enemies[i + current_count], self.player) end,
                    ['idle'] = function() return EnemiesIdle(self.enemies[i + current_count]) end
                }
                self.enemies[i + current_count].area = self.current_world
                self.enemies[i + current_count].x = math.random(GAME_WIDTH / 2, GAME_WIDTH - 66)
                self.enemies[i + current_count].y = math.random(10, GAME_HEIGHT - 48)
                self.enemies[i + current_count].waiting = false
                self.enemies[i + current_count]:changeState('walk')
            end
            self.spawn_timer = 0
        else
            self:spawnTimer(dt)
        end
    elseif self.current_world == 'beach' and self.night then
        if self.spawn_timer > 10 then
            local current_count = #self.enemies
            for i = 1, math.random(3, 6) do
                table.insert(self.enemies, Enemies())
                -- set up enemies state machine
                self.enemies[i + current_count].statemachine = SM {
                    ['walk'] = function() return EnemiesWalk(self.enemies[i + current_count], self.player) end,
                    ['idle'] = function() return EnemiesIdle(self.enemies[i + current_count]) end
                }
                self.enemies[i + current_count].area = self.current_world
                self.enemies[i + current_count].x = math.random(96, GAME_WIDTH / 2 - 16)
                self.enemies[i + current_count].y = math.random(0, GAME_HEIGHT - 36)
                self.enemies[i + current_count].waiting = false
                self.enemies[i + current_count]:changeState('walk')
            end
            self.spawn_timer = 0
        else
            self:spawnTimer(dt)
        end
    end
    
    -- render correct area
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

    -- check for correct lure in area
    if self.player.casting and self.current_world == 'river'then
        if self.player.inventory['lure'] == 'basic' then
            self.check_lure = true
        else
            self.check_lure = false
        end
    elseif self.player.casting and self.current_world == 'beach' then
        if self.player.inventory['lure'] == 'basic' or self.player.inventory['lure'] == 'novice' then
            self.check_lure = true
        else
            self.check_lure = false
        end
    end

    -- display message for short period of time
    if self.check_lure and self.timer < 5 then
        self:waitTimer(dt)
    elseif self.timer > 5 then
        self.timer = 0
        self.check_lure = false
    end

    -- display new fish mesage for short period of time
    if self.player.catch_new and self.catch_timer < 5 then
        self:catchTimer(dt)
    elseif self.catch_timer > 5 then
        self.catch_timer = 0
        self.player.catch_new = false
    end

    -- update the world
    self.world:update(dt)

    -- update enemies
    for i = 1, #self.enemies do
        if not self.enemies[i].dead and self.enemies[i].health <= 0 then
            -- pass the eighth tutorial
            if self.player.tutorial[8] == false and self.player.tutorial[7] == true then
                self.player.tutorial[8] = true
            end
            -- kill enemy
            self.enemies[i].dead = true
            -- increment kill count
            self.player.kills = self.player.kills + 1
            -- chance for money
            local money = math.random((self.enemies[i].color * (10)), (self.enemies[i].color * (20)))
            -- store money gained for visual
            self.player.money_gained['value'] = money
            -- increment player money
            self.player.inventory['money'] = self.player.inventory['money'] + money
            -- increment total earned money
            self.player.money_earned = self.player.money_earned + money
            -- play get money sound
            Sounds['get_money']:play()
        else
            self.enemies[i]:update(dt)
        end
    end

    -- pass the nineth tutorial
    if self.player.tutorial[9] == false and self.player.tutorial[8] == true then
        Timer.after(8, function()
            self.player.tutorial[9] = true
        end)
    end

    -- show money gained
    if self.player.money_gained['value'] > 0 then
        Timer.tween(.5, {
            [self.player.money_gained] = {alpha = 0}
        }):finish(function()
            self.player.money_gained['value'] = 0
            self.player.money_gained['alpha'] = 255
        end)
    end

    -- update the player
    self.player:update(dt)

    -- allow user to quit game
    if love.mouse.pressed(1) and mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= GAME_HEIGHT - 34 and mouseY <= GAME_HEIGHT - 2 then
        love.event:quit()
    end

    -- switch item
    if self.player.equiped ~= 'pole' then
        if love.mouse.wheelmoved == 'up' or love.keyboard.pressed('t') then
            -- pass the seventh tutorial
            if self.player.tutorial[7] == false and self.player.tutorial[6] == true then
                self.player.tutorial[7] = true
            end
            self.player.equiped = 'pole'
        end
    elseif self.player.equiped ~= 'sword' then
        if love.mouse.wheelmoved == 'down' or love.keyboard.pressed('t') then
            self.player.equiped = 'sword'
        end
    end

    -- end game if player dies
    if self.player.health <= 0 then
        gameSM:change('game-over', {
            time = self.game_time,
            money = self.player.money_earned,
            caught = self.player.fish_count,
            lost = self.player.loss_count,
            kills = self.player.kills,
            completion = self.completion
        })
    -- end game if player reaches 100%
    elseif self.completion == 100 then
        gameSM:change('game-over', {
            time = self.game_time,
            money = self.player.money_earned,
            caught = self.player.fish_count,
            lost = self.player.loss_count,
            kills = self.player.kills,
            completion = self.completion
        })
    end

end

function Play:render()

    if self.player.shopping then

        -- shop
        self:drawShop()

    elseif self.player.browsing_achievements then

        -- achievements
        self:drawAchievement()

    else
        -- render the world
        self.world:render()

        -- render enemies
        if self.current_world == 'river' or self.current_world == 'beach' and self.night then
            for i = 1, #self.enemies do
                self.enemies[i]:render()
            end
        end
        -- render the player
        self.player:render()

        -- darken the screen for night time
        if self.night then
            love.graphics.setColor(0, 0, 0, 100 / 255)
            love.graphics.rectangle('fill', 0, 0, GAME_WIDTH, GAME_HEIGHT)
        end

        -- reset color
        love.graphics.setColor(1, 1, 1, 1)

        -- render cast power bar if casting
        if self.player.casting then
            love.graphics.setLineWidth(2)
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.rectangle('fill', 16, GAME_HEIGHT - self.player.timer / 2, 8, self.player.timer / 2, 4)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.rectangle('line', 16, GAME_HEIGHT - self.player.cast_max / 2, 8, self.player.cast_max / 2, 6)
        end

        -- render fishing mechanic
        if self.player.fish_on then
            self:drawFishing()
        end

        -- render usage for area
        if self.check_lure then
            self:drawUsage(self.player.area)
        end

        -- messsage for new fish
        if self.player.catch_new then
            -- reset color
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(Fonts['x-sm'])
            love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], GAME_WIDTH / 2 - 52, 0, 0, 0.25, 0.20)
            love.graphics.setColor(0, 0, 0, 180 / 255)
            love.graphics.printf("NEW  FISH !!!", GAME_WIDTH / 2 - 80, 10, 150, 'center')
        end

        -- tips on how to play
        self:drawIntro()

        -- reset color
        love.graphics.setColor(1, 1, 1, 1)

        -- render player hearts
        self:drawHearts()

        -- player inventory
        for i = 1, 5 do
            love.graphics.draw(SpriteSheet['inventory'], Sprites['inventory'][1], (30 * 7) + (i * 30), GAME_HEIGHT - 31)
        end

        -- render fish caught in inventory
        if self.player.inventory['fish'][1] ~= nil then
            for i = 1, 5 do
                if self.player.inventory['fish'][i] ~= nil then
                    love.graphics.draw(SpriteSheet['fish'], Sprites['small_fish'][self.player.inventory['fish'][i]], (30 * 7) + (i * 30) + 7, GAME_HEIGHT - 24)
                end
            end
        end

        -- selected item
        if self.player.equiped == 'pole' then
            love.graphics.setColor(1, 1, 1, 140 / 255)
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][2], 30 * 6, GAME_HEIGHT - 32)
            love.graphics.setColor(1, 1, 1 ,1)
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][3], 30 * 5, GAME_HEIGHT - 32)
        elseif self.player.equiped == 'sword' then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][2], 30 * 6, GAME_HEIGHT - 32)
            love.graphics.setColor(1, 1, 1, 140 / 255)
            love.graphics.draw(SpriteSheet['fish'], Sprites['items'][3], 30 * 5, GAME_HEIGHT - 32)
        end
        

        -- render quit button
        if mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= GAME_HEIGHT - 34 and mouseY <= GAME_HEIGHT - 2 then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 180 / 255)
        end
        love.graphics.setFont(Fonts['sm'])
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], GAME_WIDTH - 82, GAME_HEIGHT - 34)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf('QUIT', GAME_WIDTH - 76, GAME_HEIGHT - 30, 200)

        -- render money
        love.graphics.setColor(1, 215 / 255, 0, 1)
        love.graphics.printf('$' .. tostring(self.player.inventory['money']), 397, GAME_HEIGHT - 28, 150)
        -- render money gained
        if self.player.money_gained['value'] > 0 then
            love.graphics.setColor(0, 1, 0, self.player.money_gained['alpha'] / 255)
            love.graphics.printf('+ $' .. tostring(self.player.money_gained['value']), 397, GAME_HEIGHT - 52, 150)
        end

        -- render shop button
        love.graphics.setFont(Fonts['sm'])
        if mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= 2 and mouseY <= 34 then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 180 / 255)
        end
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], GAME_WIDTH - 82, 2)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf('SHOP', GAME_WIDTH - 80, 7, 100)

        -- render sell button
        if mouseX >= GAME_WIDTH - 82 and mouseX <= GAME_WIDTH - 2 and mouseY >= 36 and mouseY <= 68 then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 180 / 255)
        end
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], GAME_WIDTH - 82, 36)
        love.graphics.setColor(0, 1, 0, 180 / 255)
        love.graphics.printf('SELL', GAME_WIDTH - 76, 41, 100)

        -- render achievement button
        if mouseX >= GAME_WIDTH - 46 and mouseX <= GAME_WIDTH - 2 and mouseY >= 70 and mouseY <= 118 then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 180 / 255)
        end
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][8], GAME_WIDTH - 46, 70)

        -- render night/day indicator
        love.graphics.setFont(Fonts['sm'])
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('fill', GAME_WIDTH - 208, 20, CYCLE, 12, 2)
        if not self.night then
            love.graphics.printf("DAY", GAME_WIDTH - 178, -2, 200)
        else
            love.graphics.printf("NIGHT", GAME_WIDTH - 190, -2, 200)
        end
        -- night/day progress indicator
        if not self.night then
            -- day bar
            love.graphics.setColor(1, 204 / 255, 0, 1)
            love.graphics.rectangle('fill', (GAME_WIDTH - 208 + (CYCLE - self.night_timer)), 20, self.night_timer, 12)
            -- night bar
            love.graphics.setColor(0, 0, 139 / 255, 1)
            love.graphics.rectangle('fill', GAME_WIDTH - 208, 20, (CYCLE - self.night_timer), 12)
        else
            -- day bar
            love.graphics.setColor(1, 204 / 255, 0, 1)
            love.graphics.rectangle('fill', GAME_WIDTH - 208, 20, (CYCLE - self.night_timer), 12)
            -- night bar
            love.graphics.setColor(0, 0, 139 / 255, 1)
            love.graphics.rectangle('fill', (GAME_WIDTH - 208 + (CYCLE - self.night_timer)), 20, self.night_timer, 12)
        end
        love.graphics.setLineWidth(2)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('line', GAME_WIDTH - 208, 20, CYCLE, 12, 2)

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
        if mouseX >= ((3 * (GAME_WIDTH / 4)) - 60) and mouseX <= ((3 * (GAME_WIDTH / 4)) + 20) and mouseY >= (GAME_HEIGHT / 4 + 44 )and mouseY <= (GAME_HEIGHT / 4 + 76) then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 160 / 255)
        end
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (3 * (GAME_WIDTH / 4)) - 60, GAME_HEIGHT / 4 + 44)
        if self.player.inventory['money'] >= 2000 then
            love.graphics.setColor(1, 215 / 255, 0, 1)
        else
            love.graphics.setColor(1, 0, 0, 1)
        end
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
        if mouseX >= ((GAME_WIDTH / 4) - 16) and mouseX <= ((GAME_WIDTH / 4) + 64) and mouseY >= (GAME_HEIGHT / 2 + 132) and mouseY <= (GAME_HEIGHT / 2 + 164) then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 160 / 255)
        end
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (GAME_WIDTH / 4) - 16, GAME_HEIGHT / 2 + 132)
        if self.player.inventory['money'] >= 4000 then
            love.graphics.setColor(1, 215 / 255, 0, 1)
        else
            love.graphics.setColor(1, 0, 0, 1)
        end
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
        if mouseX >= ((3 * (GAME_WIDTH / 4)) - 60) and mouseX <= ((3 * (GAME_WIDTH / 4)) + 20) and mouseY >= (GAME_HEIGHT / 2 + 132) and mouseY <= (GAME_HEIGHT / 2 + 164) then
            love.graphics.setColor(1, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 160 / 255)
        end
        love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (3 * (GAME_WIDTH / 4)) - 60, GAME_HEIGHT / 2 + 132)
        if self.player.inventory['money'] >= 8000 then
            love.graphics.setColor(1, 215 / 255, 0, 1)
        else
            love.graphics.setColor(1, 0, 0, 1)
        end
        love.graphics.printf("BUY",(3 * (GAME_WIDTH / 4)) - 48, GAME_HEIGHT / 2 + 136, 200)
    end

    --[[
        hearts
    ]]--
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][14], (GAME_WIDTH / 2 - 22), GAME_HEIGHT / 2 - 68)
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][2], (GAME_WIDTH / 2 - 80), GAME_HEIGHT / 2 - 20)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('HEALTH', (GAME_WIDTH / 2 - 54), GAME_HEIGHT / 2 - 10, 200)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.printf('$500', (GAME_WIDTH / 2 - 38), GAME_HEIGHT / 2 + 16, 200)
    --buy button
    if mouseX >= (GAME_WIDTH / 2) - 40 and mouseX <= (GAME_WIDTH / 2) + 39  and mouseY >= GAME_HEIGHT / 2 + 44 and mouseY <= GAME_HEIGHT / 2 + 75 then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 160 / 255)
    end
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], (GAME_WIDTH / 2) - 40, GAME_HEIGHT / 2 + 44)
    if self.player.inventory['money'] >= 500 and self.player.health < 8 then
        love.graphics.setColor(1, 215 / 255, 0, 1)
    else
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.printf("BUY", (GAME_WIDTH / 2) - 28, GAME_HEIGHT / 2 + 48, 200)

    -- exit button
    if mouseX >= 2 and mouseX <= 82 and mouseY >= 2 and mouseY <= 34 then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 160 / 255)
    end
    love.graphics.draw(SpriteSheet['shop'], Sprites['shop_items'][1], 2, 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('EXIT', 7, 7, 200)
end

function Play:drawAchievement()

    -- background
    love.graphics.draw(SpriteSheet['shop_background'])
    love.graphics.setFont(Fonts['sm'])

    -- exit button
    if mouseX >= 2 and mouseX <= 82 and mouseY >= 2 and mouseY <= 34 then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 160 / 255)
    end
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

    -- keep track of completion
    self.completion = (math.floor((caught / 16) * 100))

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

function Play:drawFishing()

    -- background
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle('fill', 16, GAME_HEIGHT - self.player.cast_max , 20, self.player.cast_max, 4)
    -- reel
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', 16, GAME_HEIGHT - self.player.reel_position - 32, 20, 32, 4)
    -- fish
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(SpriteSheet['fish'], Sprites['small_fish'][2], 18, GAME_HEIGHT - self.player.fish_position - 16)
    -- outine
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 16, GAME_HEIGHT - self.player.cast_max, 20, self.player.cast_max, 4)

    -- reel in progress
    -- outine
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 38, GAME_HEIGHT - CATCH, 10, CATCH, 4)
    -- reel_in
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle('fill', 38, GAME_HEIGHT - self.player.reel_in, 10, self.player.reel_in, 4)

    -- breakaway progress
    -- outine
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('line', 50, GAME_HEIGHT - BREAK, 10, BREAK, 4)
    -- reel_in
    love.graphics.setColor((self.player.fish_breakaway * 2)/255, 100/255, 10/255, 1)
    love.graphics.rectangle('fill', 50, GAME_HEIGHT - self.player.fish_breakaway, 10, self.player.fish_breakaway, 4)

    -- reset color
    love.graphics.setColor(1, 1, 1, 1)

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

    -- switching between pole and sword
    if self.player.tutorial[7] == false and self.player.tutorial[6] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.38)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("SCOLL  YOUR  MOUSE  UP  AND  DOWN  OR  USE  'T'  TO  SWITCH  BETWEEN  POLE  AND  SWORD.", 20, 10, 150, 'center')

    end

    -- when enemies spawn
    if self.player.tutorial[8] == false and self.player.tutorial[7] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.54)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("SLIMES  WILL  SPAWN  AT  NIGHT  IN  THE  RIVER  AND  OCEAN  AREAS,  USE  YOUR  SWORD  TO  KILL  THEM  AND  EARN  SOME  EXTRA  MONEY.", 20, 10, 150, 'center')

    end

    -- what happens if you die
    if self.player.tutorial[9] == false and self.player.tutorial[8] == true then

        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.25)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("IF  YOU  DIE,  IT'S  GAME  OVER  SO  BE  CAREFUL", 20, 10, 150, 'center')

    end
    

end

function Play:drawUsage(area)

    if area == 'river' then
        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.38)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("YOU  MUST  OWN  A  NOVICE  OR  BETTER  LURE  TO  FISH  AT  THE  RIVER", 20, 10, 150, 'center')
    elseif area == 'beach' then
        love.graphics.setColor(1, 1, 1, 180 / 255)
        love.graphics.setFont(Fonts['x-sm'])
        love.graphics.draw(SpriteSheet['title'], Sprites['title'][1], 0, 0, 0, 0.5, 0.38)
        love.graphics.setColor(0, 0, 0, 180 / 255)
        love.graphics.printf("YOU  MUST  OWN  A  AMATEUR  OR  BETTER  LURE  TO  FISH  AT  THE  BEACH", 20, 10, 150, 'center')
    end
end

function Play:drawHearts()

    for i = 1, 8 do
        if self.player.health >= i then
            love.graphics.draw(SpriteSheet['fish'], Sprites['hearts'][2], (30 * 7) + (i * 18) + 16, GAME_HEIGHT - 48)
        else
            love.graphics.draw(SpriteSheet['fish'], Sprites['hearts'][1], (30 * 7) + (i * 18) + 16, GAME_HEIGHT - 48)
        end
    end


end

function Play:waitTimer(dt)

    self.timer = self.timer + dt * 2

end

function Play:catchTimer(dt)

    self.catch_timer = self.catch_timer + dt * 2

end

function Play:nightTimer(dt)

    self.night_timer = self.night_timer - dt

end

function Play:spawnTimer(dt)

    self.spawn_timer = self.spawn_timer + dt

end

function Play:gameTimer(dt)

    self.game_time = self.game_time + dt

end
