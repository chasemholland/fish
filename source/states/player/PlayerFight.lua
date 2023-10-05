--[[
    Fighting state.
]]

PlayerFight = Class {__includes = Base}

function PlayerFight:init(player, enemies)

    -- player
    self.player = player

    -- enemies
    self.enemies = enemies

    -- timer to cycle through animations
    self.anim_timer = 0

    -- keep track of animation
    self.anim_played = 0

    -- get current direction
    self.player.frame = self:getFrame()

    -- check hit once
    self.checked = false

end

function PlayerFight:update(dt)

    if self.anim_played < 2 then
        self:anim(self.player.direction, dt)
        if not self.checked then
            for i = 1, #self.enemies do
                if not self.enemies[i].dead and self:hitEnemies(self.player.direction, self.enemies[i]) then
                    -- play hit sound
                    Sounds['sword_hit']:play()
                    -- decrement enemy health
                    self.enemies[i].health = self.enemies[i].health - 1
                    -- flag enemy as hurt
                    self.enemies[i].hurt['hit'] = true
                end
            end
            -- turn check on to prevent multiple checks
            self.checked = true
        end
    else
        self.player:changeState('idle')
    end

end

function PlayerFight:anim(direction, dt)

    self.anim_timer = self.anim_timer + dt * 16

    if self.anim_timer > 1 then
        if direction == 'up' then
            if self.player.frame == FIGHT_UP[1] then
                self.player.frame = FIGHT_UP[2]
                self.anim_played = self.anim_played + 1
                self.anim_timer = 0
            elseif self.player.frame == FIGHT_UP[2] then
                self.player.frame = FIGHT_UP[1]
                self.anim_played = self.anim_played + 1
                self.enim_timer = 0
            end
        elseif direction == 'down' then
            if self.player.frame == FIGHT_DOWN[1] then
                self.player.frame = FIGHT_DOWN[2]
                self.anim_played = self.anim_played + 1
                self.anim_timer = 0
            elseif self.player.frame == FIGHT_DOWN[2] then
                self.player.frame = FIGHT_DOWN[1]
                self.anim_played = self.anim_played + 1
                self.enim_timer = 0
            end
        elseif direction == 'left' then
            if self.player.frame == FIGHT_LEFT[1] then
                self.player.frame = FIGHT_LEFT[2]
                self.anim_played = self.anim_played + 1
                self.anim_timer = 0
            elseif self.player.frame == FIGHT_LEFT[2] then
                self.player.frame = FIGHT_LEFT[1]
                self.anim_played = self.anim_played + 1
                self.enim_timer = 0
            end
        elseif direction == 'right' then
            if self.player.frame == FIGHT_RIGHT[1] then
                self.player.frame = FIGHT_RIGHT[2]
                self.anim_played = self.anim_played + 1
                self.anim_timer = 0
            elseif self.player.frame == FIGHT_RIGHT[2] then
                self.player.frame = FIGHT_RIGHT[1]
                self.anim_played = self.anim_played + 1
                self.enim_timer = 0
            end
        end
    end
end

function PlayerFight:hitEnemies(direction, enemy)

    if direction == 'up' then
        if self.player.y + 48 >= enemy.y - 32 and self.player.y - 48 <= enemy.y 
        and self.player.x - 16 <= enemy.x and self.player.x + 80 >= enemy.x + 32 then
            -- store the side the enemy was hit from
            enemy.hurt['side'] = 'bottom'
            return true
        else
            return false
        end
    elseif direction == 'down' then
        if self.player.y + 32 <= enemy.y and self.player.y + 112 >= enemy.y + 32 
        and self.player.x - 16 <= enemy.x and self.player.x + 80 >= enemy.x + 32 then
            -- store the side the enemy was hit from
            enemy.hurt['side'] = 'top'
            return true
        else
            return false
        end
    elseif direction == 'left' then
        if self.player.x + 32 >= enemy.x + 32 and self.player.x - 48 <= enemy.x 
        and self.player.y - 16 <= enemy.y and self.player.y + 80 >= enemy.y + 32 then
            -- store the side the enemy was hit from
            enemy.hurt['side'] = 'right'
            return true
        else
            return false
        end
    elseif direction == 'right' then
        if self.player.x + 32 <= enemy.x and self.player.x + 112 >= enemy.x + 32 
        and self.player.y - 16 <= enemy.y and self.player.y + 80 >= enemy.y + 32 then
            -- store the side the enemy was hit from
            enemy.hurt['side'] = 'left'
            return true
        else
            return false
        end
    end
end

function PlayerFight:getFrame()

    if self.player.frame == PLAYER_IDLE_UP or self.player.frame == PLAYER_UP[1] or self.player.frame == PLAYER_UP[2] 
    or self.player.frame == PLAYER_UP[3] or self.player.frame == PLAYER_UP[4] then
        return FIGHT_IDLE_UP
    elseif self.player.frame == PLAYER_IDLE_DOWN or self.player.frame == PLAYER_DOWN[1] or self.player.frame == PLAYER_DOWN[2] 
    or self.player.frame == PLAYER_DOWN[3] or self.player.frame == PLAYER_DOWN[4]then
        return FIGHT_IDLE_DOWN
    elseif self.player.frame == PLAYER_IDLE_LEFT or self.player.frame == PLAYER_LEFT[1] or self.player.frame == PLAYER_LEFT[2] 
    or self.player.frame == PLAYER_LEFT[3] or self.player.frame == PLAYER_LEFT[4] then
        return FIGHT_IDLE_LEFT
    elseif self.player.frame == PLAYER_IDLE_RIGHT or self.player.frame == PLAYER_RIGHT[1] or self.player.frame == PLAYER_RIGHT[2] 
    or self.player.frame == PLAYER_RIGHT[3] or self.player.frame == PLAYER_RIGHT[4] then
        return FIGHT_IDLE_RIGHT
    end
end