--[[
    Player shopping state.
]]
PlayerShop = Class{__includes = Base}

function PlayerShop:init(player)

    -- player
    self.player = player

end

function PlayerShop:update(dt)

    -- buy items from shop
    if love.mouse.pressed(1) then
        -- novice hook
        if mouseX >= ((3 * (GAME_WIDTH / 4)) - 60) and mouseX <= ((3 * (GAME_WIDTH / 4)) + 20) and mouseY >= (GAME_HEIGHT / 4 + 44 )and mouseY <= (GAME_HEIGHT / 4 + 76)
        and self.player.inventory['money'] >= 2000 and self.player.inventory['owned_lure']['novice'] == false and self.player.inventory['owned_lure']['amateur'] == false
        and self.player.inventory['owned_lure']['advanced'] == false then

            -- play loose money sound
            Sounds['loose_money']:play()

            -- decrement player money
            self.player.inventory['money'] = self.player.inventory['money'] - 2000

            -- set lure to owned
            self.player.inventory['owned_lure']['novice'] = true

            -- equip lure
            self.player.inventory['lure'] = 'novice'

        -- amatuer hook
        elseif mouseX >= ((GAME_WIDTH / 4) - 16) and mouseX <= ((GAME_WIDTH / 4) + 64) and mouseY >= (GAME_HEIGHT / 2 + 132) and mouseY <= (GAME_HEIGHT / 2 + 164)
        and self.player.inventory['money'] >= 4000 and self.player.inventory['owned_lure']['amateur'] == false and self.player.inventory['owned_lure']['novice'] == true then

            -- play loose money sound
            Sounds['loose_money']:play()

            -- decrement player money
            self.player.inventory['money'] = self.player.inventory['money'] - 4000

            -- set lure to owned
            self.player.inventory['owned_lure']['amateur'] = true

            -- equip lure
            self.player.inventory['lure'] = 'amateur'

        -- advanced hook
        elseif mouseX >= ((3 * (GAME_WIDTH / 4)) - 60) and mouseX <= ((3 * (GAME_WIDTH / 4)) + 20) and mouseY >= (GAME_HEIGHT / 2 + 132) and mouseY <= (GAME_HEIGHT / 2 + 164)
        and self.player.inventory['money'] >= 8000 and self.player.inventory['owned_lure']['advanced'] == false and self.player.inventory['owned_lure']['amateur'] == true then

            -- play loose money sound
            Sounds['loose_money']:play()

            -- decrement player money
            self.player.inventory['money'] = self.player.inventory['money'] - 8000

            -- set lure to owned
            self.player.inventory['owned_lure']['advanced'] = true

            -- equip lure
            self.player.inventory['lure'] = 'advanced'
            
        -- health
        elseif mouseX >= (GAME_WIDTH / 2) - 40 and mouseX <= (GAME_WIDTH / 2) + 39  and mouseY >= GAME_HEIGHT / 2 + 44 and mouseY <= GAME_HEIGHT / 2 + 75 and self.player.inventory['money'] >= 500
        and self.player.health < 8 then

            -- play loose money sound
            Sounds['loose_money']:play()

            -- decrement player money
            self.player.inventory['money'] = self.player.inventory['money'] - 500

            -- increment player health
            self.player.health = self.player.health + 1
        end
    end
    

    -- press escape to exit shop
    if love.mouse.pressed(1) and mouseX >= 2 and mouseX <= 82 and mouseY >= 2 and mouseY <= 34 then
        self.player.shopping = false
        self.player.paused = false
        self.player:changeState('idle')
    end

end