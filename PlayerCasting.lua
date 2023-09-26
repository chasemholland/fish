--[[
    Player casting state.
]]
PlayerCasting = Class{__includes = Base}

function PlayerCasting:init(player)

    -- player
    self.player = player

    -- get the current casting direction frame
    if self.player.direction == 'left' then
        self.player.frame = PLAYER_CAST_LEFT
    elseif self.player.direction == 'right' then
        self.player.frame = PLAYER_CAST_RIGHT
    elseif self.player.direction == 'up' then
        self.player.frame = PLAYER_CAST_UP
    elseif self.player.direction == 'down' then
        self.player.frame = PLAYER_CAST_DOWN
    end

    -- temp value for power, set to 0 on init
    self.player.timer = 0

    -- flag for if player has cast, set to false on init
    self.player.cast = false


end

function PlayerCasting:update(dt)

    -- check to see if mouse was released
    if not love.mouse.isDown(1) and not self.player.cast then
        -- cast the line
        self:Cast()
    -- set a max power
    elseif self.player.timer >= self.player.cast_max - 1 then
        self.player.power = math.floor(self.player.timer)
    -- increment power while holding down the mouse
    elseif not self.player.cast then
        self:getPower(dt)
    end

    
    -- check if fishing is complete switch to idle state
    if love.mouse.isDown(2) then
        self.player.cast = false
        self.player:changeState('idle')
    end

end

-- increment power
function PlayerCasting:getPower(dt)

    self.player.timer = self.player.timer + dt * 200

end

function PlayerCasting:Cast()

    self.player.casting = false
    self.player.cast = true
    self.player.power = math.floor(self.player.timer)
    self.player.timer = 0

    -- only allow casting into water
    if self.player.frame == PLAYER_CAST_LEFT then
        self.player.frame = PLAYER_FISH_LEFT
        self.player:changeState('idle')
    elseif self.player.frame == PLAYER_CAST_RIGHT then
        self.player.frame = PLAYER_FISH_RIGHT
        self.player:changeState('idle')

    elseif self.player.frame == PLAYER_CAST_UP then
        self.player.frame = PLAYER_FISH_UP
        self.player:changeState('idle')

    elseif self.player.frame == PLAYER_CAST_DOWN then
        self.player.frame = PLAYER_FISH_DOWN

        -- check if cast was on a water tile
        if ((self.player.y + POLE_TIP_DOWN[2]) + self.player.power) <= WATER_TOP then
            self.player:changeState('idle')
        else
            self.player:changeState('fishing')
        end
    end

end