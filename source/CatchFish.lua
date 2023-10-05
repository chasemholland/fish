--[[
    Functions used to determine what fish is caught.
]]

CatchFish = Class{}

function CatchFish:init(area, inventory)

    self.fish = self:fish(area, inventory)

end

function CatchFish:fish(area, inventory)

    local fish = 0

    if area == 'start' then

        local blue = math.random(1, 5)
        local yellow = math.random(1, 5)
        local red = math.random(1, 5)
        local rainbow = math.random(1, 7)

        if rainbow > red + yellow + blue then
            fish = 4
        elseif red > yellow and red > blue then
            fish = 3
        elseif yellow > blue then
            fish = 2
        else
            fish = 1
        end

    elseif area == 'river' then

        local blue = math.random(1, 5)
        local yellow = math.random(1, 5)
        local red = math.random(1, 5)
        local rainbow = math.random(1, 7)

        if rainbow > red + yellow + blue then
            fish = 8
        elseif red > yellow and red > blue then
            fish = 7
        elseif yellow > blue then
            fish = 6
        else
            fish = 5
        end

    elseif area == 'beach' then
        if inventory['lure'] == 'amateur' then

            local blue = math.random(1, 5)
            local yellow = math.random(1, 5)
            local red = math.random(1, 5)
            local rainbow = math.random(1, 7)

            if rainbow > red + yellow + blue then
                fish = 12
            elseif red > yellow and red > blue then
                fish = 11
            elseif yellow > blue then
                fish = 10
            else
                fish = 9
            end

        elseif inventory['lure'] == 'advanced' then

            local set = math.random(1, 2)
            if set == 1 then

                local blue = math.random(1, 5)
                local yellow = math.random(1, 5)
                local red = math.random(1, 5)
                local rainbow = math.random(1, 7)

                if rainbow > red + yellow + blue then
                    fish = 12
                elseif red > yellow and red > blue then
                    fish = 11
                elseif yellow > blue then
                    fish = 10
                else
                    fish = 9
                end

            else
            
                local blue = math.random(1, 5)
                local yellow = math.random(1, 5)
                local red = math.random(1, 5)
                local rainbow = math.random(1, 7)

                if rainbow > red + yellow + blue then
                    fish = 16
                elseif red > yellow and red > blue then
                    fish = 15
                elseif yellow > blue then
                    fish = 14
                else
                    fish = 13
                end
            end
        end
    end

    return fish
end