--[[
    Player fishing state.
]]
PlayerFishing = Class{__includes = Base}

function PlayerFishing:init(player)

    -- player
    self.player = player

    -- fish
    self.fish = 0

    -- timer for chance of fish on
    self.timer = 0

    -- timer for fish moving
    self.fish_timer = 0

    -- position fish moving to
    self.fish_final_position = 0

    -- flag if fish has been hooked
    self.player.fish_on = false

    -- start reel position opposite of starting fish position
    self.player.reel_position = self.player.cast_max - 32

    -- starting fish position
    self.player.fish_position = math.random(self.player.cast_max - 16)

    -- player reel in progress
    self.player.reel_in = 2

    -- break away timer
    self.player.fish_breakaway = 1

    -- flag for fish_on sound played
    self.sound_played = false

end

function PlayerFishing:update(dt)

    if self.timer >= 1 then
        if self.player.fish_on == false then
            self.player.fish_on = math.random(1, 10) == 1 and true or false
        end
        if self.player.fish_on == true then

            if self.sound_played == false then
                -- play fish_on sound
                Sounds['fish_on']:setLooping(false)
                Sounds['fish_on']:play()
                self.sound_played = true
            end

            self.fish = CatchFish(self.player.area).fish

            -- fishing mechanic
            if love.mouse.isDown(2) then
                -- increase reel position
                if self.player.reel_position >= self.player.cast_max - 32 then
                    self.player.reel_position = self.player.cast_max - 32
                else
                    self:reelPosition(1.5)
                end
            else
                -- decrease reel position
                if self.player.reel_position <= 1 then
                    self.player.reel_position = 0
                else
                    self:reelPosition(-1.5)
                end
            end

            if self.fish_timer >= 1 then

                -- only get a new final position once fish reaches final position
                if self.fish_final_position == 0 then
                    -- move fish position
                    self:fishPosition(math.floor(math.random(-(self.player.cast_max - 16), (self.player.cast_max - 16))))
                end

                -- increment fish position to its final position
                if self.player.fish_position < self.fish_final_position then
                    self.player.fish_position = self.player.fish_position + 1
                elseif self.player.fish_position > self.fish_final_position then
                    self.player.fish_position = self.player.fish_position - 1
                elseif self.player.fish_position == self.fish_final_position then
                    -- reset final position
                    self.fish_final_position = 0
                    -- set fish timer back to zero
                    self.fish_timer = 0
                end
            else
                -- increment fish timer
                self:fishTimer(dt, self.fish)
            end

            -- reel the fish in
            if self.player.reel_position <= self.player.fish_position and self.player.reel_position + 32 >= self.player.fish_position + 16 then
                self.player.reel_in = self.player.reel_in + 2
                -- decrease break away timer
                if self.player.fish_breakaway >= 1 then
                    self:fishBreakaway(dt, -1)
                else
                    self.player.fish_breakaway = 1
                end
            else
                if self.player.reel_in <= 2 then
                    self.player.reel_in = 2
                    if self.player.fish_breakaway < BREAK then
                        self:fishBreakaway(dt, 1)
                    else

                        -- play fish_off sound
                        Sounds['fish_off']:setLooping(false)
                        Sounds['fish_off']:play()

                        -- fish breaks away, return to idle
                        self.player.cast = false
                        self.player.fish_on = false
                        self.player:changeState('idle')
                    end
                else
                    self.player.reel_in = self.player.reel_in - 2
                    -- increase break away timer
                    if self.player.fish_breakaway < BREAK then
                        self:fishBreakaway(dt, 1)
                    else

                        -- play fish_off sound
                        Sounds['fish_off']:setLooping(false)
                        Sounds['fish_off']:play()

                        -- fish breaks away, return to idle
                        self.player.cast = false
                        self.player.fish_on = false
                        self.player:changeState('idle')
                    end
                end
            end

            -- check if fish has been caught
            if self.player.reel_in >= CATCH then

                self.player.cast = false
                self.player.fish_on = false

                -- pass the third tutorial
                if self.player.tutorial[3] == false and self.player.tutorial[1] == true and self.player.tutorial[2] == true then
                    self.player.tutorial[3] = true
                end

                -- insert fish into inventory
                for i = 1, 5 do
                    if self.player.inventory['fish'][i] == nil then
                        self.player.inventory['fish'][i] = self.fish
                        -- check if fish is new
                        if self.player.inventory['caught'][self.fish] == false then
                            -- flag for message about new fish
                            self.player.catch_new = true
                            -- play new_fish sound
                            Sounds['new_fish']:setLooping(false)
                            Sounds['new_fish']:play()
                            -- set fish to has been caught
                            self.player.inventory['caught'][self.fish] = true
                            goto continue
                        else
                            -- play old_fish sound
                            Sounds['old_fish']:setLooping(false)
                            Sounds['old_fish']:play()
                            goto continue
                        end
                    end
                end
                ::continue::
                
                self.player:changeState('idle')
            end

        else
            self.timer = 0
        end
    else
        self:getNibble(dt)
    end


    -- allow to exit fishing before hooked
    if love.mouse.isDown(2) and not self.player.fish_on then
        self.player.cast = false
        self.player:changeState('idle')
    end

end

-- increment power
function PlayerFishing:getNibble(dt)

    self.timer = self.timer + dt * 2

end

function PlayerFishing:reelPosition(direction)

    self.player.reel_position = self.player.reel_position + direction

end

function PlayerFishing:fishTimer(dt, fish)

    if fish <= 4 then
        self.fish_timer = self.fish_timer + dt
    elseif fish >= 5 and fish <= 8 then
        self.fish_timer = self.fish_timer + dt * 2
    elseif fish >= 9 and fish <= 12 then
        self.fish_timer = self.fish_timer + dt * 3
    elseif fish >= 13 and fish <= 16 then
        self.fish_timer = self.fish_timer + dt * 4
    end

end

function PlayerFishing:fishBreakaway(dt, direction)

    self.player.fish_breakaway = self.player.fish_breakaway + (direction * dt * 20)

end

function PlayerFishing:fishPosition(direction)

    if direction + self.fish_final_position <= 0 then
        return
    elseif direction + self.fish_final_position >= self.player.cast_max - 16 then
        return
    else
        self.fish_final_position = self.fish_final_position + direction
    end

end
