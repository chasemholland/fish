--[[
    Functions used to get sprites.
]]

function GetSmallFish(SpriteSheet)

    local small_fish = {}

    local x = 0
    local y = 0

    for column = 1, 16 do

        table.insert(small_fish, love.graphics.newQuad(
            x, y, 16, 16, SpriteSheet:getDimensions()
        ))

        x = x + 16
    end

    return small_fish
end

function GetBigFish(SpriteSheet)

    local big_fish = {}

    local x = 0
    local y = 16

    for row = 1, 2 do

        for row = 1, 8 do

            table.insert(big_fish, love.graphics.newQuad(
                x, y, 32, 32, SpriteSheet:getDimensions()
            ))

            x = x + 32
        end
        x = 0
        y = y + 32

    end

    return big_fish
end

function GetPlayer(SpriteSheet)

    local player = {}

    local x = 0
    local y = 80

    for row = 1, 6 do

        for column = 1, 4 do

            table.insert(player, love.graphics.newQuad(
                x, y, 64, 64, SpriteSheet:getDimensions()
            ))

            x = x + 64
        end
        x = 0
        y = y + 64

    end

    local x = 0
    local y = 480

    for row = 1, 2 do

        for column = 1, 4 do

            table.insert(player, love.graphics.newQuad(
                x, y, 64, 64, SpriteSheet:getDimensions()
            ))

            x = x + 64

        end
        x = 0
        y = y + 64

    end

    return player
end

function GetGround(SpriteSheet)

    local ground = {}

    local x = 0
    local y = 0

    for row = 1, 2 do

        table.insert(ground, love.graphics.newQuad(
            x, y, 16, 16, SpriteSheet:getDimensions()
        ))

        y = y + 16
    end

    return ground
end

function GetWall(SpriteSheet)

    local wall = {}

    local x = 16
    local y = 0

    for row = 1, 2 do

        for column = 1, 7 do

            table.insert(wall, love.graphics.newQuad(
                x, y, 16, 16, SpriteSheet:getDimensions()
            ))

            x = x + 16
        end
        x = 16
        y = y + 16
    end

    return wall
end

function GetWallGround(SpriteSheet)

    local wall_ground = {}

    local x = 128
    local y = 0

    for row = 1, 2 do

        for column = 1, 4 do

            table.insert(wall_ground, love.graphics.newQuad(
                x, y, 16, 16, SpriteSheet:getDimensions()
            ))

            x = x + 16
        end
        x = 128
        y = y + 16

    end

    return wall_ground
end

function GetGroundPath(SpriteSheet)

    local path = {}

    local x = 0 
    local y = 32

    for column = 1, 3 do
        for row = 1, 2 do
            table.insert(path, love.graphics.newQuad(
                x, y, 16, 16, SpriteSheet:getDimensions()
            ))
            y = y + 16
        end
        x = x + 16
        y = 32
    end

    return path
end

function GetSigns(SpriteSheet)

    local signs = {}

    local x = 48
    local y = 32

    for column = 1, 4 do
        table.insert(signs, love.graphics.newQuad(
            x, y, 32, 32, SpriteSheet:getDimensions()
        ))
        x = x + 32
    end

    return signs
end

function GetWater(SpriteSheet)

    local water = {}

    local x = 192
    local y = 0

    for column = 1, 2 do

        table.insert(water, love.graphics.newQuad(
            x, y, 16, 16, SpriteSheet:getDimensions()
        ))
        y = y + 16
    end

    return water
end

function GetInventory(SpriteSheet)

    local inventory = {}

    local x = 0
    local y = 0

    table.insert(inventory, love.graphics.newQuad(
        x, y, 30, 30, SpriteSheet:getDimensions()
    ))

    return inventory
end

function GetItems(SpriteSheet)

    local items = {}

    local x = 0
    local y = 464

    table.insert(items, love.graphics.newQuad(
        x, y, 6, 10, SpriteSheet:getDimensions()
    ))

    for x = 80, 112, 32 do
            table.insert(items, love.graphics.newQuad(
            x, 608, 32, 32, SpriteSheet:getDimensions()
        ))
    end

    return items
end

function GetShop(SpriteSheet)

    local shop = {}

    local x = 0
    local y = 0

    table.insert(shop, love.graphics.newQuad(
        x, y, 80, 32, SpriteSheet:getDimensions()
    ))

    x = 80

    table.insert(shop, love.graphics.newQuad(
        x, y, 160, 64, SpriteSheet:getDimensions()
    ))
    
    x = 0
    y = 64

    for column = 1, 6 do
        table.insert(shop, love.graphics.newQuad(
            x, y, 44, 48, SpriteSheet:getDimensions()
        ))
        x = x + 44
    end

    x = 0
    y = 112

    for column = 1, 5 do
        table.insert(shop, love.graphics.newQuad(
            x, y, 32, 32, SpriteSheet:getDimensions()
        ))
        x = x + 32
    end

    -- heart item
    table.insert(shop, love.graphics.newQuad(
        264, 64, 44, 48, SpriteSheet:getDimensions()
    ))

    return shop
end

function GetTitle(SpriteSheet)

    local title = {}

    local x = 0
    local y = 0

    table.insert(title, love.graphics.newQuad(
        x, y, 380, 180, SpriteSheet:getDimensions()
    ))

    return title
end

function GetBeach(SpriteSheet)

    local beach = {}

    local x = 0
    local y = 0

    -- beach tiles
    for i = 1, 13 do
        
        for n = 1, 2 do
            table.insert(beach, love.graphics.newQuad(
            x, y, 16, 16, SpriteSheet:getDimensions()
            ))

            y = y + 16
        end
        
        y = 0
        x = x + 16

    end

    return beach
end

function GetEnemies(SpriteSheet)

    local enemies = {}

    for y = 0, 64, 32 do

        for x = 0, 352, 32 do

            table.insert(enemies, love.graphics.newQuad(
                x, y, 32, 32, SpriteSheet:getDimensions()
            ))

        end
    end

    return enemies
end

function GetHearts(SpriteSheet)

    local hearts = {}

    for y = 608, 624, 16 do

        table.insert(hearts, love.graphics.newQuad(
            64, y, 16, 16, SpriteSheet:getDimensions()
        ))
    end
    
    return hearts
end