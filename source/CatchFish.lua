--[[
    Functions used to determine what fish is caught.
]]

CatchFish = Class{}

function CatchFish:init(area)

    self.fish = self:fish(area)

end

function CatchFish:fish(area)

    local fish = 1

    if area == 'start' then

        for i = 1, 3 do

            local number = math.random(1, 4) == 1 and true or false
            if number == true then
                fish = fish + 1
            end

        end

    elseif area == 'river' then

        fish = 5

        for i = 1, 3 do

            local number = math.random(1, 4) == 1 and true or false
            if number == true then
                fish = fish + 1
            end
        end

--[[
    elseif area == 'beach' then

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
        ]]

    elseif area == 'beach' then

        local fish_level = math.random(1, 2)
        if fish_level == 1 then
            fish = 9
        elseif fish_level == 2 then
            fish = 13
        end

        for i = 1, 3 do

            local number = math.random(1, 4) == 1 and true or false
            if number == true then
                fish = fish + 1
            end
        end

    end

    return fish
end
