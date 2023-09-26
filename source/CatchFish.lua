--[[
    Functions used to determine what fish is caught.
]]

CatchFish = Class{}

function CatchFish:init(lure)

    self.lure = lure
    self.fish = self:fish(self.lure)

end

function CatchFish:fish(lure)

    local fish = 1

    if lure == 'basic' then

        for i = 1, 3 do

            local number = math.random(1, 2) == 1 and true or false
            if number == true then
                fish = fish + 1
            end

        end

    elseif lure == 'novice' then

        local fish_level = math.random(1, 2)
        if fish_level == 1 then
            fish = fish
        elseif fish_level == 2 then
            fish = 5
        end

        for i = 1, 3 do

            local number = math.random(1, 2) == 1 and true or false
            if number == true then
                fish = fish + 1
            end
        end

    elseif lure == 'amateur' then

        local fish_level = math.random(1, 3)
        if fish_level == 1 then
            fish = fish
        elseif fish_level == 2 then
            fish = 5
        elseif fish_level == 3 then
            fish = 9
        end

        for i = 1, 3 do

            local number = math.random(1, 2) == 1 and true or false
            if number == true then
                fish = fish + 1
            end
        end

    elseif lure == 'advanced' then

        local fish_level = math.random(1, 4)
        if fish_level == 1 then
            fish = fish
        elseif fish_level == 2 then
            fish = 5
        elseif fish_level == 3 then
            fish = 9
        elseif fish_level == 4 then
            fish = 13
        end

        for i = 1, 3 do

            local number = math.random(1, 2) == 1 and true or false
            if number == true then
                fish = fish + 1
            end
        end

    end

    return fish
end


            
